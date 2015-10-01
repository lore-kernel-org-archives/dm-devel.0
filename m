From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] fs: Verify access of user towards block device file
 when mounting
Date: Thu, 1 Oct 2015 09:40:52 -0400
Message-ID: <20151001134052.GB27818@redhat.com>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
 <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
 <20150930234215.GA24127@redhat.com>
 <20151001125508.GA101875@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151001125508.GA101875@ubuntu-hedt>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 01 2015 at  8:55am -0400,
Seth Forshee <seth.forshee@canonical.com> wrote:

> On Wed, Sep 30, 2015 at 07:42:15PM -0400, Mike Snitzer wrote:
> > On Wed, Sep 30 2015 at  4:15pm -0400,
> > Seth Forshee <seth.forshee@canonical.com> wrote:
> > 
> > > When mounting a filesystem on a block device there is currently
> > > no verification that the user has appropriate access to the
> > > device file passed to mount. This has not been an issue so far
> > > since the user in question has always been root, but this must
> > > be changed before allowing unprivileged users to mount in user
> > > namespaces.
> > > 
> > > To fix this, add an argument to lookup_bdev() to specify the
> > > required permissions. If the mask of permissions is zero, or
> > > if the user has CAP_SYS_ADMIN, the permission check is skipped,
> > > otherwise the lookup fails if the user does not have the
> > > specified access rights for the inode at the supplied path.
> > > 
> > > Callers associated with mounting are updated to pass permission
> > > masks to lookup_bdev() so that these mounts will fail for an
> > > unprivileged user who lacks permissions for the block device
> > > inode. All other callers pass 0 to maintain their current
> > > behaviors.
> > > 
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > > ---
> > >  drivers/md/bcache/super.c |  2 +-
> > >  drivers/md/dm-table.c     |  2 +-
> > >  drivers/mtd/mtdsuper.c    |  6 +++++-
> > >  fs/block_dev.c            | 18 +++++++++++++++---
> > >  fs/quota/quota.c          |  2 +-
> > >  include/linux/fs.h        |  2 +-
> > >  6 files changed, 24 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > > index e76ed003769e..35bb3ea4cbe2 100644
> > > --- a/drivers/md/dm-table.c
> > > +++ b/drivers/md/dm-table.c
> > > @@ -380,7 +380,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > >  	BUG_ON(!t);
> > >  
> > >  	/* convert the path to a device */
> > > -	bdev = lookup_bdev(path);
> > > +	bdev = lookup_bdev(path, 0);
> > >  	if (IS_ERR(bdev)) {
> > >  		dev = name_to_dev_t(path);
> > >  		if (!dev)
> > 
> > Given dm_get_device() is passed @mode why not have it do something like
> > you did in blkdev_get_by_path()? e.g.:
> 
> I only dealt with code related to mounting in this patch since that's
> what I'm working on. I have it on my TODO list to consider converting
> other callers of lookup_bdev. But if you're sure doing so makes sense
> for dm_get_device and that it won't cause regressions then I could add a
> patch for it.

OK, dm_get_device() is called in DM device activation path (by tools
like lvm2).

After lookup_bdev() it goes on to call blkdev_get_by_dev() with this
call chain: 
  dm_get_device -> dm_get_table_device -> open_table_device -> blkdev_get_by_dev

Not immediately clear to me why we'd need to augment blkdev_get_by_dev()
to do this checking also.

However, thinking further: In a device stack (e.g. dm/lvm2, md, etc)
new virtual block devices are created that layer ontop of the
traditional block devices.  This level of indirection may cause your
lookup_bdev() check to go on to succeed (if access constraints were not
established on the upper level dm or md device?).  I'm just thinking
outloud here: but have you verified your changes work as intended on
devices created with either lvm2 or mdadm?

What layer establishes access rights to historically root-only
priviledged block devices?  Is it user namespaces?

I haven't kept up with user namespaces as it relates to stacking block
drivers like DM.  But I'm happy to come up to speed and at the same time
help you verify all works as expected with DM blocks devices...

Mike
