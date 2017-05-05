defmodule Graphitex.Client do
  @moduledoc """
  A registered process that provides a network interface for graphite
  """

  use GenServer
  require Logger

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, %{socket: nil}, name: @name)
  end

  @doc """
  Add a node and the service it provides to the directory.
  """
  @spec metric(number, [String.t]) :: nil
  def metric(value, namespace) when is_list(namespace) do
    metric({value, Enum.join(namespace, ".")})
  end
  @spec metric(number, binary) :: nil
  def metric(value, namespace) when is_binary(namespace) do
    metric({value, namespace})
  end
  @spec metric(number, binary|String.t, Float.t) :: nil
  def metric(value, namespace, ts) when is_float(ts) do
    metric({value, namespace, Float.round(ts, 1)})
  end
  @spec metric({number, binary|String.t, Float.t}) :: nil
  def metric(measurement) do
    GenServer.cast(@name, {:metric, pack_msg(measurement)})
  end

  @spec metric_batch([{number, binary|String.t, Float.t}]) :: nil
  def metric_batch(batch) do
    bulk_mgs = batch
    |> Enum.map(&pack_msg/1)
    |> Enum.join("")
    GenServer.cast(@name, {:metric, bulk_mgs})
  end

  #
  # Private API
  #

  @spec pack_msg({number, String.t}) :: binary
  defp pack_msg({val, ns} = _arg) do
    pack_msg(val, ns, :os.system_time(:seconds))
  end
  @spec pack_msg({number, String.t, Float.t}) :: binary
  defp pack_msg({val, ns, ts} = _arg) do
    pack_msg(val, ns, ts)
  end
  @spec pack_msg(number, String.t, Float.t) :: binary
  defp pack_msg(val, ns, ts) do
    '#{ns} #{val} #{ts}\n'
  end

  #
  # GenServer callbacks
  #

  def init(state) do
    {:ok, state}
  end

  def connect(state) do
    port = Application.get_env(:graphitex, :port, 2003)
    host = Application.get_env(:graphitex, :host)
    opts = [:binary, active: false]
    Logger.info fn -> "Connecting to carbon at #{host}:#{port}" end
    {:ok, socket} = :gen_tcp.connect(host, port, opts)
    Logger.info "Connected"
    %{state | socket: socket}
  end

  def terminate({:error, :closed}, state) do
    state
  end
  def terminate(_reason, %{socket: socket} = state) when not is_nil(socket) do
    :gen_tcp.close(state.socket)
  end

  def handle_cast(msg, %{socket: nil} = state) do
    connected_state = connect(state)
    handle_cast(msg, connected_state)
  end
  def handle_cast({:metric, msg}, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, msg)
    {:noreply, state}
  end

end
