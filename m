From: Jacob Broido <jacob.broido@gmail.com>
Subject: Re: Fwd: cow snapshot on cloop device
Date: Fri, 26 Aug 2005 03:51:16 +0200
Message-ID: <6262291505082518517c9d1adb@mail.gmail.com>
References: <6262291505082404352d0a4dc2@mail.gmail.com>
	<6262291505082410002ca214a9@mail.gmail.com>
	<6262291505082410015647272d@mail.gmail.com>
	<200508251902.39765.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1735568122=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200508251902.39765.kevcorry@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin Corry <kevcorry@us.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1735568122==
Content-Type: multipart/alternative;
	boundary="----=_Part_2110_12103172.1125021076618"

------=_Part_2110_12103172.1125021076618
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hey Kevin,
Thanks for the response,

I've read through the thread but I am not clear on a few issues,

Why is there a need to create a snapshot-origin, isnt the fact that I creat=
e=20
snapshot of a specific device, in my case root_master, using the command :=
=20
echo "0 4096128 snapshot root_master /dev/loop0 p 8"| dmsetup create=20
root_cow0=20
already monitors the origin device root_master for write operations?

As far as I understood the COW/snapshot logic is the following:
1) Snapshot device is created over some other dm device
2) snapshot dm device is mounted.
3) Any call to write() or othere rw syscalls issues a write to backing stor=
e=20
as defined during creation of snapshot device, and relevant pointers=20
updated.
4) Read from mounted snapshot device, results in one of the following : if=
=20
data was modified since the snapshot its read from COW backing=20
device(transparently to end user) , if data was not modified from snapshot=
=20
creation, its read from origin dm device.


In addition as I mentioned, I am able to mount the dm snapshot device, and =
I=20
am also able to perform write operations (even though the origin device is=
=20
on a readonly media).

The problem I encountered is data corruption and is partial, all files are=
=20
partially damaged or have corrupted parts.

What am I missing?

P.S Is there a documentation reagrding varios targets and their table forma=
t
P.P.S in snapshot creation, what does <p|n> mean.
Thanks.


On 8/26/05, Kevin Corry <kevcorry@us.ibm.com> wrote:
>=20
> Hi Jacob,
>=20
> On Wed August 24 2005 12:01 pm, Jacob Broido wrote:
> > ---------- Forwarded message ----------
> > From: Jacob Broido <jacob.broido@gmail.com>
> > Date: Aug 24, 2005 7:00 PM
> > Subject: Re: [dm-devel] cow snapshot on cloop device
> > To: Kevin Corry <kevcorry@us.ibm.com>
> >
> > I am using dmsetup directly. and I do the following:
> > 1) Create an empty file that will be used as cow backing storage
> > 2) losetup the backing file to /dev/loop0
> > 3) create a snapshot of main root_device on /dev/loop0
> > 4) mount the cow snapshot
> >
> >
> > Here is the info you requested:
> > The kernel is a - 2.6.11.10 <http://2.6.11.10> <http://2.6.11.10> + xen=
=20
> patch.
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > / # dmsetup ls
> > root_master (253, 0)
> > root_cow0 (253, 1)
> > / # dmsetup table
> > root_master: 0 4096128 linear 240:0 0
> > root_cow0: 0 4096128 snapshot 253:0 7:0 P 8
>=20
> Ok, this is not going to do what you're expecting it to do. In order to=
=20
> use
> snapshotting, you need a snapshot device, and you also need a=20
> snapshot-origin
> device. The snapshot-origin code is what monitors the I/O path for the=20
> origin
> device, and performs the copy-on-writes as necessary.
>=20
> Last summer I did a write-up how you might use dmsetup to create=20
> snapshots.
> You can read the thread at:
> https://www.redhat.com/archives/dm-devel/2004-July/msg00068.html
>=20
> But in short, it's vastly simpler to just use LVM2 or EVMS to create
> snapshots. You should be able to create volumes on your cloop devices=20
> using
> either set of tools.
>=20
> Let me know if you have additional questions after reading through the=20
> thread
> above.
>=20
> --
> Kevin Corry
> kevcorry@us.ibm.com
> http://www.ibm.com/linux/
> http://evms.sourceforge.net/
>=20



--=20
Not gonna be king of the world if you're slave to the grind
- Skid Row

