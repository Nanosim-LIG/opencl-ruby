def init
  sections :header, :box_info, :pre_docstring, T('docstring'), :children,
    :attribute_summary, [:item_summary], :inherited_attributes,
    :method_summary, [:item_summary], :inherited_methods,
    :methodmissing, [T('method_details')],
    :attribute_details, [T('method_details')],
    :method_details_list, [T('method_details')],
    :constant_summary, [T('docstring')], :inherited_constants
end
