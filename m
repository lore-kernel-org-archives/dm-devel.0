From: Jacob Broido <jacob.broido@gmail.com>
Subject: Fwd: cow snapshot on cloop device
Date: Wed, 24 Aug 2005 19:01:21 +0200
Message-ID: <6262291505082410015647272d@mail.gmail.com>
References: <6262291505082404352d0a4dc2@mail.gmail.com>
	<200508241358.56758.kevcorry@us.ibm.com>
	<6262291505082410002ca214a9@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0714975048=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6262291505082410002ca214a9@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0714975048==
Content-Type: multipart/alternative;
	boundary="----=_Part_693_17149490.1124902881095"

------=_Part_693_17149490.1124902881095
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------- Forwarded message ----------
From: Jacob Broido <jacob.broido@gmail.com>
Date: Aug 24, 2005 7:00 PM
Subject: Re: [dm-devel] cow snapshot on cloop device
To: Kevin Corry <kevcorry@us.ibm.com>

I am using dmsetup directly. and I do the following:
1) Create an empty file that will be used as cow backing storage
2) losetup the backing file to /dev/loop0
3) create a snapshot of main root_device on /dev/loop0
4) mount the cow snapshot


Here is the info you requested:
The kernel is a - 2.6.11.10 <http://2.6.11.10> + xen patch.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
/ # dmsetup ls
root_master (253, 0)
root_cow0 (253, 1)
/ # dmsetup table
root_master: 0 4096128 linear 240:0 0=20
root_cow0: 0 4096128 snapshot 253:0 7:0 P 8

/ # cat /proc/partitions

major minor #blocks name

7 0 loop0
8 0 sda
8 1 sda1
8 2 sda2
8 3 sda3
240 0 cloop0
252 0 dm-0
253 1 dm-1

/ # cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root.old / ext2 rw 0 0
/proc /proc proc rw,noadirtime 0 0
/sys /sys sysfs rw 0 0
/dev/hdc /cdrom iso9660 ro 0 0
/ramdisk /ramdisk tmpfs rw 0 0
/dev/mapper/root_cow0 /cow ext2 rw.noatime 0 0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

On 8/24/05, Kevin Corry <kevcorry@us.ibm.com> wrote:=20
>=20
> On Wed August 24 2005 11:35 am, Jacob Broido wrote:
> > Hi,
> > I am trying to set a cow snapshot on a cloop device.=20
> > I managed to create a snapshot and mount it as read/write, but it=20
> appears
> > that the data inside the /cloop appears invalid:
> >
> > Binary executables appear to be invalid, I perfomed diff between files=
=20
> on=20
> > snapshotted /dev/cloop, and the same files accessed directly through=20
> cloop.
> >
> > The files were diffrent,
> > anyone has idea as to what can be the reason for this?
>=20
> Are you using LVM, EVMS, or dmsetup to create your snapshot? Please send=
=20
> in=20
> the output from "dmsetup ls" and "dmsetup table", as well as the contents
> of /proc/partitions and /proc/mounts, after you have activated and mounte=
d
> your snapshot.
>=20
> --
> Kevin Corry
> kevcorry@us.ibm.com
> http://www.ibm.com/linux/
> http://evms.sourceforge.net/
>=20



--=20
Not gonna be king of the world if you're slave to the grind
- Skid Row=20


--=20
Not gonna be king of the world if you're slave to the grind
- Skid Row

------=_Part_693_17149490.1124902881095
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<br><br>---------- Forwarded message ----------<br><span class=3D"gmail_quo=
te">From: <b class=3D"gmail_sendername">Jacob Broido</b> &lt;<a href=3D"mai=
lto:jacob.broido@gmail.com">jacob.broido@gmail.com</a>&gt;<br>Date: Aug 24,=
 2005 7:00 PM
<br>Subject: Re: [dm-devel] cow snapshot on cloop device<br>To: Kevin Corry=
 &lt;<a href=3D"mailto:kevcorry@us.ibm.com">kevcorry@us.ibm.com</a>&gt;<br>=
