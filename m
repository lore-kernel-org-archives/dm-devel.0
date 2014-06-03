From: Frederick Grose <fgrose@gmail.com>
Subject: Re: Persistent Overlay COW Full: Flipped the Invalid bit
 in a hexdump; how do I grow it now?
Date: Tue, 3 Jun 2014 10:45:16 -0400
Message-ID: <CAEcBt+V1dPs+4qJ0wQ+7BwCKF+K_PGdowLNA8dFBUzVf+sbxJg@mail.gmail.com>
References: <CAF5F7ZKGG-S1oouoUT+f_vitg_gpov=NHPRDjL7aLiOdbXf+uA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1288231971197112967=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAF5F7ZKGG-S1oouoUT+f_vitg_gpov=NHPRDjL7aLiOdbXf+uA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1288231971197112967==
Content-Type: multipart/alternative; boundary=089e01182fb6cfbbb104faef9171

--089e01182fb6cfbbb104faef9171
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 3, 2014 at 9:20 AM, Rahul Nabar <rpnabar@gmail.com> wrote:

> I accidentally managed to fill up the persistent COW snapshot overlay
> on my Fedora20 USB & it got flagged Invalid thus rendering the Live
> USB unbootable since the root filesystem couldn't be mounted.
>
> dmsetup status
> live-rw 0 8388608 snapshot Invalid.
>
>  Subsequently I used a 2011 thread(link below) on the dm-devel mailing
> list ( Alasdair Kergon, Frederick Grose etc.) and flipped the invalid
> bit in the overlay file by booting a different system and attaching
> the USB stick to it.
>
> Like so:  echo $'\x01' | dd
> of=3D/run/media..../liveuser/LIVE.../overlay-LIVE-17F4-055A  bs=3D1
> count=3D1 seek=3D4 conv=3Dnotrunc
>
> hexdump of the file verified the flipped 5th byte. Now the LiveUSB
> boots & I can successfully see my data but it's hard to do anything
> more since it gets full almost immediately after I boot.
>
> Is there a way to grow the overlay file? Would this work?
>
>  dd if=3D/dev/zero of=3Doverlay-LIVE-17F4-055A seek=3Doverlay_size
> count=3Dsize_increase
>
> How do I compute the number overlay_size?


=E2=80=8Bblockdev -q --getsz <overlay/device/path or overlay/file/path>=E2=
=80=8B

or the denominator in the

dmsetup status

for the live-rw snapshot

(Units are 512 byte sectors.)

I suppose size_increase can
> be some large number?
>
> Or are more steps needed to expand the overlay?
>
>
> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/14644


=E2=80=8BSee
=E2=80=8Bhttps://fedoraproject.org/wiki/LiveOS_image#Merge_overlay_into_new=
_image

     --Fred

--089e01182fb6cfbbb104faef9171
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:&#39;tre=
buchet ms&#39;,sans-serif;font-size:small;color:rgb(0,0,153)"><span style=
=3D"font-family:arial;color:rgb(34,34,34)">On Tue, Jun 3, 2014 at 9:20 AM, =
Rahul Nabar </span><span dir=3D"ltr" style=3D"font-family:arial;color:rgb(3=
4,34,34)">&lt;<a href=3D"mailto:rpnabar@gmail.com" target=3D"_blank">rpnaba=
r@gmail.com</a>&gt;</span><span style=3D"font-family:arial;color:rgb(34,34,=
34)"> wrote:</span><br>

</div><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;=
border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex=
">I accidentally managed to fill up the persistent COW snapshot overlay<br>


