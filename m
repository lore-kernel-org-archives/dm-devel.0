From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 13/19] fs: Allow superblock owner to access
 do_remount_sb()
Date: Fri, 4 Dec 2015 13:02:57 -0600
Message-ID: <20151204190257.GD3624@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-14-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449070821-73820-14-git-send-email-seth.forshee@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

Quoting Seth Forshee (seth.forshee@canonical.com):
> Superblock level remounts are currently restricted to global
> CAP_SYS_ADMIN, as is the path for changing the root mount to
> read only on umount. Loosen both of these permission checks to
> also allow CAP_SYS_ADMIN in any namespace which is privileged
> towards the userns which originally mounted the filesystem.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

>  fs/namespace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 18fc58760aec..b00a765895e7 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1510,7 +1510,7 @@ static int do_umount(struct mount *mnt, int flags)
>  		 * Special case for "unmounting" root ...
>  		 * we just try to remount it readonly.
>  		 */
> -		if (!capable(CAP_SYS_ADMIN))
> +		if (!ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
>  			return -EPERM;
>  		down_write(&sb->s_umount);
>  		if (!(sb->s_flags & MS_RDONLY))
> @@ -2199,7 +2199,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
>  	down_write(&sb->s_umount);
>  	if (flags & MS_BIND)
>  		err = change_mount_flags(path->mnt, flags);
> -	else if (!capable(CAP_SYS_ADMIN))
> +	else if (!ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
>  		err = -EPERM;
>  	else
>  		err = do_remount_sb(sb, flags, data, 0);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
