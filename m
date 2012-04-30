From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] thinp-test-suite: support for non power of 2
 pool blocksize
Date: Mon, 30 Apr 2012 11:15:02 +0100
Message-ID: <20120430101501.GB5955@ubuntu>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<1335588269-807-2-git-send-email-snitzer@redhat.com>
	<20120428045151.GA853@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120428045151.GA853@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 28, 2012 at 12:51:51AM -0400, Mike Snitzer wrote:
> On Sat, Apr 28 2012 at 12:44am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> The non power of 2 support patch required quite a few thinp-test-suite
> fixes; this works for me but there may be more clever/clean ways to
> address rounding down the pool size to a multiple of blocksize...

Yes, I need to do some work here.  We can't keep tweaking these magic
numbers.

- Some tests hardwire a block size, eg, my cache_tests, your
  non-power-2 tests.

- Some tests can prove their point with a small pool size.  So no point
  wasting time by running on bigger pools.

- Some tests would definitely benefit by scaling up to larger pools,
  more thins etc, as hardware allows.  But we should probably control
  this from the command line - big tests take a long time to run, so
  we shouldn't assume we should scale up the tests to consume all disk
  space.

- different hardware has different logical block sizes, which can
  effect io sizes (eg, see discard tests).  The code needs to make it
  clear that the sizes are being influenced by the LBS.

- We should make it clear in the results, and the test source, which
  tests scaled up and how.  eg, did data_block_size change?,
  data_dev_size?
