From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: RFC: I/O bandwidth controller
Date: Wed, 13 Aug 2008 19:56:12 +0200
Message-ID: <48A3203C.6090104@gmail.com>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>	 <48A0A689.40908@gmail.com> <loom.20080812T071504-212@post.gmane.org>	 <20080812.201025.57762305.taka@valinux.co.jp>	 <48A18854.9020000@gmail.com> <48A18B1F.6080000@gmail.com>	 <1218549276.4456.100.camel@sebastian.kern.oss.ntt.co.jp>	 <48A1F62E.4090202@gmail.com> <2891419e0808130047o702c9174tf36a4316ed247497@mail.gmail.com>
Reply-To: righi.andrea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757373AbYHMR4j@vger.kernel.org>
In-Reply-To: <2891419e0808130047o702c9174tf36a4316ed247497@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dong-Jae Kang <baramsori72@gmail.com>
Cc: =?windows-1252?Q?Fernando_Luis_V=E1zquez_Cao?= <fernando@oss.ntt.co.jp>, Hirokazu Takahashi <taka@valinux.co.jp>, balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com, ranjitm@google.com
List-Id: dm-devel.ids

Dong-Jae Kang wrote:
> Hi,
>=20
> 2008/8/13 Andrea Righi <righi.andrea@gmail.com>:
>> Fernando Luis V=E1zquez Cao wrote:
>>> On Tue, 2008-08-12 at 22:29 +0900, Andrea Righi wrote:
>>>> Andrea Righi wrote:
>>>>> Hirokazu Takahashi wrote:
>>>>>>>>>>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspec=
ts
>>>>>>>>>>>
>>>>>>>>>>> The implementation of an I/O scheduling algorithm is to a c=
ertain extent
>>>>>>>>>>> influenced by what we are trying to achieve in terms of I/O=
 bandwidth
>>>>>>>>>>> shaping, but, as discussed below, the required accuracy can=
 determine
>>>>>>>>>>> the layer where the I/O controller has to reside. Off the t=
op of my
>>>>>>>>>>> head, there are three basic operations we may want perform:
>>>>>>>>>>>   - I/O nice prioritization: ionice-like approach.
>>>>>>>>>>>   - Proportional bandwidth scheduling: each process/group o=
f processes
>>>>>>>>>>> has a weight that determines the share of bandwidth they re=
ceive.
>>>>>>>>>>>   - I/O limiting: set an upper limit to the bandwidth a gro=
up of tasks
>>>>>>>>>>> can use.
>>>>>>>>>> Use a deadline-based IO scheduling could be an interesting p=
ath to be
>>>>>>>>>> explored as well, IMHO, to try to guarantee per-cgroup minim=
um bandwidth
>>>>>>>>>> requirements.
>>>>>>>>> Please note that the only thing we can do is to guarantee min=
imum
>>>>>>>>> bandwidth requirement when there is contention for an IO reso=
urce, which
>>>>>>>>> is precisely what a proportional bandwidth scheduler does. An=
 I missing
>>>>>>>>> something?
>>>>>>>> Correct. Proportional bandwidth automatically allows to guaran=
tee min
>>>>>>>> requirements (instead of IO limiting approach, that needs addi=
tional
>>>>>>>> mechanisms to achive this).
>>>>>>>>
>>>>>>>> In any case there's no guarantee for a cgroup/application to s=
ustain
>>>>>>>> i.e. 10MB/s on a certain device, but this is a hard problem an=
yway, and
>>>>>>>> the best we can do is to try to satisfy "soft" constraints.
>>>>>>> I think guaranteeing the minimum I/O bandwidth is very importan=
t. In the
>>>>>>> business site, especially in streaming service system, administ=
rator requires
>>>>>>> the functionality to satisfy QoS or performance of their servic=
e.
>>>>>>> Of course, IO throttling is important, but, personally, I think=
 guaranteeing
>>>>>>> the minimum bandwidth is more important than limitation of maxi=
mum bandwidth
>>>>>>> to satisfy the requirement in real business sites.
>>>>>>> And I know Andrea's io-throttle patch supports the latter case =
well and it is
>>>>>>> very stable.
>>>>>>> But, the first case(guarantee the minimum bandwidth) is not sup=
ported in any
>>>>>>> patches.
>>>>>>> Is there any plans to support it? and Is there any problems in =
implementing it?
>>>>>>> I think if IO controller can support guaranteeing the minimum b=
andwidth and
>>>>>>> work-conserving mode simultaneously, it more easily satisfies t=
he requirement
>>>>>>> of the business sites.
>>>>>>> Additionally, I didn't understand "Proportional bandwidth autom=
atically allows
>>>>>>> to guarantee min
>>>>>>> requirements" and "soft constraints".
>>>>>>> Can you give me a advice about this ?
>>>>>>> Thanks in advance.
>>>>>>>
>>>>>>> Dong-Jae Kang
>>>>>> I think this is what dm-ioband does.
>>>>>>
>>>>>> Let's say you make two groups share the same disk, and give them
>>>>>> 70% of the bandwidth the disk physically has and 30% respectivel=
y.
>>>>>> This means the former group is almost guaranteed to be able to u=
se
>>>>>> 70% of the bandwidth even when the latter one is issuing quite
>>>>>> a lot of I/O requests.
>>>>>>
>>>>>> Yes, I know there exist head seek lags with traditional magnetic=
 disks,
