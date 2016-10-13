From: Ryan Norwood <ryan.p.norwood@gmail.com>
Subject: thin pool performance bottleneck
Date: Thu, 13 Oct 2016 17:37:29 -0400
Message-ID: <CAFTvtQmUj2dO+0e8GtSp4jmoNS2RLCm4KdbcE=v3JYyZZTx=tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7200316831258786916=="
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

--===============7200316831258786916==
Content-Type: multipart/alternative; boundary=94eb2c14c720a7167e053ec5ea57

--94eb2c14c720a7167e053ec5ea57
Content-Type: text/plain; charset=UTF-8

Hi,

We have been pushing thin pool performance beyond what most would normally
do. In the process we have noticed an IOPS performance ceiling within a
single thin pool. Jon Bernard started an email thread about this problem
which is linked below.

https://www.redhat.com/archives/dm-devel/2016-July/msg00264.html

To give you a brief rundown, our array can handle over 1.2m IOPS at a 4k
block size, and the performance between thick and thin device compares very
well until you reach about 200k IOPS (read or write). Beyond this it
appears that the performance is bottlenecked by a spinlock in the thin pool.

What tells us that there is much more headroom available is that we can
create 4 separate thin pools and get a aggregate of 800k IOPS across thin
devices created within them (200k per pool). Adding additional pools beyond
this gives diminishing returns.

We have tried a variety of tests to isolate the issue including:

- multiple chunk-sizes between 64k and 512k
- zero provisioning turned off and on
- filling the thin devices fully before running the tests
- using device mapper directly and bypassing LVM2
- enabling blk-mq
- kernel versions from 3.10.327 through 4.6
- IO on a single thin device, or spread across many within the same pool

Or testing centers around FIO and random reads, but have also looked at
writes and sequential IO. Here is our FIO job configuration which can
reproduce the results.


[random]
direct=1
rw=randrw
zero_buffers
norandommap
randrepeat=0
ioengine=libaio
group_reporting
rwmixread=100
bs=4k
iodepth=32
numjobs=16
runtime=600

I would appreciate any ideas or thoughts you might have on this issue.
Please let me know if there is any other information I can provide. The
thread I linked to above has the lock stat output.

Regards,
Ryan

--94eb2c14c720a7167e053ec5ea57
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"color:rgb(0,0,0);font-family:calibri,arial,h=
elvetica,sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px">Hi,</d=
iv><div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-=
serif;font-size:16px;margin-top:0px;margin-bottom:0px"><br></div><div style=
=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-si=
ze:16px;margin-top:0px;margin-bottom:0px">We have been pushing thin pool pe=
rformance beyond what most would normally do. In the process=C2=A0we have n=
oticed an IOPS performance ceiling within a single thin pool. Jon Bernard s=
tarted an email thread about this problem which is=C2=A0linked below.</div>=
<div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-ser=
if;font-size:16px;margin-top:0px;margin-bottom:0px"><br></div><div style=3D=
"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:=
16px;margin-top:0px;margin-bottom:0px"><a href=3D"https://www.redhat.com/ar=
chives/dm-devel/2016-July/msg00264.html" target=3D"_blank" id=3D"gmail-LPln=
k746378"><span id=3D"gmail-LPlnk746378">https://www.redhat.com/archives/dm-=
devel/2016-July/msg00264.html</span></a><br></div><div style=3D"color:rgb(0=
,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-=
top:0px;margin-bottom:0px"><br></div><div style=3D"color:rgb(0,0,0);font-fa=
mily:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top:0px;margi=
n-bottom:0px">To give you a brief rundown, our array can handle over 1.2m I=
OPS at a=C2=A04k block size, and the performance between thick and thin dev=
ice compares very well=C2=A0until you reach about 200k IOPS (read or write)=
. Beyond this it appears that the performance is bottlenecked by a spinlock=
 in the thin pool.</div><div style=3D"color:rgb(0,0,0);font-family:calibri,=
