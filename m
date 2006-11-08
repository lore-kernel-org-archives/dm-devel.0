From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Wed, 8 Nov 2006 14:33:50 +1100
Message-ID: <20061108033350.GR11034@melbourne.sgi.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <200611080005.50070.rjw@sisk.pl> <20061107234951.GD30653@agk.surrey.redhat.com> <200611080100.18290.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754028AbWKHDfS@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611080100.18290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>
List-Id: dm-devel.ids

On Wed, Nov 08, 2006 at 01:00:17AM +0100, Rafael J. Wysocki wrote:
> 
> However, XFS_IOC_FREEZE happily returns 0 after calling freeze_bdev(),
> apparetnly assuming that it won't fail.

Because it _can't_ fail at this point. We've got an active superblock,
because we've had to open a fd on the filesystem to get to the point
where we can issue the ioctl.

Hence the get_super() call will always succeed and the freeze
will be executed if we are not read only. The superblock
state changes if the freeze goes ahead, and XFS uses this state
change to determine what to do when the thaw command is sent.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