<br></span>I am using dmsetup directly. and I do the following:<br>
1) Create an empty file that will be used as cow backing storage<br>
2) losetup the backing file to /dev/loop0<br>
3) create a snapshot of main root_device on /dev/loop0<br>
4) mount the cow snapshot<br>
<br>
<br>
Here is the info you requested:<br>
The kernel is a - <a href=3D"http://2.6.11.10" target=3D"_blank" onclick=3D=
"return top.js.OpenExtLink(window,event,this)">2.6.11.10</a> + xen patch.<b=
r>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D<br>
/ # dmsetup ls<br>
root_master &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (253, 0)<br>
root_cow0&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; (253, 1)<br>
/ # dmsetup table<br>
root_master: 0 4096128 linear 240:0 0 <br>
root_cow0: 0 4096128 snapshot 253:0 7:0 P 8<br>
<br>
/ # cat /proc/partitions<br>
<br>
major minor&nbsp; #blocks&nbsp;&nbsp;&nbsp; name<br>
<br>
7&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; loop0<br>
8&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sda<br>
8&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sda1<br>
8&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sda2<br>
8&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; sda3<br>
240&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cloop0<br>
252&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dm-0<br>
253&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dm-1<br>
<br>
/ # cat /proc/mounts<br>
rootfs / rootfs rw 0 0<br>
/dev/root.old&nbsp; / ext2 rw 0 0<br>
/proc /proc proc rw,noadirtime 0 0<br>
/sys&nbsp; /sys sysfs rw 0 0<br>
/dev/hdc /cdrom iso9660 ro 0 0<br>
/ramdisk /ramdisk tmpfs rw 0 0<br>
/dev/mapper/root_cow0 /cow ext2 rw.noatime 0 0<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D<div><span class=3D"e" id=3D"q_105e96f6f1d75cf8_1"><br><br><div><span=
 class=3D"gmail_quote">On 8/24/05, <b class=3D"gmail_sendername">Kevin Corr=
y</b> &lt;<a href=3D"mailto:kevcorry@us.ibm.com" target=3D"_blank" onclick=
=3D"return top.js.OpenExtLink(window,event,this)">
kevcorry@us.ibm.com</a>&gt; wrote:
</span><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rg=
b(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">On Wed Aug=
ust 24 2005 11:35 am, Jacob Broido wrote:<br>&gt; Hi,<br>&gt; I am trying t=
o set a cow snapshot on a cloop device.
<br>&gt; I managed to create a snapshot and mount it as read/write, but it =
appears<br>&gt; that the data inside the /cloop appears invalid:<br>&gt;<br=
>&gt; Binary executables appear to be invalid, I perfomed diff between file=
s on
<br>&gt; snapshotted /dev/cloop, and the same files accessed directly throu=
gh cloop.<br>&gt;<br>&gt; The files were diffrent,<br>&gt; anyone has idea =
as to what can be the reason for this?<br><br>Are you using LVM, EVMS, or d=
msetup to create your snapshot? Please send in
<br>the output from &quot;dmsetup ls&quot; and &quot;dmsetup table&quot;, a=
s well as the contents<br>of /proc/partitions and /proc/mounts, after you h=
ave activated and mounted<br>your snapshot.<br><br>--<br>Kevin Corry<br>

<a href=3D"mailto:kevcorry@us.ibm.com" target=3D"_blank" onclick=3D"return =
top.js.OpenExtLink(window,event,this)">kevcorry@us.ibm.com</a><br><a href=
=3D"http://www.ibm.com/linux/" target=3D"_blank" onclick=3D"return top.js.O=
penExtLink(window,event,this)">
http://www.ibm.com/linux/</a><br><a href=3D"http://evms.sourceforge.net/" t=
arget=3D"_blank" onclick=3D"return top.js.OpenExtLink(window,event,this)">h=
ttp://evms.sourceforge.net/</a><br></blockquote>
</div><br><br clear=3D"all"><br></span></div><div><span class=3D"e" id=3D"q=
_105e96f6f1d75cf8_2">-- <br>Not gonna be king of the world if you're slave =
to the grind<br>- Skid Row

</span></div><br clear=3D"all"><br>-- <br>Not gonna be king of the world if=
 you're slave to the grind<br>- Skid Row

------=_Part_693_17149490.1124902881095--


--===============0714975048==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0714975048==--
