# frozen_string_literal: true

namespace :sample_task do
  task :exec, %w[hoge foo bar] => :environment do |_, args|
    raise "Specify arguments ex) rake sample_task:exec[hoge,foo,bar]" if args.hoge.nil? || args.foo.nil? || args.bar.nil?

    puts "hoge: #{args.hoge}, foo: #{args.foo}, bar: #{args.bar}"
  end
end
