From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Tue, 12 Aug 2008 22:15:38 +0900
Message-ID: <1218546938.4456.72.camel@sebastian.kern.oss.ntt.co.jp>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
	 <48A0A689.40908@gmail.com> <loom.20080812T071504-212@post.gmane.org>
	 <20080812.201025.57762305.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754479AbYHLNP7@vger.kernel.org>
In-Reply-To: <20080812.201025.57762305.taka@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: baramsori72@gmail.com, balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Tue, 2008-08-12 at 20:52 +0900, Hirokazu Takahashi wrote:
> Hi,
>=20
> > > Fernando Luis V=C3=A1zquez Cao wrote:
> > > >>> This seems to be the easiest part, but the current cgroups
> > > >>> infrastructure has some limitations when it comes to dealing =
with block
> > > >>> devices: impossibility of creating/removing certain control s=
tructures
> > > >>> dynamically and hardcoding of subsystems (i.e. resource contr=
ollers).
> > > >>> This makes it difficult to handle block devices that can be h=
otplugged
> > > >>> and go away at any time (this applies not only to usb storage=
 but also
> > > >>> to some SATA and SCSI devices). To cope with this situation p=
roperly we
> > > >>> would need hotplug support in cgroups, but, as suggested befo=
re and
> > > >>> discussed in the past (see (0) below), there are some limitat=
ions.
> > > >>>
> > > >>> Even in the non-hotplug case it would be nice if we could tre=
at each
> > > >>> block I/O device as an independent resource, which means we c=
ould do
> > > >>> things like allocating I/O bandwidth on a per-device basis. A=
s long as
> > > >>> performance is not compromised too much, adding some kind of =
basic
> > > >>> hotplug support to cgroups is probably worth it.
> > > >>>
> > > >>> (0) http://lkml.org/lkml/2008/5/21/12
> > > >> What about using major,minor numbers to identify each device a=
nd account
> > > >> IO statistics? If a device is unplugged we could reset IO stat=
istics
> > > >> and/or remove IO limitations for that device from userspace (i=
=2Ee. by a
> > > >> deamon), but pluggin/unplugging the device would not be blocke=
d/affected
> > > >> in any case. Or am I oversimplifying the problem?
> > > > If a resource we want to control (a block device in this case) =
is
> > > > hot-plugged/unplugged the corresponding cgroup-related structur=
es inside
> > > > the kernel need to be allocated/freed dynamically, respectively=
=2E The
> > > > problem is that this is not always possible. For example, with =
the
> > > > current implementation of cgroups it is not possible to treat e=
ach block
> > > > device as a different cgroup subsytem/resource controlled, beca=
use
> > > > subsystems are created at compile time.
> > >=20
> > > The whole subsystem is created at compile time, but controller da=
ta
> > > structures are allocated dynamically (i.e. see struct mem_cgroup =
for
> > > memory controller). So, identifying each device with a name, or a=
 key
> > > like major,minor, instead of a reference/pointer to a struct coul=
d help
> > > to handle this in userspace. I mean, if a device is unplugged a
> > > userspace daemon can just handle the event and delete the control=
ler
> > > data structures allocated for this device, asynchronously, via
> > > userspace->kernel interface. And without holding a reference to t=
hat
> > > particular block device in the kernel. Anyway, implementing a gen=
eric
> > > interface that would allow to define hooks for hot-pluggable devi=
ces (or
> > > similar events) in cgroups would be interesting.
> > >=20
> > > >>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspects
> > > >>>
> > > >>> The implementation of an I/O scheduling algorithm is to a cer=
tain extent
> > > >>> influenced by what we are trying to achieve in terms of I/O b=
andwidth
> > > >>> shaping, but, as discussed below, the required accuracy can d=
etermine
> > > >>> the layer where the I/O controller has to reside. Off the top=
 of my
