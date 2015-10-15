From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2 7/7] Smack: Handle labels consistently in untrusted
 mounts
Date: Wed, 14 Oct 2015 22:46:47 -0700
Message-ID: <561F3DC7.4070901@schaufler-ca.com>
References: <1444755861-54997-1-git-send-email-seth.forshee@canonical.com>
 <1444755861-54997-8-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444755861-54997-8-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: dm-devel.ids

On 10/13/2015 10:04 AM, Seth Forshee wrote:
> The SMACK64, SMACK64EXEC, and SMACK64MMAP labels are all handled
> differently in untrusted mounts. This is confusing and
> potentically problematic. Change this to handle them all the same
> way that SMACK64 is currently handled; that is, read the label
> from disk and check it at use time. For SMACK64 and SMACK64MMAP
> access is denied if the label does not match smk_root. To be
> consistent with suid, a SMACK64EXEC label which does not match
> smk_root will still allow execution of the file but will not run
> with the label supplied in the xattr.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Aside from the one comment below (which I can be talked out of)
this looks fine.

> ---
>  security/smack/smack_lsm.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 621200f86b56..bee0b2652bf4 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -891,6 +891,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  	struct inode *inode = file_inode(bprm->file);
>  	struct task_smack *bsp = bprm->cred->security;
>  	struct inode_smack *isp;
> +	struct superblock_smack *sbsp;
>  	int rc;
>  
>  	if (bprm->cred_prepared)
> @@ -900,6 +901,10 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
>  		return 0;
>  
> +	sbsp = inode->i_sb->s_security;
> +	if (sbsp->smk_flags & SMK_SB_UNTRUSTED && isp->smk_task != sbsp->smk_root)

Call me old fashioned, but how about

	if ((sbsp->smk_flags & SMK_SB_UNTRUSTED) && isp->smk_task != sbsp->smk_root)

naked '&'s give me the willies. 

> +		return 0;
> +
>  	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
>  		struct task_struct *tracer;
>  		rc = 0;
> @@ -1703,6 +1708,7 @@ static int smack_mmap_file(struct file *file,
>  	struct task_smack *tsp;
>  	struct smack_known *okp;
>  	struct inode_smack *isp;
> +	struct superblock_smack *sbsp;
>  	int may;
>  	int mmay;
>  	int tmay;
> @@ -1714,6 +1720,10 @@ static int smack_mmap_file(struct file *file,
>  	isp = file_inode(file)->i_security;
>  	if (isp->smk_mmap == NULL)
>  		return 0;
> +	sbsp = file_inode(file)->i_sb->s_security;
> +	if (sbsp->smk_flags & SMK_SB_UNTRUSTED &&
> +	    isp->smk_mmap != sbsp->smk_root)
> +		return -EACCES;
>  	mkp = isp->smk_mmap;
>  
>  	tsp = current_security();
> @@ -3492,16 +3502,14 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
>  			if (rc >= 0)
>  				transflag = SMK_INODE_TRANSMUTE;
>  		}
> -		if (!(sbsp->smk_flags & SMK_SB_UNTRUSTED)) {
> -			/*
> -			 * Don't let the exec or mmap label be "*" or "@".
> -			 */
> -			skp = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
> -			if (IS_ERR(skp) || skp == &smack_known_star ||
> -			    skp == &smack_known_web)
> -				skp = NULL;
> -			isp->smk_task = skp;
> -		}
> +		/*
> +		 * Don't let the exec or mmap label be "*" or "@".
> +		 */
> +		skp = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
> +		if (IS_ERR(skp) || skp == &smack_known_star ||
> +		    skp == &smack_known_web)
> +			skp = NULL;
> +		isp->smk_task = skp;
>  
>  		skp = smk_fetch(XATTR_NAME_SMACKMMAP, inode, dp);
>  		if (IS_ERR(skp) || skp == &smack_known_star ||
