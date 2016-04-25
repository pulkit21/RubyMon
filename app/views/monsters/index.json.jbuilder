json.array!(@monsters) do |monster|
  json.extract! monster, :id, :name, :power, :monster_type
  json.user do
    json.id monster.user.id
    json.name monster.user.name
    json.uid monster.user.uid
    json.email monster.user.email
    json.image monster.user.image
  end

  if monster.team
    json.team do
      json.id monster.team.id
      json.name monster.team.name
    end
  end
end
