From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 0/3] Fix SMP races in dm-crypt
Date: Wed, 21 Mar 2007 15:44:32 +0000
Message-ID: <20070321154432.GH27600@agk.surrey.redhat.com>
References: <200703210806.30499.okir@lst.de>
	<20070321100312.GF27600@agk.surrey.redhat.com>
	<87y7lqhgcl.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87y7lqhgcl.fsf@rho.meyering.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Meyering <jim@meyering.net>
Cc: dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, Mar 21, 2007 at 02:32:42PM +0100, Jim Meyering wrote:
> 2007-03-12  Jim Meyering  <jim@meyering.net>
> 
>         * lib/fs/libdevmapper.c (do_suspend): Detect write failure reliably.
>         (do_load): Likewise.
>         (find_mount_point): Avoid buffer overrun for unusually long inputs.
 
That userspace code is neither used nor maintained any more.  It's
probably time to drop it from CVS so people don't waste time looking at
it:-)

> 2007-03-11  Jim Meyering  <meyering@redhat.com>
> 
>         * dmsetup/dmsetup.c (_loop_table): Detect close failure.

I'll apply that, thanks, but I'm in no hurry because that section of
code is unfinished and only partially reviewed.

Alasdair
-- 
agk@redhat.com
