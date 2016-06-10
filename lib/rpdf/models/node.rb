module Intersail
  module Rpdf
    class Node
      def name
        @name
      end
      def children
        @children
      end
      def has_children?
        @children && @children.respond_to?(:length) && @children.length>0
      end

      def [](index)
        @hash[index]
      end
      
      def initialize(hash)
        @hash = hash

        @name = hash[:name]

        subtags = hash[:childs][:tag_node] if hash[:childs] && hash[:childs][:tag_node]

        if subtags.kind_of? Array
          @children = subtags.map{|c| Node.new(c)}
        elsif subtags.kind_of? Hash
          @children = [Node.new(subtags)]
        end
      end
    end
  end
end
