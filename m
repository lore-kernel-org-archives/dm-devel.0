From: "Stamper, Brian P. (ARC-D)[Stinger Ghaffarian Technologies Inc. (SGT
	Inc.)]" <brian.p.stamper@nasa.gov>
Subject: Re: Fedora 15 dm-linear device lookup failed
Date: Wed, 29 Jun 2011 14:47:25 -0500
Message-ID: <CA30CF5D.11CAD%brian.p.stamper@nasa.gov>
References: <CA303451.11C28%brian.p.stamper@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3431392326691361272=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA303451.11C28%brian.p.stamper@nasa.gov>
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

--===============3431392326691361272==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_CA30CF5D11CADbrianpstampernasagov_"

--_000_CA30CF5D11CADbrianpstampernasagov_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


I was able to boot this system by taking an initramfs from another Fedora 1=
5 test system and putting it in /boot and referencing it in grub.conf.  How=
ever, I need to find out why an initramfs I build on the system is unable t=
o boot.

When I'm in dracut, I was able to do some checking.  Using the lvm commands=
, I was able to activate and deactivate the vg, display the lvs, but not us=
e them.  I would get "device not found", and in /dev/mapper, the lvm device=
s were not there.  There were other lvm devices there, but not from my prim=
ary system lvm.  The only thing that stands out about it is that it is ext4=
, not ext3.

Comparing the decompiled initrds, there's no modules that stand out.  Sas.o=
ut is a listing of the WORKING initrd, tfs.out is the NOT WORKING initrd.

[root@testfs ramdisks]# diff sas.out tfs.out
718d717
< ./lib/firmware/ql2500_fw.bin
1248,1249d1246
< ./etc/ld.so.conf.d/openmotif-64.conf
< ./etc/ld.so.conf.d/kernel-2.6.38.7-30.fc15.x86_64.conf
1252c1249
< ./etc/ld.so.conf.d/kernel-2.6.34.8-68.fc13.x86_64.conf
---
> ./etc/ld.so.conf.d/qt-x86_64.conf
1262d1258
< ./etc/modprobe.d/openfwwf.conf
1278a1275
> ./etc/udev/rules.d/40-multipath.rules
1317a1315
> ./lib64/libcryptsetup.so.1.2.0
1322a1321
> ./lib64/libcap.so
1407d1405
< ./lib64/libcryptsetup.so.1.1.0
1419a1418
> ./lib64/libnss_files-2.12.2.so
1480a1480
> ./usr/bin/checkisomd5
1491d1490
< ./usr/lib64/libnss_files.so
1517a1517
> ./usr/share/plymouth/themes/default.plymouth

Nothing there looks relevant.  Libcryptsetup needs updating on the test sys=
tem I pulled the initrd from.  The q-logic firmware is irrelevant.  There a=
re a couple of older kernels on the test system.  Libcap.so is a dependency=
 of legato backup software.  Libnss_files should have nothing to do with ac=
cessing an LVM.

So I'm stuck.  My system is up, but only if I build an initrd on another sy=
stem and copy it over, meaning next time I update the kernel it will not bo=
ot.  Nothing's jumping out at me as obviously missing modules from the brok=
en initrd.  Where else can I look?

-Brian




On 6/29/11 1:45 AM, "Brian Stamper" <brian.p.stamper@nasa.gov> wrote:

I just upgraded a Fedora system from 13 to 15, and now I can't get it to bo=
ot.  I'm getting dumped to a dracut shell and getting the error dm-linear d=
evice lookup failed.  In the dracut output with debug on, I see dracut scan=
 my drives, and I see it find my 3 LVs, but it then tries to do something w=
ith them, I get the error, and it then fails out with root device not found=
 and drops me into dracut.

Here's the odd thing, booting off the rescue dvd my volumes are fine.  The =
LVM can be mounted no problem.

This makes me think that there's something missing from the kernel or initr=
d.  I can't really figure out what though.  I've gone through the output of=
 lsmod when running from the rescue dvd.  I've even build a few ramdisks in=
cluding all the modules that I thought might be related (dm, lvm, mdraid, d=
mraid, multipath).  I tried building them with mkinitrd -with=3Dmodule, and=
 I tried again with dracut -add=3Dmodules.  No change in results.

I'm not sure where to go from here.  I feel like the system can be rescued,=
 but I don't know how to work backward through dracut to find out why it's =
unable to find my root volume.  Any help would be appreciated.  Cross-posti=
ng to lvm.

Thanks,
-Brian

--_000_CA30CF5D11CADbrianpstampernasagov_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: [dm-devel] Fedora 15 dm-linear device lookup failed</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'><BR>
I was able to boot this system by taking an initramfs from another Fedora 1=
5 test system and putting it in /boot and referencing it in grub.conf. &nbs=
p;However, I need to find out why an initramfs I build on the system is una=
ble to boot.<BR>
<BR>
When I&#8217;m in dracut, I was able to do some checking. &nbsp;Using the l=
vm commands, I was able to activate and deactivate the vg, display the lvs,=
 but not use them. &nbsp;I would get &#8220;device not found&#8221;, and in=
 /dev/mapper, the lvm devices were not there. &nbsp;There were other lvm de=
