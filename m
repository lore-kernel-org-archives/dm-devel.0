From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] Fix error paths on device initialization
 in the block layer
Date: Tue, 15 Oct 2013 09:32:46 -0600
Message-ID: <20131015153246.GR541@kernel.dk>
References: <alpine.LRH.2.02.1310141138500.24159@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310141138500.24159@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Kay Sievers <kay.sievers@vrfy.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Ken Chen <kenchen@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 14 2013, Mikulas Patocka wrote:
> Hi
> 
> This series of patches fixes some crashes in the block layer in device 
> initialization when memory allocation fails.
> 
> The crashes were discovered during stress testing - we tried to create as 
> many logical volumes as possible.
> 
> Note that there are still some places in the kernel where error handling 
> is inadequate, for example add_disk or blk_register_region.

Thanks, they all look good. Applied for 3.13.

-- 
Jens Axboe
