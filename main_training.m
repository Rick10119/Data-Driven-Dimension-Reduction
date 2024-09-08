% Train the ALF model on three different datasets
data_set_names = ["cement", "steelpowder", "steelmaking"];
for name_idx = 1:3
    data_set_name = data_set_names(name_idx);
    main;
end
