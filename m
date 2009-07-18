From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 00:31:55 -0400
Message-ID: <20090718043155.GI4231@webber.adilger.int>
References: <19041.4714.686158.130252@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <dm-devel-bounces@redhat.com>
Content-disposition: inline
In-reply-to: <19041.4714.686158.130252@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Jul 18, 2009  10:08 +1000, Neil Brown wrote:
>  It has recently come to by attention that Linux on a 32 bit host does
>  not handle devices beyond 16TB particularly well.
> 
>  In particular, any access that goes through the page cache for the
>  block device is limited to a pgoff_t number of pages.
>  As pgoff_t is "unsigned long" and hence 32bit, and as page size is
>  4096, this comes to 16TB total.
:
:
>  I suppose we could add a CONFIG option to make pgoff_t be 
>  "unsigned long long".  Would the cost/benefit of that be acceptable?

I think the point is that for those people who want to use > 16TB
devices on 32-bit platforms (e.g. embedded/appliance systems) the
choice is between "completely non-functional" and "uses a bit more
memory per page", and the answer is pretty obvious.

For users who don't want to support this, they don't have to (just
like CONFIG_LBD or whatever), and for 64-bit systems it is irrelevant.
I think years ago we had the idea that it would be 64-bit everywhere
by now, and while that is true for many systems, embedded/appliance
systems will probably continue to be 32-bit for as long as they can.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
