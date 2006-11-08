From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 8 Nov 2006 14:25:11 +0000
Message-ID: <20061108142511.GG30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611080005.50070.rjw@sisk.pl> <45511430.8030703@redhat.com>
	<200611080042.03563.rjw@sisk.pl>
	<20061108000109.GE30653@agk.surrey.redhat.com>
	<20061108082722.GH8394166@melbourne.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061108082722.GH8394166@melbourne.sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 08, 2006 at 07:27:22PM +1100, David Chinner wrote:
> But it's trivial to detect this condition - if (sb->s_frozen != SB_UNFROZEN)
> then the filesystem is already frozen and you shouldn't try to freeze
> it again. It's simple to do, and the whole problem then just goes away....
 
So is that another vote in support of explicitly supporting multiple concurrent
freeze requests, letting them all succeed, and only thawing after the last one
has requested its thaw?  (It's not enough just to check SB_UNFROZEN - also need
to track whether any other outstanding requests to avoid risk of it getting
unfrozen while something independent believes it still to be frozen.)

Alasdair
-- 
agk@redhat.com
