module StringEnum
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.class_eval do
      def self.string_enum(**kargs)
        kargs.each_pair do |k, v|
          enum k.to_sym => v.map{ |e| [e.to_sym, e.to_s] }.to_h
        end
      end
    end
  end
end
