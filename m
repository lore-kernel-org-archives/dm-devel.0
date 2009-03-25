From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Wed, 25 Mar 2009 12:21:32 -0400
Message-ID: <1237998092.6560.233.camel@jaspav.missionsit.net.missionsit.net>
References: <20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
	<20090324181735.GR5528@edu.joroinen.fi>
	<1237952460.6560.204.camel@jaspav.missionsit.net.missionsit.net>
	<20090325155207.GE24960@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090325155207.GE24960@edu.joroinen.fi>
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

On Wed, 2009-03-25 at 17:52 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Tue, Mar 24, 2009 at 11:41:00PM -0400, John A. Sullivan III wrote:
> > > > Latency seems to be our key.  If I can add only 20 micro-seconds =
of
> > > > latency from initiator and target each, that would be roughly 200=
 micro
> > > > seconds.  That would almost triple the throughput from what we ar=
e
> > > > currently seeing.
> > > >=20
> > >=20
> > > Indeed :)=20
> > >=20
> > > > Unfortunately, I'm a bit ignorant of tweaking networks on opensol=
aris.
> > > > I can certainly learn but am I headed in the right direction or i=
s this
> > > > direction of investigation misguided? Thanks - John
> > > >=20
> > >=20
> > > Low latency is the key for good (iSCSI) SAN performance, as it dire=
ctly
> > > gives you more (possible) IOPS.=20
> > >=20
> > > Other option is to configure software/settings so that there are mu=
ltiple
> > > outstanding IO's on the fly.. then you're not limited with the late=
ncy (so much).
> > >=20
> > > -- Pasi
> > <snip>
> > Ross has been of enormous help offline.  Indeed, disabling jumbo pack=
ets
> > produced an almost 50% increase in single threaded throughput.  We ar=
e
> > pretty well set although still a bit disappointed in the latency we a=
re
> > seeing in opensolaris and have escalated to the vendor about addressi=
ng
> > it.
> >=20
>=20
> Ok. That's pretty big increase. Did you figure out why that happens?=20
Greater latency with jumbo packets.
>=20
> > The once piece which is still a mystery is why using four targets on
> > four separate interfaces striped with dmadm RAID0 does not produce an
> > aggregate of slightly less than four times the IOPS of a single targe=
t
> > on a single interface. This would not seem to be the out of order SCS=
I
> > command problem of multipath.  One of life's great mysteries yet to b=
e
> > revealed.  Thanks again, all - John
>=20
> Hmm.. maybe the out-of-order problem happens at the target? It gets IO
> requests to nearby offsets from 4 different sessions and there's some k=
ind
> of locking or so going on?=20
Ross pointed out a flaw in my test methodology.  By running one I/O at a
time, it was literally doing that - not one full RAID0 I/O but one disk
I/O apparently.  He said to truly test it, I would need to run as many
concurrent I/Os as there were disks in the array.  Thanks - John
>=20
> Just guessing.=20
>=20
> -- Pasi
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