on my Fedora20 USB &amp; it got flagged Invalid thus rendering the Live<br>
USB unbootable since the root filesystem couldn&#39;t be mounted.<br>
<br>
dmsetup status<br>
live-rw 0 8388608 snapshot Invalid.<br>
<br>
=C2=A0Subsequently I used a 2011 thread(link below) on the dm-devel mailing=
<br>
list ( Alasdair Kergon, Frederick Grose etc.) and flipped the invalid<br>
bit in the overlay file by booting a different system and attaching<br>
the USB stick to it.<br>
<br>
Like so: =C2=A0echo $&#39;\x01&#39; | dd<br>
of=3D/run/media..../liveuser/LIVE.../overlay-LIVE-17F4-055A =C2=A0bs=3D1<br=
>
count=3D1 seek=3D4 conv=3Dnotrunc<br>
<br>
hexdump of the file verified the flipped 5th byte. Now the LiveUSB<br>
boots &amp; I can successfully see my data but it&#39;s hard to do anything=
<br>
more since it gets full almost immediately after I boot.<br>
<br>
Is there a way to grow the overlay file? Would this work?<br>
<br>
=C2=A0dd if=3D/dev/zero of=3Doverlay-LIVE-17F4-055A seek=3Doverlay_size cou=
nt=3Dsize_increase<br>
<br>
How do I compute the number overlay_size?</blockquote><div><br></div><div c=
lass=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><span s=
tyle=3D"font-family:&#39;trebuchet ms&#39;,sans-serif">=E2=80=8B</span><fon=
t face=3D"courier new, monospace">blockdev -q --getsz &lt;overlay/device/pa=
th or overlay/file/path&gt;=E2=80=8B</font></div>

<div class=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><=
font face=3D"courier new, monospace"><br></font></div><div class=3D"gmail_d=
efault" style=3D"font-size:small;color:rgb(0,0,153)"><font face=3D"courier =
new, monospace">or the denominator in the=C2=A0</font></div>

<div class=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><=
font face=3D"courier new, monospace"><br></font></div><div class=3D"gmail_d=
efault" style=3D"font-size:small;color:rgb(0,0,153)"><font face=3D"courier =
new, monospace">dmsetup status</font></div>

<div class=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><=
font face=3D"courier new, monospace"><br></font></div><div class=3D"gmail_d=
efault" style=3D"font-size:small;color:rgb(0,0,153)"><font face=3D"courier =
new, monospace">for the live-rw snapshot</font></div>

<div class=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><=
font face=3D"courier new, monospace"><br></font></div><div class=3D"gmail_d=
efault" style=3D"font-size:small;color:rgb(0,0,153)"><font face=3D"courier =
new, monospace">(Units are 512 byte sectors.)</font></div>

<div class=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><=
font face=3D"courier new, monospace"><br></font></div><blockquote class=3D"=
gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border=
-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">

 I suppose size_increase can<br>
be some large number?<br>
<br>
Or are more steps needed to expand the overlay?<br>
<br>
<br>
<a href=3D"http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/1=
4644" target=3D"_blank">http://thread.gmane.org/gmane.linux.kernel.device-m=
apper.devel/14644</a></blockquote><div><br></div><div class=3D"gmail_defaul=
t" style=3D"font-size:small;color:rgb(0,0,153)">

<span style=3D"font-family:&#39;trebuchet ms&#39;,sans-serif">=E2=80=8B</sp=
an><font face=3D"courier new, monospace">See</font></div><div class=3D"gmai=
l_default" style=3D"font-size:small;color:rgb(0,0,153)"><font face=3D"couri=
er new, monospace">=E2=80=8B<a href=3D"https://fedoraproject.org/wiki/LiveO=
S_image#Merge_overlay_into_new_image">https://fedoraproject.org/wiki/LiveOS=
_image#Merge_overlay_into_new_image</a></font></div>

<div class=3D"gmail_default" style=3D"font-size:small;color:rgb(0,0,153)"><=
font face=3D"courier new, monospace"><br></font></div><div class=3D"gmail_d=
efault" style=3D"font-size:small;color:rgb(0,0,153)"><font face=3D"courier =
new, monospace">=C2=A0 =C2=A0 =C2=A0--Fred</font></div>

</div></div></div>

--089e01182fb6cfbbb104faef9171--


--===============1288231971197112967==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1288231971197112967==--
