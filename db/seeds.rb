# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Position.create([{title: 'foil captain'}, {title: 'epee captain'}, {title: 'sabre captain'}, {title: 'armorer'}, {title: 'treasurer'}, {title: 'president'}])

Status.create([{status_desc: 'Working'}, {status_desc: 'Not Working'}, {status_desc: 'In Repair'}, {status_desc: 'Ordered'}])

EquipmentType.create([{description: 'foil mask'}, {description:'sabre mask'}, {description:'epee mask'}, {description:'sabre'}, {description:'foil'}, {description:'epee'}, {description:'foil lame'}, {description:'sabre lame'}])

RequestStatus.create([{status_desc: 'Pending'}, {status_desc: 'Approved'}, {status_desc: 'Denied'}, {status_desc: 'Withdrawn'}])