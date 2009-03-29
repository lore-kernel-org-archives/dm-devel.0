From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Sun, 29 Mar 2009 17:22:21 -0400
Message-ID: <1238361741.6478.16.camel@jaspav.missionsit.net.missionsit.net>
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
	<20090329180951.GZ24960@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090329180951.GZ24960@edu.joroinen.fi>
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

On Sun, 2009-03-29 at 21:09 +0300, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Fri, Mar 27, 2009 at 02:28:45PM -0400, John A. Sullivan III wrote:
> > On Fri, 2009-03-27 at 03:03 -0400, John A. Sullivan III wrote:
> > > On Wed, 2009-03-25 at 12:21 -0400, John A. Sullivan III wrote:
> > > > On Wed, 2009-03-25 at 17:52 +0200, Pasi K=C3=A4rkk=C3=A4inen wrot=
e:
> > > > > On Tue, Mar 24, 2009 at 11:41:00PM -0400, John A. Sullivan III =
wrote:
> > > > > > > > Latency seems to be our key.  If I can add only 20 micro-=
seconds of
> > > > > > > > latency from initiator and target each, that would be rou=
ghly 200 micro
> > > > > > > > seconds.  That would almost triple the throughput from wh=
at we are
> > > > > > > > currently seeing.
> > > > > > > >=20
> > > > > > >=20
> > > > > > > Indeed :)=20
> > > > > > >=20
> > > > > > > > Unfortunately, I'm a bit ignorant of tweaking networks on=
 opensolaris.
> > > > > > > > I can certainly learn but am I headed in the right direct=
ion or is this
> > > > > > > > direction of investigation misguided? Thanks - John
> > > > > > > >=20
> > > > > > >=20
> > > > > > > Low latency is the key for good (iSCSI) SAN performance, as=
 it directly
> > > > > > > gives you more (possible) IOPS.=20
> > > > > > >=20
> > > > > > > Other option is to configure software/settings so that ther=
e are multiple
> > > > > > > outstanding IO's on the fly.. then you're not limited with =
the latency (so much).
> > > > > > >=20
> > > > > > > -- Pasi
> > > > > > <snip>
> > > > > > Ross has been of enormous help offline.  Indeed, disabling ju=
mbo packets
> > > > > > produced an almost 50% increase in single threaded throughput=
.  We are
> > > > > > pretty well set although still a bit disappointed in the late=
ncy we are
> > > > > > seeing in opensolaris and have escalated to the vendor about =
addressing
> > > > > > it.
> > > > > >=20
> > > > >=20
> > > > > Ok. That's pretty big increase. Did you figure out why that hap=
pens?=20
> > > > Greater latency with jumbo packets.
> > > > >=20
> > > > > > The once piece which is still a mystery is why using four tar=
gets on
> > > > > > four separate interfaces striped with dmadm RAID0 does not pr=
oduce an
> > > > > > aggregate of slightly less than four times the IOPS of a sing=
le target
> > > > > > on a single interface. This would not seem to be the out of o=
rder SCSI
> > > > > > command problem of multipath.  One of life's great mysteries =
yet to be
> > > > > > revealed.  Thanks again, all - John
> > > > >=20
> > > > > Hmm.. maybe the out-of-order problem happens at the target? It =
gets IO
> > > > > requests to nearby offsets from 4 different sessions and there'=
s some kind
> > > > > of locking or so going on?=20
> > > > Ross pointed out a flaw in my test methodology.  By running one I=
/O at a
> > > > time, it was literally doing that - not one full RAID0 I/O but on=
e disk
> > > > I/O apparently.  He said to truly test it, I would need to run as=
 many
> > > > concurrent I/Os as there were disks in the array.  Thanks - John
> > > > ><snip>
> > > Argh!!! This turned out to be alarmingly untrue.  This time, we wer=
e
> > > doing some light testing on a different server with two bonded
> > > interfaces in a single bridge (KVM environment) going to the same S=
AM we
> > > used in our four port test.
> > >=20
> > > For kicks and to prove to ourselves that RAID0 scaled with multiple=
 I/O
