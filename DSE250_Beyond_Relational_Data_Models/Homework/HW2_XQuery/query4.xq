<result>
{
for $s in distinct-values(doc('j_caesar.xml')//SPEAKER)
where every $a in doc('j_caesar.xml')//ACT 
satisfies exists($a/SCENE/SPEECH/SPEAKER[text()=$s])
return 
<character>{$s}</character>
}
</result>