json.array!(@tutors) do |tutor|
  json.name tutor.name
  json.url tutor_path(tutor)
end
