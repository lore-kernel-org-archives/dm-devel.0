From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH RESEND v2 11/18] fs: Ensure the mounter of a filesystem is privileged towards its inodes
Date: Fri, 04 Mar 2016 16:43:06 -0600
Message-ID: <87twkl50g5.fsf@x220.int.ebiederm.org>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
	<1451930639-94331-12-git-send-email-seth.forshee@canonical.com>
	<20160303170201.GA30224@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160303170201.GA30224@ubuntu-hedt> (Seth Forshee's message of
	"Thu, 3 Mar 2016 11:02:01 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

Seth Forshee <seth.forshee@canonical.com> writes:

> On Mon, Jan 04, 2016 at 12:03:50PM -0600, Seth Forshee wrote:
>> The mounter of a filesystem should be privileged towards the
>> inodes of that filesystem. Extend the checks in
>> inode_owner_or_capable() and capable_wrt_inode_uidgid() to
>> permit access by users priviliged in the user namespace of the
>> inode's superblock.
>
> Eric - I've discovered a problem related to this patch. The patches
> you've already applied to your testing branch make it so that s_user_ns
> can be an unprivileged user for proc and kernfs-based mounts. In some
> cases DAC is the only thing protecting files in these mounts (ignoring
> MAC), and with this patch an unprivileged user could bypass DAC.
>
> There's a simple solution - always set s_user_ns to &init_user_ns for
> those filesystems. I think this is the right thing to do, since the
> backing store behind these filesystems are really kernel objects.  But
> this would break the assumption behind your patch "userns: Simpilify
> MNT_NODEV handling" and cause a regression in mounting behavior.
>
> I've come up with several possible solutions for this conflict.
>
>  1. Drop this patch and keep on setting s_user_ns to unprivilged users.
>     This would be unfortunate because I think this patch does make sense
>     for most filesystems.
>  2. Restrict this patch so that a user privileged towards s_user_ns is
>     only privileged towards the super blocks inodes if s_user_ns has a
>     mapping for both i_uid and i_gid. This is better than (1) but still
>     not ideal in my mind.
>  3. Drop your patch and maintain the current MNT_NODEV behavior.
>  4. Add a new s_iflags flag to indicate a super block is from an
>     unprivileged mount, and use this in your patch instead of s_user_ns.
>
> Any preference, or any other ideas?

In general this is only an issue if uids and gids on the filesystem
do not map into the user namespace.

Therefore the general fix is to limit the logic of checking for
capabilities in s_user_ns if we are dealing with INVALID_UID and
INVALID_GID.  For proc and kernfs that should never be the case
so the problem becomes a non-issue.

Further I would look at limiting that relaxation to just
inode_change_ok.  So that we can easily wrap that check per filesystem
and deny the relaxation for proc and kernfs.  proc and kernfs already
have wrappers for .setattr so denying changes when !uid_vaid and
!gid_valid would be a trivial addition, and ensure calamity does
not ensure.

Furthmore by limiting any additional to inode_change_ok we keep
the work of the additional tests off of the fast paths.

Eric
