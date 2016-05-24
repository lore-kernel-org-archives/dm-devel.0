From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v4 10/21] fs: Check for invalid i_uid in may_follow_link()
Date: Tue, 24 May 2016 16:55:26 +0100
Message-ID: <20160524155526.GB2830@dztty.fritz.box>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
 <1461699396-33000-11-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461699396-33000-11-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 26, 2016 at 02:36:23PM -0500, Seth Forshee wrote:
> Filesystem uids which don't map into a user namespace may result
> in inode->i_uid being INVALID_UID. A symlink and its parent
> could have different owners in the filesystem can both get
> mapped to INVALID_UID, which may result in following a symlink
> when this would not have otherwise been permitted when protected
> symlinks are enabled.
> 
> Add a new helper function, uid_valid_eq(), and use this to
> validate that the ids in may_follow_link() are both equal and
> valid. Also add an equivalent helper for gids, which is
> currently unused.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Reviewed-by: Djalal Harouni <tixxdz@opendz.org>


> ---
>  fs/namei.c             |  2 +-
>  include/linux/uidgid.h | 10 ++++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index a29094c6f4a1..6fe8b0d8ca90 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -915,7 +915,7 @@ static inline int may_follow_link(struct nameidata *nd)
>  		return 0;
>  
>  	/* Allowed if parent directory and link owner match. */
> -	if (uid_eq(parent->i_uid, inode->i_uid))
> +	if (uid_valid_eq(parent->i_uid, inode->i_uid))
>  		return 0;
>  
>  	if (nd->flags & LOOKUP_RCU)
> diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
> index 03835522dfcb..e09529fe2668 100644
> --- a/include/linux/uidgid.h
> +++ b/include/linux/uidgid.h
> @@ -117,6 +117,16 @@ static inline bool gid_valid(kgid_t gid)
>  	return __kgid_val(gid) != (gid_t) -1;
>  }
>  
> +static inline bool uid_valid_eq(kuid_t left, kuid_t right)
> +{
> +	return uid_eq(left, right) && uid_valid(left);
> +}
> +
> +static inline bool gid_valid_eq(kgid_t left, kgid_t right)
> +{
> +	return gid_eq(left, right) && gid_valid(left);
> +}
> +
>  #ifdef CONFIG_USER_NS
>  
>  extern kuid_t make_kuid(struct user_namespace *from, uid_t uid);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Djalal Harouni
http://opendz.org
