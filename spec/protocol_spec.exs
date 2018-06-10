defmodule Jylis.Protocol.Spec do
  use ESpec

  describe "serialize" do
    let :input,  do: ["MVREG", "GET", "temperature"]
    let :output, do: "*3\r\n$5\r\nMVREG\r\n$3\r\nGET\r\n$11\r\ntemperature\r\n"

    specify do: Jylis.Protocol.serialize(input()) |> should(eq output())
  end

  defmodule Deserialize do
    use ESpec, shared: true

    let_overridable input:  nil
    let_overridable output: nil

    specify do: Jylis.Protocol.deserialize(input()) |> should(eq output())
  end

  describe "deserialize" do
    describe "simple string" do
      let :input,  do: "+OK\r\n"
      let :output, do: {:ok, "OK"}

      include_examples Deserialize
    end

    describe "error" do
      # TODO: What is the right output for errors? #############################
      #       What errors does Jylis return?
      let :input,  do: "-WRONGTYPE Operation against a key holding the wrong kind of value\r\n"
      let :output, do: {:error, {:wrongtype, "Operation against a key holding the wrong kind of value"}}

      include_examples Deserialize
    end

    describe "integer" do
      let :input,  do: ":-12345\r\n"
      let :output, do: {:ok, -12345}

      include_examples Deserialize
    end

    describe "bulk string" do
      let :input,  do: "$6\r\nfoobar\r\n"
      let :output, do: {:ok, "foobar"}

      include_examples Deserialize

      describe "empty string" do
        let :input,  do: "$0\r\n\r\n"
        let :output, do: {:ok, ""}

        include_examples Deserialize
      end

      describe "null value" do
        let :input,  do: "$-1\r\n"
        let :output, do: {:ok, nil}

        include_examples Deserialize
      end
    end

    describe "array" do
      describe "empty" do
        let :input,  do: "*0\r\n"
        let :output, do: {:ok, []}

        include_examples Deserialize
      end

      describe "null" do
        let :input,  do: "*-1\r\n"
        let :output, do: {:ok, nil}

        include_examples Deserialize
      end

      describe "two bulk strings" do
        let :input,  do: "*2\r\n$3\r\nfoo\r\n$3\r\nbar\r\n"
        let :output, do: {:ok, ["foo", "bar"]}

        include_examples Deserialize
      end

      describe "three integers" do
        let :input,  do: "*3\r\n:1\r\n:2\r\n:3\r\n"
        let :output, do: {:ok, [1, 2, 3]}

        include_examples Deserialize
      end

      describe "mixed types" do
        let :input,  do: "*5\r\n:1\r\n:2\r\n:3\r\n:4\r\n$6\r\nfoobar\r\n"
        let :output, do: {:ok, [1, 2, 3, 4, "foobar"]}

        include_examples Deserialize
      end

      describe "contains arrays" do
        let :input,  do: "*2\r\n*3\r\n:1\r\n:2\r\n:3\r\n*2\r\n+foo\r\n+bar\r\n"
        let :output, do: {:ok, [[1, 2, 3], ["foo", "bar"]]}

        include_examples Deserialize
      end

      describe "contains null elements" do
        let :input,  do: "*3\r\n$3\r\nfoo\r\n$-1\r\n$3\r\nbar\r\n"
        let :output, do: {:ok, ["foo", nil, "bar"]}

        include_examples Deserialize
      end
    end

    describe "unexpected end of file" do
      let :input,  do: "*5\r\n:1\r\n:2\r\n:3\r\n:4\r\n"
      let :output, do: {:error, :unexpected_eof}

      # include_examples Deserialize
      specify ""
    end

    describe "unexpected data remaining" do
      specify ""
    end

    describe "malformed crlf terminator" do
      specify ""
    end
  end
end
