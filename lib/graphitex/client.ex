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
  def metric(value, namespace) when is_list(namespace) do
    metric(value, Enum.join(namespace, "."))
  end
  def metric(value, namespace) when is_binary(namespace) do
    metric(value, namespace, :os.system_time(:seconds))
  end
  def metric(value, namespace, ts) when is_float(ts) do
    metric(value, namespace, Float.round(ts, 1))
  end
  def metric(value, namespace, ts) do
    GenServer.cast(@name, {:metric, pack_msg(value, namespace, ts)})
  end


  #
  # Private API
  #

  defp pack_msg(val, ns, ts) do
    '#{ns} #{val} #{ts}\n'
  end
  #
  # GenServer callbacks
  #

  def init(state) do
    connect(state)
  end

  def connect(state) do
    port = Application.get_env(:graphitex, :port, 2003)
    host = Application.get_env(:graphitex, :host)
    opts = [:binary, active: false]
    Logger.info fn -> "Connecting to #{host}:#{port}" end
    case :gen_tcp.connect(host, port, opts) do
      {:ok, socket} ->
        {:ok, %{state | socket: socket}}
      {:error, reason} ->
        Logger.error fn -> "Could not connect: #{reason}" end
        {:stop, {:connect, reason}}
    end
  end

  def terminate(_reason, state) do
    :gen_tcp.close(state.socket)
  end

  def handle_cast({:metric, msg}, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, msg)
    {:noreply, state}
  end

end
