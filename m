From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Thu, 9 Nov 2006 00:06:11 +0100
Message-ID: <200611090006.12880.rjw@sisk.pl>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <200611081543.28548.rjw@sisk.pl> <20061108152533.GH30653@agk.surrey.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423871AbWKHXIh@vger.kernel.org>
In-Reply-To: <20061108152533.GH30653@agk.surrey.redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>
List-Id: dm-devel.ids

On Wednesday, 8 November 2006 16:25, Alasdair G Kergon wrote:
> On Wed, Nov 08, 2006 at 03:43:26PM +0100, Rafael J. Wysocki wrote:
> > Will it be enough to cover the interactions with dm?
>  
> There are cases where you *cannot* freeze the filesystem (unless
> you wait for userspace processes to finish what they are doing) -
> and only dm can tell you that.
> 
> The freeze_filesystems() code ought to do it's best in any given 
> circumstances within the constraints.
> 
> So:
>   Get the filesystem's block device.
>   Check the full tree of devices that that block device depends upon
> and for any device that belongs to device-mapper check if it is suspended.
> If it is, skip the original device.
> 
>   struct mapped_device *dm_get_md(dev_t dev);
>   int dm_suspended(struct mapped_device *md);
>   void dm_put(struct mapped_device *md);
> 
> Handling the tree is the difficult bit, but sysfs could help.
> [You can get the device-mapper dependencies with:
>   struct mapped_device *dm_get_md(dev_t dev);
>   struct dm_table *dm_get_table(struct mapped_device *md);
>   struct list_head *dm_table_get_devices(struct dm_table *t);
>   void dm_table_put(struct dm_table *t);
>   void dm_put(struct mapped_device *md);
> ]
> 
> Consider that you could have an already-frozen filesystem containing a loop
> device containing a device-mapper device containing a not-frozen filesystem.

I think the last point is handled correctly by freezing the filesystems in the
reverse order - unless the fs below the loop has been frozen before by
someone else, but I guess that would lead to problems anyway.

> You won't be able to freeze that top filesystem because the I/O would
> queue lower down the stack.  (Similar problem if the device-mapper device
> in the stack was suspended.)

The suspended dm device in the stack is not, however.

Is there any list of all dm devices in the system?

Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
