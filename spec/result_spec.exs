defmodule Jylis.Result.Spec do
  use ESpec

  let :value,             do: "72.1"
  let :unix_timestamp,    do: 1528238308
  let :iso8601_timestamp, do: "2018-06-05T22:38:28Z"

  describe "to_iso8601" do
    it "converts a unix timestamp in a result to iso8601" do
      expected = {value(), iso8601_timestamp()}

      {value(), unix_timestamp()}
      |> Jylis.Result.to_iso8601
      |> should(eq expected)
    end
  end
end
