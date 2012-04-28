From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] thinp-test-suite: support for non power of 2
	pool blocksize
Date: Sat, 28 Apr 2012 00:51:51 -0400
Message-ID: <20120428045151.GA853@redhat.com>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<1335588269-807-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1335588269-807-2-git-send-email-snitzer@redhat.com>
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

On Sat, Apr 28 2012 at 12:44am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Non power of 2 blocksize support is needed to properly align thinp IO
> on storage that has non power of 2 optimal IO sizes (e.g. RAID6 10+2).
> 
> Use do_div wrappers to support non power of 2 blocksize for the pool's
> data device.  do_div provides comparable performance to the power of 2
> math that was performed until now (as tested on modern x86_64 hardware).
> 
> Verify that the pool's blocksize is a multiple of 64K and that the
> pool's data device is a multiple of blocksize.

The non power of 2 support patch required quite a few thinp-test-suite
fixes; this works for me but there may be more clever/clean ways to
address rounding down the pool size to a multiple of blocksize...

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 creation_tests.rb      |   26 ++++++++++++++++++++------
 lib/thinp-test.rb      |    2 ++
 multiple_pool_tests.rb |    2 ++
 pool_resize_tests.rb   |    4 +++-
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/creation_tests.rb b/creation_tests.rb
index 7c298cc..3d804e1 100644
--- a/creation_tests.rb
+++ b/creation_tests.rb
@@ -41,8 +41,9 @@ class CreationTests < ThinpTestCase
   end
 
   def test_huge_block_size
-    size = @size
     data_block_size = 524288
+    size = @size / data_block_size
+    size *= data_block_size
     volume_size = 524288
     lwm = 5
     table = Table.new(ThinPool.new(size, @metadata_dev, @data_dev,
@@ -54,12 +55,22 @@ class CreationTests < ThinpTestCase
 
   tag :thinp_target, :quick
 
-  def test_non_power_of_2_data_block_size_fails
-    table = Table.new(ThinPool.new(@size, @metadata_dev, @data_dev,
-                                   @data_block_size + 57, @low_water_mark))
+  def test_data_dev_not_multiple_of_block_size_fails
+    size = @size - 128 + 1
+    table = Table.new(ThinPool.new(size, @metadata_dev, @data_dev,
+                                   128, @low_water_mark))
     assert_bad_table(table)
   end
 
+  def test_non_power_of_2_data_block_size_succeeds
+    data_block_size = 384
+    size = @size / data_block_size
+    size *= data_block_size
+    table = Table.new(ThinPool.new(size, @metadata_dev, @data_dev,
+                                   data_block_size, @low_water_mark))
+    @dm.with_dev(table) {|pool| {}}
+  end
+
   def test_too_small_data_block_size_fails
     table = Table.new(ThinPool.new(@size, @metadata_dev, @data_dev,
                                    64, @low_water_mark))
@@ -73,8 +84,11 @@ class CreationTests < ThinpTestCase
   end
 
   def test_largest_data_block_size_succeeds
-    table = Table.new(ThinPool.new(@size, @metadata_dev, @data_dev,
-                                   2**21, @low_water_mark))
+    data_block_size = 2**21
+    size = @size / data_block_size
+    size *= data_block_size
+    table = Table.new(ThinPool.new(size, @metadata_dev, @data_dev,
+                                   data_block_size, @low_water_mark))
     @dm.with_dev(table) {|pool| {}}
   end
 
diff --git a/lib/thinp-test.rb b/lib/thinp-test.rb
index 7152c2e..3cbf254 100644
--- a/lib/thinp-test.rb
+++ b/lib/thinp-test.rb
@@ -32,6 +32,8 @@ class ThinpTestCase < Test::Unit::TestCase
 
     @volume_size = config[:volume_size]
     @volume_size = 2097152 if @volume_size.nil?
+    @volume_size /= @data_block_size
+    @volume_size *= @data_block_size
 
     @tiny_size = @data_block_size
 
diff --git a/multiple_pool_tests.rb b/multiple_pool_tests.rb
index 75afa49..93b1cdd 100644
--- a/multiple_pool_tests.rb
+++ b/multiple_pool_tests.rb
@@ -85,6 +85,8 @@ class MultiplePoolTests < ThinpTestCase
     md_size = limit_metadata_dev_size(tvm.free_space / 16)
     tvm.add_volume(linear_vol('md', md_size))
     data_size = limit_data_dev_size(tvm.free_space)
+    data_size /= @block_size
+    data_size *= @block_size
     tvm.add_volume(linear_vol('data', data_size))
 
     with_devs(tvm.table('md'),
diff --git a/pool_resize_tests.rb b/pool_resize_tests.rb
index 3b17b44..6c8eadf 100644
--- a/pool_resize_tests.rb
+++ b/pool_resize_tests.rb
@@ -17,6 +17,8 @@ class PoolResizeTests < ThinpTestCase
     super
     @low_water_mark = 0
     @data_block_size = 128
+    @size /= @data_block_size
+    @size *= @data_block_size
   end
 
   tag :thinp_target
@@ -143,7 +145,7 @@ class PoolResizeTests < ThinpTestCase
   def test_ext4_runs_out_of_space
     # we create a pool with a really tiny data volume that wont be
     # able to complete a mkfs.
-    with_standard_pool(16) do |pool|
+    with_standard_pool(128) do |pool|
       with_new_thin(pool, @volume_size, 0) do |thin|
 
         event_tracker = pool.event_tracker;
