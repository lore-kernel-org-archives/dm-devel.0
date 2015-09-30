From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] fs: Verify access of user towards block device file
 when mounting
Date: Wed, 30 Sep 2015 19:42:15 -0400
Message-ID: <20150930234215.GA24127@redhat.com>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
 <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 30 2015 at  4:15pm -0400,
Seth Forshee <seth.forshee@canonical.com> wrote:

> When mounting a filesystem on a block device there is currently
> no verification that the user has appropriate access to the
> device file passed to mount. This has not been an issue so far
> since the user in question has always been root, but this must
> be changed before allowing unprivileged users to mount in user
> namespaces.
> 
> To fix this, add an argument to lookup_bdev() to specify the
> required permissions. If the mask of permissions is zero, or
> if the user has CAP_SYS_ADMIN, the permission check is skipped,
> otherwise the lookup fails if the user does not have the
> specified access rights for the inode at the supplied path.
> 
> Callers associated with mounting are updated to pass permission
> masks to lookup_bdev() so that these mounts will fail for an
> unprivileged user who lacks permissions for the block device
> inode. All other callers pass 0 to maintain their current
> behaviors.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/md/bcache/super.c |  2 +-
>  drivers/md/dm-table.c     |  2 +-
>  drivers/mtd/mtdsuper.c    |  6 +++++-
>  fs/block_dev.c            | 18 +++++++++++++++---
>  fs/quota/quota.c          |  2 +-
>  include/linux/fs.h        |  2 +-
>  6 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e76ed003769e..35bb3ea4cbe2 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -380,7 +380,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  	BUG_ON(!t);
>  
>  	/* convert the path to a device */
> -	bdev = lookup_bdev(path);
> +	bdev = lookup_bdev(path, 0);
>  	if (IS_ERR(bdev)) {
>  		dev = name_to_dev_t(path);
>  		if (!dev)

Given dm_get_device() is passed @mode why not have it do something like
you did in blkdev_get_by_path()? e.g.:

> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 26cee058dc02..54d94cd64577 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1394,9 +1394,14 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
>  					void *holder)
>  {
>  	struct block_device *bdev;
> +	int perm = 0;
>  	int err;
>  
> -	bdev = lookup_bdev(path);
> +	if (mode & FMODE_READ)
> +		perm |= MAY_READ;
> +	if (mode & FMODE_WRITE)
> +		perm |= MAY_WRITE;
> +	bdev = lookup_bdev(path, perm);
>  	if (IS_ERR(bdev))
>  		return bdev;
>  
