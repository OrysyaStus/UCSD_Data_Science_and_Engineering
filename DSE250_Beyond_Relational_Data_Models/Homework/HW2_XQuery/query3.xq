<result>
{
for $s in distinct-values (doc("j_caesar.xml")//SPEAKER)
return
<answer>
<who> {$s} </who>
   { for $t in doc("j_caesar.xml")//ACT
     where $t//SPEECH[SPEAKER[1] = $s]
     return 
     <when>{$t/TITLE/text()}</when>
    }
</answer>
}
</result>