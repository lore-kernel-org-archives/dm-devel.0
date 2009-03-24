From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 07:02:41 -0400
Message-ID: <1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324073935.GK5528@edu.joroinen.fi>
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

On Tue, 2009-03-24 at 09:39 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Mon, Mar 23, 2009 at 05:46:36AM -0400, John A. Sullivan III wrote:
> > On Sun, 2009-03-22 at 17:27 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> > > On Fri, Mar 20, 2009 at 06:01:23AM -0400, John A. Sullivan III wrot=
e:
> > > > >=20
> > > > > John:
> > > > >=20
> > > > > Thanks for the reply.
> > > > >=20
> > > > > I ended up writing a small C program to do the priority computa=
tion for me.
> > > > >=20
> > > > > I have two sets of FC-AL shelves attached to two dual-channel Q=
logic
> > > > > cards. That gives me two paths to each disk. I have about 56 sp=
indles
> > > > > in the current configuration, and am tying them together with m=
d
> > > > > software raid.
> > > > >=20
> > > > > Now, even though each disk says it handles concurrent I/O on ea=
ch
> > > > > port, my testing indicates that throughput suffers when using m=
ultibus
> > > > > by about 1/2 (from ~60 MB/sec sustained I/O with failover to 35=
 MB/sec
> > > > > when using multibus).
> > > > >=20
> > > > > However, with failover, I am effectively using only one channel=
 on
> > > > > each card. With my custom priority callout, I more or less matc=
h the
> > > > > disks with even numbers to the even numbered scsi channels with=
 a
> > > > > higher priority. Same with the odd numbered disks and odd numbe=
red
> > > > > channels. The odds are 2ndary on even and vice versa. It seems =
to work
> > > > > rather well, and appears to spread the load nicely.
> > > > >=20
> > > > > Thanks again for your help!
> > > > >=20
> > > > I'm really glad you brought up the performance problem. I had pos=
ted
> > > > about it a few days ago but it seems to have gotten lost.  We are=
 really
> > > > struggling with performance issues when attempting to combine mul=
tiple
> > > > paths (in the case of multipath to one big target) or targets (in=
 the
> > > > case of software RAID0 across several targets) rather than using,=
 in
> > > > effect, JBODs.  In our case, we are using iSCSI.
> > > >=20
> > > > Like you, we found that using multibus caused almost a linear dro=
p in
> > > > performance.  Round robin across two paths was half as much as ag=
gregate
> > > > throughput to two separate disks, four paths, one fourth.
> > > >=20
> > > > We also tried striping across the targets with software RAID0 com=
bined
> > > > with failover multipath - roughly the same effect.
> > > >=20
> > > > We really don't want to be forced to treated SAN attached disks a=
s
> > > > JDOBs.  Has anyone cracked this problem of using them in either m=
ultibus
> > > > or RAID0 so we can present them as a single device to the OS and =
still
> > > > load balance multiple paths.  This is a HUGE problem for us so an=
y help
> > > > is greatly appreciated.  Thanks- John
> > >=20
> > > Hello.
> > >=20
> > > Hmm.. just a guess, but could this be related to the fact that if y=
our paths
> > > to the storage are different iSCSI sessions (open-iscsi _doesn't_ s=
upport
> > > multiple connections per session aka MC/s), then there is a separat=
e SCSI
> > > command queue per path.. and if SCSI requests are split across thos=
e queues=20
> > > they can get out-of-order and that causes performance drop?
> > >=20
> > > See:
> > > http://www.nabble.com/round-robin-with-vmware-initiator-and-iscsi-t=
arget-td21958346.html
> > >=20
> > > Especially the reply from Ross (CC). Maybe he has some comments :)=20
> > >=20
> > > -- Pasi
> > <snip>
> > I'm trying to spend a little time on this today and am really feeling=
 my
> > ignorance on the way iSCSI works :(  It looks like linux-iscsi suppor=
ts
> > MC/S but has not been in active development and will not even compile=
 on
> > my 2.6.27 kernel.
> >=20
> > To simplify matters, I did put each SAN interface on a separate netwo=
rk.
> > Thus, all the different sessions.  If I place them all on the same
> > network and use the iface parameters of open-iscsi, does that elimina=
te
> > the out-of-order problem and allow me to achieve the performance
> > scalability I'm seeking from dm-multipath in multibus mode? Thanks -
> > John
>=20
> If you use ifaces feature of open-iscsi, you still get separate session=
s.
>=20
> open-iscsi just does not support MC/s :(
>=20
> I think core-iscsi does support MC/s..=20
>=20
> Then you again you should play with the different multipath settings, a=
nd
> tweak how often IOs are split to different paths etc.. maybe that helps=
.
>=20
> -- Pasi
<snip>
I think we're pretty much at the end of our options here but I document
what I've found thus far for closure.

Indeed, there seems to be no way around the session problem.  Core-iscsi
does seem to support MC/s but has not been updated in years.  It did not
compile with my 2.6.27 kernel and, given that others seem to have had
the same problem, I did not spend a lot of time troubleshooting it.

We did play with the multipath rr_min_io settings and smaller always
seemed to be better until we got into very large numbers of session.  We
were testing on a dual quad core AMD Shanghai 2378 system with 32 GB
RAM, a quad port Intel e1000 card and two on-board nvidia forcedeth
ports with disktest using 4K blocks to mimic the file system using
sequential reads (and some sequential writes).

With a single thread, there was no difference at all - only about 12.79
MB/s no matter what we did.  With 10 threads and only two interfaces,
there was only a slight difference between rr=3D1 (81.2B/s), rr=3D10 (78.=
87)
and rr=3D100 (80).

However, when we opened to three and four interfaces, there was a huge
jump for rr=3D1 (100.4, 105.95) versus rr=3D10 (80.5, 80.75) and rr=3D100
(74.3, 77.6).

At 100 threads on three or four ports, the best performance shifted to
rr=3D10 (327 MB/s, 335) rather than rr=3D1 (291.7, 290.1) or rr=3D100 (21=
6.3).
At 400 threads, rr=3D100 started to overtake rr=3D10 slightly.

This was using all e1000 interfaces. Our first four port test included
one of the on board ports and performance was dramatically less than
three e1000 ports.  Subsequent testing tweaking forcedeth parameters
from defaults yielded no improvement.

After solving the I/O scheduler problem, dm RAID0 behaved better.  It
still did not give us anywhere near a fourfold increase (four disks on
four separate ports) but only marginal improvement (14.3 MB/s) using c=3D=
8
(to fit into a jumbo packet, match the zvol block size on the back end
and be two block sizes).  It did, however, give the best balance of
performance being just slightly slower than rr=3D1 at 10 threads and
slightly slower than rr=3D10 at 100 threads though not scaling as well to
400 threads.

Thus, collective throughput is acceptable but individual throughput is
still awful.

Thanks, all - John
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
