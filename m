From: Nauman Rafique <nauman@google.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 8 Sep 2009 09:30:53 -0700
Message-ID: <e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090908134244.GA15974@redhat.com>
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
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Tue, Sep 8, 2009 at 6:42 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Tue, Sep 08, 2009 at 12:01:19PM +0900, Ryo Tsuruta wrote:
>> Hi Rik,
>>
>> Rik van Riel <riel@redhat.com> wrote:
>> > Ryo Tsuruta wrote:
>> >
>> > > However, if you want to get fairness in a case like this, a new
>> > > bandwidth control policy which controls accurately according to
>> > > assigned weights can be added to dm-ioband.
>> >
>> > Are you saying that dm-ioband is purposely unfair,
>> > until a certain load level is reached?
>>
>> Not unfair, dm-ioband(weight policy) is intentionally designed to
>> use bandwidth efficiently, weight policy tries to give spare bandwidth
>> of inactive groups to active groups.
>>
>
> This group is running a sequential reader. How can you call it an inact=
ive
> group?
>
> I think that whole problem is that like CFQ you have not taken care of
> idling into account.

I think this is probably the key deal breaker. dm-ioband has no
mechanism to anticipate or idle for a reader task. Without such a
mechanism, a proportional division scheme cannot work for tasks doing
reads. Most readers do not send down more than one IO at a time, and
they do not send another until the previous one is complete.
Anticipation helps in this case, as we would wait for the task to send
down a new IO, before we expire its timeslice. Without anticipation,
we would serve the one IO from reader and then go on to serve IOs from
other tasks. When the reader would finally get around to sending next
IO, it would have to wait behind other IOs that have sent down in the
meanwhile.

IO schedulers in block layer have anticipation built into them, so a
proportional scheduling scheduling at that layer does not have to
repeat the logic or data structures for anticipation.

In fact, a rate limiting mechanism like dm-ioband can potentially
break the anticipation logic at IO schedulers, by queuing up the IOs
at an upper layer, while scheduler in block layer could have been
anticipating for it.

>
> Your solution seems to be designed only for processes doing bulk IO ove=
r
> a very long period of time. I think it limits the usefulness of solutio=
n
> severely.
>
>> > > We regarded reducing throughput loss rather than reducing duration
>> > > as the design of dm-ioband. Of course, it is possible to make a ne=
w
>> > > policy which reduces duration.
>> >
>> > ... while also reducing overall system throughput
>> > by design?
>>
>> I think it reduces system throughput compared to the current
>> implementation, because it causes more overhead to do fine grained
>> control.
>>
>> > Why are you even bothering to submit this to the
>> > linux-kernel mailing list, when there is a codebase
>> > available that has no throughput or fairness regressions?
>> > (Vivek's io scheduler based io controler)
>>
>> I think there are some advantages to dm-ioband. That's why I post
>> dm-ioband to the mailing list.
>>
>> - dm-ioband supports not only proportional weight policy but also rate
>> =A0 limiting policy. Besides, new policies can be added to dm-ioband i=
f
>> =A0 a user wants to control bandwidth by his or her own policy.
>
> I think we can easily extent io scheduler based controller to also supp=
ort
> max rate per group policy also. That should not be too hard. It is a
> matter of only keeping track of io rate per group and if a group is
> exceeding the rate, then schedule it out and move on to next group.

At Google, we have implemented a rate limiting mechanism on top of
Vivek's patches, and have been testing it. But I feel like the patch
set maintained by Vivek is pretty big already. Once we have those
patches merged, we can introduce more functionality.

>
> I can do that once proportional weight solution is stablized and gets
> merged.
>
> So its not an advantage of dm-ioband.
>
>> - The dm-ioband driver can be replaced without stopping the system by
>> =A0 using device-mapper's facility. It's easy to maintain.
>
> We talked about this point in the past also. In io scheduler based
> controller, just move all the tasks to root group and you got a system
> not doing any io control.
>
> By the way why would one like to do that?
>
> So this is also not an advantage.
>
>> - dm-ioband can use without cgroup. (I remember Vivek said it's not an
>> =A0 advantage.)
>
> I think this is more of a disadvantage than advantage. We have a very w=
ell
> defined functionality of cgroup in kernel to group the tasks. Now you a=
re
> coming up with your own method of grouping the tasks which will make li=
fe
> even more confusing for users and application writers.
>
> I don't understand what is that core requirement of yours which is not =
met
> by io scheduler based io controller. range policy control you have
> implemented recently. I don't think that removing dm-ioband module
> dynamically is core requirement. Also whatever you can do with addition=
al
> grouping mechanism, you can do with cgroup also.
>
> So if there is any of your core functionality which is not fulfilled by
> io scheduler based controller, please let me know. I will be happy to l=
ook
> into it and try to provide that feature. But looking at above list, I a=
m
> not convinced that any of the above is a compelling argument for dm-iob=
and
> inclusion.
>
> Thanks
> Vivek
>
