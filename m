From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm-bufio: fix deadlock with loop device
Date: Wed, 10 Jul 2019 13:48:01 -0400
Message-ID: <20190710174801.GA20281@redhat.com>
References: <20190710001719.2504-1-junxiao.bi@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190710001719.2504-1-junxiao.bi@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: honglei.wang@oracle.com, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 09 2019 at  8:17pm -0400,
Junxiao Bi <junxiao.bi@oracle.com> wrote:

> When thin-volume was built on loop device, if available memory is low,
> the following deadlock can be triggered.
> 
> One process P1 was allocating memory with GFP_FS flag, direct alloc fail,
> memory reclaim invoked memory shrinker in dm_bufio, dm_bufio_shrink_scan()
> run, mutex dm_bufio_client->lock was acquired, then P1 wait for dm_buffer
> io done in __try_evict_buffer->()__try_evict_buffer().
> 
> But this io may never done as it was issued to the underlying loop device
> who forward it using fs direct-io, there some memory allocation were using
> GFP_FS(like do_blockdev_direct_IO()), if direct alloc fail, memory reclaim
> will invoke memory shrinker in dm_bufio, where dm_bufio_shrink_scan()
> will be invoked, since the mutex was already hold by P1, the loop thread
> will hung, io will never done. ABBA deadlock.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
> Changes in v2:
>   - refine the commit log
> 
>  drivers/md/dm-bufio.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 2a48ea3f1b30..b6b5acc92ca2 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -1599,9 +1599,7 @@ dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  	unsigned long freed;
>  
>  	c = container_of(shrink, struct dm_bufio_client, shrinker);
> -	if (sc->gfp_mask & __GFP_FS)
> -		dm_bufio_lock(c);
> -	else if (!dm_bufio_trylock(c))
> +	if (!dm_bufio_trylock(c))
>  		return SHRINK_STOP;
>  
>  	freed  = __scan(c, sc->nr_to_scan, sc->gfp_mask);
> -- 
> 2.17.1
> 

This needs more careful review and understanding.

I'll commit to getting that done (hopefully with Mikulas' assistance)
during the 5.3-rcX cycle.  But I'm not ready to stage this change yet.

Revisiting dm-bufio on loop is needed.  Commit 9d28eb12447ee ("dm bufio:
change __GFP_IO to __GFP_FS in shrinker callbacks") was meant to address
deadlocks reported whern running on loop.  And __try_evict_buffer() has
a check for GFP_NOFS ("!(gfp & __GFP_FS"); but that is only relevant to
__scan() callers and dm_bufio_shrink_scan() is looking to take the lock
before __scan() is called.  So it does seem like we have issues in the
bufio code in general.  Needs a proper audit though.

Mike
