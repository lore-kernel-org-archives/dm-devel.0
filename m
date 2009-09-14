From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 20/23] io-controller: Per cgroup request
	descriptor support
Date: Mon, 14 Sep 2009 11:33:37 -0700
Message-ID: <e98e18940909141133m5186b780r3215ce15141e4f87@mail.gmail.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-21-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251495072-7780-21-git-send-email-vgoyal@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Aug 28, 2009 at 2:31 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o Currently a request queue has got fixed number of request descriptors=
 for
> =A0sync and async requests. Once the request descriptors are consumed, =
new
> =A0processes are put to sleep and they effectively become serialized. B=
ecause
> =A0sync and async queues are separate, async requests don't impact sync=
 ones
> =A0but if one is looking for fairness between async requests, that is n=
ot
> =A0achievable if request queue descriptors become bottleneck.
>
> o Make request descriptor's per io group so that if there is lots of IO
> =A0going on in one cgroup, it does not impact the IO of other group.
>
> o This patch implements the per cgroup request descriptors. request poo=
l per
> =A0queue is still common but every group will have its own wait list an=
d its
> =A0own count of request descriptors allocated to that group for sync an=
d async
> =A0queues. So effectively request_list becomes per io group property an=
d not a
> =A0global request queue feature.
>
> o Currently one can define q->nr_requests to limit request descriptors
> =A0allocated for the queue. Now there is another tunable q->nr_group_re=
quests
> =A0which controls the requests descriptr limit per group. q->nr_request=
s
> =A0supercedes q->nr_group_requests to make sure if there are lots of gr=
oups
> =A0present, we don't end up allocating too many request descriptors on =
the
> =A0queue.
>
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> =A0block/blk-core.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0317 ++++++++++++++++++=
+++++++++++++++---------
> =A0block/blk-settings.c =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A0block/blk-sysfs.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 59 ++++++--
> =A0block/elevator-fq.c =A0 =A0 =A0 =A0 =A0| =A0 36 +++++
> =A0block/elevator-fq.h =A0 =A0 =A0 =A0 =A0| =A0 29 ++++
> =A0block/elevator.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A07 +-
> =A0include/linux/blkdev.h =A0 =A0 =A0 | =A0 47 ++++++-
> =A0include/trace/events/block.h | =A0 =A06 +-
> =A0kernel/trace/blktrace.c =A0 =A0 =A0| =A0 =A06 +-
> =A09 files changed, 421 insertions(+), 87 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 47cce59..18b400b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -460,20 +460,53 @@ void blk_cleanup_queue(struct request_queue *q)
> =A0}
> =A0EXPORT_SYMBOL(blk_cleanup_queue);
>
> -static int blk_init_free_list(struct request_queue *q)
> +struct request_list *
> +blk_get_request_list(struct request_queue *q, struct bio *bio)
> +{
> +#ifdef CONFIG_GROUP_IOSCHED
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Determine which request list bio will be allocated f=
rom. This
> + =A0 =A0 =A0 =A0* is dependent on which io group bio belongs to
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 return elv_get_request_list_bio(q, bio);
> +#else
> + =A0 =A0 =A0 return &q->rq;
> +#endif
> +}
> +
> +static struct request_list *rq_rl(struct request_queue *q, struct requ=
est *rq)
> +{
> +#ifdef CONFIG_GROUP_IOSCHED
> + =A0 =A0 =A0 int priv =3D rq->cmd_flags & REQ_ELVPRIV;
> +
> + =A0 =A0 =A0 return elv_get_request_list_rq(q, rq, priv);
> +#else
> + =A0 =A0 =A0 return &q->rq;
> +#endif
> +}
> +
> +void blk_init_request_list(struct request_list *rl)
> =A0{
> - =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
>
> =A0 =A0 =A0 =A0rl->count[BLK_RW_SYNC] =3D rl->count[BLK_RW_ASYNC] =3D 0=
;
> - =A0 =A0 =A0 rl->starved[BLK_RW_SYNC] =3D rl->starved[BLK_RW_ASYNC] =3D=
 0;
> - =A0 =A0 =A0 rl->elvpriv =3D 0;
> =A0 =A0 =A0 =A0init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
> =A0 =A0 =A0 =A0init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
> +}
>
> - =A0 =A0 =A0 rl->rq_pool =3D mempool_create_node(BLKDEV_MIN_RQ, mempoo=
l_alloc_slab,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_f=
ree_slab, request_cachep, q->node);
> +static int blk_init_free_list(struct request_queue *q)
> +{
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* In case of group scheduling, request list is inside =
group and is
> + =A0 =A0 =A0 =A0* initialized when group is instanciated.
> + =A0 =A0 =A0 =A0*/
> +#ifndef CONFIG_GROUP_IOSCHED
> + =A0 =A0 =A0 blk_init_request_list(&q->rq);
> +#endif
> + =A0 =A0 =A0 q->rq_data.rq_pool =3D mempool_create_node(BLKDEV_MIN_RQ,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_a=
lloc_slab, mempool_free_slab,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 request_c=
achep, q->node);
>
> - =A0 =A0 =A0 if (!rl->rq_pool)
> + =A0 =A0 =A0 if (!q->rq_data.rq_pool)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> =A0 =A0 =A0 =A0return 0;
> @@ -581,6 +614,9 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_=
t *lock, int node_id)
> =A0 =A0 =A0 =A0q->queue_flags =A0 =A0 =A0 =A0 =A0=3D QUEUE_FLAG_DEFAULT=
;
> =A0 =A0 =A0 =A0q->queue_lock =A0 =A0 =A0 =A0 =A0 =3D lock;
>
> + =A0 =A0 =A0 /* init starved waiter wait queue */
> + =A0 =A0 =A0 init_waitqueue_head(&q->rq_data.starved_wait);
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * This also sets hw/phys segments, boundary and size
> =A0 =A0 =A0 =A0 */
> @@ -615,14 +651,14 @@ static inline void blk_free_request(struct reques=
t_queue *q, struct request *rq)
> =A0{
> =A0 =A0 =A0 =A0if (rq->cmd_flags & REQ_ELVPRIV)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0elv_put_request(q, rq);
> - =A0 =A0 =A0 mempool_free(rq, q->rq.rq_pool);
> + =A0 =A0 =A0 mempool_free(rq, q->rq_data.rq_pool);
> =A0}
>
> =A0static struct request *
> =A0blk_alloc_request(struct request_queue *q, struct bio *bio, int flag=
s, int priv,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0gfp_t gfp_mask)
> =A0{
> - =A0 =A0 =A0 struct request *rq =3D mempool_alloc(q->rq.rq_pool, gfp_m=
ask);
> + =A0 =A0 =A0 struct request *rq =3D mempool_alloc(q->rq_data.rq_pool, =
gfp_mask);
>
> =A0 =A0 =A0 =A0if (!rq)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> @@ -633,7 +669,7 @@ blk_alloc_request(struct request_queue *q, struct b=
io *bio, int flags, int priv,
>
> =A0 =A0 =A0 =A0if (priv) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(elv_set_request(q, rq, bio,=
 gfp_mask))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_free(rq, q->rq.rq=
_pool);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_free(rq, q->rq_da=
ta.rq_pool);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq->cmd_flags |=3D REQ_ELVPRIV;
> @@ -676,18 +712,18 @@ static void ioc_set_batching(struct request_queue=
 *q, struct io_context *ioc)
> =A0 =A0 =A0 =A0ioc->last_waited =3D jiffies;
> =A0}
>
> -static void __freed_request(struct request_queue *q, int sync)
> +static void __freed_request(struct request_queue *q, int sync,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct request_list *rl)
> =A0{
> - =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
> -
> - =A0 =A0 =A0 if (rl->count[sync] < queue_congestion_off_threshold(q))
> + =A0 =A0 =A0 if (q->rq_data.count[sync] < queue_congestion_off_thresho=
ld(q))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_clear_queue_congested(q, sync);
>
> - =A0 =A0 =A0 if (rl->count[sync] + 1 <=3D q->nr_requests) {
> + =A0 =A0 =A0 if (q->rq_data.count[sync] + 1 <=3D q->nr_requests)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_clear_queue_full(q, sync);
> +
> + =A0 =A0 =A0 if (rl->count[sync] + 1 <=3D q->nr_group_requests) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (waitqueue_active(&rl->wait[sync]))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&rl->wait[sync])=
;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_clear_queue_full(q, sync);
> =A0 =A0 =A0 =A0}
> =A0}
>
> @@ -695,63 +731,130 @@ static void __freed_request(struct request_queue=
 *q, int sync)
