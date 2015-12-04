From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 02/19] block_dev: Check permissions towards block device
 inode when mounting
Date: Fri, 4 Dec 2015 10:28:07 -0600
Message-ID: <20151204162807.GB1722@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-3-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449070821-73820-3-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Wed, Dec 02, 2015 at 09:40:02AM -0600, Seth Forshee wrote:
> Unprivileged users should not be able to mount block devices when
> they lack sufficient privileges towards the block device inode.
> Update blkdev_get_by_path() to validate that the user has the
> required access to the inode at the specified path. The check
> will be skipped for CAP_SYS_ADMIN, so privileged mounts will
> continue working as before.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/block_dev.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 3ebbde85d898..4fdb6ab59816 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1424,9 +1424,14 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
>  					void *holder)
>  {
>  	struct block_device *bdev;
> +	int perm = 0;
>  	int err;
>  
> -	bdev = lookup_bdev(path, 0);
> +	if (mode & FMODE_READ)
> +		perm |= MAY_READ;
> +	if (mode & FMODE_WRITE)
> +		perm |= MAY_WRITE;
> +	bdev = lookup_bdev(path, perm);
>  	if (IS_ERR(bdev))
>  		return bdev;
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
