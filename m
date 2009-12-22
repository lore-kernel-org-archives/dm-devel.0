From: =?GB2312?B?1cXT7g==?= <chaimvy@gmail.com>
Subject: Re: Shared snapshots
Date: Tue, 22 Dec 2009 17:50:53 +0800
Message-ID: <b8091bb40912220150n5d3eb153ga5689f64bccda203@mail.gmail.com>
References: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0015337299346342850=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
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

--===============0015337299346342850==
Content-Type: multipart/alternative; boundary=000e0cd144684b208a047b4e24ca

--000e0cd144684b208a047b4e24ca
Content-Type: text/plain; charset=ISO-8859-1

does the origin device or cow  device can be resized dynamically?
once created the multisnapshot device 'ms':
echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnapshot /dev/mapper/
vg1-lv1 /dev/mapper/vg1-lv2 16 0 mikulas 0|dmsetup create ms
vg1-lv1, vg1-lv2, ms, if all of them can be resized dynamically?

thank you very much!


2009/12/16 Mikulas Patocka <mpatocka@redhat.com>

> Hi
>
> I uploaded new shared snapshots here:
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
>
> changes:
>
> - Broken to separate patches, one patch per file. The last patch adds all
> the files to Makefile and makes it all compile. It allows you to ack
> patches individually. I didn't use stubs to compile intermediate patches,
> the problem is that if multiple patches modify the same file, general
> modifications to the code become harder. With one-patch-per-file I can
> edit it with normal text editor and quilt regenerates the patches.
>
> - Document on-disk format in dm-multisnap-mikulas-struct.h
>
> - More functions are commented
>
> - Removed /*printk ... */ statements. I left some #ifdefed debug routines,
> they are non-trivial to write again
>
> - Fixed a bug on big-endian systems
>
> - Exposed interface for snapshots-of-snapshots, tested that they work
>
> Mikulas
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--000e0cd144684b208a047b4e24ca
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>does the origin=A0device=A0or cow=A0 device can be resized dynamically=
?</div>
<div>once created the multisnapshot device &#39;ms&#39;:</div>
<div><font style=3D"BACKGROUND-COLOR: #ffffff" color=3D"#3333ff">echo 0 `bl=
ockdev --getsize /dev/mapper/<font color=3D"#ffffff">vg1-lv1</font>` multis=
napshot /dev/mapper/<font color=3D"#990000">vg1-lv1</font> /dev/mapper/<fon=
t color=3D"#990000">vg1-lv2</font> 16 0 mikulas 0|dmsetup create <font colo=
r=3D"#990000">ms</font></font><br>
</div>
<div>vg1-lv1, vg1-lv2, ms, if all of them can be resized dynamically?</div>
<div>=A0</div>
<div>thank you very much!</div>
<div>=A0</div>
<div>=A0</div>
<div class=3D"gmail_quote">2009/12/16 Mikulas Patocka <span dir=3D"ltr">&lt=
;<a href=3D"mailto:mpatocka@redhat.com">mpatocka@redhat.com</a>&gt;</span><=
br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hi<br><br>I uploaded new shared =
snapshots here:<br><a href=3D"http://people.redhat.com/mpatocka/patches/ker=
nel/new-snapshots/devel/" target=3D"_blank">http://people.redhat.com/mpatoc=
ka/patches/kernel/new-snapshots/devel/</a><br>
<br>changes:<br><br>- Broken to separate patches, one patch per file. The l=
ast patch adds all<br>the files to Makefile and makes it all compile. It al=
lows you to ack<br>patches individually. I didn&#39;t use stubs to compile =
intermediate patches,<br>
the problem is that if multiple patches modify the same file, general<br>mo=
difications to the code become harder. With one-patch-per-file I can<br>edi=
t it with normal text editor and quilt regenerates the patches.<br><br>
- Document on-disk format in dm-multisnap-mikulas-struct.h<br><br>- More fu=
nctions are commented<br><br>- Removed /*printk ... */ statements. I left s=
ome #ifdefed debug routines,<br>they are non-trivial to write again<br>
<br>- Fixed a bug on big-endian systems<br><br>- Exposed interface for snap=
shots-of-snapshots, tested that they work<br><br>Mikulas<br><font color=3D"=
#888888"><br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-devel@redh=
at.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></font></blockq=
uote></div><br>

--000e0cd144684b208a047b4e24ca--


--===============0015337299346342850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0015337299346342850==--
