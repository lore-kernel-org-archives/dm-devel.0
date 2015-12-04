From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 08/19] cred: Reject inodes with invalid ids in
 set_create_file_as()
Date: Fri, 4 Dec 2015 10:49:19 -0600
Message-ID: <20151204164919.GD1722@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-9-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449070821-73820-9-git-send-email-seth.forshee@canonical.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Wed, Dec 02, 2015 at 09:40:08AM -0600, Seth Forshee wrote:
> Using INVALID_[UG]ID for the LSM file creation context doesn't
> make sense, so return an error if the inode passed to
> set_create_file_as() has an invalid id.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/cred.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 71179a09c1d6..ff8606f77d90 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -689,6 +689,8 @@ EXPORT_SYMBOL(set_security_override_from_ctx);
>   */
>  int set_create_files_as(struct cred *new, struct inode *inode)
>  {
> +	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
> +		return -EINVAL;
>  	new->fsuid = inode->i_uid;
>  	new->fsgid = inode->i_gid;
>  	return security_kernel_create_files_as(new, inode);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
