From: David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH v2] dm table: do not allow queue limits that
 will exceed hardware limits
Date: Mon, 17 Sep 2012 15:44:29 -0400 (EDT)
Message-ID: <213748621.1049831.1347911069189.JavaMail.root@redhat.com>
References: <20120914204133.GA376@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120914204133.GA376@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

----- Original Message -----
> v2: adjust the patch header to be more succinct
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index f6979ad..9b931b4 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1264,6 +1264,15 @@ combine_limits:
>  			       (unsigned long long) ti->len);
>  	}
>  
> +	/*
> +	 * If a table doesn't have any component devices (e.g. multipath
> +	 * loses all paths) don't allow the queue_limits to be left at
> +	 * their maximum (as established by blk_set_stacking_limits() so
> +	 * limits could be inherited from component devices).
> +	 */
> +	if (limits->max_sectors == UINT_MAX)
> +		blk_set_default_limits(limits);
> +
>  	return validate_hardware_logical_block_alignment(table, limits);
>  }
>  
> --
> 1.7.1
> 
> 

Instead of setting to defaults, how about maintaining previous limits?
The initial queue setup sets defaults when a queue is first configured,
and this maintains known, working limits if all paths are temporarly
lost.  For example, I have a test setup with a lower than normal max
segment list.  It can fail a test with the previous patch as the
default limits exceed the hardware limits. But this setup will work if
we leave queue limits unchanged in the special case of there being no
target devices.

David Jeffery

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e09b6f..89ec9ee 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2425,6 +2425,15 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
+	/*
+	 * If a table doesn't have any component devices (e.g. multipath
+	 * loses all paths) don't allow the queue_limits to be left at
+	 * their maximum (as established by blk_set_stacking_limits()).
+	 * Instead, maintain the previous limits.
+	 */
+	if (limits.max_sectors == UINT_MAX)
+		limits = md->queue->limits;
+
 	map = __bind(md, table, &limits);
 
 out:
