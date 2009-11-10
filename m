From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3] dm snapshot: allow live exception store
 handover between tables
Date: Mon, 9 Nov 2009 22:22:25 -0500
Message-ID: <20091110032225.GA16580@redhat.com>
References: <1257818350-9872-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1257818350-9872-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 09 2009 at  8:59pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Index: linux-2.6/drivers/md/dm-snap.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-snap.c
> +++ linux-2.6/drivers/md/dm-snap.c
> @@ -659,7 +796,10 @@ static int snapshot_ctr(struct dm_target
>  	s->active = 0;
>  	s->suspended = 0;
>  	atomic_set(&s->pending_exceptions_count, 0);
> +	s->is_handover_destination = 0;
> +	s->handover_snap = NULL;
>  	init_rwsem(&s->lock);
> +	INIT_LIST_HEAD(&s->list);

The above s->list initialization was needed to avoid a GPF in
unregister_snapshot() that would occur if handover was skipped by
calling __unlink_snapshots_for_handover().

Skipping handover also implies skipping register_snapshot().  Skipping
register_snapshot() opens us up to new modes of failure in dm-snap.c's
snapshot cleanup paths.  One that I missed is the following:

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5e53ee2..1737917 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -386,7 +386,7 @@ static void unregister_snapshot(struct dm_snapshot
*s)
	o = __lookup_origin(s->origin->bdev);
 
	list_del(&s->list);
-	if (list_empty(&o->snapshots)) {
+	if (o && list_empty(&o->snapshots)) {
		list_del(&o->hash_list);
		kfree(o);
	}
