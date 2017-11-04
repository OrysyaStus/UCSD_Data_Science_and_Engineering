for $s in doc("j_caesar.xml")//SPEECH
where $s/LINE = "Et tu, Brute! Then fall, Caesar."
return 
<result>
<answer>
<who> {$s/SPEAKER/text()} </who>
 <when> {$s/../../TITLE/text()} </when>
</answer>
</result>