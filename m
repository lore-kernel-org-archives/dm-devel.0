From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH] io-controller: Add io group reference handling for
	request
Date: Fri, 8 May 2009 10:41:01 -0700
Message-ID: <e98e18940905081041r386e52a5q5a2b1f13f1e8c634@mail.gmail.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	 <4A03FF3C.4020506@cn.fujitsu.com> <20090508135724.GE7293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754455AbZEHRlY@vger.kernel.org>
In-Reply-To: <20090508135724.GE7293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Fri, May 8, 2009 at 6:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, May 08, 2009 at 05:45:32PM +0800, Gui Jianfeng wrote:
>> Hi Vivek,
>>
>> This patch adds io group reference handling when allocating
>> and removing a request.
>>
>
> Hi Gui,
>
> Thanks for the patch. We were thinking that requests can take a refer=
ence
> on io queues and io queues can take a reference on io groups. That sh=
ould
> make sure that io groups don't go away as long as active requests are
> present.
>
> But there seems to be a small window while allocating the new request
> where request gets allocated from a group first and then later it is
> mapped to that group and queue is created. IOW, in get_request_wait()=
,
> we allocate a request from a particular group and set rq->rl, then
> drop the queue lock and later call elv_set_request() which again maps
> the request to the group saves rq->iog and creates new queue. This wi=
ndow
> is troublesome because request can be mapped to a particular group at=
 the
> time of allocation and during set_request() it can go to a different
> group as queue lock was dropped and group might have disappeared.
>
> In this case probably it might make sense that request also takes a
> reference on groups. At the same time it looks too much that request =
takes
> a reference on queue as well as group object. Ideas are welcome on ho=
w
> to handle it...

IMHO a request being allocated on the wrong cgroup should not be a big
problem as such. All it means is that the request descriptor was
accounted to the wrong cgroup in this particular corner case. Please
correct me if I am wrong.

We can also get rid of rq->iog pointer too. What that means is that
request is associated with ioq (rq->ioq), and we can use
ioq_to_io_group() function to get the io_group. So the request would
only be indirectly associated with an io_group i.e. the request is
associated with an io_queue and the io_group for the request is the
io_group associated with io_queue. Do you see any problems with that
approach?

Thanks.
--
Nauman


>
> Thanks
> Vivek
>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>> =A0elevator-fq.c | =A0 15 ++++++++++++++-
>> =A0elevator-fq.h | =A0 =A05 +++++
>> =A0elevator.c =A0 =A0| =A0 =A02 ++
>> =A03 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
>> index 9500619..e6d6712 100644
>> --- a/block/elevator-fq.c
>> +++ b/block/elevator-fq.c
>> @@ -1968,11 +1968,24 @@ void elv_fq_set_request_io_group(struct requ=
est_queue *q, struct request *rq,
>> =A0 =A0 =A0 spin_unlock_irqrestore(q->queue_lock, flags);
>> =A0 =A0 =A0 BUG_ON(!iog);
>>
>> - =A0 =A0 /* Store iog in rq. TODO: take care of referencing */
>> + =A0 =A0 elv_get_iog(iog);
>> =A0 =A0 =A0 rq->iog =3D iog;
>> =A0}
>>
>> =A0/*
>> + * This request has been serviced. Clean up iog info and drop the r=
eference.
>> + */
>> +void elv_fq_unset_request_io_group(struct request *rq)
>> +{
>> + =A0 =A0 struct io_group *iog =3D rq->iog;
>> +
>> + =A0 =A0 if (iog) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rq->iog =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 elv_put_iog(iog);
>> + =A0 =A0 }
>> +}
>> +
>> +/*
>> =A0 * Find/Create the io queue the rq should go in. This is an optim=
ization
>> =A0 * for the io schedulers (noop, deadline and AS) which maintain o=
nly single
>> =A0 * io queue per cgroup. In this case common layer can just mainta=
in a
>> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
>> index db3a347..96a28e9 100644
>> --- a/block/elevator-fq.h
>> +++ b/block/elevator-fq.h
>> @@ -512,6 +512,7 @@ static inline struct io_group *ioq_to_io_group(s=
truct io_queue *ioq)
>> =A0extern int io_group_allow_merge(struct request *rq, struct bio *b=
io);
>> =A0extern void elv_fq_set_request_io_group(struct request_queue *q,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct request *rq, struct bio *bio);
>> +extern void elv_fq_unset_request_io_group(struct request *rq);
>> =A0static inline bfq_weight_t iog_weight(struct io_group *iog)
>> =A0{
>> =A0 =A0 =A0 return iog->entity.weight;
>> @@ -571,6 +572,10 @@ static inline void elv_fq_set_request_io_group(=
struct request_queue *q,
>> =A0{
>> =A0}
>>
>> +static inline void elv_fq_unset_request_io_group(struct request *rq=
)
>> +{
>> +}
>> +
>> =A0static inline bfq_weight_t iog_weight(struct io_group *iog)
>> =A0{
>> =A0 =A0 =A0 /* Just root group is present and weight is immaterial. =
*/
>> diff --git a/block/elevator.c b/block/elevator.c
>> index 44c9fad..d75eec7 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -992,6 +992,8 @@ void elv_put_request(struct request_queue *q, st=
ruct request *rq)
>> =A0{
>> =A0 =A0 =A0 struct elevator_queue *e =3D q->elevator;
>>
>> + =A0 =A0 elv_fq_unset_request_io_group(rq);
>> +
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Optimization for noop, deadline and AS which mainta=
in only single
>> =A0 =A0 =A0 =A0* ioq per io group
>>
>
