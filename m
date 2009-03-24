From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 18:36:04 +0200
Message-ID: <20090324163603.GQ5528@edu.joroinen.fi>
References: <7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
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

On Tue, Mar 24, 2009 at 11:43:20AM -0400, John A. Sullivan III wrote:
> I greatly appreciate the help.  I'll answer in the thread below as well
> as consolidating answers to the questions posed in your other email.
>=20
> On Tue, 2009-03-24 at 17:01 +0200, Pasi K=E4rkk=E4inen wrote:
> > On Tue, Mar 24, 2009 at 08:21:45AM -0400, John A. Sullivan III wrote:
> > > >=20
> > > > Core-iscsi developer seems to be active developing at least the=20
> > > > new iSCSI target (LIO target).. I think he has been testing it wi=
th
> > > > core-iscsi, so maybe there's newer version somewhere?=20
> > > >=20
> > > > > We did play with the multipath rr_min_io settings and smaller a=
lways
> > > > > seemed to be better until we got into very large numbers of ses=
sion.  We
> > > > > were testing on a dual quad core AMD Shanghai 2378 system with =
32 GB
> > > > > RAM, a quad port Intel e1000 card and two on-board nvidia force=
deth
> > > > > ports with disktest using 4K blocks to mimic the file system us=
ing
> > > > > sequential reads (and some sequential writes).
> > > > >=20
> > > >=20
> > > > Nice hardware. Btw are you using jumbo frames or flow control for=
 iSCSI
> > > > traffic?=20
> > > >=20
> >=20
> > Dunno if you noticed this.. :)=20
> We are actually quite enthusiastic about the environment and the
> project.  We hope to have many of these hosting about 400 VServer guest=
s
> running virtual desktops from the X2Go project.  It's not my project bu=
t
> I don't mind plugging them as I think it is a great technology.
>=20
> We are using jumbo frames.  The ProCurve 2810 switches explicitly state
> to NOT use flow control and jumbo frames simultaneously.  We tried it
> anyway but with poor results.

Ok.=20

iirc 2810 does not have very big buffers per port, so you might be better
using flow control instead of jumbos.. then again I'm not sure how good f=
low
control implementation HP has?=20

The whole point of flow control is to prevent packet loss/drop.. this hap=
pens
with sending pause frames before the port buffers get full. If port buffe=
rs
get full then the switch doesn't have any other option than to drop the
packets.. and this causes tcp-retransmits -> causes delay and tcp slows d=
own
to prevent further packet drops.

flow control "pause frames" cause less delay than tcp-retransmits.=20

Do you see tcp retransmits with "netstat -s" ? Check both the target and =
the initiators.

> >=20
> >=20
> > > > >=20
> > > >=20
> > > > When you used dm RAID0 you didn't have any multipath configuratio=
n, right?=20
> > > Correct although we also did test successfully with multipath in
> > > failover mode and RAID0.
> > > >=20
> >=20
> > OK.
> >=20
> > > > What kind of stripe size and other settings you had for RAID0?
> > > Chunk size was 8KB with four disks. =20
> > > >=20
> >=20
> > Did you try with much bigger sizes.. 128 kB ?
> We tried slightly larger sizes - 16KB and 32KB I believe and observed
> performance degradation.  In fact, in some scenarios 4KB chunk sizes
> gave us better performance than 8KB.

Ok.=20

> >=20
> > > > What kind of performance do you get using just a single iscsi ses=
sion (and
> > > > thus just a single path), no multipathing, no DM RAID0 ? Just a f=
ilesystem
> > > > directly on top of the iscsi /dev/sd? device.
> > > Miserable - same roughly 12 MB/s.
> >=20
> > OK, Here's your problem. Was this btw reads or writes? Did you tune
> > readahead-settings?=20
> 12MBps is sequential reading but sequential writing is not much
> different.  We did tweak readahead to 1024. We did not want to go much
> larger in order to maintain balance with the various data patterns -
> some of which are random and some of which may not read linearly.