arial,helvetica,sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px"=
><br></div><div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helveti=
ca,sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px">What tells u=
s that there is much more=C2=A0headroom available is that we can create 4 s=
eparate thin pools and get a aggregate=C2=A0of 800k IOPS across thin device=
s created=C2=A0within them (200k per pool). Adding additional pools beyond =
this gives=C2=A0diminishing returns.=C2=A0</div><div style=3D"color:rgb(0,0=
,0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-to=
p:0px;margin-bottom:0px"><br></div><div style=3D"color:rgb(0,0,0);font-fami=
ly:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top:0px;margin-=
bottom:0px">We have tried a variety of tests to isolate the issue including=
:</div><div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,s=
ans-serif;font-size:16px;margin-top:0px;margin-bottom:0px"><br></div><div s=
tyle=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;fon=
t-size:16px;margin-top:0px;margin-bottom:0px">- multiple chunk-sizes betwee=
n 64k and 512k</div><div style=3D"color:rgb(0,0,0);font-family:calibri,aria=
l,helvetica,sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px">- z=
ero provisioning turned off and on</div><div style=3D"color:rgb(0,0,0);font=
-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top:0px;ma=
rgin-bottom:0px">- filling the thin=C2=A0devices fully before running the t=
ests</div><div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetic=
a,sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px">- using devic=
e mapper directly and bypassing LVM2</div><div style=3D"color:rgb(0,0,0);fo=
nt-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top:0px;=
margin-bottom:0px">- enabling=C2=A0blk-mq</div><div style=3D"color:rgb(0,0,=
0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top=
:0px;margin-bottom:0px">- kernel versions from 3.10.327 through 4.6</div><d=
iv style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif=
;font-size:16px;margin-top:0px;margin-bottom:0px">- IO on a single thin dev=
ice, or spread across many within the same pool</div><div style=3D"color:rg=
b(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px;marg=
in-top:0px;margin-bottom:0px"><br></div><div style=3D"color:rgb(0,0,0);font=
-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top:0px;ma=
rgin-bottom:0px">Or testing centers around FIO and random reads, but have a=
lso looked at writes and sequential IO. Here is our FIO job=C2=A0configurat=
ion which can reproduce the=C2=A0results.</div><div style=3D"color:rgb(0,0,=
0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top=
:0px;margin-bottom:0px"><br></div><div style=3D"color:rgb(0,0,0);font-famil=
y:calibri,arial,helvetica,sans-serif;font-size:16px;margin-top:0px;margin-b=
ottom:0px">=C2=A0</div><div style=3D"color:rgb(0,0,0);font-family:calibri,a=
rial,helvetica,sans-serif;font-size:16px">[random]</div><div style=3D"color=
:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px">=
direct=3D1=C2=A0</div><div style=3D"color:rgb(0,0,0);font-family:calibri,ar=
ial,helvetica,sans-serif;font-size:16px">rw=3Drandrw=C2=A0</div><div style=
=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-si=
ze:16px">zero_buffers=C2=A0</div><div style=3D"color:rgb(0,0,0);font-family=
:calibri,arial,helvetica,sans-serif;font-size:16px">norandommap=C2=A0</div>=
<div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-ser=
if;font-size:16px">randrepeat=3D0=C2=A0</div><div style=3D"color:rgb(0,0,0)=
;font-family:calibri,arial,helvetica,sans-serif;font-size:16px">ioengine=3D=
libaio</div><div style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvet=
ica,sans-serif;font-size:16px">group_reporting</div><div style=3D"color:rgb=
(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px">rwmi=
xread=3D100=C2=A0</div><div style=3D"color:rgb(0,0,0);font-family:calibri,a=
rial,helvetica,sans-serif;font-size:16px">bs=3D4k=C2=A0</div><div style=3D"=
color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:1=
6px">iodepth=3D32=C2=A0</div><div style=3D"color:rgb(0,0,0);font-family:cal=
ibri,arial,helvetica,sans-serif;font-size:16px">numjobs=3D16=C2=A0</div><di=
v style=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;=
font-size:16px">runtime=3D600</div><div style=3D"color:rgb(0,0,0);font-fami=
ly:calibri,arial,helvetica,sans-serif;font-size:16px"><br></div><div style=
=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-si=
ze:16px">I would appreciate any ideas or thoughts you might have on this is=
sue. Please let me know if there is any other information I can provide. Th=
e thread I linked to above has the lock stat output.=C2=A0</div><div style=
=3D"color:rgb(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-si=
ze:16px"><br></div><div style=3D"color:rgb(0,0,0);font-family:calibri,arial=
,helvetica,sans-serif;font-size:16px">Regards,</div><div style=3D"color:rgb=
(0,0,0);font-family:calibri,arial,helvetica,sans-serif;font-size:16px">Ryan=
</div></div>

--94eb2c14c720a7167e053ec5ea57--


--===============7200316831258786916==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7200316831258786916==--
