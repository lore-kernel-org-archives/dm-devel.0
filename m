From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Tue, 7 Nov 2006 23:49:51 +0000
Message-ID: <20061107234951.GD30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061107122837.54828e24.akpm@osdl.org>
	<45510C73.7060408@redhat.com> <200611080005.50070.rjw@sisk.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200611080005.50070.rjw@sisk.pl>
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
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 08, 2006 at 12:05:49AM +0100, Rafael J. Wysocki wrote:
> But freeze_bdev() is supposed to return the result of get_super(bdev)
> _unconditionally_.  Moreover, in its current form freeze_bdev() _cannot_
> _fail_, so I don't see how this change doesn't break any existing code.
> For example freeze_filesystems() (recently added to -mm) will be broken
> if the down_trylock() is unsuccessful.
 
I hadn't noticed that -mm patch.  I'll take a look.  Up to now, device-mapper
(via dmsetup) and xfs (via xfs_freeze, which dates from before device-mapper
handled this automatically) were the only users.  Only one freeze should be
issued at once.  A freeze is a temporary thing, normally used while creating a
snapshot.  (One problem we still have is lots of old documentation on the web
advising people to run xfs_freeze before creating device-mapper snapshots.)

You're right that the down_trylock idea is more trouble than it's worth and
should be scrapped.

Alasdair
-- 
agk@redhat.com
