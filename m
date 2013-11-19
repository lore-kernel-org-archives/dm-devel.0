From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache mq policy warmup issue
Date: Tue, 19 Nov 2013 13:50:33 -0500
Message-ID: <20131119185032.GB1833@redhat.com>
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
To: "Mears, Morgan" <Morgan.Mears@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 13 2013 at 11:13am -0500,
Mears, Morgan <Morgan.Mears@netapp.com> wrote:

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

The fix for this is now staged in linux-next, see:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=38863832030359bfa8153bee6d7045e372780deb

> Are there any tests in device-mapper-test-suite that you would recommend
> for testing whether promotions are occurring as expected?

Joe included more tests in device-mapper-test-suite, try:

dmtest run --suite cache -t /SingleBlockPromotionTests/

(the few tests that fail are due to extra IO that occurs due readahead
because buffered IO is used to read an entire block, the test needs
improving to use direct IO)
