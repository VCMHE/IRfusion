function [ Sal ] = detail_fusion2_l1l0( ImgTexture_1, ImgTexture_2, Weight )
D_F=cell(1,4);
for i=1:4

D_F{i}=(1-Weight).*ImgTexture_2{i}+Weight.*ImgTexture_1{i};

end

Sal = D_F{2}+D_F{3}+ D_F{4}+D_F{1};

end





