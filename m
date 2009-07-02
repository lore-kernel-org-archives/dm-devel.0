From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 13/25] io-controller: Wait for requests to
	complete from last queue before new queue is scheduled
Date: Thu, 2 Jul 2009 16:17:30 -0400
Message-ID: <20090702201730.GB3712@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-14-git-send-email-vgoyal@redhat.com>
	<e98e18940907021309u1f784b3at409b55ba46ed108c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e98e18940907021309u1f784b3at409b55ba46ed108c@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nauman Rafique <nauman@google.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 02, 2009 at 01:09:14PM -0700, Nauman Rafique wrote:
> On Thu, Jul 2, 2009 at 1:01 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> > o Currently one can dispatch requests from multiple queues to the dis=
k. This
> > =A0is true for hardware which supports queuing. So if a disk support =
queue
> > =A0depth of 31 it is possible that 20 requests are dispatched from qu=
eue 1
> > =A0and then next queue is scheduled in which dispatches more requests=
.
> >
> > o This multiple queue dispatch introduces issues for accurate account=
ing of
> > =A0disk time consumed by a particular queue. For example, if one asyn=
c queue
> > =A0is scheduled in, it can dispatch 31 requests to the disk and then =
it will
> > =A0be expired and a new sync queue might get scheduled in. These 31 r=
equests
> > =A0might take a long time to finish but this time is never accounted =
to the
> > =A0async queue which dispatched these requests.
> >
> > o This patch introduces the functionality where we wait for all the r=
equests
> > =A0to finish from previous queue before next queue is scheduled in. T=
hat way
> > =A0a queue is more accurately accounted for disk time it has consumed=
. Note
> > =A0this still does not take care of errors introduced by disk write c=
aching.
> >
> > o Because above behavior can result in reduced throughput, this behav=
ior will
> > =A0be enabled only if user sets "fairness" tunable to 2 or higher.
>=20
> Vivek,
> Did you collect any numbers for the impact on throughput from this
> patch? It seems like with this change, we can even support NCQ.
>=20

Hi Nauman,

Not yet. I will try to do some impact analysis of this change and post th=
e
results.

Thanks
Vivek

> >
> > o This patch helps in achieving more isolation between reads and buff=
ered
> > =A0writes in different cgroups. buffered writes typically utilize ful=
l queue
> > =A0depth and then expire the queue. On the contarary, sequential read=
s
> > =A0typicaly driver queue depth of 1. So despite the fact that writes =
are
> > =A0using more disk time it is never accounted to write queue because =
we don't
> > =A0wait for requests to finish after dispatching these. This patch he=
lps
> > =A0do more accurate accounting of disk time, especially for buffered =
writes
> > =A0hence providing better fairness hence better isolation between two=
 cgroups
> > =A0running read and write workloads.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> > =A0block/elevator-fq.c | =A0 31 ++++++++++++++++++++++++++++++-
> > =A01 files changed, 30 insertions(+), 1 deletions(-)
> >
> > diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> > index 68be1dc..7609579 100644
> > --- a/block/elevator-fq.c
> > +++ b/block/elevator-fq.c
> > @@ -2038,7 +2038,7 @@ STORE_FUNCTION(elv_slice_sync_store, &efqd->elv=
_slice[1], 1, UINT_MAX, 1);
> > =A0EXPORT_SYMBOL(elv_slice_sync_store);
> > =A0STORE_FUNCTION(elv_slice_async_store, &efqd->elv_slice[0], 1, UINT=
_MAX, 1);
> > =A0EXPORT_SYMBOL(elv_slice_async_store);
> > -STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 1, 0);
> > +STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 2, 0);
> > =A0EXPORT_SYMBOL(elv_fairness_store);
> > =A0#undef STORE_FUNCTION
> >
> > @@ -2952,6 +2952,24 @@ void *elv_fq_select_ioq(struct request_queue *=
q, int force)
> > =A0 =A0 =A0 =A0}
> >
> > =A0expire:
> > + =A0 =A0 =A0 if (efqd->fairness >=3D 2 && !force && ioq && ioq->disp=
atched) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If there are request dispatched fr=
om this queue, don't
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* dispatch requests from new queue t=
ill all the requests from
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* this queue have completed.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* This helps in attributing right am=
ount of disk time consumed
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* by a particular queue when hardwar=
e allows queuing.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Set ioq =3D NULL so that no more r=
equests are dispatched from
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* this queue.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 elv_log_ioq(efqd, ioq, "select: wait fo=
r requests to finish"
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disp=3D=
%lu", ioq->dispatched);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioq =3D NULL;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto keep_queue;
> > + =A0 =A0 =A0 }
> > +
> > =A0 =A0 =A0 =A0elv_ioq_slice_expired(q);
> > =A0new_queue:
> > =A0 =A0 =A0 =A0ioq =3D elv_set_active_ioq(q, new_ioq);
> > @@ -3109,6 +3127,17 @@ void elv_ioq_completed_request(struct request_=
queue *q, struct request *rq)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0elv_io=
q_arm_slice_timer(q, 1);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If f=
airness >=3D2 and there are requests
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* di=
spatched from this queue, don't dispatch
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ne=
w requests from a different queue till
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* al=
l requests from this queue have finished.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Th=
is helps in attributing right disk time
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to=
 a queue when hardware supports queuing.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (efq=
d->fairness >=3D 2 && ioq->dispatched)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto done;
> > +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Exp=
ire the queue */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0elv_io=
q_slice_expired(q);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > --
> > 1.6.0.6
> >
> >
