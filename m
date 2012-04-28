From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: thinp-test-suite: support for non power of 2 pool
	blocksize
Date: Sat, 28 Apr 2012 11:32:46 -0400
Message-ID: <20120428153246.GA4416@redhat.com>
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
To: dm-devel@redhat.com
Cc: ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 28 2012 at 12:51am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sat, Apr 28 2012 at 12:44am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Non power of 2 blocksize support is needed to properly align thinp IO
> > on storage that has non power of 2 optimal IO sizes (e.g. RAID6 10+2).
> > 
> > Use do_div wrappers to support non power of 2 blocksize for the pool's
> > data device.  do_div provides comparable performance to the power of 2
> > math that was performed until now (as tested on modern x86_64 hardware).
> > 
> > Verify that the pool's blocksize is a multiple of 64K and that the
> > pool's data device is a multiple of blocksize.
> 
> The non power of 2 support patch required quite a few thinp-test-suite
> fixes; this works for me but there may be more clever/clean ways to
> address rounding down the pool size to a multiple of blocksize...

Need this too:

diff --git a/pool_resize_tests.rb b/pool_resize_tests.rb
index 6c8eadf..61e046f 100644
--- a/pool_resize_tests.rb
+++ b/pool_resize_tests.rb
@@ -50,6 +50,8 @@ class PoolResizeTests < ThinpTestCase
 
   def test_resize_no_io
     target_step = @size / 8
+    target_step /= @data_block_size
+    target_step *= @data_block_size
     with_standard_pool(target_step) do |pool|
       2.upto(8) do |n|
         table = Table.new(ThinPool.new(n * target_step, @metadata_dev, @data_dev,
