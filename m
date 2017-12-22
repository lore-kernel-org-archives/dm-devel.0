From: Coly Li <i@coly.li>
Subject: Re: [PATCH 01/11] block_dev: Support checking inode permissions in
 lookup_bdev()
Date: Sat, 23 Dec 2017 02:59:55 +0800
Message-ID: <17fbec10-68b1-2d2b-d417-2cdfee22b0fa@coly.li>
References: <cover.1512741134.git.dongsu@kinvolk.io>
 <ef5e609602df6d7e2b4aa07b92600f04b6851902.1512041070.git.dongsu@kinvolk.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <ef5e609602df6d7e2b4aa07b92600f04b6851902.1512041070.git.dongsu@kinvolk.io>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Dongsu Park <dongsu@kinvolk.io>, linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org, Alban Crequy <alban@kinvolk.io>, "Eric W . Biederman" <ebiederm@xmission.com>, Miklos Szeredi <mszeredi@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Sargun Dhillon <sargun@sargun.me>, dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Serge Hallyn <serge@hallyn.com>
List-Id: dm-devel.ids

On 22/12/2017 10:32 PM, Dongsu Park wrote:
> From: Seth Forshee <seth.forshee@canonical.com>
> 
> When looking up a block device by path no permission check is
> done to verify that the user has access to the block device inode
> at the specified path. In some cases it may be necessary to
> check permissions towards the inode, such as allowing
> unprivileged users to mount block devices in user namespaces.
> 
> Add an argument to lookup_bdev() to optionally perform this
> permission check. A value of 0 skips the permission check and
> behaves the same as before. A non-zero value specifies the mask
> of access rights required towards the inode at the specified
> path. The check is always skipped if the user has CAP_SYS_ADMIN.
> 
> All callers of lookup_bdev() currently pass a mask of 0, so this
> patch results in no functional change. Subsequent patches will
> add permission checks where appropriate.
> 
> Patch v4 is available: https://patchwork.kernel.org/patch/8943601/
> 
> Cc: dm-devel@redhat.com
> Cc: linux-bcache@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Jan Kara <jack@suse.com>
> Cc: Serge Hallyn <serge@hallyn.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Signed-off-by: Dongsu Park <dongsu@kinvolk.io>

Hi Dongsu,

Could you please use a macro like NO_PERMISSION_CHECK to replace hard
coded 0 ? At least for me, I don't need to check what does 0 mean in the
new lookup_bdev().

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c |  2 +-
>  drivers/md/dm-table.c     |  2 +-
>  drivers/mtd/mtdsuper.c    |  2 +-
>  fs/block_dev.c            | 13 ++++++++++---
>  fs/quota/quota.c          |  2 +-
>  include/linux/fs.h        |  2 +-
>  6 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index b4d28928..acc9d56c 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1967,7 +1967,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  				  sb);
>  	if (IS_ERR(bdev)) {
>  		if (bdev == ERR_PTR(-EBUSY)) {
> -			bdev = lookup_bdev(strim(path));
> +			bdev = lookup_bdev(strim(path), 0);
>  			mutex_lock(&bch_register_lock);
>  			if (!IS_ERR(bdev) && bch_is_open(bdev))
>  				err = "device already registered";
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 88130b5d..bca5eaf4 100644
[snip]


-- 
Coly Li
