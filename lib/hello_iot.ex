defmodule HelloIot do
  @moduledoc """
  Documentation for HelloIot.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HelloIot.hello
      :world

  """
  def hello do
    :world
  end

  @output "/tmp/output.wav"

  def read_out do
    Azure.Bing.NewsSearch.top_news()
    |> Map.get("description")
    |> build_ssml()
    |> Azure.CognitiveServices.TextToSpeech.to_speech_of_neural_voice()
    |> then(fn binary -> File.write(@output, binary) end)

    play(Application.get_env(:hello_iot, :target))
  end

  defp build_ssml(text) do
    Azure.CognitiveServices.TextToSpeech.ssml(text, nanami())
  end

  defp nanami do
    Azure.CognitiveServices.TextToSpeech.voices_list()
    |> Enum.filter(fn %{"LocalName" => local_name} -> local_name == "七海" end)
    |> Enum.at(0)
  end

  defp play(:rpi4) do
    :os.cmd('aplay -q #{@output}')
  end

  defp play(:host) do
    :os.cmd('open #{@output}')
  end
end
