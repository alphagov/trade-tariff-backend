Sequel.migration do
  up do
    Section.where(position: 21).update(title: "Works of art, collectors' pieces and antiques (chapters 97 to 98)")
  end

  down do
    Section.where(position: 21).update(title: "Works of art, collectors' pieces and antiques (chapters 97 to 99)")
  end
end
