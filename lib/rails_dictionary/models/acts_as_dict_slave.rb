module RailsDictionary
  module ActsAsDictSlave
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # return columns that exist in DictType#tab_and_column
      def columns_in_dict_type
        DictType.tab_and_column[self.name.underscore.to_sym]
      end

      # columns which map to dictionary
      def dict_columns(ops={})
        conf={except: nil,add: nil}
        conf.update(ops)
        cidt=self.columns_in_dict_type || []
        cidt.delete(conf[:except])
        case conf[:add]
        when String
          cidt.push(conf[:add])
        when Array
          cidt.push(*conf[:add])
        else nil
        end
        cidt.uniq! || cidt
      end

      # add a belongs_to(Dictionary) association and a named_{column} method
      def add_dynamic_column_method
        dict_mapping_columns.each { |e| belongs_to "#{e.to_s}_dict".to_sym,class_name: "Dictionary",foreign_key: e }
        dict_mapping_columns.each { |ele| named_dict_value ele.to_sym }
      end

      # Generate dynamic instance method named_column to slave model
      # def named_city(locale=nil)
      #   locale = locale.presence || default_dict_locale.presence || :en
      #   locale = "name_#{locale}"
      #   self.send(city_dict).try(:send,locale)
      # end
      def named_dict_value(method_name)
        belongs_to_name="#{method_name.to_s}_dict".to_sym
        method_name="named_#{method_name.to_s}"
        define_method(method_name) do | locale=nil |
          locale = locale.presence || default_dict_locale.presence || :en
          locale = "name_#{locale}"
          self.send(belongs_to_name).try(:send,locale)
        end
      end

    end

  end
end