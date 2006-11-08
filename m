From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 8 Nov 2006 00:01:09 +0000
Message-ID: <20061108000109.GE30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611080005.50070.rjw@sisk.pl> <45511430.8030703@redhat.com>
	<200611080042.03563.rjw@sisk.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200611080042.03563.rjw@sisk.pl>
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

On Wed, Nov 08, 2006 at 12:42:02AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 8 November 2006 00:18, Eric Sandeen wrote:
> > But, how is a stampede of fs-freezers -supposed- to work?  I could
> > imagine something like a freezer count, and the filesystem is only
> > unfrozen after everyone has thawed?  Or should only one freezer be
> > active at a time... which is what we have now I guess.
> I think it shouldn't be possible to freeze an fs more than once.

In device-mapper today, the only way to get more than one freeze on the
same device is to use xfs and issue xfs_freeze before creating an lvm snapshot
(or issuing the dmsetup equivalent), and at the moment we tell people not to do
that any more.  The device-mapper API does not permit multiple freezes of the
same device.  (The interesting question is actually whether the request should
be cascaded in any way when devices depend on other devices.)

Now if someone's introducing a new use for freeze_bdev, perhaps now's the time
to revisit the semantics and allow for concurrent freeze requests.

Alasdair
-- 
agk@redhat.com
