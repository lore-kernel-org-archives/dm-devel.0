From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Tue, 12 Aug 2008 22:54:36 +0900
Message-ID: <1218549276.4456.100.camel@sebastian.kern.oss.ntt.co.jp>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
	 <48A0A689.40908@gmail.com>	<loom.20080812T071504-212@post.gmane.org>
	 <20080812.201025.57762305.taka@valinux.co.jp> <48A18854.9020000@gmail.com>
	 <48A18B1F.6080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754171AbYHLNys@vger.kernel.org>
In-Reply-To: <48A18B1F.6080000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: righi.andrea@gmail.com
Cc: Hirokazu Takahashi <taka@valinux.co.jp>, baramsori72@gmail.com, balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com
List-Id: dm-devel.ids

On Tue, 2008-08-12 at 22:29 +0900, Andrea Righi wrote:
> Andrea Righi wrote:
> > Hirokazu Takahashi wrote:
> >>>>>>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspects
> >>>>>>>
> >>>>>>> The implementation of an I/O scheduling algorithm is to a cer=
tain extent
> >>>>>>> influenced by what we are trying to achieve in terms of I/O b=
andwidth
> >>>>>>> shaping, but, as discussed below, the required accuracy can d=
etermine
> >>>>>>> the layer where the I/O controller has to reside. Off the top=
 of my
> >>>>>>> head, there are three basic operations we may want perform:
> >>>>>>>   - I/O nice prioritization: ionice-like approach.
> >>>>>>>   - Proportional bandwidth scheduling: each process/group of =
processes
> >>>>>>> has a weight that determines the share of bandwidth they rece=
ive.
> >>>>>>>   - I/O limiting: set an upper limit to the bandwidth a group=
 of tasks
> >>>>>>> can use.
> >>>>>> Use a deadline-based IO scheduling could be an interesting pat=
h to be
> >>>>>> explored as well, IMHO, to try to guarantee per-cgroup minimum=
 bandwidth
> >>>>>> requirements.
> >>>>> Please note that the only thing we can do is to guarantee minim=
um
> >>>>> bandwidth requirement when there is contention for an IO resour=
ce, which
> >>>>> is precisely what a proportional bandwidth scheduler does. An I=
 missing
> >>>>> something?
> >>>> Correct. Proportional bandwidth automatically allows to guarante=
e min
> >>>> requirements (instead of IO limiting approach, that needs additi=
onal
> >>>> mechanisms to achive this).
> >>>>
> >>>> In any case there's no guarantee for a cgroup/application to sus=
tain
> >>>> i.e. 10MB/s on a certain device, but this is a hard problem anyw=
ay, and
> >>>> the best we can do is to try to satisfy "soft" constraints.
> >>> I think guaranteeing the minimum I/O bandwidth is very important.=
 In the=20
> >>> business site, especially in streaming service system, administra=
tor requires=20
> >>> the functionality to satisfy QoS or performance of their service.=
=20
> >>> Of course, IO throttling is important, but, personally, I think g=
uaranteeing=20
> >>> the minimum bandwidth is more important than limitation of maximu=
m bandwidth=20
> >>> to satisfy the requirement in real business sites.
> >>> And I know Andrea=E2=80=99s io-throttle patch supports the latter=
 case well and it is=20
> >>> very stable.=20
> >>> But, the first case(guarantee the minimum bandwidth) is not suppo=
rted in any=20
> >>> patches.
> >>> Is there any plans to support it? and Is there any problems in im=
plementing it?
> >>> I think if IO controller can support guaranteeing the minimum ban=
dwidth and=20
> >>> work-conserving mode simultaneously, it more easily satisfies the=
 requirement=20
> >>> of the business sites.
> >>> Additionally, I didn=E2=80=99t understand =E2=80=9CProportional b=
andwidth automatically allows=20
> >>> to guarantee min
> >>> requirements=E2=80=9D and =E2=80=9Csoft constraints=E2=80=9D.
> >>> Can you give me a advice about this ?=20
> >>> Thanks in advance.
> >>>
> >>> Dong-Jae Kang
> >> I think this is what dm-ioband does.
> >>
> >> Let's say you make two groups share the same disk, and give them
> >> 70% of the bandwidth the disk physically has and 30% respectively.
> >> This means the former group is almost guaranteed to be able to use
> >> 70% of the bandwidth even when the latter one is issuing quite
> >> a lot of I/O requests.
> >>
> >> Yes, I know there exist head seek lags with traditional magnetic d=
isks,
> >> so it's important to improve the algorithm to reduce this overhead=
=2E
> >>
> >> And I think it is also possible to add a new scheduling policy to
> >> guarantee the minimum bandwidth. It might be cool if some group ca=
n
> >> use guranteed bandwidths and the other share the rest on proportio=
nal
> >> bandwidth policy.
> >>
> >> Thanks,
> >> Hirokazu Takahashi.
> >=20
> > With IO limiting approach minimum requirements are supposed to be
> > guaranteed if the user configures a generic block device so that th=
e sum
> > of the limits doesn't exceed the total IO bandwidth of that device.=
 But,
> > in principle, there's nothing in "throttling" that guarantees "fair=
ness"
> > among different cgroups doing IO on the same block devices, that me=
ans
> > there's nothing to guarantee minimum requirements (and this is the
> > reason because I liked the Satoshi's CFQ-cgroup approach together w=
ith
> > io-throttle).
> >=20
> > A more complicated issue is how to evaluate the total IO bandwidth =
of a
> > generic device. We can use some kind of averaging/prediction, but
> > basically it would be inaccurate due to the mechanic of disks (head
> > seeks, but also caching, buffering mechanisms implemented directly =
into
> > the device, etc.). It's a hard problem. And the same problem exists=
 also
> > for proportional bandwidth as well, in terms of IO rate predictabil=
ity I
> > mean.
>=20
> BTW as I said in a previous email, an interesting path to be explored
> IMHO could be to think in terms of IO time. So, look at the time an I=
O
> request is issued to the drive, look at the time the request is serve=
d,
> evaluate the difference and charge the consumed IO time to the
> appropriate cgroup. Then dispatch IO requests in function of the
> consumed IO time debts / credits, using for example a token-bucket
> strategy. And probably the best place to implement the IO time
> accounting is the elevator.
Please note that the seek time for a specific IO request is strongly
correlated with the IO requests that preceded it, which means that the
owner of that request is not the only one to blame if it takes too long
to process it. In other words, with the algorithm you propose we may en=
d
up charging the wrong guy.
