class YarnCompletion < Formula
  desc "Bash completion for Yarn (NRSER updated version)"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.17.0.tar.gz"
  # NOTE  `brew create` just generates these from the archive it downloads... I
  #       mean, it does warn about it, but it still does it. I'm not sure how
  #       meaningful a sig is if it doesn't come from the authors or directly
  #       from packaging the source. I guess it means it can't get changed
  #       later, but seems a little like a false sense of security :/
  sha256 "cc9d86bd8d4c662833424f86f1f86cfa0516c0835874768d9cf84aaf79fb8b21"
  license "MIT"

  bottle :unneeded
  
  depends_on "bash"
  depends_on "bash-completion@2"
  
  head do
    url "https://github.com/dsifford/yarn-completion.git", branch: "master"
  end

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("source #{bash_completion}/yarn && complete -p yarn")
  end
end
