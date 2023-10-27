defmodule WorkflowGenerator.Generator do
  require Logger

  def generate_module(%{name: workflow_name, steps: steps} = _workflow) do
    Logger.critical("Compiling #{workflow_name}")
    Enum.each(steps, fn %{name: name, code: code} ->
      Logger.critical("Step - #{name}")
      contents =
        quote do
          def execute(input) do
            {result, _} = Code.eval_string(unquote(code), input: input)
            result
          end
        end
        Module.concat([workflow_name, String.capitalize(name)])
        |> Module.create(contents, Macro.Env.location(__ENV__))
    end)
    Logger.critical("Finished")
  end

  def execute_workflow(%{steps: steps, input: input, name: workflow_name}) do
    Logger.critical("Executing #{workflow_name}")
    result =
      Enum.reduce(steps, input, fn %{name: name}, result_acc ->
        Logger.critical("Step - #{name}")
        {:ok, result} =
          Module.concat(workflow_name, name)
          |> apply(:execute, [result_acc])
        Logger.critical(inspect(result))
        result
      end)
    Logger.critical("Finished - #{inspect(result)}")
  end
end
