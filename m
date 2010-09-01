From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Wed, 1 Sep 2010 06:31:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com>
	<4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org>
	<20100830194731.GA10702@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100830194731.GA10702@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 30 Aug 2010, Mike Snitzer wrote:

> Hi,
> 
> On Mon, Aug 30 2010 at 11:45am -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Here's a version w/ BUG_ON() added.  Once the queue hang issue is
> > tracked down, I'll refresh the whole series and repost.
> 
> When you next send out the refreshed series, could you cc dm-devel any
> patches that touch DM directly or block patches that are required to
> support DM?
> 
> It'd be great to cc Mikulas Patocka on those patches too (I cc'd him).
> Mikulas will be reviewing these DM patches now that we have something
> that works with your larger FLUSH+FUA patchset.
> 
> Thanks,
> Mike

My recommended approach to this (on non-request-based dm) is to simply let 
the current barrier infrastructure be as it is --- you don't need to 
change it now, you can simply map FUA write to barrier write and FLUSH to 
zero-data barrier --- and it won't cause any data corruption. It will just 
force unneeded I/O queue draining.

Once FLUSH+FUA interface is finalized and committed upstream, we can 
remove that I/O queue draining from dm to improve performance.

Mikulas
