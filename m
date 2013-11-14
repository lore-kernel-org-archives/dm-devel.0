From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache mq policy warmup issue
Date: Thu, 14 Nov 2013 14:37:17 +0000
Message-ID: <20131114143716.GB17651@debian>
References: <9BDA3ECEC2A5454BB4294114677019E131B6C2F9@SACEXCMBX02-PRD.hq.netapp.com>
	<33A0129EBFD46748804DE81B354CA1B21C031288@SACEXCMBX06-PRD.hq.netapp.com>
	<33A0129EBFD46748804DE81B354CA1B21C031CD6@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C031CD6@SACEXCMBX06-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 13, 2013 at 04:13:43PM +0000, Mears, Morgan wrote:
> On Mon, Nov 04, 2013 at 12:22:26PM -0500, Krishnasamy, Somasundaram wrote:
> > Mike,
> > 
> > I was doing some testing with latest dm-cache code (from 'for-next' branch). I
> > am having difficulty in making the cache to warm-up. I used the below script
> > to read range of blocks repeatedly to get them promoted. I assume after
> > reading a block for mq->promote_threshold + 4 times, a block will be
> > promoted. But it is not happening. I also tested the same with the
> > sequential_threshold set to very high value.
> > 
> > Cache warming-up was relatively easier in the previous dm-cache code. Is this
> > something you have seen in your testing?. Is there anything different should I
> > do?
> 
> I'm also testing with the for-next branch of linux-dm.git and seeing the
> same thing as Somu.  It's easy to reproduce; reading the same block on the
> cached device over and over with dd does not result in that block being
> promoted.
> 
> I did notice that the "read miss" counter for the cached device increments
> each time I execute dd, which I believe means this isn't a buffer cache
> issue (I also used dd iflag=direct).  The migration_threshold value
> shouldn't be an issue for this test, but I set it to a very high value
> anyway; didn't make any difference.
> 
> Are there any tests in device-mapper-test-suite that you would recommend
> for testing whether promotions are occurring as expected?
> 
> --Morgan

Hi Morgan,

I just added these tests, promotion is occuring, just not as much as I'd like:

https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cache/promotion_tests.rb

Ah, these tests all trigger promotion via a write, I'll do some that just read.

- Joe
