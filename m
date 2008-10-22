From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Wed, 22 Oct 2008 12:39:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0810221238030.3985@hs20-bc2-1.build.redhat.com>
References: <48FC23DE.5040000@poczta.onet.pl> <48FC4498.5070706@redhat.com>
	<48FD7911.1000705@poczta.onet.pl>
	<Pine.LNX.4.64.0810210953560.12983@hs20-bc2-1.build.redhat.com>
	<48FDFF53.5080007@poczta.onet.pl>
	<Pine.LNX.4.64.0810211319330.13319@hs20-bc2-1.build.redhat.com>
	<48FE22A0.30005@poczta.onet.pl>
	<Pine.LNX.4.64.0810211736230.24588@hs20-bc2-1.build.redhat.com>
	<48FF2C91.4080401@poczta.onet.pl>
	<Pine.LNX.4.64.0810221140440.28028@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810221140440.28028@hs20-bc2-1.build.redhat.com>
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

Oh, sorry for this "struct struct" in the patch in free_pending_exception, 
replace it just with one "struct". I forgot to refresh the patch before 
sending it.

Mikulas

On Wed, 22 Oct 2008, Mikulas Patocka wrote:

> On Wed, 22 Oct 2008, aluno3@poczta.onet.pl wrote:
> 
> > Hi
> > 
> > I used your patch and I ran test the same workload. After a few hours
> > test, everything is OK. Is it possible? Test is still running.When I get
> > something wrong from kernel I write to You again.
> 
> Hi
> 
> That's good that it works. So try this. Keep the first patch (it is this 
> one --- 
> http://people.redhat.com/mpatocka/patches/kernel/2.6.27/dm-snapshot-fix-primary-pe-race.patch 
> --- I think Milan already sent it to you and you have it applied). Undo 
> the second patch (that one that hides deallocation with /* */ ). And apply 
> this. Run the same test.
> 
> Mikulas
> 
> ---
>  drivers/md/dm-snap.c |   10 +++++++++-
>  drivers/md/dm-snap.h |    2 ++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.27-clean/drivers/md/dm-snap.c
> ===================================================================
> --- linux-2.6.27-clean.orig/drivers/md/dm-snap.c	2008-10-22 15:41:24.000000000 +0200
> +++ linux-2.6.27-clean/drivers/md/dm-snap.c	2008-10-22 15:51:33.000000000 +0200
> @@ -368,6 +368,7 @@ static struct dm_snap_pending_exception 
>  	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
>  							     GFP_NOIO);
>  
> +	atomic_inc(&s->n_pending_exceptions);
>  	pe->snap = s;
>  
>  	return pe;
> @@ -375,7 +376,10 @@ static struct dm_snap_pending_exception 
>  
>  static void free_pending_exception(struct dm_snap_pending_exception *pe)
>  {
> -	mempool_free(pe, pe->snap->pending_pool);
> +	struct struct dm_snapshot *s = pe->snap;
> +	mempool_free(pe, s->pending_pool);
> +	smp_mb__before_atomic_dec();
> +	atomic_dec(&s->n_pending_exceptions);
>  }
>  
>  static void insert_completed_exception(struct dm_snapshot *s,
> @@ -601,6 +605,7 @@ static int snapshot_ctr(struct dm_target
>  	s->valid = 1;
>  	s->active = 0;
>  	s->last_percent = 0;
> +	atomic_set(&s->n_pending_exceptions, 0);
>  	init_rwsem(&s->lock);
>  	spin_lock_init(&s->pe_lock);
>  	s->ti = ti;
> @@ -727,6 +732,9 @@ static void snapshot_dtr(struct dm_targe
>  	/* After this returns there can be no new kcopyd jobs. */
>  	unregister_snapshot(s);
>  
> +	while (atomic_read(&s->n_pending_exceptions))
> +		yield();
> +
>  #ifdef CONFIG_DM_DEBUG
>  	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
>  		BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
> Index: linux-2.6.27-clean/drivers/md/dm-snap.h
> ===================================================================
> --- linux-2.6.27-clean.orig/drivers/md/dm-snap.h	2008-10-22 15:45:08.000000000 +0200
> +++ linux-2.6.27-clean/drivers/md/dm-snap.h	2008-10-22 15:46:49.000000000 +0200
> @@ -163,6 +163,8 @@ struct dm_snapshot {
>  
>  	mempool_t *pending_pool;
>  
> +	atomic_t n_pending_exceptions;
> +
>  	struct exception_table pending;
>  	struct exception_table complete;
>  
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