> > > as opposed to limiting the test to only single I/O, we tried some a=
ctual
> > > file transfers to the SAN mounted in sync mode.  We found concurren=
tly
> > > transferring two identical files to the RAID0 array composed of two
> > > iSCSI attached drives was 57% slower than concurrently transferring=
 the
> > > files to the drives separately. In other words, copying file1 and f=
ile2
> > > concurrently to RAID0 took 57% longer than concurrently copying fil=
e1 to
> > > disk1 and file2 to disk2.
> > >=20
> > > We then took a little different approach and used disktest.  We ran=
 two
> > > concurrent sessions with -K1.  In one case, we ran both sessions to=
 the
> > > 2 disk RAID0 array.  The performance was significantly less again, =
than
> > > running the two concurrent tests against two separate iSCSI disks. =
 Just
> > > to be clear, these were the same disks as composed the array, just =
not
> > > grouped in the array.
> > >=20
> > > Even more alarmingly, we did the same test using multipath multibus=
,
> > > i.e., two concurrent disktest with -K1 (both reads and rights, all
> > > sequential with 4K block sizes).  The first session completely star=
ved
> > > the second.  The first one continued at only slightly reduced speed
> > > while the second one (kicked off just as fast as we could hit the e=
nter
> > > key) received only roughly 50 IOPS.  Yes, that's fifty.
> > >=20
> > > Frightening but I thought I had better pass along such extreme resu=
lts
> > > to the multipath team.  Thanks - John
> > HOLD THE PRESSES - This turned out to be a DIFFERENT problem.  Argh!
> > That's what I get for being a management type out of my depth doing
> > engineering until we hire our engineering staff!
> >=20
> > As mentioned, these tests were run on a different, lighter duty syste=
m.
> > When we ran the same tests on the larger, four dedicated SAN port
> > server, RAID0 scaled nicely showing little degradation between one
> > thread and four concurrent threads, i.e., our test file transfers too=
k
> > almost the same when a single user did them as opposed to when four
> > users did them concurrently.
> >=20
> > The problem with our other system was, the RAID (and probably
> > multi-path) was backfiring because the iSCSI connection was buckling
> > under any appreciable load because the Ethernet interfaces use bridgi=
ng.
> >=20
> > These are much lighter duty systems and we bought them from the same
> > vendor as the SAN but with only the two onboard Ethernet ports.  Bein=
g
> > ignorant, we looked to them for design guidance (and they were excell=
ent
> > in all other regards) and were not cautioned about sharing these
> > interfaces.  Because these are light duty, we intentionally broke the
> > cardinal rule of not using a dedicated SAN network for them.  That's =
not
> > so much the problem. However, because they are running KVM, the
> > interfaces are bridged (actually bonded and bridged using tlb as alb
> > breaks with bridging in its current implementation - but bonding is n=
ot
> > the issue).  Under any appreciable load, the iSCSI connections time o=
ut.
> > We've tried varying the noop time out values but with no success.  We=
 do
> > not have the time to test rigorously but assume this is why throughpu=
t
> > did not scale at all.  disktest with -K10 achieved the same throughpu=
t
> > as disktest with -K1.  Oh well, the price of tuition.
>=20
> Uhm, so there was virtualization in the mix.. I didn't realize that ear=
lier..
>=20
> Did you benchmark from the host or from the guest?=20
>=20
> So yeah.. the RAID-setup is working now, if I understood you correctly.=
.=20
> but the multipath setup is still problematic?=20
<snip>
I wish I had more time to pursue this but we lost an unexpected five
weeks on this on a three month project.  I would seem the RAID0 is
scaling although we haven't absolutely verified it.  Multipath does as
well.  We did find wide variations in how well it scales based upon the
combination of rr_min_io and maximum number of concurrent transactions.
As I believe would be expected, lower rr_min_io (as in 1) performed much
better under few concurrent threads (e.g., 10) but started to lose its
edge under heavier concurrent threads (e.g., 100).  Thus my ignorant
guess is for something low density virtualization, the former works
better and for high density (such as our desktop setup) higher works
better.  Of course, even those definitions vary widely depending on the
nature of the guests.

RAID0 was more even, being just slightly slower than rr=3D1 under light
loads and just slightly slower than rr=3D10 under moderate and heavy
loads.

Tests were run from the virtualization host.  Thanks for all your help -
John
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
