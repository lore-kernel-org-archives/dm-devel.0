From: "George ." <george@ucdn.com>
Subject: dm-cache data corruption
Date: Wed, 19 Feb 2014 14:31:12 +0200
Message-ID: <CAPi_w4wWnJa8XDXsXscgPzYukvAB4eADgvPDLKcGNEU3ykfjiQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3384064904904211958=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3384064904904211958==
Content-Type: multipart/alternative; boundary=001a11c3490870c50a04f2c1909f

--001a11c3490870c50a04f2c1909f
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I'm currently testing dm-cache on 'debian 3.12-1-amd64 #1 SMP Debian
3.12.9-1' vanilla kernel and finally reproduced the issue with data
corruption on cached device.

Using small and simple setup:



*root@debian:~# blockdev --getsz /dev/sda51951744root@debian:~# blockdev
--getsz /dev/sda6122880root@debian:~# blockdev --getsz /dev/sda728672*
*root@debian:~# dmsetup create cached --table '0 1951744 cache /dev/sda7
/dev/sda6 /dev/sda5  512 1 writeback default 0'*

and a script that actually starts many (let's say 100) instances of
*badblock* tool,  writing, reading and comparing 0x55, 0xaa, 0xff, 0x00
patterns, where each instance repeats that procedure over is own range of
blocks. See my bash script (attached)

Here how I run it:
*./dm-stress-test.sh -n 100 -r 10000 -d /dev/mapper/cached -t p*

/dev/mapper/cached, 512, 1951744
running parallel test
checking blocks 0 to 19516
checking blocks 19517 to 39033
*.*
*.*
*.*
*checking blocks 1932183 to 1951699*
*waiting for bad blocks*
*file has bad blocks, ./bad_block_43*
*839295*
*file has bad blocks, ./bad_block_43*
*839295*
*file has bad blocks, ./bad_block_43*
*839295*
*^CCTRL-C exiting ...*

here is the dm-cache status at the time of first corrupted block:

*root@debian:~# dmsetup status *
*cached: 0 1951744 cache 7/3584 852 126848 1040 166813 0 85 85 71 0 2
migration_threshold 2048 4 random_threshold 4 sequential_threshold 51*2


I've also tried this test on custom build kernel 'Linux george 3.13.0+ #3
SMP Mon Feb 17 10:44:59 EET 2014 x86_64 x86_64 x86_64 GNU/Linux' and there
is the same issue

If using ram device for cache and sata for origin the first corrupted
blocks appears almost  immediately .


We been testing dm-cache on larger setups (see https://www.redhat
.com/archives/dm-devel/2014-January/msg00135.html) but there we were able
to corrupt cached device after several days under heavy traffic.

--001a11c3490870c50a04f2c1909f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I&#39;m currently testing <span cla=
ss=3D"" style=3D"background-color:yellow"><span class=3D"" style=3D"backgro=
und-color:yellow"><span class=3D"" style>dm</span></span></span>-cache on &=
#39;<font color=3D"#000000"><span class=3D"" style=3D"background-color:yell=
ow"><span class=3D"" style=3D"background-color:yellow"><span class=3D"" sty=
le>debian</span></span></span> 3.12-1-amd64 #1 <span class=3D"" style=3D"ba=
ckground-color:yellow"><span class=3D"" style=3D"background-color:yellow"><=
span class=3D"" style>SMP</span></span></span> Debian 3.12.9-1&#39; vanilla=
 kernel and finally reproduced the issue with data corruption on cached dev=
ice.</font></div>
<div><font color=3D"#000000"><br></font></div><div><font color=3D"#000000">=
Using small and simple setup:</font></div><div><font color=3D"#000000"><br>=
</font></div><div><font color=3D"#000000"><br></font></div><div><font color=
=3D"#000000"><i><div>
root@<span class=3D"" style=3D"background-color:yellow"><span class=3D"" st=
yle=3D"background-color:yellow"><span class=3D"" style>debian</span></span>=
</span>:~# <span class=3D"" style=3D"background-color:yellow"><span class=
=3D"" style=3D"background-color:yellow"><span class=3D"" style>blockdev</sp=
an></span></span> --<span class=3D"" style=3D"background-color:yellow"><spa=
n class=3D"" style=3D"background-color:yellow"><span class=3D"" style>getsz=
</span></span></span> /<span class=3D"" style=3D"background-color:yellow"><=
span class=3D"" style=3D"background-color:yellow"><span class=3D"" style>de=
v</span></span></span>/sda5</div>
<div>1951744</div><div>root@<span class=3D"" style=3D"background-color:yell=
ow"><span class=3D"" style=3D"background-color:yellow"><span class=3D"" sty=
le>debian</span></span></span>:~# <span class=3D"" style=3D"background-colo=
r:yellow"><span class=3D"" style=3D"background-color:yellow"><span class=3D=
"" style>blockdev</span></span></span> --<span class=3D"" style=3D"backgrou=
nd-color:yellow"><span class=3D"" style=3D"background-color:yellow"><span c=
lass=3D"" style>getsz</span></span></span> /<span class=3D"" style=3D"backg=
round-color:yellow"><span class=3D"" style=3D"background-color:yellow"><spa=
n class=3D"" style>dev</span></span></span>/sda6</div>
<div>122880</div><div>root@<span class=3D"" style=3D"background-color:yello=
w"><span class=3D"" style=3D"background-color:yellow"><span class=3D"" styl=
e>debian</span></span></span>:~# <span class=3D"" style=3D"background-color=
:yellow"><span class=3D"" style=3D"background-color:yellow"><span class=3D"=
" style>blockdev</span></span></span> --<span class=3D"" style=3D"backgroun=
d-color:yellow"><span class=3D"" style=3D"background-color:yellow"><span cl=
ass=3D"" style>getsz</span></span></span> /<span class=3D"" style=3D"backgr=
ound-color:yellow"><span class=3D"" style=3D"background-color:yellow"><span=
 class=3D"" style>dev</span></span></span>/sda7</div>
<div>28672</div><div><br></div></i></font></div><div><font color=3D"#000000=
"><i>root@<span class=3D"" style=3D"background-color:yellow"><span class=3D=
"" style=3D"background-color:yellow"><span class=3D"" style>debian</span></=
span></span>:~# <span class=3D"" style=3D"background-color:yellow"><span cl=
ass=3D"" style=3D"background-color:yellow"><span class=3D"" style>dmsetup</=
span></span></span> create cached --table &#39;0 1951744 cache /<span class=
=3D"" style=3D"background-color:yellow"><span class=3D"" style=3D"backgroun=
d-color:yellow"><span class=3D"" style>dev</span></span></span>/sda7 /<span=
 class=3D"" style=3D"background-color:yellow"><span class=3D"" style=3D"bac=
kground-color:yellow"><span class=3D"" style>dev</span></span></span>/sda6 =
/<span class=3D"" style=3D"background-color:yellow"><span class=3D"" style=
=3D"background-color:yellow"><span class=3D"" style>dev</span></span></span=
>/sda5 =A0512 1 <span class=3D"" style=3D"background-color:yellow"><span cl=
ass=3D"" style=3D"background-color:yellow"><span class=3D"" style>writeback=
</span></span></span> default 0&#39;</i><br>
</font></div><div><font color=3D"#000000"><br></font></div><div><font color=
=3D"#000000">and a script that actually starts many (let&#39;s say 100) ins=
tances=A0of <i><b><span class=3D"" style=3D"background-color:yellow"><span =
class=3D"" style=3D"background-color:yellow"><span class=3D"" style>badbloc=
k</span></span></span></b></i> tool, =A0writing, reading and comparing 0x55=
,=A0</font><span style=3D"color:rgb(0,0,0)">0x</span><span style=3D"color:r=
gb(0,0,0)"><span class=3D"" style=3D"background-color:yellow"><span class=
=3D"" style=3D"background-color:yellow"><span class=3D"" style>aa</span></s=
pan></span>,=A0</span><span style=3D"color:rgb(0,0,0)">0x</span><span style=
=3D"color:rgb(0,0,0)">ff,=A0</span><span style=3D"color:rgb(0,0,0)">0x</spa=
n><span style=3D"color:rgb(0,0,0)">00 patterns, where each instance repeats=
 that procedure over is own range of blocks. See my bash script (attached)<=
/span></div>
<div><font color=3D"#000000"><br></font></div><div><font color=3D"#000000">=
Here how I run it:</font></div><div><font color=3D"#000000"><i>./<span clas=
s=3D"" style=3D"background-color:yellow"><span class=3D"" style>dm</span></=
span>-stress-test.sh -n 100 -r 10000 -d /<span class=3D"" style=3D"backgrou=
nd-color:yellow"><span class=3D"" style>dev</span></span>/mapper/cached -t =
p</i><br>
</font></div><div><br></div><div><div>/<span class=3D"" style>dev</span>/ma=
pper/cached, 512, 1951744</div><div>running parallel test</div><div>checkin=
g blocks 0 to 19516</div><div>checking blocks 19517 to 39033</div></div><di=
v>
<i style=3D"color:rgb(0,0,0)">.</i><br></div><div><font color=3D"#000000"><=
i>.</i></font></div><div><font color=3D"#000000"><i>.</i></font></div><div>=
<font color=3D"#000000"><div><i>checking blocks 1932183 to 1951699</i></div=
><div>
<i>waiting for bad blocks</i></div><div><i>file has bad blocks, ./bad_block=
_43</i></div><div><i>839295</i></div><div><i>file has bad blocks, ./bad_blo=
ck_43</i></div><div><i>839295</i></div><div><i>file has bad blocks, ./bad_b=
lock_43</i></div>
<div><i>839295</i></div><div><i>^<span class=3D"" style=3D"background-color=
:yellow"><span class=3D"" style>CCTRL</span></span>-C exiting ...</i></div>=
<div><br></div><div>here is the <span class=3D"" style=3D"background-color:=
yellow"><span class=3D"" style>dm</span></span>-cache status at the time of=
 first corrupted block:</div>
<div><br></div><div><div><i>root@<span class=3D"" style=3D"background-color=
:yellow"><span class=3D"" style>debian</span></span>:~# <span class=3D"" st=
yle=3D"background-color:yellow"><span class=3D"" style>dmsetup</span></span=
> status=A0</i></div>
<div><i>cached: 0 1951744 cache 7/3584 852 126848 1040 166813 0 85 85 71 0 =
2 migration_threshold 2048 4 random_threshold 4 sequential_threshold 51</i>=
2</div></div><div><br></div></font></div><div><font color=3D"#000000"><br>
</font></div><div><font color=3D"#000000">I&#39;ve also tried this test on =
<span class=3D"" style=3D"background-color:yellow">custom</span>=A0build <s=
pan class=3D"" style=3D"background-color:yellow">kernel</span> &#39;Linux <=
span class=3D"" style=3D"background-color:yellow"><span class=3D"" style>ge=
orge</span></span> 3.13.0+ #3 <span class=3D"" style=3D"background-color:ye=
llow"><span class=3D"" style>SMP</span></span> Mon Feb 17 10:44:59 <span cl=
ass=3D"" style=3D"background-color:yellow"><span class=3D"" style>EET</span=
></span> 2014 x86_64 x86_64 x86_64 GNU/Linux&#39; and there is the same iss=
ue=A0</font></div>
<div><br></div><div><font color=3D"#000000">If using ram device for cache a=
nd <span class=3D"" style=3D"background-color:yellow"><span class=3D"" styl=
e>sata</span></span> for origin the first corrupted blocks appears almost =
=A0immediately .</font></div>
<div><font color=3D"#000000"><br></font></div><div><font color=3D"#000000">=
<br></font></div><div><font color=3D"#000000">We been testing <span class=
=3D"" style=3D"background-color:yellow"><span class=3D"" style=3D"backgroun=
d-color:yellow"><span class=3D"" style>dm</span></span></span>-cache on lar=
ger setups (see=A0<a href=3D"https://www">https://www</a>.<span class=3D"" =
style=3D"background-color:yellow"><span class=3D"" style=3D"background-colo=
r:yellow"><span class=3D"" style>redhat</span></span></span>.com/archives/<=
span class=3D"" style=3D"background-color:yellow"><span class=3D"" style=3D=
"background-color:yellow"><span class=3D"" style>dm</span></span></span>-<s=
pan class=3D"" style=3D"background-color:yellow"><span class=3D"" style=3D"=
background-color:yellow"><span class=3D"" style>devel</span></span></span>/=
2014-January/msg00135.html</font><span style=3D"color:rgb(0,0,0)">) but the=
re we were able to corrupt cached device after several days under heavy tra=
ffic.</span></div>
</div>

--001a11c3490870c50a04f2c1909f--


--===============3384064904904211958==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3384064904904211958==--
