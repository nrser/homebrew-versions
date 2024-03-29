class YarnAT102 < Formula
  desc "Yarn JavaScript package manager version 1.0.2"
  homepage "https://yarnpkg.com/"
  url "https://github.com/yarnpkg/yarn/releases/download/v1.0.2/yarn-v1.0.2.tar.gz"
  head "https://github.com/yarnpkg/yarn.git"

  depends_on "node" => :recommended

  def install
    libexec.install Dir["*"]
    
    # old way:
    # bin.install_symlink "#{libexec}/bin/yarn.js" => "yarn"
    # bin.install_symlink "#{libexec}/bin/yarn.js" => "yarnpkg"
    
    # new way: (https://github.com/Homebrew/homebrew-core/commit/b465fc700ad7c617b30c86ed985d0dbbdf9e7455#diff-049797e41058fd9c5475703be58fcb60)
    (bin/"yarn").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX
    (bin/"yarnpkg").write_env_script "#{libexec}/bin/yarn.js", :PREFIX => HOMEBREW_PREFIX
    
    inreplace "#{libexec}/package.json", '"installationMethod": "tar"', '"installationMethod": "homebrew"'
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
