From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 15/19] capabilities: Allow privileged user in s_user_ns
 to set file caps
Date: Fri, 4 Dec 2015 13:42:06 -0600
Message-ID: <20151204194206.GF3624@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-16-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449070821-73820-16-git-send-email-seth.forshee@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

Quoting Seth Forshee (seth.forshee@canonical.com):
> A privileged user in a super block's s_user_ns is privileged
> towards that file system and thus should be allowed to set file
> capabilities. The file capabilities will not be trusted outside
> of s_user_ns, so an unprivileged user cannot use this to gain
> privileges in a user namespace where they are not already
> privileged.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  security/commoncap.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 2119421613f6..d6c80c19c449 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -653,15 +653,17 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
>  int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  		       const void *value, size_t size, int flags)
>  {
> +	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
> +
>  	if (!strcmp(name, XATTR_NAME_CAPS)) {
> -		if (!capable(CAP_SETFCAP))
> +		if (!ns_capable(user_ns, CAP_SETFCAP))
>  			return -EPERM;

This, for file capabilities, is fine,

>  		return 0;
>  	}
>  
>  	if (!strncmp(name, XATTR_SECURITY_PREFIX,
>  		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> -	    !capable(CAP_SYS_ADMIN))
> +	    !ns_capable(user_ns, CAP_SYS_ADMIN))

but this is for all other security.*.

It's probably still ok, but let's think about it a sec.  MAC like
selinux or smack should be orthogonal to DAC.  Capabilities are the
same in essence, but the reason they can be treated differently here
is because capabilties are in fact targated at a user namespace.
Apparmor namespaces, for instance, are completely orthogonal to user
namespaces, as are contexts in selinux.

Now, if smack or selinux xattrs are being set then those modules
should be gating these writes.  Booting a kernel without those
modules should be a challenge for an untrusted user.  But such a
situation could be exploited opportunistically if it were to happen.

The problem with simply not changing this here is that if selinux
or smack authorizes the xattr write, then commoncap shouldn't be
denying it.

I get the feeling we need cooperation among the modules (i.e. "if
the write is to 'security.$lsm' and $lsm is not loaded, then require
capable(CAP_SYS_ADMIN), else just allow)  But that's not how things are
structured right now.

Maybe security.ko could grow central logic to 'assign' security.*
capabilities to specific lsms and gate writes to those if $lsm is not
loaded.

Does anything break if the second hunk in each fn in this patch is
not applied?


>  		return -EPERM;
>  	return 0;
>  }
> @@ -679,15 +681,17 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
>   */
>  int cap_inode_removexattr(struct dentry *dentry, const char *name)
>  {
> +	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
> +
>  	if (!strcmp(name, XATTR_NAME_CAPS)) {
> -		if (!capable(CAP_SETFCAP))
> +		if (!ns_capable(user_ns, CAP_SETFCAP))
>  			return -EPERM;
>  		return 0;
>  	}
>  
>  	if (!strncmp(name, XATTR_SECURITY_PREFIX,
>  		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> -	    !capable(CAP_SYS_ADMIN))
> +	    !ns_capable(user_ns, CAP_SYS_ADMIN))
>  		return -EPERM;
>  	return 0;
>  }
> -- 
> 1.9.1
