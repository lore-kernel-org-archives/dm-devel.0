From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 1/5] fs: Verify access of user towards block device file
 when mounting
Date: Thu, 1 Oct 2015 10:55:09 -0500
Message-ID: <20151001155509.GD101875@ubuntu-hedt>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
 <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
 <87mvw2d2cn.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvw2d2cn.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 01, 2015 at 10:40:08AM -0500, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > When mounting a filesystem on a block device there is currently
> > no verification that the user has appropriate access to the
> > device file passed to mount. This has not been an issue so far
> > since the user in question has always been root, but this must
> > be changed before allowing unprivileged users to mount in user
> > namespaces.
> >
> > To fix this, add an argument to lookup_bdev() to specify the
> > required permissions. If the mask of permissions is zero, or
> > if the user has CAP_SYS_ADMIN, the permission check is skipped,
> > otherwise the lookup fails if the user does not have the
> > specified access rights for the inode at the supplied path.
> >
> > Callers associated with mounting are updated to pass permission
> > masks to lookup_bdev() so that these mounts will fail for an
> > unprivileged user who lacks permissions for the block device
> > inode. All other callers pass 0 to maintain their current
> > behaviors.
> >
> 
> Seth can you split this patch?
> 
> One patch to add an argument to lookup_bdev,
> and then for each kind of callsite a follow-on patch (if we are ready
> for that).
> 
> That will separate the logical changes and make things easier to track
> via bisect and more importantly easier to review things.

Sure, I'll do that.

Seth
