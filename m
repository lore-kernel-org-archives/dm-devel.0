From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RESEND v2 17/18] fuse: Restrict allow_other to the
 superblock's namespace or a descendant
Date: Wed, 9 Mar 2016 12:40:51 +0100
Message-ID: <20160309114051.GG8655@tucsk>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
 <1451930639-94331-18-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451930639-94331-18-git-send-email-seth.forshee@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Mon, Jan 04, 2016 at 12:03:56PM -0600, Seth Forshee wrote:
> Unprivileged users are normally restricted from mounting with the
> allow_other option by system policy, but this could be bypassed
> for a mount done with user namespace root permissions. In such
> cases allow_other should not allow users outside the userns
> to access the mount as doing so would give the unprivileged user
> the ability to manipulate processes it would otherwise be unable
> to manipulate. Restrict allow_other to apply to users in the same
> userns used at mount or a descendant of that namespace.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

> ---
>  fs/fuse/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 8fd9fe4dcd43..24e4cdb554f1 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1015,7 +1015,7 @@ int fuse_allow_current_process(struct fuse_conn *fc)
>  	const struct cred *cred;
>  
>  	if (fc->flags & FUSE_ALLOW_OTHER)
> -		return 1;
> +		return current_in_userns(fc->user_ns);
>  
>  	cred = current_cred();
>  	if (uid_eq(cred->euid, fc->user_id) &&
> -- 
> 1.9.1
> 
