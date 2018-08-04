using XMLTypes
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

struct TestElement <: XMLElement
    attributes::Vector{Pair{String,String}}
    content::Vector{Union{String,XMLElement}}
end#struct

name(::TestElement) = "test"

attr = ["class" => "good", "id" => "4"]
cont = ["hello world", TestElement([], [])]
t = TestElement(attr, cont)

@test attributes(t) == attr
@test content(t) == cont
