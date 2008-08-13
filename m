From: "=?EUC-KR?B?sK21v8Dn?=" <baramsori72@gmail.com>
Subject: Re: RFC: I/O bandwidth controller
Date: Wed, 13 Aug 2008 15:23:00 +0900
Message-ID: <2891419e0808122323l5dad8ff7q81cf666e8c814620@mail.gmail.com>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
	 <48A0A689.40908@gmail.com> <loom.20080812T071504-212@post.gmane.org>
	 <20080812.201025.57762305.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754457AbYHMGXU@vger.kernel.org>
In-Reply-To: <20080812.201025.57762305.taka@valinux.co.jp>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com, righi.andrea@gmail.com, fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

Hi, Takahashi-san,
Thank you for your comments

> Hi,
>
>> > Fernando Luis V=E1zquez Cao wrote:
>> > >>> This seems to be the easiest part, but the current cgroups
>> > >>> infrastructure has some limitations when it comes to dealing w=
ith block
>> > >>> devices: impossibility of creating/removing certain control st=
ructures
>> > >>> dynamically and hardcoding of subsystems (i.e. resource contro=
llers).
>> > >>> This makes it difficult to handle block devices that can be ho=
tplugged
>> > >>> and go away at any time (this applies not only to usb storage =
but also
>> > >>> to some SATA and SCSI devices). To cope with this situation pr=
operly we
>> > >>> would need hotplug support in cgroups, but, as suggested befor=
e and
>> > >>> discussed in the past (see (0) below), there are some limitati=
ons.
>> > >>>
>> > >>> Even in the non-hotplug case it would be nice if we could trea=
t each
>> > >>> block I/O device as an independent resource, which means we co=
uld do
>> > >>> things like allocating I/O bandwidth on a per-device basis. As=
 long as
>> > >>> performance is not compromised too much, adding some kind of b=
asic
>> > >>> hotplug support to cgroups is probably worth it.
>> > >>>
>> > >>> (0) http://lkml.org/lkml/2008/5/21/12
>> > >> What about using major,minor numbers to identify each device an=
d account
>> > >> IO statistics? If a device is unplugged we could reset IO stati=
stics
>> > >> and/or remove IO limitations for that device from userspace (i.=
e. by a
>> > >> deamon), but pluggin/unplugging the device would not be blocked=
/affected
>> > >> in any case. Or am I oversimplifying the problem?
>> > > If a resource we want to control (a block device in this case) i=
s
>> > > hot-plugged/unplugged the corresponding cgroup-related structure=
s inside
>> > > the kernel need to be allocated/freed dynamically, respectively.=
 The
>> > > problem is that this is not always possible. For example, with t=
he
>> > > current implementation of cgroups it is not possible to treat ea=
ch block
>> > > device as a different cgroup subsytem/resource controlled, becau=
se
>> > > subsystems are created at compile time.
>> >
>> > The whole subsystem is created at compile time, but controller dat=
a
>> > structures are allocated dynamically (i.e. see struct mem_cgroup f=
or
>> > memory controller). So, identifying each device with a name, or a =
key
>> > like major,minor, instead of a reference/pointer to a struct could=
 help
>> > to handle this in userspace. I mean, if a device is unplugged a
>> > userspace daemon can just handle the event and delete the controll=
er
>> > data structures allocated for this device, asynchronously, via
>> > userspace->kernel interface. And without holding a reference to th=
at
>> > particular block device in the kernel. Anyway, implementing a gene=
ric
>> > interface that would allow to define hooks for hot-pluggable devic=
es (or
>> > similar events) in cgroups would be interesting.
>> >
>> > >>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspects
>> > >>>
>> > >>> The implementation of an I/O scheduling algorithm is to a cert=
ain extent
>> > >>> influenced by what we are trying to achieve in terms of I/O ba=
ndwidth
>> > >>> shaping, but, as discussed below, the required accuracy can de=
termine
>> > >>> the layer where the I/O controller has to reside. Off the top =
of my
>> > >>> head, there are three basic operations we may want perform:
>> > >>>   - I/O nice prioritization: ionice-like approach.
>> > >>>   - Proportional bandwidth scheduling: each process/group of p=
rocesses
>> > >>> has a weight that determines the share of bandwidth they recei=
ve.
>> > >>>   - I/O limiting: set an upper limit to the bandwidth a group =
of tasks
>> > >>> can use.
>> > >> Use a deadline-based IO scheduling could be an interesting path=
 to be
>> > >> explored as well, IMHO, to try to guarantee per-cgroup minimum =
bandwidth
>> > >> requirements.
>> > > Please note that the only thing we can do is to guarantee minimu=
m
>> > > bandwidth requirement when there is contention for an IO resourc=
e, which
>> > > is precisely what a proportional bandwidth scheduler does. An I =
missing
>> > > something?
>> >
>> > Correct. Proportional bandwidth automatically allows to guarantee =
min
>> > requirements (instead of IO limiting approach, that needs addition=
al
>> > mechanisms to achive this).
>> >
>> > In any case there's no guarantee for a cgroup/application to susta=
in
>> > i.e. 10MB/s on a certain device, but this is a hard problem anyway=
, and
>> > the best we can do is to try to satisfy "soft" constraints.
>>
>> I think guaranteeing the minimum I/O bandwidth is very important. In=
 the
>> business site, especially in streaming service system, administrator=
 requires
>> the functionality to satisfy QoS or performance of their service.
>> Of course, IO throttling is important, but, personally, I think guar=
anteeing
>> the minimum bandwidth is more important than limitation of maximum b=
andwidth
>> to satisfy the requirement in real business sites.
>> And I know Andrea's io-throttle patch supports the latter case well =
and it is
>> very stable.
>> But, the first case(guarantee the minimum bandwidth) is not supporte=
d in any
>> patches.
>> Is there any plans to support it? and Is there any problems in imple=
menting it?
>> I think if IO controller can support guaranteeing the minimum bandwi=
dth and
>> work-conserving mode simultaneously, it more easily satisfies the re=
quirement
>> of the business sites.
>> Additionally, I didn't understand "Proportional bandwidth automatica=
lly allows
>> to guarantee min
>> requirements" and "soft constraints".
>> Can you give me a advice about this ?
>> Thanks in advance.
>>
>> Dong-Jae Kang
>
> I think this is what dm-ioband does.
>
> Let's say you make two groups share the same disk, and give them
> 70% of the bandwidth the disk physically has and 30% respectively.
> This means the former group is almost guaranteed to be able to use
> 70% of the bandwidth even when the latter one is issuing quite
> a lot of I/O requests.
>
> Yes, I know there exist head seek lags with traditional magnetic disk=
s,
> so it's important to improve the algorithm to reduce this overhead.
>

In previous my posting, what I mean was absolute guaranteeing for
minimum bandwidth, regardless of disk seek time, I/O type(sequential,
random, or mixed =85) of process.
I also basically prefer proportional share depending on priority or
weight and I think it is meaningful, such like as dm-ioband, 2-layer
CFQ(satoshi) and 2-Layer CFQ(vasily).
But, additionally in that situation, I think absolute guaranteeing of
the minimum bandwidth will be required and several related companies
want it to be supported. Because proportional share has inaccuracy of
performance predictability, as Andrea mentioned before.
So, to complement the point, IMHO, I think so.

> And I think it is also possible to add a new scheduling policy to
> guarantee the minimum bandwidth. It might be cool if some group can
> use guranteed bandwidths and the other share the rest on proportional
> bandwidth policy.

Yes, I agree with you. This was what I intend to say
Thank you,

Dong-Jae Kang
