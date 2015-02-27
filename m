From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-snapshot: suspend merging snapshot
 when doing exception handover
Date: Fri, 27 Feb 2015 15:02:57 -0500
Message-ID: <20150227200257.GD6945@redhat.com>
References: <alpine.LRH.2.02.1502261140380.13050@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502261140380.13050@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 26 2015 at 11:41am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> There was a bug when that resulted in a crash when there were pending
> exceptions and snapshot exception store handover was performed at the
> same time - and there was a patch that fixed it.
> 
> However, a similar problem exists in snapshot merging. When snapshot
> merging is in progress, we use the target "snapshot-merge" instead of
> "snapshot-origin". Consequently, during exception store handover, we must
> find the snapshot-merge target and suspend it's associated md.
> 
> To avoid lockdep warnings, the target must be suspended and resumed
> without holding _origins_lock.
> 
> This patch introduces a function dm_hold that grabs a reference on
> mapped_device, but unlike dm_get, it doesn't crash if the devices has the
> flag DMF_FREEING, it returns and error in this case.
> 
> In snapshot_resume we grab the reference to the origin device using
> dm_hold while holding _origins_lock (_origins_lock guarantees that the
> device won't disappear). Then we release _origins_lock, suspend the
> device and grab _origins_lock again.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Staged for 4.0 here (again bumped target version and tweaked header):
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-4.0&id=09ee96b21456883e108c3b00597bb37ec512151b
 
> Index: linux-2.6-debug/drivers/md/dm.c
> ===================================================================
> --- linux-2.6-debug.orig/drivers/md/dm.c
> +++ linux-2.6-debug/drivers/md/dm.c
> @@ -2526,10 +2539,16 @@ static void __dm_destroy(struct mapped_d
>  	set_bit(DMF_FREEING, &md->flags);
>  	spin_unlock(&_minor_lock);
>  
> +	/*
> +	 * Take suspend_lock so that presuspend and postsuspend methods
> +	 * do not race with internal suspend.
> +	 */
> +	mutex_lock(&md->suspend_lock);
>  	if (!dm_suspended_md(md)) {
>  		dm_table_presuspend_targets(map);
>  		dm_table_postsuspend_targets(map);
>  	}
> +	mutex_unlock(&md->suspend_lock);
>  
>  	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
>  	dm_put_live_table(md, srcu_idx);

I split this chunk out to a new commit for 4.0 here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-4.0&id=ab7c7bb6f4ab95dbca96fcfc4463cd69843e3e24
