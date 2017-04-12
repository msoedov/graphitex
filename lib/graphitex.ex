defmodule Graphitex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Graphitex.Client, []),
    ]

    opts = [strategy: :one_for_one, name: Graphitex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defdelegate metric(value, namespace), to: Graphitex.Client
  defdelegate metric(value, namespace, ts), to: Graphitex.Client
  defdelegate metric_batch(msgs), to: Graphitex.Client


  def now do
    :os.system_time(:seconds)
  end

end
