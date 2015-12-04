From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 18/19] fuse: Restrict allow_other to the superblock's
 namespace or a descendant
Date: Fri, 4 Dec 2015 14:43:19 -0600
Message-ID: <20151204204319.GF147214@ubuntu-hedt>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-19-git-send-email-seth.forshee@canonical.com>
 <20151204200541.GI3624@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204200541.GI3624@mail.hallyn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Fri, Dec 04, 2015 at 02:05:41PM -0600, Serge E. Hallyn wrote:
> Quoting Seth Forshee (seth.forshee@canonical.com):
> > Unprivileged users are normally restricted from mounting with the
> > allow_other option by system policy, but this could be bypassed
> > for a mount done with user namespace root permissions. In such
> > cases allow_other should not allow users outside the userns
> > to access the mount as doing so would give the unprivileged user
> > the ability to manipulate processes it would otherwise be unable
> > to manipulate. Restrict allow_other to apply to users in the same
> > userns used at mount or a descendant of that namespace.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  fs/fuse/dir.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index f67f4dd86b36..5b8edb1203b8 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -1018,8 +1018,14 @@ int fuse_allow_current_process(struct fuse_conn *fc)
> >  {
> >  	const struct cred *cred;
> >  
> > -	if (fc->flags & FUSE_ALLOW_OTHER)
> > -		return 1;
> > +	if (fc->flags & FUSE_ALLOW_OTHER) {
> > +		struct user_namespace *ns;
> > +		for (ns = current_user_ns(); ns; ns = ns->parent) {
> > +			if (ns == fc->user_ns)
> > +				return 1;
> > +		}
> 
> 	use current_in_userns() ?

Yes, it should. I wrote this before I wrote the patch which adds that
function and never thought to go back to change it here.
