From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v2 5/7] selinux: Add support for unprivileged mounts from
 user namespaces
Date: Tue, 13 Oct 2015 16:27:09 -0400
Message-ID: <561D691D.9080209@tycho.nsa.gov>
References: <1444755861-54997-1-git-send-email-seth.forshee@canonical.com>
 <1444755861-54997-6-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1444755861-54997-6-git-send-email-seth.forshee@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>
Cc: linux-bcache@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mtd@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On 10/13/2015 01:04 PM, Seth Forshee wrote:
> Security labels from unprivileged mounts in user namespaces must
> be ignored. Force superblocks from user namespaces whose labeling
> behavior is to use xattrs to use mountpoint labeling instead.
> For the mountpoint label, default to converting the current task
> context into a form suitable for file objects, but also allow the
> policy writer to specify a different label through policy
> transition rules.
>
> Pieced together from code snippets provided by Stephen Smalley.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

> ---
>   security/selinux/hooks.c | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index de05207eb665..09be1dc21e58 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -756,6 +756,28 @@ static int selinux_set_mnt_opts(struct super_block *sb,
>   			goto out;
>   		}
>   	}
> +
> +	/*
> +	 * If this is a user namespace mount, no contexts are allowed
> +	 * on the command line and security labels must be ignored.
> +	 */
> +	if (sb->s_user_ns != &init_user_ns) {
> +		if (context_sid || fscontext_sid || rootcontext_sid ||
> +		    defcontext_sid) {
> +			rc = -EACCES;
> +			goto out;
> +		}
> +		if (sbsec->behavior == SECURITY_FS_USE_XATTR) {
> +			sbsec->behavior = SECURITY_FS_USE_MNTPOINT;
> +			rc = security_transition_sid(current_sid(), current_sid(),
> +						     SECCLASS_FILE, NULL,
> +						     &sbsec->mntpoint_sid);
> +			if (rc)
> +				goto out;
> +		}
> +		goto out_set_opts;
> +	}
> +
>   	/* sets the context of the superblock for the fs being mounted. */
>   	if (fscontext_sid) {
>   		rc = may_context_mount_sb_relabel(fscontext_sid, sbsec, cred);
> @@ -824,6 +846,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
>   		sbsec->def_sid = defcontext_sid;
>   	}
>
> +out_set_opts:
>   	rc = sb_finish_set_opts(sb);
>   out:
>   	mutex_unlock(&sbsec->lock);
>