vices there, but not from my primary system lvm. &nbsp;The only thing that =
stands out about it is that it is ext4, not ext3.<BR>
<BR>
Comparing the decompiled initrds, there&#8217;s no modules that stand out. =
&nbsp;Sas.out is a listing of the WORKING initrd, tfs.out is the NOT WORKIN=
G initrd.<BR>
<BR>
[root@testfs ramdisks]# diff sas.out tfs.out <BR>
718d717<BR>
&lt; ./lib/firmware/ql2500_fw.bin<BR>
1248,1249d1246<BR>
&lt; ./etc/ld.so.conf.d/openmotif-64.conf<BR>
&lt; ./etc/ld.so.conf.d/kernel-2.6.38.7-30.fc15.x86_64.conf<BR>
1252c1249<BR>
&lt; ./etc/ld.so.conf.d/kernel-2.6.34.8-68.fc13.x86_64.conf<BR>
---<BR>
&gt; ./etc/ld.so.conf.d/qt-x86_64.conf<BR>
1262d1258<BR>
&lt; ./etc/modprobe.d/openfwwf.conf<BR>
1278a1275<BR>
&gt; ./etc/udev/rules.d/40-multipath.rules<BR>
1317a1315<BR>
&gt; ./lib64/libcryptsetup.so.1.2.0<BR>
1322a1321<BR>
&gt; ./lib64/libcap.so<BR>
1407d1405<BR>
&lt; ./lib64/libcryptsetup.so.1.1.0<BR>
1419a1418<BR>
&gt; ./lib64/libnss_files-2.12.2.so<BR>
1480a1480<BR>
&gt; ./usr/bin/checkisomd5<BR>
1491d1490<BR>
&lt; ./usr/lib64/libnss_files.so<BR>
1517a1517<BR>
&gt; ./usr/share/plymouth/themes/default.plymouth<BR>
<BR>
Nothing there looks relevant. &nbsp;Libcryptsetup needs updating on the tes=
t system I pulled the initrd from. &nbsp;The q-logic firmware is irrelevant=
. &nbsp;There are a couple of older kernels on the test system. &nbsp;Libca=
p.so is a dependency of legato backup software. &nbsp;Libnss_files should h=
ave nothing to do with accessing an LVM.<BR>
<BR>
So I&#8217;m stuck. &nbsp;My system is up, but only if I build an initrd on=
 another system and copy it over, meaning next time I update the kernel it =
will not boot. &nbsp;Nothing&#8217;s jumping out at me as obviously missing=
 modules from the broken initrd. &nbsp;Where else can I look?<BR>
<BR>
-Brian<BR>
<BR>
<BR>
<BR>
<BR>
On 6/29/11 1:45 AM, &quot;Brian Stamper&quot; &lt;<a href=3D"brian.p.stampe=
r@nasa.gov">brian.p.stamper@nasa.gov</a>&gt; wrote:<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'>I just upgraded a Fedora system from 13 to =
15, and now I can&#8217;t get it to boot. &nbsp;I&#8217;m getting dumped to=
 a dracut shell and getting the error dm-linear device lookup failed. &nbsp=
;In the dracut output with debug on, I see dracut scan my drives, and I see=
 it find my 3 LVs, but it then tries to do something with them, I get the e=
rror, and it then fails out with root device not found and drops me into dr=
acut.<BR>
<BR>
Here&#8217;s the odd thing, booting off the rescue dvd my volumes are fine.=
 &nbsp;The LVM can be mounted no problem.<BR>
<BR>
This makes me think that there&#8217;s something missing from the kernel or=
 initrd. &nbsp;I can&#8217;t really figure out what though. &nbsp;I&#8217;v=
e gone through the output of lsmod when running from the rescue dvd. &nbsp;=
I&#8217;ve even build a few ramdisks including all the modules that I thoug=
ht might be related (dm, lvm, mdraid, dmraid, multipath). &nbsp;I tried bui=
lding them with mkinitrd &#8212;with=3Dmodule, and I tried again with dracu=
t &#8212;add=3Dmodules. &nbsp;No change in results.<BR>
<BR>
I&#8217;m not sure where to go from here. &nbsp;I feel like the system can =
be rescued, but I don&#8217;t know how to work backward through dracut to f=
ind out why it&#8217;s unable to find my root volume. &nbsp;Any help would =
be appreciated. &nbsp;Cross-posting to lvm.<BR>
<BR>
Thanks,<BR>
-Brian<BR>
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_CA30CF5D11CADbrianpstampernasagov_--


--===============3431392326691361272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3431392326691361272==--
