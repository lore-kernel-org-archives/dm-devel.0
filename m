From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RESEND v2 18/18] fuse: Allow user namespace mounts
Date: Wed, 9 Mar 2016 14:08:55 +0100
Message-ID: <20160309130855.GH8655@tucsk>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
 <1451930639-94331-19-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451930639-94331-19-git-send-email-seth.forshee@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Mon, Jan 04, 2016 at 12:03:57PM -0600, Seth Forshee wrote:
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

> ---
>  fs/fuse/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index b7bdfdac3521..2fd338c199ce 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1201,7 +1201,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
>  static struct file_system_type fuse_fs_type = {
>  	.owner		= THIS_MODULE,
>  	.name		= "fuse",
> -	.fs_flags	= FS_HAS_SUBTYPE,
> +	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
>  	.mount		= fuse_mount,
>  	.kill_sb	= fuse_kill_sb_anon,
>  };
> @@ -1233,7 +1233,7 @@ static struct file_system_type fuseblk_fs_type = {
>  	.name		= "fuseblk",
>  	.mount		= fuse_mount_blk,
>  	.kill_sb	= fuse_kill_sb_blk,
> -	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
> +	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
>  };
>  MODULE_ALIAS_FS("fuseblk");
>  
> -- 
> 1.9.1
> 
