From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH RESEND v2 11/18] fs: Ensure the mounter of a filesystem
 is privileged towards its inodes
Date: Wed, 30 Mar 2016 09:58:20 -0500
Message-ID: <20160330145820.GA41461@ubuntu-hedt>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
 <1451930639-94331-12-git-send-email-seth.forshee@canonical.com>
 <20160303170201.GA30224@ubuntu-hedt>
 <87twkl50g5.fsf@x220.int.ebiederm.org>
 <20160328165936.GC137406@ubuntu-hedt>
 <87twjoiw6u.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87twjoiw6u.fsf@x220.int.ebiederm.org>
Sender: owner-linux-security-module@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Tue, Mar 29, 2016 at 08:36:09PM -0500, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > On Fri, Mar 04, 2016 at 04:43:06PM -0600, Eric W. Biederman wrote:
> >> In general this is only an issue if uids and gids on the filesystem
> >> do not map into the user namespace.
> >> 
> >> Therefore the general fix is to limit the logic of checking for
> >> capabilities in s_user_ns if we are dealing with INVALID_UID and
> >> INVALID_GID.  For proc and kernfs that should never be the case
> >> so the problem becomes a non-issue.
> >> 
> >> Further I would look at limiting that relaxation to just
> >> inode_change_ok. 
> >
> > Finally got around to implementing this today; is the patch below what
> > you had in mind?
> 
> Pretty much.
> 
> For the same reason that capble_wrt_inode_uidgid(inode) had to look
> at both inode->i_uid and inode->i_gid I think we need to look at
> both inode->i_uid and inode->i_gid in those case.
> 
> I am worried about chgrp_ok in cases such as inode->i_uid is valid
> but unmapped.  I have a similiar worry about chown_ok where
> inode->i_gid is valid but unmapped (although that worry is less
> serious).

That makes sense.

So then what is wanted is to check that the other id is either invalid,
or else it maps into s_user_ns. So for chown_ok() something like this:

    if (!uid_valid(inode->i_uid) &&
        (!gid_valid(inode->i_gid) || kgid_has_mapping(inode->i_sb->s_user_ns, inode->i_gid)) &&
        ns_capable(inode->i_sb->s_user_ns, CAP_CHOWN))
            return true;

and likewise for chgrp_ok(). Does that satisfy your concerns?

> >> So that we can easily wrap that check per filesystem
> >> and deny the relaxation for proc and kernfs.  proc and kernfs already
> >> have wrappers for .setattr so denying changes when !uid_vaid and
> >> !gid_valid would be a trivial addition, and ensure calamity does
> >> not ensure.
> >
> > I'm confused about this part though. As you say above, proc and kernfs
> > will never have inodes with invalid ids, so it's not an issue. Do you
> > just mean this to be extra insurance against problems?
> 
> I meant two things.
> 1) As filesystems explicitly have to call inode_change_ok they can
>    over ride the default if it is possible.
> 
> 2) Because being paranoid about backward compatibility matters, it
>    almost certainly workth add adding a check:
>    "if (!uid_valid(inode->i_uid) ||!gid_valid(inode->i_gid)) return -EPERM"
>    To proc and sysfs just before they call inode_change_ok just so we
>    don't need to analyze them and confirm that they don't use
>    INVALID_UID.
> 
>    That just makes the patch more robust.
> 
>    The we could leave removing that code for a follow on patch where
>    someone takes the time to read through and audit all of the proc and
>    sysfs code to ensure that the case does not arise, instead of just
>    implicitily assuming it.
> 
>    That is the usual pattern when pushing down changes.  Do something
>    that is easily guaranteed to work, and leave the careful looking for
>    a patch all of it's own.

Okay, I'll add checks.

Thanks,
Seth