>>>>>> so it's important to improve the algorithm to reduce this overhe=
ad.
>>>>>>
>>>>>> And I think it is also possible to add a new scheduling policy t=
o
>>>>>> guarantee the minimum bandwidth. It might be cool if some group =
can
>>>>>> use guranteed bandwidths and the other share the rest on proport=
ional
>>>>>> bandwidth policy.
>>>>>>
>>>>>> Thanks,
>>>>>> Hirokazu Takahashi.
>>>>> With IO limiting approach minimum requirements are supposed to be
>>>>> guaranteed if the user configures a generic block device so that =
the sum
>>>>> of the limits doesn't exceed the total IO bandwidth of that devic=
e. But,
>>>>> in principle, there's nothing in "throttling" that guarantees "fa=
irness"
>>>>> among different cgroups doing IO on the same block devices, that =
means
>>>>> there's nothing to guarantee minimum requirements (and this is th=
e
>>>>> reason because I liked the Satoshi's CFQ-cgroup approach together=
 with
>>>>> io-throttle).
>>>>>
>>>>> A more complicated issue is how to evaluate the total IO bandwidt=
h of a
>>>>> generic device. We can use some kind of averaging/prediction, but
>>>>> basically it would be inaccurate due to the mechanic of disks (he=
ad
>>>>> seeks, but also caching, buffering mechanisms implemented directl=
y into
>>>>> the device, etc.). It's a hard problem. And the same problem exis=
ts also
>>>>> for proportional bandwidth as well, in terms of IO rate predictab=
ility I
>>>>> mean.
>>>> BTW as I said in a previous email, an interesting path to be explo=
red
>>>> IMHO could be to think in terms of IO time. So, look at the time a=
n IO
>>>> request is issued to the drive, look at the time the request is se=
rved,
>>>> evaluate the difference and charge the consumed IO time to the
>>>> appropriate cgroup. Then dispatch IO requests in function of the
>>>> consumed IO time debts / credits, using for example a token-bucket
>>>> strategy. And probably the best place to implement the IO time
>>>> accounting is the elevator.
>>> Please note that the seek time for a specific IO request is strongl=
y
>>> correlated with the IO requests that preceded it, which means that =
the
>>> owner of that request is not the only one to blame if it takes too =
long
>>> to process it. In other words, with the algorithm you propose we ma=
y end
>>> up charging the wrong guy.
>> mmh.. yes. The only scenario I can imagine where this solution is no=
t
>> fair is when there're a lot of guys always requesting the same near
>> blocks and a single guy looking for a single distant block (supposin=
g
>> disk seeks are more expensive than read/write ops).
>>
>> In this case it would be fair to charge a huge amount only to the gu=
y
>> requesting the single distant block and distribute the cost of the s=
eek
>> to move back the head equally among the other guys. Using the algori=
ghm
>> I proposed, instead, both the single "bad" guy and the first "good" =
guy
>> that moves back the disk head would spend a large sum of IO credits.
>>
>=20
> I have a question about your description.
> In I/O controlling, how do you think about the meaning of "fair" amon=
g cgroups ?

Good question, thanks!

fair =3D equally distribute the IO cost and throttling among cgroups,
instead of equal distribution among processes, and equally among the
processes belonging to the same cgroup.

In the previous scenario the process that moves back the disk head
wouldn't be charged for the whole IO cost. It's the belonging cgroup
that would be charged instead. So, the accounting is perfectly fair fro=
m
this point of view, because the cgroup credits are shared among the
processes within the cgroup.

The IO controller instead should be able to apply throttling in a "fair=
"
way, that means, when the credits are over it should distribute the
throttling time equally among the processes within the cgroup, i.e.
imposing a total_time_to_sleep/N to each process (where N is the number
of processes into the cgroup) or, even better, distribute the
total_time_to_sleep as a function of the previously generated task's IO=
,
looking at the IO taskstats for example (/proc/PID/io). But this is
another problem anyway.

So, it seems I used a bad example, sorry.

> These days I was confused about it.
> IMHO, if they have a same access time and same access opportunity for
> disk I/O regardless of their I/O style(sequential / random / mixed /
> =85), I think it is fare.
> Of course, in this fair situation, the cgroups with same priority or
> weight can have a different I/O bandwidth. but, I think it will be in
> reasonable range.
> So, if other cgroups with fast I/O was sacrificed for the cgroup with
> too late I/O to equaliz the I/O quantity, it can be considered
> "unfair" for the cgroup with fast I/O
> Do I have something wrong about the "fair" concept?
> This is just my opinion :)
> I welcome and appreciate for other opinions and comments about this
>=20
> PS)
> Andrea, this question is not related to the io-controller
> But, I just wonder your another project, network io-throttle, is goin=
g
> on now? My colleague has researched the similar project and he is try
> to implement another one. And i am also interested in net
> io-controller. Thank you

=46or net-io-controller there's a better solution than mine, have a loo=
k
at this:

http://lkml.org/lkml/2008/7/24/455

-Andrea