------=_Part_2110_12103172.1125021076618
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hey Kevin,<br>
Thanks for the response,<br>
<br>
I've read through the thread but I am not clear on a few issues,<br>
<br>
&nbsp;Why is there a need to create a snapshot-origin, isnt the fact
that I create snapshot of a specific device, in my case root_master,
using the command : <br>
echo &quot;0 <span class=3D"q">4096128 snapshot&nbsp; root_master /dev/loop=
0 p 8&quot;| dmsetup create root_cow0 <br>
already monitors the origin device root_master for write operations?<br>
<br>
As far as I understood the COW/snapshot logic is the following:<br>
1) Snapshot device is created over some other dm device<br>
2) snapshot dm device is mounted.<br>
3) Any call to write() or othere rw syscalls issues a write to backing
store as defined during creation of snapshot device, and relevant
pointers updated.<br>
4) Read from mounted snapshot device, results in one of the following :
if data was modified since the snapshot its read from COW backing
device(transparently to end user) , if data was not modified from
snapshot creation, its read from origin dm device.<br>
<br>
<br>
In addition as I mentioned, I am able to mount the dm snapshot device,
and I am also able to perform write operations (even though the origin
device is on a readonly media).<br>
<br>
The problem I encountered is data corruption and is partial, all files are =
partially damaged or have corrupted parts.<br>
<br>
What am I missing?<br>
<br>
</span>P.S Is there a documentation reagrding varios targets and their tabl=
e format<br>
P.P.S in snapshot creation, what does &lt;p|n&gt; mean.<br>
Thanks.<br>
<br>
<br><div><span class=3D"gmail_quote">On 8/26/05, <b class=3D"gmail_senderna=
me">Kevin Corry</b> &lt;<a href=3D"mailto:kevcorry@us.ibm.com">kevcorry@us.=
ibm.com</a>&gt; wrote:</span><blockquote class=3D"gmail_quote" style=3D"bor=
der-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-=
left: 1ex;">
Hi Jacob,<br><br>On Wed August 24 2005 12:01 pm, Jacob Broido wrote:<br>&gt=
; ---------- Forwarded message ----------<br>&gt; From: Jacob Broido &lt;<a=
 href=3D"mailto:jacob.broido@gmail.com">jacob.broido@gmail.com</a>&gt;<br>
&gt; Date: Aug 24, 2005 7:00 PM<br>&gt; Subject: Re: [dm-devel] cow snapsho=
t on cloop device<br>&gt; To: Kevin Corry &lt;<a href=3D"mailto:kevcorry@us=
.ibm.com">kevcorry@us.ibm.com</a>&gt;<br>&gt;<br>&gt; I am using dmsetup di=
rectly. and I do the following:
<br>&gt; 1) Create an empty file that will be used as cow backing storage<b=
r>&gt; 2) losetup the backing file to /dev/loop0<br>&gt; 3) create a snapsh=
ot of main root_device on /dev/loop0<br>&gt; 4) mount the cow snapshot<br>
&gt;<br>&gt;<br>&gt; Here is the info you requested:<br>&gt; The kernel is =
a - <a href=3D"http://2.6.11.10">2.6.11.10</a> &lt;<a href=3D"http://2.6.11=
.10">http://2.6.11.10</a>&gt; + xen patch.<br>&gt; =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
<br>&gt; / # dmsetup ls<br>&gt; root_master (253, 0)<br>&gt; root_cow0 (253=
, 1)<br>&gt; / # dmsetup table<br>&gt; root_master: 0 4096128 linear 240:0 =
0<br>&gt; root_cow0: 0 4096128 snapshot 253:0 7:0 P 8<br><br>Ok, this is no=
t going to do what you're expecting it to do. In order to use
<br>snapshotting, you need a snapshot device, and you also need a snapshot-=
origin<br>device. The snapshot-origin code is what monitors the I/O path fo=
r the origin<br>device, and performs the copy-on-writes as necessary.<br>
<br>Last summer I did a write-up how you might use dmsetup to create snapsh=
ots.<br>You can read the thread at:<br><a href=3D"https://www.redhat.com/ar=
chives/dm-devel/2004-July/msg00068.html">https://www.redhat.com/archives/dm=
-devel/2004-July/msg00068.html
</a><br><br>But in short, it's vastly simpler to just use LVM2 or EVMS to c=
reate<br>snapshots. You should be able to create volumes on your cloop devi=
ces using<br>either set of tools.<br><br>Let me know if you have additional=
 questions after reading through the thread
<br>above.<br><br>--<br>Kevin Corry<br><a href=3D"mailto:kevcorry@us.ibm.co=
m">kevcorry@us.ibm.com</a><br><a href=3D"http://www.ibm.com/linux/">http://=
www.ibm.com/linux/</a><br><a href=3D"http://evms.sourceforge.net/">http://e=
vms.sourceforge.net/
</a><br></blockquote></div><br><br clear=3D"all"><br>-- <br>Not gonna be ki=
ng of the world if you're slave to the grind<br>- Skid Row

------=_Part_2110_12103172.1125021076618--


--===============1735568122==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1735568122==--
