From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement barrier support for single device
	DM devices
Date: Tue, 19 Feb 2008 22:12:22 +1100
Message-ID: <20080219111222.GE155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080219023900.GB4066@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080219023900.GB4066@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 19, 2008 at 02:39:00AM +0000, Alasdair G Kergon wrote:
> > For example, how safe
> > xfs is if barriers are not supported or turned off?  
> 
> The last time we tried xfs with dm it didn't seem to notice -EOPNOTSUPP
> everywhere it should => recovery may find corruption.

Bug reports, please. What we don't know about, we can't fix.

As of this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0bfefc46dc028df60120acdb92062169c9328769

XFS should be handling all cases of -EOPNOTSUPP for barrier
I/Os. If you are still having problems, please let us know.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
