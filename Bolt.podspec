Pod::Spec.new do |s|

s.name = "Bolt"
s.summary = "The Bolt iOS SDK enables merchants to integrate their apps with Bolt Checkout."
s.version = "1.0.1"
s.author = { "Bolt Financial" => "support@bolt.com" }

s.homepage = "https://bolt.com"
s.readme = "https://raw.githubusercontent.com/BoltApp/bolt-ios/master/README.md"
s.source = { :http => "https://bolt-mobile-sdk.s3.us-west-2.amazonaws.com/1.0.1/Bolt.xcframework.zip" }
s.ios.vendored_frameworks = "Bolt.xcframework"

s.platform = :ios
s.ios.deployment_target = "13.0"
s.swift_version = "5.0"

s.license = { :type => "MIT", :text => <<-LICENSE
                MIT License

                Copyright (c) 2023 Bolt

                Permission is hereby granted, free of charge, to any person obtaining a copy
                of this software and associated documentation files (the "Software"), to deal
                in the Software without restriction, including without limitation the rights
                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                copies of the Software, and to permit persons to whom the Software is
                furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all
                copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                SOFTWARE.
              LICENSE
            }
end
