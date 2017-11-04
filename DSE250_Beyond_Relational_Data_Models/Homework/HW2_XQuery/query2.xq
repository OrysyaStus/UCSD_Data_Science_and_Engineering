<speakers>
{
for $s in distinct-values(doc("j_caesar.xml")//SPEAKER)
return 
<character>{$s}</character>
}
</speakers>