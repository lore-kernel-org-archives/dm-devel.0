From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator
	fair queuing
Date: Mon, 17 Aug 2009 16:37:39 -0400
Message-ID: <20090817203739.GD3539@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-3-git-send-email-vgoyal@redhat.com>
	<4A88EACC.6010805@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A88EACC.6010805@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Mon, Aug 17, 2009 at 01:29:48PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +static void place_entity(struct io_service_tree *st, struct io_entity *entity,
> > +				int add_front)
> > +{
> > +	u64 vdisktime = st->min_vdisktime;
> > +	struct rb_node *parent;
> > +	struct io_entity *entry;
> > +	int nr_active = st->nr_active - 1;
> > +
> > +	/*
> > +	 * Currently put entity at the end of last entity. This probably will
> > +	 * require adjustments as we move along
> > +	 */
> > +	if (io_entity_class_idle(entity)) {
> > +		vdisktime = elv_delta_fair(ELV_IDLE_DELAY, entity);
> > +		parent = rb_last(&st->active);
> > +		if (parent) {
> > +			entry = rb_entry(parent, struct io_entity, rb_node);
> > +			vdisktime += entry->vdisktime;
> > +		}
> > +	} else if (!add_front && nr_active) {
> > +		parent = rb_last(&st->active);
> > +		if (parent) {
> > +			entry = rb_entry(parent, struct io_entity, rb_node);
> > +			vdisktime = entry->vdisktime;
> > +		}
> > +	} else
> > +		vdisktime = st->min_vdisktime;
> 
> Hi Vivek,
> 
> Should we set vdisktime a little small than st->min_vdisktime to ensure putting
> this entity at the left-most position when add_front is set?
> 

Hi Gui,

Good point. Actually instead of giving a little smaller time, I have
modified __enqueue_io_entity() to take additional argument to put the
entity at the front of the rb-tree. Please find attached the patch.

Thanks
Vivek

o There can be multiple entities with same vdisktime that is equal to
  min_vdisktime. If one queue decids to preempt the current queue and even
  if we assign the min_vdisktime to preempting queue, it will not be dispatched
  first as there are other entities with same vdisktime. This patch adds
  an option to __enqueue_entity() telling it that new entity being queued
  is to be added at front hence in case of equal queues, instead of going
  right of the tree, it goes to the left of the tree.

o Also update the min_vdisktime() after selecting a new queue. Currently
  min_vdisktime() is updated only upon queue expiry. But it might hapeen
  that after queue expiry (put_prev_entity()), queue got deleted because
  it did not have any request. In that case min_vdisktime and vdisktime
  of leftmost entity might differ. Hence make sure to update min_vdisktime
  when an entity is selected for dispatch. 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux13/block/elevator-fq.c
===================================================================
--- linux13.orig/block/elevator-fq.c	2009-08-16 14:43:26.000000000 -0400
+++ linux13/block/elevator-fq.c	2009-08-17 16:16:06.000000000 -0400
@@ -129,7 +129,7 @@ static inline u64 min_vdisktime(u64 min_
 
 static void update_min_vdisktime(struct io_service_tree *st)
 {
-	u64 vdisktime;
+	u64 vdisktime = st->min_vdisktime;
 
 	if (st->active_entity)
 		vdisktime = st->active_entity->vdisktime;
@@ -486,7 +486,8 @@ static void dequeue_io_entity(struct io_
 }
 
 static void
-__enqueue_io_entity(struct io_service_tree *st, struct io_entity *entity)
+__enqueue_io_entity(struct io_service_tree *st, struct io_entity *entity,
+			int add_front)
 {
 	struct rb_node **node = &st->active.rb_node;
 	struct rb_node *parent = NULL;
@@ -498,7 +499,8 @@ __enqueue_io_entity(struct io_service_tr
 		parent = *node;
 		entry = rb_entry(parent, struct io_entity, rb_node);
 
-		if (key < entity_key(st, entry)) {
+		if (key < entity_key(st, entry) ||
+			(add_front && (key == entity_key(st, entry)))) {
 			node = &parent->rb_left;
 		} else {
 			node = &parent->rb_right;
@@ -528,7 +530,7 @@ static void enqueue_io_entity(struct io_
 	sd->nr_active++;
 	entity->on_st = 1;
 	place_entity(st, entity, 0);
-	__enqueue_io_entity(st, entity);
+	__enqueue_io_entity(st, entity, 0);
 	debug_update_stats_enqueue(entity);
 }
 
@@ -559,6 +561,7 @@ static struct io_entity *lookup_next_io_
 			__dequeue_io_entity(st, entity);
 			st->active_entity = entity;
 			sd->active_entity = entity;
+			update_min_vdisktime(entity->st);
 			break;
 		}
 	}
@@ -587,7 +590,7 @@ static void requeue_io_entity(struct io_
 	if (next_entity && next_entity != entity) {
 		__dequeue_io_entity(st, entity);
 		place_entity(st, entity, 1);
-		__enqueue_io_entity(st, entity);
+		__enqueue_io_entity(st, entity, 1);
 	}
 }
 
@@ -610,7 +613,7 @@ static void put_prev_io_entity(struct io
 		io_entity_update_prio(entity);
 		enqueue_io_entity(entity);
 	} else
-		__enqueue_io_entity(st, entity);
+		__enqueue_io_entity(st, entity, 0);
 }
 
 /* Put curr ioq back into rb tree. */
