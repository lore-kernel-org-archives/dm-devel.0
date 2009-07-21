From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 21/25] io-controller: Per cgroup request
	descriptor support
Date: Tue, 21 Jul 2009 10:57:09 -0700
Message-ID: <e98e18940907211057p629a4f20g693e156217de5a2d@mail.gmail.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-22-git-send-email-vgoyal@redhat.com>
	<4A655434.5060404@cn.fujitsu.com>
	<e98e18940907202255y5c7c546ei95d87e5a451ad0c2@mail.gmail.com>
	<20090721140134.GB540@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090721140134.GB540@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 21, 2009 at 7:01 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Mon, Jul 20, 2009 at 10:55:31PM -0700, Nauman Rafique wrote:
>> On Mon, Jul 20, 2009 at 10:37 PM, Gui
>> Jianfeng<guijianfeng@cn.fujitsu.com> wrote:
>> > Vivek Goyal wrote:
>> >> o Currently a request queue has got fixed number of request descrip=
tors for
>> >> =A0 sync and async requests. Once the request descriptors are consu=
med, new
>> >> =A0 processes are put to sleep and they effectively become serializ=
ed. Because
>> >> =A0 sync and async queues are separate, async requests don't impact=
 sync ones
>> >> =A0 but if one is looking for fairness between async requests, that=
 is not
>> >> =A0 achievable if request queue descriptors become bottleneck.
>> >>
>> >> o Make request descriptor's per io group so that if there is lots o=
f IO
>> >> =A0 going on in one cgroup, it does not impact the IO of other grou=
p.
>> >>
>> >> o This is just one relatively simple way of doing things. This patc=
h will
>> >> =A0 probably change after the feedback. Folks have raised concerns =
that in
>> >> =A0 hierchical setup, child's request descriptors should be capped =
by parent's
>> >> =A0 request descriptors. May be we need to have per cgroup per devi=
ce files
>> >> =A0 in cgroups where one can specify the upper limit of request des=
criptors
>> >> =A0 and whenever a cgroup is created one needs to assign request de=
scritor
>> >> =A0 limit making sure total sum of child's request descriptor is no=
t more than
>> >> =A0 of parent.
>> >>
>> >> =A0 I guess something like memory controller. Anyway, that would be=
 the next
>> >> =A0 step. For the time being, we have implemented something simpler=
 as follows.
>> >>
>> >> o This patch implements the per cgroup request descriptors. request=
 pool per
>> >> =A0 queue is still common but every group will have its own wait li=
st and its
>> >> =A0 own count of request descriptors allocated to that group for sy=
nc and async
>> >> =A0 queues. So effectively request_list becomes per io group proper=
ty and not a
>> >> =A0 global request queue feature.
>> >>
>> >> o Currently one can define q->nr_requests to limit request descript=
ors
>> >> =A0 allocated for the queue. Now there is another tunable q->nr_gro=
up_requests
>> >> =A0 which controls the requests descriptr limit per group. q->nr_re=
quests
>> >> =A0 supercedes q->nr_group_requests to make sure if there are lots =
of groups
>> >> =A0 present, we don't end up allocating too many request descriptor=
s on the
>> >> =A0 queue.
>> >>
>> >
>> > =A0Hi Vivek,
>> >
>> > =A0In order to prevent q->nr_requests from becoming the bottle-neck =
of allocating
>> > =A0requests, whether we can update nr_requests accordingly when allo=
cating or removing
>> > =A0a cgroup?
>>
>> Vivek,
>> I agree with Gui here. In fact, it does not make much sense to keep
>> the nr_requests limit if we already have per cgroup limit in place.
>> This change also simplifies code quite a bit, as we can get rid of all
>> that sleep_on_global logic.
>>
>
> Hi Nauman, Gui,
>
> There were few reasons to keep a total limit on number of request
> descriptors (q->nr_requests) apart from per group limit.
>
> - We have this notion of queue being congested or not depending on out =
of
> =A0q->nr_requests how many are currently being used. Writeback threads,
> =A0some filesystems and other places make use of this information to ei=
ther
> =A0not to block or to avoid pushing too much of data on device if queue=
 is
> =A0congested.
>
> =A0With q->nr_requests removed, how do you define queue full and conges=
ted
> =A0semantics?

We can still keep q->nr_requests around, but don't use that number to
deny request descriptor allocation; only use it for defining queue
full and congested semantics.

>
> - I think slee_on_global logic makes sense even without q->nr_requests.
> =A0Assume that a group allows request descriptor allocation but due to =
lack
> =A0of memory, allocation fails. Where do you make this process wait to
> =A0attempt next time? Making all such failed processes on gloabl list o=
n
> =A0queue instead of per group list makes more sense to me for following
> =A0reasons.
>
> =A0 =A0 =A0 =A0- If this is the first request allocation from the group=
 and we
> =A0 =A0 =A0 =A0 =A0make the process sleep on group list, it will never =
be woken up
> =A0 =A0 =A0 =A0 =A0as no request from that group will complete.
>
> =A0 =A0 =A0 =A0- If there are many processes who failed request descrip=
tor
> =A0 =A0 =A0 =A0 =A0allocation, when some request completes, I think it =
is more
> =A0 =A0 =A0 =A0 =A0fair to wake these up in FIFO manner to try out allo=
cation again
> =A0 =A0 =A0 =A0 =A0instead of waiting for request to complete from the =
group
> =A0 =A0 =A0 =A0 =A0process belongs to. The reason being that io control=
ler did not
> =A0 =A0 =A0 =A0 =A0fail the request descriptor allocation.
>
> =A0So even if you get rid of q->nr_requests, you still shall have to ha=
ve
> =A0some logic of global wait list where failed allocations can wait.
>
> - It is backward compatible and there are less chances of higher layers
> =A0being broken due to this.
>
>
> Gui, I think automatic updation of q->nr_requests is probably not a ver=
y
> good thing. It is user defined tunable and user does not expect this to
> change automatically.
>
> At this point of time I really can't think of simpler and cleaner way.
> Ideas are welcome.
>
> Thanks
> Vivek
>
