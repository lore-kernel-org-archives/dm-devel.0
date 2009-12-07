From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: snapshot merging: change timeout to a sequence count
Date: Mon, 7 Dec 2009 11:04:10 -0500
Message-ID: <20091207160410.GE8917@redhat.com>
References: <Pine.LNX.4.64.0912070816120.15633@hs20-bc2-1.build.redhat.com>
	<20091207155258.GD8917@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091207155258.GD8917@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 07 2009 at 10:52am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Dec 07 2009 at  8:19am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > This changes the timeout to a sequence count. And adds a comment.
> > 
> > Mikulas
> > 
> > ---
> > 
> > Avoit the timeout.
> > 
> > Use a sequence count to resolve the race. The count increases each time
> > an exception reallocation finishes. Use wait_event() to wait until the count
> > changes.
> > 
> > The chunk-reallocation logic is explained in the comment in the patch.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Here is an updated patch that falls at the end of my snapshot-merge
> series here:
> http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.33/
> 
> ---
> 
> dm snapshot: change the snapshot reallocation timeout to a sequence count
> 
> Use a sequence count to resolve the race between I/O to chunks that are
> about to be merged.  The count increases each time an exception
> reallocation finishes.  Use wait_event() to wait until the count
> changes.
> 
> The chunk-reallocation logic is now explained in snapshot_merge_process()
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/dm-snap.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
> 
> Index: linux-rhel6/drivers/md/dm-snap.c
> ===================================================================
> --- linux-rhel6.orig/drivers/md/dm-snap.c
> +++ linux-rhel6/drivers/md/dm-snap.c
> @@ -271,6 +271,8 @@ static struct list_head *_origins;
>  static struct rw_semaphore _origins_lock;
>  
>  static DECLARE_WAIT_QUEUE_HEAD(_pending_exception_done);
> +static DEFINE_SPINLOCK(_pending_exception_done_spinlock);
> +static u64 _pending_exception_done_count = 0;

BTW, checkpatch issues the following error:

ERROR: do not initialise statics to 0 or NULL
#24: FILE: drivers/md/dm-snap.c:275:
+static u64 _pending_exception_done_count = 0;
