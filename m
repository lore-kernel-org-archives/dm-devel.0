From: Hannes Reinecke <hare@suse.de>
Subject: Re: Re: [k-ueda@ct.jp.nec.com: Re:
	request-based	dm-multipath]
Date: Thu, 16 Apr 2009 09:29:22 +0200
Message-ID: <49E6DE52.9090007@suse.de>
References: <20090410151914.GA3800@redhat.com>	<20090410153102.GC3800@redhat.com>	<Pine.LNX.4.64.0904151443170.23593@hs20-bc2-1.build.redhat.com>	<20090415201829.GB9064@redhat.com>
	<Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
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
List-Id: dm-devel.ids

Mikulas Patocka wrote:
> On Wed, 15 Apr 2009, Mike Snitzer wrote:
>=20
>> On Wed, Apr 15 2009 at  3:09pm -0400,
>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>> On Fri, 10 Apr 2009, Mike Snitzer wrote:
>>>
>>>> Hi Mikulaus,
>>>>
>>>> Figured I'd give you this heads up on the request-based multipath
>>>> patches too considering your recent "bottom-layer barrier support"
>>>> patchset (where you said multipath support is coming later).
>>>>
>>>> We likely want to coordinate with the NEC guys so as to make sure th=
ings
>>>> are in order for the request-based patches to get merged along with =
your
>>>> remaining barrier work for 2.6.31.
>>>>
>>>> Mike
>>>>
>>>> p.s. below you can see I mistakenly said to Kiyoshi that the recent
>>>> barrier patches that got merged upstream were "the last of the DM
>>>> barrier support"...
>>> Hi
>>>
>>> I would say one thing about the request-based patches --- don't do th=
is.
>>>
>>> Your patch adds an alternate I/O path to request processing on device=
=20
>>> mapper.
>>>
>>> So, with your patch, there will be two I/O request paths. It means th=
at=20
>>> any work on generic device-mapper code that will have to be done in t=
he=20
>>> future (such as for example barriers that I did) will be twice harder=
. It=20
>>> will take twice the time to understand request processing, twice brai=
n=20
>>> capacity to remember it, twice the time for coding, twice the time fo=
r=20
>>> code review, twice the time for testing.
>>>
>>> If the patch goes in, it will make a lot of things twice harder. And =
once=20
>>> the patch is in productive kernels, there'd be very little possibilit=
y to=20
>>> pull it out.
>>>
>>> What is the exact reason for your patch? I suppose that it's some=20
>>> performance degradation caused by the fact that dm-multipath doesn't=20
>>> distributes requests optimally across both paths. dm-multipath has=20
>>> pluggable path selectors, so you could improve dm-round-robin.c (or w=
rite=20
>>> alternate path selector module) and you don't have to touch generic d=
m=20
>>> code to solve this problem.
>>>
>>> The point is that improving dm-multipath target with better path sele=
ctor=20
>>> is much less intrusive than patching device mapper core. If you impro=
ve=20
>>> dm-multipath target, only people hacking on dm-multipath will have to=
=20
>>> learn about your code. If you modify generic dm.c file, anyone doing=20
>>> anything on device mapper must learn about your code --- so human tim=
e=20
>>> consumed in much worse in this case.
>>>
>>> So, try the alternate solution (write new path selector for dm-multip=
ath)=20
>>> and then you can compare them and see the result --- and then it can =
be=20
>>> consisdered if the high human time consumed by patching dm.c is worth=
 the=20
>>> performance improvement.
>> Mikulas,
>>
>> Section 3.1 of the the following 2007 Linux Symposium paper answers th=
e
>> "why?" on request-based dm-multipath:
>> http://ols.108.redhat.com/2007/Reprints/ueda-Reprint.pdf
>>
>> In summary:
>> With request-based multipath performance and path error handling is
>> improved. =20
>>
>> Performance:
>> The I/O scheduler is leveraged to merge bios into requests; and these
>> requests are then able to be more evenly balanced across the available
>> paths (no need to starve other paths like the bio-based multipath is
>> prone to do).
>=20
> So you can improve the bio-based selector. You can count number&size of=
=20
> outstanding requests on each path and select the less loaded path.
>=20
And which is what you _cannot_ do.
You have _no_ idea at all how the bios are merged in to requests.
And as you do scheduling decisions based on the _bios_ you will interfere
with the elevator. Hence you always have to select large scheduling
intervals as to have the disturbance of the elevator as small as possible=
.

Just decrease 'min_rr_io' setting and watch the performace to drop.

> You can remember several end positions of last requests and when new=20
> request matches one of them, send it to the appropriate path, assuming=20
> that the lower device's scheduler will marge that. Or --- another solut=
ion=20
> is to access queues of the underlying devices and ask them if there's=20
> anything to merge --- and then send the request down the path that has=20
> some adjacent request.
>=20
But this would duplicate the elevator merging logic, wouldn't it?
You would have to out-guess the elevator which requests it would merge
next ...

> I know that the round-robin selector is silly, but you just haven't eve=
n=20
> try to improve it.
>=20
> If there is non-intrusive solution (improve path selector), it should b=
e=20
> tried first, before making an intrusive solution (alternate request pat=
h=20
> in dm core).
>=20
>> Error handling:
>> Finer grained error statistics are available when interfacing more
>> directly with the hardware like the request-based multipath does.
>=20
> You can signal it via flags in bios. No need to rewrite dm core.
>=20
But this makes failover costly, as you have to fail over each
individual bio. Hence you cannot (by design) have a real load
balancing as the cost of failover a single path is prohibitively
high.

Using request-based multipathing OTOH the cost for failover becomes
really small and you can do real load-balancing.
Like setting rr_min_io setting to '1' and you won't suffer any
performance drawback.

>> NEC may already have comparative performance data that will help
>> illustrate the improvement associated with request-based multipath?
>> They apparently have dynamic load balancing patches that they develope=
d
>> for use with the current bio-based multipath.
>=20
> So where is it better and why? Does it save CPU time or disk throughtpu=
t?=20
> How? On which workload?
>=20
> Did they really try to implement some smart path ballancing that takes=20
> into account merging?
>=20
No, they didn't, because of the abovementioned points.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
