From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 8 Nov 2006 02:30:39 +0000
Message-ID: <20061108023039.GF30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061107122837.54828e24.akpm@osdl.org>
	<45510C73.7060408@redhat.com> <200611080005.50070.rjw@sisk.pl>
	<20061107234951.GD30653@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061107234951.GD30653@agk.surrey.redhat.com>
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
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 07, 2006 at 11:49:51PM +0000, Alasdair G Kergon wrote:
> I hadn't noticed that -mm patch.  I'll take a look.  

swsusp-freeze-filesystems-during-suspend-rev-2.patch

I think you need to give more thought to device-mapper
interactions here.  If an underlying device is suspended
by device-mapper without freezing the filesystem (the
normal state) and you issue a freeze_bdev on a device
above it, the freeze_bdev may never return if it attempts
any synchronous I/O (as it should).

Try:
  while process generating I/O to filesystem on LVM
  issue dmsetup suspend --nolockfs (which the lvm2 tools often do)
  try your freeze_filesystems()

Maybe: don't allow freeze_filesystems() to run when the system is in that
state; or, use device-mapper suspend instead of freeze_bdev directly where
dm is involved; or skip dm devices that are already frozen - all with
appropriate dependency tracking to process devices in the right order.

Alasdair
-- 
agk@redhat.com
