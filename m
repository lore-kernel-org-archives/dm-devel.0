From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 08:21:45 -0400
Message-ID: <1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324115708.GM5528@edu.joroinen.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Ross S. W. Walker" <rwalker@medallion.com>
List-Id: dm-devel.ids

On Tue, 2009-03-24 at 13:57 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Tue, Mar 24, 2009 at 07:02:41AM -0400, John A. Sullivan III wrote:
> > > > <snip>
> > > > I'm trying to spend a little time on this today and am really fee=
ling my
> > > > ignorance on the way iSCSI works :(  It looks like linux-iscsi su=
pports
> > > > MC/S but has not been in active development and will not even com=
pile on
> > > > my 2.6.27 kernel.
> > > >=20
> > > > To simplify matters, I did put each SAN interface on a separate n=
etwork.
> > > > Thus, all the different sessions.  If I place them all on the sam=
e
> > > > network and use the iface parameters of open-iscsi, does that eli=
minate
> > > > the out-of-order problem and allow me to achieve the performance
> > > > scalability I'm seeking from dm-multipath in multibus mode? Thank=
s -
> > > > John
> > >=20
> > > If you use ifaces feature of open-iscsi, you still get separate ses=
sions.
> > >=20
> > > open-iscsi just does not support MC/s :(
> > >=20
> > > I think core-iscsi does support MC/s..=20
> > >=20
> > > Then you again you should play with the different multipath setting=
s, and
> > > tweak how often IOs are split to different paths etc.. maybe that h=
elps.
> > >=20
> > > -- Pasi
> > <snip>
> > I think we're pretty much at the end of our options here but I docume=
nt
> > what I've found thus far for closure.
> >=20
> > Indeed, there seems to be no way around the session problem.  Core-is=
csi
> > does seem to support MC/s but has not been updated in years.  It did =
not
> > compile with my 2.6.27 kernel and, given that others seem to have had
> > the same problem, I did not spend a lot of time troubleshooting it.
> >=20
>=20
> Core-iscsi developer seems to be active developing at least the=20
> new iSCSI target (LIO target).. I think he has been testing it with
> core-iscsi, so maybe there's newer version somewhere?=20
>=20
> > We did play with the multipath rr_min_io settings and smaller always
> > seemed to be better until we got into very large numbers of session. =
 We
> > were testing on a dual quad core AMD Shanghai 2378 system with 32 GB
> > RAM, a quad port Intel e1000 card and two on-board nvidia forcedeth
> > ports with disktest using 4K blocks to mimic the file system using
> > sequential reads (and some sequential writes).
> >=20
>=20
> Nice hardware. Btw are you using jumbo frames or flow control for iSCSI
> traffic?=20
>=20
> > With a single thread, there was no difference at all - only about 12.=
79
> > MB/s no matter what we did.  With 10 threads and only two interfaces,
> > there was only a slight difference between rr=3D1 (81.2B/s), rr=3D10 =
(78.87)
> > and rr=3D100 (80).
> >=20
> > However, when we opened to three and four interfaces, there was a hug=
e
> > jump for rr=3D1 (100.4, 105.95) versus rr=3D10 (80.5, 80.75) and rr=3D=
100
> > (74.3, 77.6).
> >=20
> > At 100 threads on three or four ports, the best performance shifted t=
o
> > rr=3D10 (327 MB/s, 335) rather than rr=3D1 (291.7, 290.1) or rr=3D100=
 (216.3).
> > At 400 threads, rr=3D100 started to overtake rr=3D10 slightly.
> >=20
> > This was using all e1000 interfaces. Our first four port test include=
d
> > one of the on board ports and performance was dramatically less than
> > three e1000 ports.  Subsequent testing tweaking forcedeth parameters
> > from defaults yielded no improvement.
> >=20
> > After solving the I/O scheduler problem, dm RAID0 behaved better.  It
> > still did not give us anywhere near a fourfold increase (four disks o=
n
> > four separate ports) but only marginal improvement (14.3 MB/s) using =
c=3D8
> > (to fit into a jumbo packet, match the zvol block size on the back en=
d
> > and be two block sizes).  It did, however, give the best balance of
> > performance being just slightly slower than rr=3D1 at 10 threads and
> > slightly slower than rr=3D10 at 100 threads though not scaling as wel=
l to
> > 400 threads.
> >=20
>=20
> When you used dm RAID0 you didn't have any multipath configuration, rig=
ht?=20
Correct although we also did test successfully with multipath in
failover mode and RAID0.
>=20
> What kind of stripe size and other settings you had for RAID0?
Chunk size was 8KB with four disks. =20
>=20
> What kind of performance do you get using just a single iscsi session (=
and
> thus just a single path), no multipathing, no DM RAID0 ? Just a filesys=
tem
> directly on top of the iscsi /dev/sd? device.
Miserable - same roughly 12 MB/s.
>=20
> > Thus, collective throughput is acceptable but individual throughput i=
s
> > still awful.
> >=20
>=20
> Sounds like there's some other problem if invidual throughput is bad? O=
r did
> you mean performance with a single disktest IO thread is bad, but using=
 multiple
> disktest threads it's good.. that would make more sense :)=20
Yes, the latter.  Single thread (I assume mimicking a single disk
operation, e.g., copying a large file) is miserable - much slower than
local disk despite the availability of huge bandwidth.  We start
utilizing the bandwidth when multiplying concurrent disk activity into
the hundreds.

I am guessing the single thread performance problem is an open-iscsi
issue but I was hoping multipath would help us work around it by
utilizing multiple sessions per disk operation.  I suppose that is where
we run into the command ordering problem unless there is something else
afoot.  Thanks - John
<snip>
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
