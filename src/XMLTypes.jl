# Copyright 2018 Adam Beckmeyer
#
# This file is part of XMLTypes.jl.
# XMLTypes.jl is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# XMLTypes.jl is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with XMLTypes.jl.  If not, see <https://www.gnu.org/licenses/>.

module XMLTypes

export XMLElement

"Represents an XML element (e.g. `<xml attr=\"string\">content</xml>`)."
abstract type XMLElement end

export attributes, content

"Returns iterator of `Pair{String,String}` attributes for element."
attributes(element::XMLElement) = element.attributes

"Returns iterator of `Union{String,XMLElement}` for element contents."
content(element::XMLElement) = element.content

export dump_attributes, dump

"Turns an iterator of `Pair{String,String}` into standard XML tag attributes."
function dump_attributes(attributes)::String
    join(map(p -> "$(p.first)=\"$(p.second)\"", attributes), " ")
end

"Turns an `XMLElement` into its canonical tag-form representation."
function dump(element::XMLElement)::String
    element_name = name(element)
    attr_str = dump_attributes(attributes(element))
    # XML tags can be jammed together, and strings require appropriate spaces
    # TODO: what is max allowed depth of recursion? Problematic for normal uses?
    content_str = join(dump.(content(element)), "")
    # If no content, we can use a self-closing tag
    if length(content(element)) == 0
        """
        <$element_name $attr_str />
        """
    else
        """
        <$element_name $attr_str>
            $content_str
        </$element_name>
        """
    end#if
end#function

# `content(element)` is mixed vector of strings and elements to fuse `dump` on
dump(s::AbstractString) = s

end#module
