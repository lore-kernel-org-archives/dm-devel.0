From: "Stamper, Brian P. (ARC-D)[Logyx LLC]" <brian.p.stamper@nasa.gov>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Fri, 27 Aug 2010 16:48:55 -0500
Message-ID: <C89D80D7.10732%brian.p.stamper@nasa.gov>
References: <20100827182634.GB31618@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3246361058636824756=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100827182634.GB31618@us.ibm.com>
Content-Language: en
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

--===============3246361058636824756==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C89D80D710732brianpstampernasagov_"

--_000_C89D80D710732brianpstampernasagov_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Here's what I've found:

If I vgchange the 2 affected VGs to inactive, multipath will pick up the de=
vices.  However, once I do that, I can't seem to get the VGs reactivated in=
 such a way to make the volumes mountable.  I use vgchange -a y to make the=
 VG active, then do "vgscan -mknodes".  That doesn't seem to create the dev=
ices in /dev, only in /dev/mapper, so I've tried issuing /etc/init.d/udev-p=
ost reload, which does create the volumes in /dev/<vg>/<lv>.  The issue is,=
 it has no blkid.  And if I try to mount the mapper device directly, mount =
doesn't know what filesystem type it is.  I'm not an lvm pro, so it's possi=
ble I'm missing a step or two, but in the past when moving around snapshots=
 of lvms, vgscan -mknodes has always been sufficient.

As for not having multipath in initrd, I have created an initrd image with =
the following:

mkinitrd /boot/initramfs-with-multipath.img 2.6.33.8-149.fc13.x86_64 --with=
=3Ddm-multipath

I then created a grub entry for it, booted off it, and no change in behavio=
r.  Is that what you had in mind?

-Brian

On 8/27/10 11:26 AM, "Malahal Naineni" <malahal@us.ibm.com> wrote:

If you can, deactivate the affected VG, restart multipath (it should be
able to load maps now) and then activate the VG. If this works, then
there is something that is causing LVM to claim devices before multipath
does.

Thanks, Malahal.
PS: If you don't have multipath in initrd, LVM *may* claim paths as PV's
before the multipath from active root can claim them. Don't have enough
info on Fedora13 initrd if this can happen though.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


--_000_C89D80D710732brianpstampernasagov_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: [dm-devel] oblem with lvm and multipath on fedora 13</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'><BR>
Here&#8217;s what I&#8217;ve found:<BR>
<BR>
If I vgchange the 2 affected VGs to inactive, multipath will pick up the de=
vices. &nbsp;However, once I do that, I can&#8217;t seem to get the VGs rea=
ctivated in such a way to make the volumes mountable. &nbsp;I use vgchange =
&#8211;a y to make the VG active, then do &#8220;vgscan &#8212;mknodes&#822=
1;. &nbsp;That doesn&#8217;t seem to create the devices in /dev, only in /d=
ev/mapper, so I&#8217;ve tried issuing /etc/init.d/udev-post reload, which =
does create the volumes in /dev/&lt;vg&gt;/&lt;lv&gt;. &nbsp;The issue is, =
it has no blkid. &nbsp;And if I try to mount the mapper device directly, mo=
unt doesn&#8217;t know what filesystem type it is. &nbsp;I&#8217;m not an l=
vm pro, so it&#8217;s possible I&#8217;m missing a step or two, but in the =
past when moving around snapshots of lvms, vgscan &#8212;mknodes has always=
 been sufficient.<BR>
<BR>
As for not having multipath in initrd, I have created an initrd image with =
the following:<BR>
<BR>
mkinitrd /boot/initramfs-with-multipath.img 2.6.33.8-149.fc13.x86_64 --with=
=3Ddm-multipath<BR>
<BR>
I then created a grub entry for it, booted off it, and no change in behavio=
r. &nbsp;Is that what you had in mind?<BR>
<BR>
-Brian<BR>
<BR>
On 8/27/10 11:26 AM, &quot;Malahal Naineni&quot; &lt;<a href=3D"malahal@us.=
ibm.com">malahal@us.ibm.com</a>&gt; wrote:<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'><BR>
If you can, deactivate the affected VG, restart multipath (it should be<BR>
able to load maps now) and then activate the VG. If this works, then<BR>
there is something that is causing LVM to claim devices before multipath<BR=
>
does.<BR>
<BR>
Thanks, Malahal.<BR>
PS: If you don't have multipath in initrd, LVM *may* claim paths as PV's<BR=
>
before the multipath from active root can claim them. Don't have enough<BR>
info on Fedora13 initrd if this can happen though.<BR>
<BR>
--<BR>
dm-devel mailing list<BR>
<a href=3D"dm-devel@redhat.com">dm-devel@redhat.com</a><BR>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.re=
dhat.com/mailman/listinfo/dm-devel</a><BR>
<BR>
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_C89D80D710732brianpstampernasagov_--


--===============3246361058636824756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3246361058636824756==--
