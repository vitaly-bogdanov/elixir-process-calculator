defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end) |> Process.register(:calculator) # регистрируем процесс под именем :calculator
  end
  defp loop (current_value) do
    new_value = receive do
      {:result, client_id} -> 
        send(client_id, {:response, current_value})
        current_value # возвращаем текущее значение
      {:add, value} -> current_value + value
      {:sub, value} -> current_value - value
      {:mult, value} -> current_value * value
      {:div, value} -> current_value / value
      {:value, value} -> value
      {:clear} -> 0
      invalid_request -> 
        "Invalid request: #{invalid_request}" |> IO.inspect
        current_value # возвращаем текущее значение
    end
    new_value |> loop
  end
  def result do
    :calculator 
    |> send({:result, self()})
    receive do
      {:response, value} -> value
    end
  end
  def add(value) do
    :calculator 
    |> send({:add, value})
    result()
  end
  def sub(value) do
    :calculator 
    |> send({:sub, value})
    result()
  end
  def mult(value) do
    :calculator
    |> send({:mult, value})
    result()
  end
  def div(value) do
    :calculator
    |> send({:div, value})
    result()
  end
  def enter(value) do
    :calculator |> send({:value, value})
    result()
  end
  def clear do
    :calculator |> send({:clear})
    result()
  end
end