I did some benchmarking earlier between two servers; other one running ie=
td
target with 'nullio' and other running open-iscsi initiator. Both using a=
 single gigabit NIC.=20

I remember getting very close to full gigabit speed at least with bigger
block sizes. I can't remember how much I got with 4 kB blocks.=20

Those tests were made with dd.

nullio target is a good way to benchmark your network and initiator and
verify everything is correct.=20

Also it's good to first test for example with FTP and Iperf to verify
network is working properly between target and the initiator and all the
other basic settings are correct.

Btw have you configured tcp stacks of the servers? Bigger default tcp win=
dow
size, bigger maximun tcp window size etc..=20

> >=20
> > Can paste your iSCSI session settings negotiated with the target?=20
> Pardon my ignorance :( but, other than packet traces, how do I show the
> final negotiated settings?

Try:

iscsiadm -i -m session
iscsiadm -m session -P3


> >=20
> > > >=20
> > > > Sounds like there's some other problem if invidual throughput is =
bad? Or did
> > > > you mean performance with a single disktest IO thread is bad, but=
 using multiple
> > > > disktest threads it's good.. that would make more sense :)=20
> > > Yes, the latter.  Single thread (I assume mimicking a single disk
> > > operation, e.g., copying a large file) is miserable - much slower t=
han
> > > local disk despite the availability of huge bandwidth.  We start
> > > utilizing the bandwidth when multiplying concurrent disk activity i=
nto
> > > the hundreds.
> > >=20
> > > I am guessing the single thread performance problem is an open-iscs=
i
> > > issue but I was hoping multipath would help us work around it by
> > > utilizing multiple sessions per disk operation.  I suppose that is =
where
> > > we run into the command ordering problem unless there is something =
else
> > > afoot.  Thanks - John
> >=20
> > You should be able to get many times the throughput you get now.. jus=
t with
> > a single path/session.
> >=20
> > What kind of latency do you have from the initiator to the target/sto=
rage?=20
> >=20
> > Try with for example 4 kB ping:
> > ping -s 4096 <ip_of_the_iscsi_target>
> We have about 400 micro seconds - that seems a bit high :(
> rtt min/avg/max/mdev =3D 0.275/0.337/0.398/0.047 ms
>=20

Yeah.. that's a bit high.=20

> >=20
> > 1000ms divided by the roundtrip you get from ping should give you max=
imum
> > possible IOPS using a single path..=20
> >=20
> 1000 / 0.4 =3D 2500
> > 4 kB * IOPS =3D=3D max bandwidth you can achieve.
> 2500 * 4KB =3D 10 MBps
> Hmm . . . seems like what we are getting.  Is that an abnormally high
> latency? We have tried playing with interrupt coalescing on the
> initiator side but without significant effect.  Thanks for putting
> together the formula for me.  Not only does it help me understand but i=
t
> means I can work on addressing the latency issue without setting up and
> running disk tests.
>=20

I think Ross suggested in some other thread the following settings for e1=
000
NICs:

"Set the e1000s InterruptThrottleRate=3D1 and their TxRingBufferSize=3D40=
96
and RxRingBufferSize=3D4096 (verify those option names with a modinfo)
and add those to modprobe.conf."

> I would love to use larger block sizes as you suggest in your other
> email but, on AMD64, I believe we are stuck with 4KB.  I've not seen an=
y
> way to change it and would gladly do so if someone knows how.
>=20

Are we talking about filesystem block sizes? That shouldn't be a problem =
if
your application uses larger blocksizes for read/write operations..=20

Try for example with:
dd if=3D/dev/zero of=3D/iscsilun/file.bin bs=3D1024k count=3D1024

and optionally add "oflag=3Ddirect" (or iflag=3Ddirect) if you want to ma=
ke sure=20
caches do not mess up the results.=20

> CFQ was indeed a problem.  It would not scale with increasing the numbe=
r
> of threads.  noop, deadline, and anticipatory all fared much better.  W=
e
> are currently using noop for the iSCSI targets.  Thanks again - John

Yep. And no problems.. hopefully I'm able to help and guide to right
direction :) =20

-- Pasi
