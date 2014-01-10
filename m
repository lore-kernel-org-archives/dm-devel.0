From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: wait until kobject is destroyed
Date: Fri, 10 Jan 2014 16:03:15 -0500
Message-ID: <20140110210314.GA12660@redhat.com>
References: <alpine.LRH.2.02.1401092050190.31354@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401092050190.31354@file01.intranet.prod.int.rdu2.redhat.com>
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

On Thu, Jan 09 2014 at  8:53pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> Here I'm sending the updated kobject patch.
> 
> Changes:
> 	The file was renamed to dm-builtin.c
> 	A comment with explanation of the race condition added.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> There may be other parts of the kernel taking reference to the dm kobject.
> We must wait until they drop the references before deallocating the md
> structure.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

This header could use some work considering the previous patch is
already staged in linux-dm.git's 'for-next' -- so this patch will build
on that.  Would be nice to see some commentary about introducing a
dm-builtin to avoid concerns about dm_kobject_release crash after dm-mod
is unloaded.  Also, touch on the role/need of struct dm_kobject_holder?

> Index: linux-3.13-rc7/drivers/md/dm-sysfs.c
> ===================================================================
> --- linux-3.13-rc7.orig/drivers/md/dm-sysfs.c	2014-01-09 20:50:18.000000000 +0100
> +++ linux-3.13-rc7/drivers/md/dm-sysfs.c	2014-01-09 20:50:38.000000000 +0100
> @@ -86,6 +86,7 @@ static const struct sysfs_ops dm_sysfs_o
>  static struct kobj_type dm_ktype = {
>  	.sysfs_ops	= &dm_sysfs_ops,
>  	.default_attrs	= dm_attrs,
> +	.release	= dm_kobject_release,
>  };
>  
>  /*
> @@ -104,5 +105,7 @@ int dm_sysfs_init(struct mapped_device *
>   */
>  void dm_sysfs_exit(struct mapped_device *md)
>  {
> -	kobject_put(dm_kobject(md));
> +	struct kobject *kobj = dm_kobject(md);
> +	kobject_put(kobj);
> +	wait_for_completion(dm_get_completion_from_kobject(kobj));
>  }
> Index: linux-3.13-rc7/drivers/md/dm.c
> ===================================================================
> --- linux-3.13-rc7.orig/drivers/md/dm.c	2014-01-09 20:50:18.000000000 +0100
> +++ linux-3.13-rc7/drivers/md/dm.c	2014-01-09 20:50:38.000000000 +0100
> @@ -200,8 +200,8 @@ struct mapped_device {
>  	/* forced geometry settings */
>  	struct hd_geometry geometry;
>  
> -	/* sysfs handle */
> -	struct kobject kobj;
> +	/* kobject and completion */
> +	struct dm_kobject_holder h;
>  
>  	/* zero-length flush that will be cloned and submitted to targets */
>  	struct bio flush_bio;

Could you rename 'h' to 'kobj_holder'?

Also, this patch needs to be rebased ontop of linux-dm.git's 'for-next'
branch.

Mike
