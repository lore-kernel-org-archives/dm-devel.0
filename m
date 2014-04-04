From: Shivaramakrishnan Vaidyanathan <shivaramakrishnan740@gmail.com>
Subject: dm-verity usage help related
Date: Fri, 4 Apr 2014 13:58:25 -0400
Message-ID: <CAAQucXYcoYB42aGmf=-01_vD1gTOg9cw=6He79i_JWjAekfsWw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8553106502408040882=="
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

--===============8553106502408040882==
Content-Type: multipart/alternative; boundary=089e01538de0a4881b04f63b438d

--089e01538de0a4881b04f63b438d
Content-Type: text/plain; charset=ISO-8859-1

Hello ,
I am new to dm-verity and I am finding it hard to use it.

This is my setup.On one VM running Ubuntu-12.04,I have a nfs-share
partition

on which I have virtual disk image files of other vm's.I want to perform
the integrity

check on these files/nfs-share.

My nfs-share partition (/dev/sdb1 mounted at /nfs-share) size is 10GB.From
the

documentation,I see the numbers 4096,4096,52224,1,root_hash and salt.

I know the doc says
4096 = datablock
4096 = hashblock
52224 = number of blocks
1 = hash offset



SIZE=$(blockdev --getsz /dev/sdb)

dmsetup create name -r --table "0 $SIZE verity 1 /dev/sdb /dev/sdc 4096
4096 52224 1 sha256 <root_hash> <salt>"

But my question how do I get these values for my setup? How do I know the
size

 of data block /hashblock in my case?How I calculate the number of blocks
and

root hash and salt to feed into the command.Can you please let me know the

process to get these values?

Also it mentions to use verity setup command for this purpose.Can you let
me know

the arguments or an example here?

Looking forward to your reply and help.

--089e01538de0a4881b04f63b438d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"font-family:arial,sans-serif;font-size:13px"=
>Hello ,</div><div style=3D"font-family:arial,sans-serif;font-size:13px">I =
am new to dm-verity and I am finding it hard to use it.</div><div style=3D"=
font-family:arial,sans-serif;font-size:13px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">This i=
s my setup.On one VM running Ubuntu-12.04,I have a nfs-share partition=A0</=
div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><d=
iv style=3D"font-family:arial,sans-serif;font-size:13px">
on which I have virtual disk image files of other vm&#39;s.I want to perfor=
m the integrity=A0</div><div style=3D"font-family:arial,sans-serif;font-siz=
e:13px"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px=
">
check on these files/nfs-share.</div><div style=3D"font-family:arial,sans-s=
erif;font-size:13px"><br></div><div style=3D"font-family:arial,sans-serif;f=
ont-size:13px">My nfs-share partition (/dev/sdb1 mounted at /nfs-share) siz=
e is 10GB.From the=A0</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">documentation,I see th=
e numbers 4096,4096,52224,1,root_hash and salt.</div><div style=3D"font-fam=
ily:arial,sans-serif;font-size:13px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">I know=
 the doc says</div><div style=3D"font-family:arial,sans-serif;font-size:13p=
x">4096 =3D datablock</div><div style=3D"font-family:arial,sans-serif;font-=
size:13px">
4096 =3D hashblock</div><div style=3D"font-family:arial,sans-serif;font-siz=
e:13px">52224 =3D number of blocks</div><div style=3D"font-family:arial,san=
s-serif;font-size:13px">1 =3D hash offset</div><div style=3D"font-family:ar=
ial,sans-serif;font-size:13px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br></=
div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><d=
iv style=3D"font-family:arial,sans-serif;font-size:13px">SIZE=3D$(blockdev =
--getsz /dev/sdb)</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">dmsetup create name -r=
 --table &quot;0 $SIZE verity 1 /dev/sdb /dev/sdc 4096=A0</div><div style=
=3D"font-family:arial,sans-serif;font-size:13px">
<a href=3D"tel:4096%2052224%201" value=3D"+14096522241" target=3D"_blank">4=
096 52224 1</a>=A0sha256 &lt;root_hash&gt; &lt;salt&gt;&quot;</div><div sty=
le=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div style=3D"=
font-family:arial,sans-serif;font-size:13px">
But my question how do I get these values for my setup? How do I know the s=
ize</div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br></d=
iv><div style=3D"font-family:arial,sans-serif;font-size:13px">=A0of data bl=
ock /hashblock in my case?How I calculate the number of blocks and=A0</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">root hash and salt to =
feed into the command.Can you please let me know the=A0</div><div style=3D"=
font-family:arial,sans-serif;font-size:13px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">proces=
s to get these values? =A0 =A0 =A0=A0</div><div style=3D"font-family:arial,=
sans-serif;font-size:13px"><br></div><div style=3D"font-family:arial,sans-s=
erif;font-size:13px">
Also it mentions to use verity setup command for this purpose.Can you let m=
e know=A0</div><div style=3D"font-family:arial,sans-serif;font-size:13px"><=
br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">the arg=
uments or an example here? =A0=A0</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">Looking forward to you=
r reply and help.</div></div>

--089e01538de0a4881b04f63b438d--


--===============8553106502408040882==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8553106502408040882==--
