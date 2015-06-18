From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] WARNING: at fs/block_dev.c:5 when removing LV on
 removed device
Date: Thu, 18 Jun 2015 15:08:15 -0400
Message-ID: <20150618190815.GA6390@redhat.com>
References: <20150618165713.GB19417@two.firstfloor.org>
 <20150618180408.GD2321@redhat.com>
 <20150618180804.GC19417@two.firstfloor.org>
 <20150618181619.GE2321@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618181619.GE2321@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Jun 18, 2015 at 02:16:19PM -0400, Mike Snitzer wrote:
> On Thu, Jun 18 2015 at  2:08pm -0400,
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > Hmm, so you have a filesystem active on it too?
> > 
> > I unmounted it before.
> > 
> > >  
> > > > Also the VG removal did not work of course.
> > > 
> > > Once you resolve the filesystem piece, from vgremove man page:
> > > 
> > > "vgremove allows you to remove one or more volume groups.  If one or
> > > more physical volumes in the volume group are lost, consider vgreduce
> > > --removemissing to make the volume group metadata consistent again."
> > 
> > Well in any case there should not be WARN()s.
> 
> Yes well I don't even know what WARN_ON you're hitting.  You're running
> a 4.0.4 fedora kernel.  Which WARN_ON() is triggering?  The
> WARN_ON_ONCE() in bdev_write_inode()? -- likely since the only caller of
> bdev_write_inode is __blkdev_put...
> 
> /**
>  * write_inode_now      -       write an inode to disk
>  * @inode: inode to write to disk
>  * @sync: whether the write should be synchronous or not
>  *
>  * This function commits an inode to disk immediately if it is dirty. This is
>  * primarily needed by knfsd.
>  *
>  * The caller must either have a ref on the inode or must have set I_WILL_FREE.
>  */
> 
> So I have no idea why bdev_write_inode() is using WARN_ON_ONCE.. makes
> since that write_inode_now() will fail if the disk no longer exists.  SO
> the WARN_ON_ONCE seems misplaced.
> 
> Git blame shows its all hch's fault:
> 
> 564f00f6c (Christoph Hellwig  2015-01-14 10:42:33 +0100   57) WARN_ON_ONCE(write_inode_now(inode, true));
> 
> 564f00f6c block_dev: only write bdev inode on close

I can reproduce it too in a Fedora 22 virtual machine. I just have to do
"umount <mnt>" after hot unplugging the virtIO disk.

But it does not happen without lvm. If I create ext4 fs directly on
/dev/vda1, then when disk goes way, fs automatically gets unmounted.

But same does not happen when /dev/vda1 is added to a volume group and
I carve out a logical volume and create and mount fs.

In that case if I do umount after device has gone away, I can see above
WARN(). And it does seem to be coming from.

WARN_ON_ONCE(write_inode_now(inode, true))

If we failed to write back inode, then warning about it sounds right?
What's wrong with that? Should it be just a kernel log of level KERN_WARN
instead?

Thanks
Vivek