> =A0* A request has just been released. =A0Account for it, update the fu=
ll and
> =A0* congestion status, wake up any waiters. =A0 Called under q->queue_=
lock.
> =A0*/
> -static void freed_request(struct request_queue *q, int sync, int priv)
> +static void freed_request(struct request_queue *q, int sync, int priv,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct request_list *rl)
> =A0{
> - =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* There is a window during request allocation where re=
quest is
> + =A0 =A0 =A0 =A0* mapped to one group but by the time a queue for the =
group is
> + =A0 =A0 =A0 =A0* allocated, it is possible that original cgroup/io gr=
oup has been
> + =A0 =A0 =A0 =A0* deleted and now io queue is allocated in a different=
 group (root)
> + =A0 =A0 =A0 =A0* altogether.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* One solution to the problem is that rq should take i=
o group
> + =A0 =A0 =A0 =A0* reference. But it looks too much to do that to solve=
 this issue.
> + =A0 =A0 =A0 =A0* The only side affect to the hard to hit issue seems =
to be that
> + =A0 =A0 =A0 =A0* we will try to decrement the rl->count for a request=
 list which
> + =A0 =A0 =A0 =A0* did not allocate that request. Chcek for rl->count g=
oing less than
> + =A0 =A0 =A0 =A0* zero and do not decrement it if that's the case.
> + =A0 =A0 =A0 =A0*/
> +
> + =A0 =A0 =A0 if (priv && rl->count[sync] > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl->count[sync]--;
> +
> + =A0 =A0 =A0 BUG_ON(!q->rq_data.count[sync]);
> + =A0 =A0 =A0 q->rq_data.count[sync]--;
>
> - =A0 =A0 =A0 rl->count[sync]--;
> =A0 =A0 =A0 =A0if (priv)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl->elvpriv--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 q->rq_data.elvpriv--;
>
> - =A0 =A0 =A0 __freed_request(q, sync);
> + =A0 =A0 =A0 __freed_request(q, sync, rl);
>
> =A0 =A0 =A0 =A0if (unlikely(rl->starved[sync ^ 1]))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __freed_request(q, sync ^ 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __freed_request(q, sync ^ 1, rl);
> +
> + =A0 =A0 =A0 /* Wake up the starved process on global list, if any */
> + =A0 =A0 =A0 if (unlikely(q->rq_data.starved)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (waitqueue_active(&q->rq_data.starved_=
wait))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&q->rq_data.starv=
ed_wait);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 q->rq_data.starved--;
> + =A0 =A0 =A0 }
> +}
> +
> +/*
> + * Returns whether one can sleep on this request list or not. There ar=
e
> + * cases (elevator switch) where request list might not have allocated
> + * any request descriptor but we deny request allocation due to gloabl
> + * limits. In that case one should sleep on global list as on this req=
uest
> + * list no wakeup will take place.
> + *
> + * Also sets the request list starved flag if there are no requests pe=
nding
> + * in the direction of rq.
> + *
> + * Return 1 --> sleep on request list, 0 --> sleep on global list
> + */
> +static int can_sleep_on_request_list(struct request_list *rl, int is_s=
ync)
> +{
> + =A0 =A0 =A0 if (unlikely(rl->count[is_sync] =3D=3D 0)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If there is a request pending in oth=
er direction
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in same io group, then set the starv=
ed flag of
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the group request list. Otherwise, w=
e need to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* make this process sleep in global st=
arved list
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to make sure it will not sleep indef=
initely.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rl->count[is_sync ^ 1] !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl->starved[is_sync] =3D =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 1;
> =A0}
>
> =A0/*
> =A0* Get a free request, queue_lock must be held.
> - * Returns NULL on failure, with queue_lock held.
> + * Returns NULL on failure, with queue_lock held. Also sets the "reaso=
n" field
> + * in case of failure. This reason field helps caller decide to whethe=
r sleep
> + * on per group list or global per queue list.
> + * reason =3D 0 sleep on per group list
> + * reason =3D 1 sleep on global list
> + *
> =A0* Returns !NULL on success, with queue_lock *not held*.
> =A0*/
> =A0static struct request *get_request(struct request_queue *q, int rw_f=
lags,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st=
ruct bio *bio, gfp_t gfp_mask)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct bio *bio, gfp_t gfp_mask,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct request_list *rl, int *reason)
> =A0{
> =A0 =A0 =A0 =A0struct request *rq =3D NULL;
> - =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
> =A0 =A0 =A0 =A0struct io_context *ioc =3D NULL;
> =A0 =A0 =A0 =A0const bool is_sync =3D rw_is_sync(rw_flags) !=3D 0;
> =A0 =A0 =A0 =A0int may_queue, priv;
> + =A0 =A0 =A0 int sleep_on_global =3D 0;
>
> =A0 =A0 =A0 =A0may_queue =3D elv_may_queue(q, rw_flags);
> =A0 =A0 =A0 =A0if (may_queue =3D=3D ELV_MQUEUE_NO)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto rq_starved;
>
> - =A0 =A0 =A0 if (rl->count[is_sync]+1 >=3D queue_congestion_on_thresho=
ld(q)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rl->count[is_sync]+1 >=3D q->nr_reque=
sts) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc =3D current_io_contex=
t(GFP_ATOMIC, q->node);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The queue will fill =
after this allocation, so set
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* it as full, and mark=
 this process as "batching".
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* This process will be=
 allowed to complete a batch of
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* requests, others wil=
l be blocked.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!blk_queue_full(q, is=
_sync)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc_set_b=
atching(q, ioc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_set_q=
ueue_full(q, is_sync);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (may_q=
ueue !=3D ELV_MQUEUE_MUST
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 && !ioc_batching(q, ioc)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* The queue is full and the allocating
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* process is not a "batcher", and not
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* exempted by the IO scheduler
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (q->rq_data.count[is_sync]+1 >=3D queue_congestion_on_=
threshold(q))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_set_queue_congested(q, is_sync);
> +
> + =A0 =A0 =A0 /* queue full seems redundant now */
> + =A0 =A0 =A0 if (q->rq_data.count[is_sync]+1 >=3D q->nr_requests)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_set_queue_full(q, is_sync);
> +
> + =A0 =A0 =A0 if (rl->count[is_sync]+1 >=3D q->nr_group_requests) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc =3D current_io_context(GFP_ATOMIC, q-=
>node);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The queue request descriptor group w=
ill fill after this
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allocation, so set it as full, and m=
ark this process as
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* "batching". This process will be all=
owed to complete a
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* batch of requests, others will be bl=
ocked.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rl->count[is_sync] <=3D q->nr_group_r=
equests)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioc_set_batching(q, ioc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (may_queue !=3D ELV_MQ=
UEUE_MUST
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 && !ioc_batching(q, ioc)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The =
queue is full and the allocating
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* proc=
ess is not a "batcher", and not
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* exem=
pted by the IO scheduler
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_set_queue_congested(q, is_sync);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/*
> @@ -759,21 +862,60 @@ static struct request *get_request(struct request=
_queue *q, int rw_flags,
> =A0 =A0 =A0 =A0 * limit of requests, otherwise we could have thousands =
of requests
> =A0 =A0 =A0 =A0 * allocated with any setting of ->nr_requests
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (rl->count[is_sync] >=3D (3 * q->nr_requests / 2))
> +
> + =A0 =A0 =A0 if (q->rq_data.count[is_sync] >=3D (3 * q->nr_requests / =
2)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Queue is too full for allocation. On=
 which request queue
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the task should sleep? Generally it =
should sleep on its
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* request list but if elevator switch =
is happening, in that
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* window, request descriptors are allo=
cated from global
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* pool and are not accounted against a=
ny particular request
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* list as group is going away.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* So it might happen that request list=
 does not have any
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* requests allocated at all and if pro=
cess sleeps on per
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* group request list, it will not be w=
oken up. In such case,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* make it sleep on global starved list=
.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(QUEUE_FLAG_ELVSWITCH, &q->qu=
eue_flags)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 || !can_sleep_on_request_list(rl,=
 is_sync))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sleep_on_global =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Allocation of request is allowed from queue perspect=
ive. Now check
> + =A0 =A0 =A0 =A0* from per group request list
> + =A0 =A0 =A0 =A0*/
> +
> + =A0 =A0 =A0 if (rl->count[is_sync] >=3D (3 * q->nr_group_requests / 2=
))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 rl->count[is_sync]++;
> =A0 =A0 =A0 =A0rl->starved[is_sync] =3D 0;
>
> + =A0 =A0 =A0 q->rq_data.count[is_sync]++;
> +
> =A0 =A0 =A0 =A0priv =3D !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags=
);
> - =A0 =A0 =A0 if (priv)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl->elvpriv++;
> + =A0 =A0 =A0 if (priv) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 q->rq_data.elvpriv++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Account the request to request list =
only if request is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* going to elevator. During elevator s=
witch, there will
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* be small window where group is going=
 away and new group
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* will not be allocated till elevator =
switch is complete.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* So till then instead of slowing down=
 the application,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we will continue to allocate request=
 from total common
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* pool instead of per group limit
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl->count[is_sync]++;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (blk_queue_io_stat(q))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rw_flags |=3D REQ_IO_STAT;
> =A0 =A0 =A0 =A0spin_unlock_irq(q->queue_lock);
>
> =A0 =A0 =A0 =A0rq =3D blk_alloc_request(q, bio, rw_flags, priv, gfp_mas=
k);
> +
> =A0 =A0 =A0 =A0if (unlikely(!rq)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Allocation failed presumably due to m=
emory. Undo anything
> @@ -783,7 +925,7 @@ static struct request *get_request(struct request_q=
ueue *q, int rw_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * wait queue, but this is pretty rare.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irq(q->queue_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 freed_request(q, is_sync, priv);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 freed_request(q, is_sync, priv, rl);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * in the very unlikely event that alloc=
ation failed and no
> @@ -793,9 +935,8 @@ static struct request *get_request(struct request_q=
ueue *q, int rw_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * rq mempool into READ and WRITE
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0rq_starved:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(rl->count[is_sync] =3D=3D 0)=
)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl->starved[is_sync] =3D =
1;
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!can_sleep_on_request_list(rl, is_syn=
c))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sleep_on_global =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> @@ -810,6 +951,8 @@ rq_starved:
>
> =A0 =A0 =A0 =A0trace_block_getrq(q, bio, rw_flags & 1);
> =A0out:
> + =A0 =A0 =A0 if (reason && sleep_on_global)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *reason =3D 1;
> =A0 =A0 =A0 =A0return rq;
> =A0}
>
> @@ -823,16 +966,39 @@ static struct request *get_request_wait(struct re=
quest_queue *q, int rw_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0struct bio *bio)
> =A0{
> =A0 =A0 =A0 =A0const bool is_sync =3D rw_is_sync(rw_flags) !=3D 0;
> + =A0 =A0 =A0 int sleep_on_global =3D 0;
> =A0 =A0 =A0 =A0struct request *rq;
> + =A0 =A0 =A0 struct request_list *rl =3D blk_get_request_list(q, bio);
>
> - =A0 =A0 =A0 rq =3D get_request(q, rw_flags, bio, GFP_NOIO);
> + =A0 =A0 =A0 rq =3D get_request(q, rw_flags, bio, GFP_NOIO, rl, &sleep=
_on_global);
> =A0 =A0 =A0 =A0while (!rq) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DEFINE_WAIT(wait);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct io_context *ioc;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 prepare_to_wait_exclusive(&rl->wait[is_sy=
nc], &wait,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 TASK_UNIN=
TERRUPTIBLE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sleep_on_global) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Task failed allocati=
on and needs to wait and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* try again. There are=
 no requests pending from
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the io group hence n=
eed to sleep on global
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* wait queue. Most lik=
ely the allocation failed
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* because of memory is=
sues.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 q->rq_data.starved++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prepare_to_wait_exclusive=
(&q->rq_data.starved_wait,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &wait, TASK_UNINTERRUPTIBLE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We are about to slee=
p on a request list and we
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* drop queue lock. Aft=
er waking up, we will do
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* finish_wait() on req=
uest list and in the mean
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* time group might be =
gone. Take a reference to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the group now.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prepare_to_wait_exclusive=
(&rl->wait[is_sync], &wait,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 TASK_UNINTERRUPTIBLE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 elv_get_rl_iog(rl);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0trace_block_sleeprq(q, bio, rw_flags & 1=
);
>
> @@ -850,9 +1016,25 @@ static struct request *get_request_wait(struct re=
quest_queue *q, int rw_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ioc_set_batching(q, ioc);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irq(q->queue_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 finish_wait(&rl->wait[is_sync], &wait);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D get_request(q, rw_flags, bio, GFP_=
NOIO);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sleep_on_global) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 finish_wait(&q->rq_data.s=
tarved_wait, &wait);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sleep_on_global =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We had taken a refer=
ence to the rl/iog. Put that now
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 finish_wait(&rl->wait[is_=
sync], &wait);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 elv_put_rl_iog(rl);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* After the sleep check the rl again i=
n case cgrop bio
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* belonged to is gone and it is mapped=
 to root group now
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rl =3D blk_get_request_list(q, bio);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D get_request(q, rw_flags, bio, GFP_=
NOIO, rl,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &sleep_on_global);
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0return rq;
> @@ -861,14 +1043,16 @@ static struct request *get_request_wait(struct r=
equest_queue *q, int rw_flags,
> =A0struct request *blk_get_request(struct request_queue *q, int rw, gfp=
_t gfp_mask)
> =A0{
> =A0 =A0 =A0 =A0struct request *rq;
> + =A0 =A0 =A0 struct request_list *rl;
>
> =A0 =A0 =A0 =A0BUG_ON(rw !=3D READ && rw !=3D WRITE);
>
> =A0 =A0 =A0 =A0spin_lock_irq(q->queue_lock);
> + =A0 =A0 =A0 rl =3D blk_get_request_list(q, NULL);
> =A0 =A0 =A0 =A0if (gfp_mask & __GFP_WAIT) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq =3D get_request_wait(q, rw, NULL);
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D get_request(q, rw, NULL, gfp_mask)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D get_request(q, rw, NULL, gfp_mask,=
 rl, NULL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rq)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irq(q->queue=
_lock);
> =A0 =A0 =A0 =A0}
> @@ -1085,12 +1269,13 @@ void __blk_put_request(struct request_queue *q,=
 struct request *req)
> =A0 =A0 =A0 =A0if (req->cmd_flags & REQ_ALLOCED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int is_sync =3D rq_is_sync(req) !=3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int priv =3D req->cmd_flags & REQ_ELVPRI=
V;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_list *rl =3D rq_rl(q, req)=
;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(!list_empty(&req->queuelist));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(!hlist_unhashed(&req->hash));
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_free_request(q, req);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 freed_request(q, is_sync, priv);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 freed_request(q, is_sync, priv, rl);

We have a potential memory bug here. freed_request should be called
before blk_free_request as blk_free_request might result in release of
cgroup, and request_list. Calling freed_request after blk_free_request
would result in operations on freed memory.

> =A0 =A0 =A0 =A0}
> =A0}
> =A0EXPORT_SYMBOL_GPL(__blk_put_request);
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 476d870..c3102c7 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -149,6 +149,7 @@ void blk_queue_make_request(struct request_queue *q=
, make_request_fn *mfn)
> =A0 =A0 =A0 =A0 * set defaults
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0q->nr_requests =3D BLKDEV_MAX_RQ;
> + =A0 =A0 =A0 q->nr_group_requests =3D BLKDEV_MAX_GROUP_RQ;
>
> =A0 =A0 =A0 =A0q->make_request_fn =3D mfn;
> =A0 =A0 =A0 =A0blk_queue_dma_alignment(q, 511);
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 418d636..f3db7f0 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -38,42 +38,67 @@ static ssize_t queue_requests_show(struct request_q=
ueue *q, char *page)
> =A0static ssize_t
> =A0queue_requests_store(struct request_queue *q, const char *page, size=
_t count)
> =A0{
> - =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
> + =A0 =A0 =A0 struct request_list *rl;
> =A0 =A0 =A0 =A0unsigned long nr;
> =A0 =A0 =A0 =A0int ret =3D queue_var_store(&nr, page, count);
> =A0 =A0 =A0 =A0if (nr < BLKDEV_MIN_RQ)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr =3D BLKDEV_MIN_RQ;
>
> =A0 =A0 =A0 =A0spin_lock_irq(q->queue_lock);
> + =A0 =A0 =A0 rl =3D blk_get_request_list(q, NULL);
> =A0 =A0 =A0 =A0q->nr_requests =3D nr;
> =A0 =A0 =A0 =A0blk_queue_congestion_threshold(q);
>
> - =A0 =A0 =A0 if (rl->count[BLK_RW_SYNC] >=3D queue_congestion_on_thres=
hold(q))
> + =A0 =A0 =A0 if (q->rq_data.count[BLK_RW_SYNC] >=3D queue_congestion_o=
n_threshold(q))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_set_queue_congested(q, BLK_RW_SYNC);
> - =A0 =A0 =A0 else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_th=
reshold(q))
> + =A0 =A0 =A0 else if (q->rq_data.count[BLK_RW_SYNC] <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_con=
gestion_off_threshold(q))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_clear_queue_congested(q, BLK_RW_SYNC=
);
>
> - =A0 =A0 =A0 if (rl->count[BLK_RW_ASYNC] >=3D queue_congestion_on_thre=
shold(q))
> + =A0 =A0 =A0 if (q->rq_data.count[BLK_RW_ASYNC] >=3D queue_congestion_=
on_threshold(q))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_set_queue_congested(q, BLK_RW_ASYNC)=
;
> - =A0 =A0 =A0 else if (rl->count[BLK_RW_ASYNC] < queue_congestion_off_t=
hreshold(q))
> + =A0 =A0 =A0 else if (q->rq_data.count[BLK_RW_ASYNC] <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_con=
gestion_off_threshold(q))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_clear_queue_congested(q, BLK_RW_ASYN=
C);
>
> - =A0 =A0 =A0 if (rl->count[BLK_RW_SYNC] >=3D q->nr_requests) {
> + =A0 =A0 =A0 if (q->rq_data.count[BLK_RW_SYNC] >=3D q->nr_requests) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_set_queue_full(q, BLK_RW_SYNC);
> - =A0 =A0 =A0 } else if (rl->count[BLK_RW_SYNC]+1 <=3D q->nr_requests) =
{
> + =A0 =A0 =A0 } else if (q->rq_data.count[BLK_RW_SYNC]+1 <=3D q->nr_req=
uests) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_clear_queue_full(q, BLK_RW_SYNC);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&rl->wait[BLK_RW_SYNC]);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (rl->count[BLK_RW_ASYNC] >=3D q->nr_requests) {
> + =A0 =A0 =A0 if (q->rq_data.count[BLK_RW_ASYNC] >=3D q->nr_requests) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_set_queue_full(q, BLK_RW_ASYNC);
> - =A0 =A0 =A0 } else if (rl->count[BLK_RW_ASYNC]+1 <=3D q->nr_requests)=
 {
> + =A0 =A0 =A0 } else if (q->rq_data.count[BLK_RW_ASYNC]+1 <=3D q->nr_re=
quests) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_clear_queue_full(q, BLK_RW_ASYNC);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&rl->wait[BLK_RW_ASYNC]);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock_irq(q->queue_lock);
> =A0 =A0 =A0 =A0return ret;
> =A0}
> +#ifdef CONFIG_GROUP_IOSCHED
> +static ssize_t queue_group_requests_show(struct request_queue *q, char=
 *page)
> +{
> + =A0 =A0 =A0 return queue_var_show(q->nr_group_requests, (page));
> +}
> +
> +static ssize_t
> +queue_group_requests_store(struct request_queue *q, const char *page,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 size_t count)
> +{
> + =A0 =A0 =A0 unsigned long nr;
> + =A0 =A0 =A0 int ret =3D queue_var_store(&nr, page, count);
> +
> + =A0 =A0 =A0 if (nr < BLKDEV_MIN_RQ)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr =3D BLKDEV_MIN_RQ;
> +
> + =A0 =A0 =A0 spin_lock_irq(q->queue_lock);
> + =A0 =A0 =A0 q->nr_group_requests =3D nr;
> + =A0 =A0 =A0 spin_unlock_irq(q->queue_lock);
> + =A0 =A0 =A0 return ret;
> +}
> +#endif
>
> =A0static ssize_t queue_ra_show(struct request_queue *q, char *page)
> =A0{
> @@ -240,6 +265,14 @@ static struct queue_sysfs_entry queue_requests_ent=
ry =3D {
> =A0 =A0 =A0 =A0.store =3D queue_requests_store,
> =A0};
>
> +#ifdef CONFIG_GROUP_IOSCHED
> +static struct queue_sysfs_entry queue_group_requests_entry =3D {
> + =A0 =A0 =A0 .attr =3D {.name =3D "nr_group_requests", .mode =3D S_IRU=
GO | S_IWUSR },
> + =A0 =A0 =A0 .show =3D queue_group_requests_show,
> + =A0 =A0 =A0 .store =3D queue_group_requests_store,
> +};
> +#endif
> +
> =A0static struct queue_sysfs_entry queue_ra_entry =3D {
> =A0 =A0 =A0 =A0.attr =3D {.name =3D "read_ahead_kb", .mode =3D S_IRUGO =
| S_IWUSR },
> =A0 =A0 =A0 =A0.show =3D queue_ra_show,
> @@ -314,6 +347,9 @@ static struct queue_sysfs_entry queue_iostats_entry=
 =3D {
>
> =A0static struct attribute *default_attrs[] =3D {
> =A0 =A0 =A0 =A0&queue_requests_entry.attr,
> +#ifdef CONFIG_GROUP_IOSCHED
> + =A0 =A0 =A0 &queue_group_requests_entry.attr,
> +#endif
> =A0 =A0 =A0 =A0&queue_ra_entry.attr,
> =A0 =A0 =A0 =A0&queue_max_hw_sectors_entry.attr,
> =A0 =A0 =A0 =A0&queue_max_sectors_entry.attr,
> @@ -393,12 +429,11 @@ static void blk_release_queue(struct kobject *kob=
j)
> =A0{
> =A0 =A0 =A0 =A0struct request_queue *q =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0container_of(kobj, struct request_queue,=
 kobj);
> - =A0 =A0 =A0 struct request_list *rl =3D &q->rq;
>
> =A0 =A0 =A0 =A0blk_sync_queue(q);
>
> - =A0 =A0 =A0 if (rl->rq_pool)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_destroy(rl->rq_pool);
> + =A0 =A0 =A0 if (q->rq_data.rq_pool)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_destroy(q->rq_data.rq_pool);
>
> =A0 =A0 =A0 =A0if (q->queue_tags)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__blk_queue_free_tags(q);
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 9c8783c..39896c2 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -925,6 +925,39 @@ static struct io_cgroup *cgroup_to_io_cgroup(struc=
t cgroup *cgroup)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct io_cgroup=
, css);
> =A0}
>
> +struct request_list *
> +elv_get_request_list_bio(struct request_queue *q, struct bio *bio)
> +{
> + =A0 =A0 =A0 struct io_group *iog;
> +
> + =A0 =A0 =A0 if (!elv_iosched_fair_queuing_enabled(q->elevator))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iog =3D q->elevator->efqd->root_group;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iog =3D elv_io_get_io_group_bio(q, bio, 1=
);
> +
> + =A0 =A0 =A0 BUG_ON(!iog);
> + =A0 =A0 =A0 return &iog->rl;
> +}
> +
> +struct request_list *
> +elv_get_request_list_rq(struct request_queue *q, struct request *rq, i=
nt priv)
> +{
> + =A0 =A0 =A0 struct io_group *iog;
> +
> + =A0 =A0 =A0 if (!elv_iosched_fair_queuing_enabled(q->elevator))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return &q->elevator->efqd->root_group->rl=
;
> +
> + =A0 =A0 =A0 BUG_ON(priv && !rq->ioq);
> +
> + =A0 =A0 =A0 if (priv)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iog =3D ioq_to_io_group(rq->ioq);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iog =3D q->elevator->efqd->root_group;
> +
> + =A0 =A0 =A0 BUG_ON(!iog);
> + =A0 =A0 =A0 return &iog->rl;
> +}
> +
> =A0/*
> =A0* Search the io_group for efqd into the hash table (by now only a li=
st)
> =A0* of bgrp. =A0Must be called under rcu_read_lock().
> @@ -1281,6 +1314,8 @@ io_group_chain_alloc(struct request_queue *q, voi=
d *key, struct cgroup *cgroup)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0elv_get_iog(iog);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io_group_path(iog);
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_init_request_list(&iog->rl);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (leaf =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0leaf =3D iog;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0prev =3D leaf;
> @@ -1502,6 +1537,7 @@ static struct io_group *io_alloc_root_group(struc=
t request_queue *q,
> =A0 =A0 =A0 =A0for (i =3D 0; i < IO_IOPRIO_CLASSES; i++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iog->sched_data.service_tree[i] =3D ELV_=
SERVICE_TREE_INIT;
>
> + =A0 =A0 =A0 blk_init_request_list(&iog->rl);
> =A0 =A0 =A0 =A0spin_lock_irq(&iocg->lock);
> =A0 =A0 =A0 =A0rcu_assign_pointer(iog->key, key);
> =A0 =A0 =A0 =A0hlist_add_head_rcu(&iog->group_node, &iocg->group_data);
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 9fe52fa..989102e 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -128,6 +128,9 @@ struct io_group {
>
> =A0 =A0 =A0 =A0/* Single ioq per group, used for noop, deadline, antici=
patory */
> =A0 =A0 =A0 =A0struct io_queue *ioq;
> +
> + =A0 =A0 =A0 /* request list associated with the group */
> + =A0 =A0 =A0 struct request_list rl;
> =A0};
>
> =A0struct io_cgroup {
> @@ -425,11 +428,31 @@ static inline void elv_get_iog(struct io_group *i=
og)
> =A0 =A0 =A0 =A0atomic_inc(&iog->ref);
> =A0}
>
> +static inline struct io_group *rl_iog(struct request_list *rl)
> +{
> + =A0 =A0 =A0 return container_of(rl, struct io_group, rl);
> +}
> +
> +static inline void elv_get_rl_iog(struct request_list *rl)
> +{
> + =A0 =A0 =A0 elv_get_iog(rl_iog(rl));
> +}
> +
> +static inline void elv_put_rl_iog(struct request_list *rl)
> +{
> + =A0 =A0 =A0 elv_put_iog(rl_iog(rl));
> +}
> +
> =A0extern int elv_set_request_ioq(struct request_queue *q, struct reque=
st *rq,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0struct bio *bio, gfp_t gfp_mask);
> =A0extern void elv_reset_request_ioq(struct request_queue *q, struct re=
quest *rq);
> =A0extern struct io_queue *elv_lookup_ioq_bio(struct request_queue *q,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0struct bio *bio);
> +struct request_list *
> +elv_get_request_list_bio(struct request_queue *q, struct bio *bio);
> +
> +struct request_list *
> +elv_get_request_list_rq(struct request_queue *q, struct request *rq, i=
nt priv);
>
> =A0#else /* !GROUP_IOSCHED */
>
> @@ -469,6 +492,9 @@ elv_lookup_ioq_bio(struct request_queue *q, struct =
bio *bio)
> =A0 =A0 =A0 =A0return NULL;
> =A0}
>
> +static inline void elv_get_rl_iog(struct request_list *rl) { }
> +static inline void elv_put_rl_iog(struct request_list *rl) { }
> +
> =A0#endif /* GROUP_IOSCHED */
>
> =A0extern ssize_t elv_slice_sync_show(struct elevator_queue *q, char *n=
ame);
> @@ -578,6 +604,9 @@ static inline struct io_queue *elv_lookup_ioq_bio(s=
truct request_queue *q,
> =A0 =A0 =A0 =A0return NULL;
> =A0}
>
> +static inline void elv_get_rl_iog(struct request_list *rl) { }
> +static inline void elv_put_rl_iog(struct request_list *rl) { }
> +
> =A0#endif /* CONFIG_ELV_FAIR_QUEUING */
> =A0#endif /* _ELV_SCHED_H */
> =A0#endif /* CONFIG_BLOCK */
> diff --git a/block/elevator.c b/block/elevator.c
> index 4ed37b6..b23db03 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -678,7 +678,7 @@ void elv_quiesce_start(struct request_queue *q)
> =A0 =A0 =A0 =A0 * make sure we don't have any requests in flight
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0elv_drain_elevator(q);
> - =A0 =A0 =A0 while (q->rq.elvpriv) {
> + =A0 =A0 =A0 while (q->rq_data.elvpriv) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__blk_run_queue(q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irq(q->queue_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msleep(10);
> @@ -777,8 +777,9 @@ void elv_insert(struct request_queue *q, struct req=
uest *rq, int where)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (unplug_it && blk_queue_plugged(q)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int nrq =3D q->rq.count[BLK_RW_SYNC] + q-=
>rq.count[BLK_RW_ASYNC]
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - queue_i=
n_flight(q);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int nrq =3D q->rq_data.count[BLK_RW_SYNC]=
 +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 q->rq_dat=
a.count[BLK_RW_ASYNC] -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_in_=
flight(q);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nrq >=3D q->unplug_thresh)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__generic_unplug_device(=
q);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 7cff5f2..74deb17 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -32,21 +32,51 @@ struct request;
> =A0struct sg_io_hdr;
>
> =A0#define BLKDEV_MIN_RQ =A04
> +
> +#ifdef CONFIG_GROUP_IOSCHED
> +#define BLKDEV_MAX_RQ =A0512 =A0 =A0 /* Default maximum for queue */
> +#define BLKDEV_MAX_GROUP_RQ =A0 =A0128 =A0 =A0 =A0/* Default maximum p=
er group*/
> +#else
> =A0#define BLKDEV_MAX_RQ =A0128 =A0 =A0 /* Default maximum */
> +/*
> + * This is eqivalent to case of only one group present (root group). L=
et
> + * it consume all the request descriptors available on the queue .
> + */
> +#define BLKDEV_MAX_GROUP_RQ =A0 =A0BLKDEV_MAX_RQ =A0 =A0 =A0/* Default=
 maximum */
> +#endif
>
> =A0struct request;
> =A0typedef void (rq_end_io_fn)(struct request *, int);
>
> =A0struct request_list {
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* count[], starved[], and wait[] are indexed by
> + =A0 =A0 =A0 =A0* count[], starved and wait[] are indexed by
> =A0 =A0 =A0 =A0 * BLK_RW_SYNC/BLK_RW_ASYNC
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0int count[2];
> =A0 =A0 =A0 =A0int starved[2];
> + =A0 =A0 =A0 wait_queue_head_t wait[2];
> +};
> +
> +/*
> + * This data structures keeps track of mempool of requests for the que=
ue
> + * and some overall statistics.
> + */
> +struct request_data {
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Per queue request descriptor count. This is in addit=
ion to per
> + =A0 =A0 =A0 =A0* cgroup count
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 int count[2];
> =A0 =A0 =A0 =A0int elvpriv;
> =A0 =A0 =A0 =A0mempool_t *rq_pool;
> - =A0 =A0 =A0 wait_queue_head_t wait[2];
> + =A0 =A0 =A0 int starved;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Global list for starved tasks. A task will be queued=
 here if
> + =A0 =A0 =A0 =A0* it could not allocate request descriptor and the ass=
ociated
> + =A0 =A0 =A0 =A0* group request list does not have any requests pendin=
g.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 wait_queue_head_t starved_wait;
> =A0};
>
> =A0/*
> @@ -339,10 +369,17 @@ struct request_queue
> =A0 =A0 =A0 =A0struct request =A0 =A0 =A0 =A0 =A0*last_merge;
> =A0 =A0 =A0 =A0struct elevator_queue =A0 *elevator;
>
> +#ifndef CONFIG_GROUP_IOSCHED
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * the queue request freelist, one for reads and one for=
 writes
> + =A0 =A0 =A0 =A0* In case of group io scheduling, this request list is=
 per group
> + =A0 =A0 =A0 =A0* and is present in group data structure.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0struct request_list =A0 =A0 rq;
> +#endif
> +
> + =A0 =A0 =A0 /* Contains request pool and other data like starved data=
 */
> + =A0 =A0 =A0 struct request_data =A0 =A0 rq_data;
>
> =A0 =A0 =A0 =A0request_fn_proc =A0 =A0 =A0 =A0 *request_fn;
> =A0 =A0 =A0 =A0make_request_fn =A0 =A0 =A0 =A0 *make_request_fn;
> @@ -405,6 +442,8 @@ struct request_queue
> =A0 =A0 =A0 =A0 * queue settings
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0unsigned long =A0 =A0 =A0 =A0 =A0 nr_requests; =A0 =A0/*=
 Max # of requests */
> + =A0 =A0 =A0 /* Max # of per io group requests */
> + =A0 =A0 =A0 unsigned long =A0 =A0 =A0 =A0 =A0 nr_group_requests;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0nr_congestion_on;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0nr_congestion_off;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0nr_batching;
> @@ -784,6 +823,10 @@ extern int scsi_cmd_ioctl(struct request_queue *, =
struct gendisk *, fmode_t,
> =A0extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, f=
mode_t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct scsi_ioctl_comma=
nd __user *);
>
> +extern void blk_init_request_list(struct request_list *rl);
> +
> +extern struct request_list *blk_get_request_list(struct request_queue =
*q,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct bio *bio);
> =A0/*
> =A0* A queue has just exitted congestion. =A0Note this in the global co=
unter of
> =A0* congested queues, and wake up anyone who was waiting for requests =
to be
> diff --git a/include/trace/events/block.h b/include/trace/events/block.=
h
> index 9a74b46..af6c9e5 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -397,7 +397,8 @@ TRACE_EVENT(block_unplug_timer,
> =A0 =A0 =A0 =A0),
>
> =A0 =A0 =A0 =A0TP_fast_assign(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __entry->nr_rq =A0=3D q->rq.count[READ] +=
 q->rq.count[WRITE];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __entry->nr_rq =A0=3D q->rq_data.count[RE=
AD] +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 q->rq_data.count[WRITE];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(__entry->comm, current->comm, TAS=
K_COMM_LEN);
> =A0 =A0 =A0 =A0),
>
> @@ -416,7 +417,8 @@ TRACE_EVENT(block_unplug_io,
> =A0 =A0 =A0 =A0),
>
> =A0 =A0 =A0 =A0TP_fast_assign(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __entry->nr_rq =A0=3D q->rq.count[READ] +=
 q->rq.count[WRITE];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __entry->nr_rq =A0=3D q->rq_data.count[RE=
AD] +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 q->rq_data.count[WRITE];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(__entry->comm, current->comm, TAS=
K_COMM_LEN);
> =A0 =A0 =A0 =A0),
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 7a34cb5..9a03980 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -786,7 +786,8 @@ static void blk_add_trace_unplug_io(struct request_=
queue *q)
> =A0 =A0 =A0 =A0struct blk_trace *bt =3D q->blk_trace;
>
> =A0 =A0 =A0 =A0if (bt) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int pdu =3D q->rq.count[READ] + =
q->rq.count[WRITE];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int pdu =3D q->rq_data.count[REA=
D] +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 q->rq_data.count[WRITE];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__be64 rpdu =3D cpu_to_be64(pdu);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__blk_add_trace(bt, 0, 0, 0, BLK_TA_UNPL=
UG_IO, 0,
> @@ -799,7 +800,8 @@ static void blk_add_trace_unplug_timer(struct reque=
st_queue *q)
> =A0 =A0 =A0 =A0struct blk_trace *bt =3D q->blk_trace;
>
> =A0 =A0 =A0 =A0if (bt) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int pdu =3D q->rq.count[READ] + =
q->rq.count[WRITE];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int pdu =3D q->rq_data.count[REA=
D] +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 q->rq_data.count[WRITE];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__be64 rpdu =3D cpu_to_be64(pdu);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__blk_add_trace(bt, 0, 0, 0, BLK_TA_UNPL=
UG_TIMER, 0,
> --
> 1.6.0.6
>
>