> > > >>> head, there are three basic operations we may want perform:
> > > >>>   - I/O nice prioritization: ionice-like approach.
> > > >>>   - Proportional bandwidth scheduling: each process/group of =
processes
> > > >>> has a weight that determines the share of bandwidth they rece=
ive.
> > > >>>   - I/O limiting: set an upper limit to the bandwidth a group=
 of tasks
> > > >>> can use.
> > > >> Use a deadline-based IO scheduling could be an interesting pat=
h to be
> > > >> explored as well, IMHO, to try to guarantee per-cgroup minimum=
 bandwidth
> > > >> requirements.
> > > > Please note that the only thing we can do is to guarantee minim=
um
> > > > bandwidth requirement when there is contention for an IO resour=
ce, which
> > > > is precisely what a proportional bandwidth scheduler does. An I=
 missing
> > > > something?
> > >=20
> > > Correct. Proportional bandwidth automatically allows to guarantee=
 min
> > > requirements (instead of IO limiting approach, that needs additio=
nal
> > > mechanisms to achive this).
> > >=20
> > > In any case there's no guarantee for a cgroup/application to sust=
ain
> > > i.e. 10MB/s on a certain device, but this is a hard problem anywa=
y, and
> > > the best we can do is to try to satisfy "soft" constraints.
> >=20
> > I think guaranteeing the minimum I/O bandwidth is very important. I=
n the=20
> > business site, especially in streaming service system, administrato=
r requires=20
> > the functionality to satisfy QoS or performance of their service.=20
> > Of course, IO throttling is important, but, personally, I think gua=
ranteeing=20
> > the minimum bandwidth is more important than limitation of maximum =
bandwidth=20
> > to satisfy the requirement in real business sites.
> > And I know Andrea=E2=80=99s io-throttle patch supports the latter c=
ase well and it is=20
> > very stable.=20
> > But, the first case(guarantee the minimum bandwidth) is not support=
ed in any=20
> > patches.
> > Is there any plans to support it? and Is there any problems in impl=
ementing it?
> > I think if IO controller can support guaranteeing the minimum bandw=
idth and=20
> > work-conserving mode simultaneously, it more easily satisfies the r=
equirement=20
> > of the business sites.
> > Additionally, I didn=E2=80=99t understand =E2=80=9CProportional ban=
dwidth automatically allows=20
> > to guarantee min
> > requirements=E2=80=9D and =E2=80=9Csoft constraints=E2=80=9D.
> > Can you give me a advice about this ?=20
> > Thanks in advance.
> >=20
> > Dong-Jae Kang
>=20
> I think this is what dm-ioband does.
>=20
> Let's say you make two groups share the same disk, and give them
> 70% of the bandwidth the disk physically has and 30% respectively.
> This means the former group is almost guaranteed to be able to use
> 70% of the bandwidth even when the latter one is issuing quite
> a lot of I/O requests.
>=20
> Yes, I know there exist head seek lags with traditional magnetic disk=
s,
> so it's important to improve the algorithm to reduce this overhead.
>=20
> And I think it is also possible to add a new scheduling policy to
> guarantee the minimum bandwidth. It might be cool if some group can
> use guranteed bandwidths and the other share the rest on proportional
> bandwidth policy.

Yes, it would be really cool if we could provide hard bandwidth
guarantees but it certainly does not look like a trivial task. To
achieve that, among other things, we would need to take into account
both the topology of block devices (RAID type, etc) and the physical
characteristics of the disks that compose them.

The former problem could be tackled at the block layer, since it is
there that stacking devices are implemented. But it is the elevators wh=
o
should examine the characteristics of the underlying devices, and
schedule IO in such a way that the variable factors, such as seek times=
,
do not compromise the hard bandwidth requirements (of course, it would
also be nice if we did not kill global I/O performance in the process).
=46inally such an elevator would still need to cooperate with the block
layer to make further topology-dependent adjustments.

- Fernando

P.S.: For some reason I received neither Dong-Jae's email nor yours, so
I had to pick it up from the mailing list. I would appreciate it if you
kept me CCed.
