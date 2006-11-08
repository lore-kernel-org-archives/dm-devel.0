From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 8 Nov 2006 15:25:33 +0000
Message-ID: <20061108152533.GH30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061108082722.GH8394166@melbourne.sgi.com>
	<20061108142511.GG30653@agk.surrey.redhat.com>
	<200611081543.28548.rjw@sisk.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200611081543.28548.rjw@sisk.pl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 08, 2006 at 03:43:26PM +0100, Rafael J. Wysocki wrote:
> Will it be enough to cover the interactions with dm?
 
There are cases where you *cannot* freeze the filesystem (unless
you wait for userspace processes to finish what they are doing) -
and only dm can tell you that.

The freeze_filesystems() code ought to do it's best in any given 
circumstances within the constraints.

So:
  Get the filesystem's block device.
  Check the full tree of devices that that block device depends upon
and for any device that belongs to device-mapper check if it is suspended.
If it is, skip the original device.

  struct mapped_device *dm_get_md(dev_t dev);
  int dm_suspended(struct mapped_device *md);
  void dm_put(struct mapped_device *md);

Handling the tree is the difficult bit, but sysfs could help.
[You can get the device-mapper dependencies with:
  struct mapped_device *dm_get_md(dev_t dev);
  struct dm_table *dm_get_table(struct mapped_device *md);
  struct list_head *dm_table_get_devices(struct dm_table *t);
  void dm_table_put(struct dm_table *t);
  void dm_put(struct mapped_device *md);
]

Consider that you could have an already-frozen filesystem containing a loop
device containing a device-mapper device containing a not-frozen filesystem.
You won't be able to freeze that top filesystem because the I/O would
queue lower down the stack.  (Similar problem if the device-mapper device
in the stack was suspended.)

Alasdair
-- 
agk@redhat.com
