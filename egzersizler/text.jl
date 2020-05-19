#using Plots,Statistics;
#using Pkg; Pkg.add("DataStructures");
module text

export n_karakter, clean_text, oku

alfabe=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
    'p','q','r','s','t','u','v','w','x','y','z']
# n karakterli kelimeleri al
function n_karakter(n::Int64)
    sayac=0
    for kelime in eachline("../data/words.txt")
        if(length(kelime)==n)
            sayac+=1
        end
    end
    return sayac
end

#=
kelime_n=[]
for i in 2:21
    push!(kelime_n,n_karakter(i))
end
z_kelime_n=(kelime_n.-mean(kelime_n))/std(kelime_n)
p1=bar(z_kelime_n,yticks=-1:0.2:3,title="z_kelime_n")
p2=bar(kelime_n,xticks=0:2:21,title="kelime_n")
@show kelime_n
plot(p1,p2,legend=false)
=#

# içinde e olmayan kelimeler
function e_harfi_var_mi(kelime::AbstractString)::Bool
    return 'e' in kelime #occursin('e',kelime)
end

#=
sayac=0
kelimesayac=0
for kelime in eachline("../data/words.txt")
    kelimesayac+=1
    if(!e_harfi_var_mi(kelime))
        sayac=+1
    end
end
print((sayac/kelimesayac)*100) # e harfi olmayanların yüzdesi
=#

# verilen harflerden birini içermeyen kelimeler
function bulundurmaz(kelime,harfler)
     for yasak in harfler
        if yasak in kelime
            return false
        end
    end
    return true
end
#bulundurmaz("abc","fds")

#=
toplam_harf=zeros(Int,26)

dosya = open("../data/words.txt");
kelimeler=readlines(dosya);

for kelime in kelimeler
    toplam_harf+=count.(string.(alfabe),kelime)
end
close(dosya)
z_toplam_harf=(toplam_harf.-mean(toplam_harf))/std(toplam_harf)
sozluk=Dict(zip(z_toplam_harf,alfabe))

[println(k," => ",f) for (f,k) in sozluk ]
p1=bar(
    collect(values(sozluk)),
    collect(keys(sozluk)),
    title="Z skor freq")
p2=bar(alfabe,
    toplam_harf,
    title="Freq")
plot(p1,p2,legend=false)
=#
# Anagram olan kelimeleri bul ve sırala
function sort_collect(s)
    return sort(collect(s))
end
#dosya = open("../data/words.txt");
#kelimeler=readlines(dosya);
#close(dosya)
function anagram_say(str)
    anagrams=Dict{Array{Char}}{Array{String}}()
    for i in str
        sc=sort_collect(i)
        if !(sc in keys(anagrams))
            anagrams[sc]=[]
        else
            push!(anagrams[sc],i)
        end
    end
    for (i,x) in anagrams
        if isempty(x) || length(x)<2
            delete!(anagrams,i)
        end
    end
    sort(collect(values(anagrams)), by=x-> length(x), rev=true)
end
#anagram_say(kelimeler)

# KİTAP OKU
function clean_text(s)
    split.(replace.(lowercase.(strip.(readlines(s))),r"[^A-Za-z ]" => ""))
end

function oku(path)
    dosya=open(path,"r")
    satirlar = clean_text(dosya)
    words=Dict{String}{Array{String}}()
    for (i,l) in enumerate(satirlar)
        if 168<i<14065 && !isempty(l) # baslangic bilgisi, gutenberg lisans kısmı ve boş satırlar geçildi
            [!(l[i] in keys(words)) ? words[l[i]]=[] : if !(l[i+1] in words[l[i]]) push!(words[l[i]],l[i+1]) end for i in 1:length(l)-1]
        end
    end
    #sort(collect(words), by= x-> length(last(x)),rev=true)
    words
end
#oku("../data/prideandprejudice.txt")
end