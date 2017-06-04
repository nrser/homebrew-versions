require "language/node"

class YarnAt0212 < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://github.com/yarnpkg/yarn/releases/download/v0.21.2/yarn-v0.21.2.tar.gz"
  version "0.21.2"
  sha256 "1ccd5676112dd1aa99759cde942f9c2e9ec22c15977f910d8d298210deb6797e"
  head "https://github.com/yarnpkg/yarn.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
