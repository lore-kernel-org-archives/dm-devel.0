From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 15/19] capabilities: Allow privileged user in s_user_ns
 to set file caps
Date: Fri, 4 Dec 2015 16:05:09 -0600
Message-ID: <20151204220509.GC5699@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-16-git-send-email-seth.forshee@canonical.com>
 <20151204194206.GF3624@mail.hallyn.com>
 <20151204203627.GD147214@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204203627.GD147214@ubuntu-hedt>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Fri, Dec 04, 2015 at 02:36:27PM -0600, Seth Forshee wrote:
> On Fri, Dec 04, 2015 at 01:42:06PM -0600, Serge E. Hallyn wrote:
> > Quoting Seth Forshee (seth.forshee@canonical.com):
> > > A privileged user in a super block's s_user_ns is privileged
> > > towards that file system and thus should be allowed to set file
> > > capabilities. The file capabilities will not be trusted outside
> > > of s_user_ns, so an unprivileged user cannot use this to gain
> > > privileges in a user namespace where they are not already
> > > privileged.
> > > 
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > > ---
> > >  security/commoncap.c | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/security/commoncap.c b/security/commoncap.c
> > > index 2119421613f6..d6c80c19c449 100644
> > > --- a/security/commoncap.c
> > > +++ b/security/commoncap.c
> > > @@ -653,15 +653,17 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
> > >  int cap_inode_setxattr(struct dentry *dentry, const char *name,
> > >  		       const void *value, size_t size, int flags)
> > >  {
> > > +	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
> > > +
> > >  	if (!strcmp(name, XATTR_NAME_CAPS)) {
> > > -		if (!capable(CAP_SETFCAP))
> > > +		if (!ns_capable(user_ns, CAP_SETFCAP))
> > >  			return -EPERM;
> > 
> > This, for file capabilities, is fine,
> > 
> > >  		return 0;
> > >  	}
> > >  
> > >  	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> > >  		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
> > > -	    !capable(CAP_SYS_ADMIN))
> > > +	    !ns_capable(user_ns, CAP_SYS_ADMIN))
> > 
> > but this is for all other security.*.
> > 
> > It's probably still ok, but let's think about it a sec.  MAC like
> > selinux or smack should be orthogonal to DAC.  Capabilities are the
> > same in essence, but the reason they can be treated differently here
> > is because capabilties are in fact targated at a user namespace.
> > Apparmor namespaces, for instance, are completely orthogonal to user
> > namespaces, as are contexts in selinux.
> > 
> > Now, if smack or selinux xattrs are being set then those modules
> > should be gating these writes.  Booting a kernel without those
> > modules should be a challenge for an untrusted user.  But such a
> > situation could be exploited opportunistically if it were to happen.
> > 
> > The problem with simply not changing this here is that if selinux
> > or smack authorizes the xattr write, then commoncap shouldn't be
> > denying it.
> 
> This is partly the logic behind the change, the other part being that
> the user could already insert the xattrs directly into the backing store
> so the LSMs must be prepared not to trust them in any case. But the
> commit message doesn't explain that, my mistake. And it's a question
> worth revisiting.
> 
> > I get the feeling we need cooperation among the modules (i.e. "if
> > the write is to 'security.$lsm' and $lsm is not loaded, then require
> > capable(CAP_SYS_ADMIN), else just allow)  But that's not how things are
> > structured right now.
> > 
> > Maybe security.ko could grow central logic to 'assign' security.*
> > capabilities to specific lsms and gate writes to those if $lsm is not
> > loaded.
> 
> I don't see any meaningful difference between this case and the case of
> inserting them into the backing store before mounting. We can't do
> anything to prevent the latter, so LSMs just have to be aware of
> unprivileged mounts and handle them with care. Previous patches do this
> for SELinux and Smack by adopting a policy that doesn't respect security
> labels on disk for these mounts. So I don't think that refusing to set
> security.* xattrs for an LSM that isn't loaded really accomplishes
> anything.

Good point.  I think that's the thing to point in the patch description.
(The original patch description doesn't mention any change apart from
file capabilities, which I think it should)

> Then there's the case of setting xattrs for an LSM that is currently
> loaded. I think that SELinux and Smack are both going to refuse these
> writes, Smack rather directly by seeing that the user lacks global
> CAP_MAC_ADMIN and SELinux by virtue of the fact that the previous patch
> in this series applies mountpoint labeling to these mounts. As far as I
> can tell the other LSMs don't take security policy from xattrs.
> 
> So, as far as I can tell, removing the check doesn't create any
> vulnerabilities.
> 
> But that's not to say it's the right thing to do. After reconsidering
> it, I'm inclined to be more conservative and to keep requiring
> capable(CAP_SYS_ADMIN) until such time as there's a use case for
> allowing a user privileged only in s_user_ns to write these xattrs.
> 
> > Does anything break if the second hunk in each fn in this patch is
> > not applied?
> 
> Not that I'm aware of, no.

That's ok, let's leave the patch as is, with updated description.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

thanks!

-serge
