From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: RFC: I/O bandwidth controller
Date: Tue, 12 Aug 2008 15:07:43 +0200 (MEST)
Message-ID: <48A18B1F.6080000@gmail.com>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>	<48A0A689.40908@gmail.com>	<loom.20080812T071504-212@post.gmane.org> <20080812.201025.57762305.taka@valinux.co.jp> <48A18854.9020000@gmail.com>
Reply-To: righi.andrea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754108AbYHLNIB@vger.kernel.org>
In-Reply-To: <48A18854.9020000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: baramsori72@gmail.com, balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com
List-Id: dm-devel.ids

Andrea Righi wrote:
> Hirokazu Takahashi wrote:
>>>>>>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspects
>>>>>>>
>>>>>>> The implementation of an I/O scheduling algorithm is to a certa=
in extent
>>>>>>> influenced by what we are trying to achieve in terms of I/O ban=
dwidth
>>>>>>> shaping, but, as discussed below, the required accuracy can det=
ermine
>>>>>>> the layer where the I/O controller has to reside. Off the top o=
f my
>>>>>>> head, there are three basic operations we may want perform:
>>>>>>>   - I/O nice prioritization: ionice-like approach.
>>>>>>>   - Proportional bandwidth scheduling: each process/group of pr=
ocesses
>>>>>>> has a weight that determines the share of bandwidth they receiv=
e.
>>>>>>>   - I/O limiting: set an upper limit to the bandwidth a group o=
f tasks
>>>>>>> can use.
>>>>>> Use a deadline-based IO scheduling could be an interesting path =
to be
>>>>>> explored as well, IMHO, to try to guarantee per-cgroup minimum b=
andwidth
>>>>>> requirements.
>>>>> Please note that the only thing we can do is to guarantee minimum
>>>>> bandwidth requirement when there is contention for an IO resource=
, which
>>>>> is precisely what a proportional bandwidth scheduler does. An I m=
issing
>>>>> something?
>>>> Correct. Proportional bandwidth automatically allows to guarantee =
min
>>>> requirements (instead of IO limiting approach, that needs addition=
al
>>>> mechanisms to achive this).
>>>>
>>>> In any case there's no guarantee for a cgroup/application to susta=
in
>>>> i.e. 10MB/s on a certain device, but this is a hard problem anyway=
, and
>>>> the best we can do is to try to satisfy "soft" constraints.
>>> I think guaranteeing the minimum I/O bandwidth is very important. I=
n the=20
>>> business site, especially in streaming service system, administrato=
r requires=20
>>> the functionality to satisfy QoS or performance of their service.=20
>>> Of course, IO throttling is important, but, personally, I think gua=
ranteeing=20
>>> the minimum bandwidth is more important than limitation of maximum =
bandwidth=20
>>> to satisfy the requirement in real business sites.
>>> And I know Andrea=E2=80=99s io-throttle patch supports the latter c=
ase well and it is=20
>>> very stable.=20
>>> But, the first case(guarantee the minimum bandwidth) is not support=
ed in any=20
>>> patches.
>>> Is there any plans to support it? and Is there any problems in impl=
ementing it?
>>> I think if IO controller can support guaranteeing the minimum bandw=
idth and=20
>>> work-conserving mode simultaneously, it more easily satisfies the r=
equirement=20
>>> of the business sites.
>>> Additionally, I didn=E2=80=99t understand =E2=80=9CProportional ban=
dwidth automatically allows=20
>>> to guarantee min
>>> requirements=E2=80=9D and =E2=80=9Csoft constraints=E2=80=9D.
>>> Can you give me a advice about this ?=20
>>> Thanks in advance.
>>>
>>> Dong-Jae Kang
>> I think this is what dm-ioband does.
>>
>> Let's say you make two groups share the same disk, and give them
>> 70% of the bandwidth the disk physically has and 30% respectively.
>> This means the former group is almost guaranteed to be able to use
>> 70% of the bandwidth even when the latter one is issuing quite
>> a lot of I/O requests.
>>
>> Yes, I know there exist head seek lags with traditional magnetic dis=
ks,
>> so it's important to improve the algorithm to reduce this overhead.
>>
>> And I think it is also possible to add a new scheduling policy to
>> guarantee the minimum bandwidth. It might be cool if some group can
>> use guranteed bandwidths and the other share the rest on proportiona=
l
>> bandwidth policy.
>>
>> Thanks,
>> Hirokazu Takahashi.
>=20
> With IO limiting approach minimum requirements are supposed to be
> guaranteed if the user configures a generic block device so that the =
sum
> of the limits doesn't exceed the total IO bandwidth of that device. B=
ut,
> in principle, there's nothing in "throttling" that guarantees "fairne=
ss"
> among different cgroups doing IO on the same block devices, that mean=
s
> there's nothing to guarantee minimum requirements (and this is the
> reason because I liked the Satoshi's CFQ-cgroup approach together wit=
h
> io-throttle).
>=20
> A more complicated issue is how to evaluate the total IO bandwidth of=
 a
> generic device. We can use some kind of averaging/prediction, but
> basically it would be inaccurate due to the mechanic of disks (head
> seeks, but also caching, buffering mechanisms implemented directly in=
to
> the device, etc.). It's a hard problem. And the same problem exists a=
lso
> for proportional bandwidth as well, in terms of IO rate predictabilit=
y I
> mean.

BTW as I said in a previous email, an interesting path to be explored
IMHO could be to think in terms of IO time. So, look at the time an IO
request is issued to the drive, look at the time the request is served,
evaluate the difference and charge the consumed IO time to the
appropriate cgroup. Then dispatch IO requests in function of the
consumed IO time debts / credits, using for example a token-bucket
strategy. And probably the best place to implement the IO time
accounting is the elevator.

-Andrea

>=20
> The only difference is that with proportional bandwidth you know that
> (taking the same example reported by Hirokazu) with i.e. 10 similar I=
O
> requests, 7 will be dispatched to the first cgroup and 3 to the other
> cgroup. So, you don't need anything to guarantee "fairness", but it's
> hard also for this case to evaluate the cost of the 7 IO requests
> respect to the cost of the other 3 IO requests as seen by user
> applications, that is the cost the users care about.
>=20
> -Andrea
