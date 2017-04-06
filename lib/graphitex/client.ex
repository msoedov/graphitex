defmodule Graphitex.Client do
  @moduledoc """
  A registered process that provides a network interface for graphite
  """

  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
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
    GenServer.cast(@name, {:metric, value, namespace, ts})
  end


  #
  # Private API
  #

  #
  # GenServer callbacks
  #

  def init(:ok) do
    port = Application.get_env(:graphitex, :port, 2004)
    host = Application.get_env(:graphitex, :host, '188.166.64.102')
    {:ok, socket} = :gen_udp.open(0)
    {:ok, %{socket: socket, host: host, port: port}}
  end

  def stop(server, _reason, _timeout) do
    :gen_udp.close(server)
  end

  def handle_cast({:metric, val, ns, ts}, %{socket: socket, host: host, port: port} = state) do
    msg = "#{ns} #{val} #{ts}"
    IO.inspect msg
    stat = :gen_udp.send(socket, host, port, msg)
    IO.inspect stat
    {:noreply, state}
  end

end
