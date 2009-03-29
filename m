From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Sun, 29 Mar 2009 21:09:51 +0300
Message-ID: <20090329180951.GZ24960@edu.joroinen.fi>
References: <20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
	<20090324181735.GR5528@edu.joroinen.fi>
	<1237952460.6560.204.camel@jaspav.missionsit.net.missionsit.net>
	<20090325155207.GE24960@edu.joroinen.fi>
	<1237998092.6560.233.camel@jaspav.missionsit.net.missionsit.net>
	<1238137415.6574.48.camel@jaspav.missionsit.net.missionsit.net>
	<1238178525.6574.144.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1238178525.6574.144.camel@jaspav.missionsit.net.missionsit.net>
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

On Fri, Mar 27, 2009 at 02:28:45PM -0400, John A. Sullivan III wrote:
> On Fri, 2009-03-27 at 03:03 -0400, John A. Sullivan III wrote:
> > On Wed, 2009-03-25 at 12:21 -0400, John A. Sullivan III wrote:
> > > On Wed, 2009-03-25 at 17:52 +0200, Pasi K=E4rkk=E4inen wrote:
> > > > On Tue, Mar 24, 2009 at 11:41:00PM -0400, John A. Sullivan III wr=
ote:
> > > > > > > Latency seems to be our key.  If I can add only 20 micro-se=
conds of
> > > > > > > latency from initiator and target each, that would be rough=
ly 200 micro
> > > > > > > seconds.  That would almost triple the throughput from what=
 we are
> > > > > > > currently seeing.
> > > > > > >=20
> > > > > >=20
> > > > > > Indeed :)=20
> > > > > >=20
> > > > > > > Unfortunately, I'm a bit ignorant of tweaking networks on o=
pensolaris.
> > > > > > > I can certainly learn but am I headed in the right directio=
n or is this
> > > > > > > direction of investigation misguided? Thanks - John
> > > > > > >=20
> > > > > >=20
> > > > > > Low latency is the key for good (iSCSI) SAN performance, as i=
t directly
> > > > > > gives you more (possible) IOPS.=20
> > > > > >=20
> > > > > > Other option is to configure software/settings so that there =
are multiple
> > > > > > outstanding IO's on the fly.. then you're not limited with th=
e latency (so much).
> > > > > >=20
> > > > > > -- Pasi
> > > > > <snip>
> > > > > Ross has been of enormous help offline.  Indeed, disabling jumb=
o packets
> > > > > produced an almost 50% increase in single threaded throughput. =
 We are
> > > > > pretty well set although still a bit disappointed in the latenc=
y we are
> > > > > seeing in opensolaris and have escalated to the vendor about ad=
dressing
> > > > > it.
> > > > >=20
> > > >=20
> > > > Ok. That's pretty big increase. Did you figure out why that happe=
ns?=20
> > > Greater latency with jumbo packets.
> > > >=20
> > > > > The once piece which is still a mystery is why using four targe=
ts on
> > > > > four separate interfaces striped with dmadm RAID0 does not prod=
uce an
> > > > > aggregate of slightly less than four times the IOPS of a single=
 target
> > > > > on a single interface. This would not seem to be the out of ord=
er SCSI
> > > > > command problem of multipath.  One of life's great mysteries ye=
t to be
> > > > > revealed.  Thanks again, all - John
> > > >=20
> > > > Hmm.. maybe the out-of-order problem happens at the target? It ge=
ts IO
> > > > requests to nearby offsets from 4 different sessions and there's =
some kind
> > > > of locking or so going on?=20
> > > Ross pointed out a flaw in my test methodology.  By running one I/O=
 at a
> > > time, it was literally doing that - not one full RAID0 I/O but one =
disk
> > > I/O apparently.  He said to truly test it, I would need to run as m=
any
> > > concurrent I/Os as there were disks in the array.  Thanks - John
> > > ><snip>
> > Argh!!! This turned out to be alarmingly untrue.  This time, we were
> > doing some light testing on a different server with two bonded
> > interfaces in a single bridge (KVM environment) going to the same SAM=
 we
> > used in our four port test.
> >=20
> > For kicks and to prove to ourselves that RAID0 scaled with multiple I=
/O
> > as opposed to limiting the test to only single I/O, we tried some act=
ual
> > file transfers to the SAN mounted in sync mode.  We found concurrentl=
y
> > transferring two identical files to the RAID0 array composed of two
> > iSCSI attached drives was 57% slower than concurrently transferring t=
he
> > files to the drives separately. In other words, copying file1 and fil=
e2
> > concurrently to RAID0 took 57% longer than concurrently copying file1=
 to
> > disk1 and file2 to disk2.
> >=20
> > We then took a little different approach and used disktest.  We ran t=
wo
> > concurrent sessions with -K1.  In one case, we ran both sessions to t=
he
> > 2 disk RAID0 array.  The performance was significantly less again, th=
an
> > running the two concurrent tests against two separate iSCSI disks.  J=
ust
> > to be clear, these were the same disks as composed the array, just no=
t
> > grouped in the array.
> >=20
> > Even more alarmingly, we did the same test using multipath multibus,
> > i.e., two concurrent disktest with -K1 (both reads and rights, all
> > sequential with 4K block sizes).  The first session completely starve=
d
> > the second.  The first one continued at only slightly reduced speed
> > while the second one (kicked off just as fast as we could hit the ent=
er
> > key) received only roughly 50 IOPS.  Yes, that's fifty.
> >=20
> > Frightening but I thought I had better pass along such extreme result=
s
> > to the multipath team.  Thanks - John
> HOLD THE PRESSES - This turned out to be a DIFFERENT problem.  Argh!
> That's what I get for being a management type out of my depth doing
> engineering until we hire our engineering staff!
>=20
> As mentioned, these tests were run on a different, lighter duty system.
> When we ran the same tests on the larger, four dedicated SAN port
> server, RAID0 scaled nicely showing little degradation between one
> thread and four concurrent threads, i.e., our test file transfers took
> almost the same when a single user did them as opposed to when four
> users did them concurrently.
>=20
> The problem with our other system was, the RAID (and probably
> multi-path) was backfiring because the iSCSI connection was buckling
> under any appreciable load because the Ethernet interfaces use bridging=
.
>=20
> These are much lighter duty systems and we bought them from the same
> vendor as the SAN but with only the two onboard Ethernet ports.  Being
> ignorant, we looked to them for design guidance (and they were excellen=
t
> in all other regards) and were not cautioned about sharing these
> interfaces.  Because these are light duty, we intentionally broke the
> cardinal rule of not using a dedicated SAN network for them.  That's no=
t
> so much the problem. However, because they are running KVM, the
> interfaces are bridged (actually bonded and bridged using tlb as alb
> breaks with bridging in its current implementation - but bonding is not
> the issue).  Under any appreciable load, the iSCSI connections time out=
.
> We've tried varying the noop time out values but with no success.  We d=
o
> not have the time to test rigorously but assume this is why throughput
> did not scale at all.  disktest with -K10 achieved the same throughput
> as disktest with -K1.  Oh well, the price of tuition.

Uhm, so there was virtualization in the mix.. I didn't realize that earli=
er..

Did you benchmark from the host or from the guest?=20

So yeah.. the RAID-setup is working now, if I understood you correctly..=20
but the multipath setup is still problematic?=20

-- Pasi
