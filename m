From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: fix allocation of devices on
 writecache tests
Date: Wed, 5 Feb 2020 04:17:47 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002050411220.8320@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200128154641.ppphhatq5hw3rtgt@reti>
	<alpine.LRH.2.02.2002041513390.20730@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2002041513390.20730@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, msnitzer@redhat.com, nkshirsa@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Here I'm sending a patch for device mapper tests suite. With this patch, 
the cache is allocated on the fast device. It performs slightly better 
than dm-cache on the git-checkout benchmark:

DM-CACHE git tests:
SMQComparisonTests
  git_extract_only_across_cache_size_smq...formatting ...
getting repo ...
Elapsed 89.0716564: git_prepare
Checking out v2.6.12 ...
Checking out v2.6.13 ...
Checking out v2.6.14 ...
Elapsed 98.78236956: extract all versions
Checking out v2.6.12 ...
Checking out v2.6.13 ...
Checking out v2.6.14 ...
Elapsed 81.25339984: extract all versions
Elapsed 271.27901308: cache size = 256, policy = smq
formatting ...
getting repo ...
Elapsed 80.05892212: git_prepare
Checking out v2.6.12 ...
Checking out v2.6.13 ...
Checking out v2.6.14 ...
Elapsed 84.97932172: extract all versions


DM-WRITECACHE git tests:
Loaded suite writecache
WriteCacheBenchmarks
  git_extract_only_across_cache_size...formatting ...
getting repo ...
Elapsed 81.97540516: git_prepare
Checking out v2.6.12 ...
Checking out v2.6.13 ...
Checking out v2.6.14 ...
Elapsed 79.58938916: extract all versions
Checking out v2.6.12 ...
Checking out v2.6.13 ...
Checking out v2.6.14 ...
Elapsed 73.42351832: extract all versions
Elapsed 241.46500768: cache size = 256
formatting ...
getting repo ...
Elapsed 89.21745808: git_prepare
Checking out v2.6.12 ...
Checking out v2.6.13 ...
Checking out v2.6.14 ...
Elapsed 74.49628804: extract all versions


From: Mikulas Patocka <mpatocka@redhat.com>

Writecache tests used the slow device for both data and cache device -
this resulted in horrible performance.

This patch fixes it, so that the fast device is used for the cache.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 lib/dmtest/writecache-stack.rb |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: device-mapper-test-suite/lib/dmtest/writecache-stack.rb
===================================================================
--- device-mapper-test-suite.orig/lib/dmtest/writecache-stack.rb	2020-02-05 10:02:41.000000000 +0100
+++ device-mapper-test-suite/lib/dmtest/writecache-stack.rb	2020-02-05 10:02:41.000000000 +0100
@@ -29,14 +29,12 @@ class WriteCacheStack
     @cache = nil
     @opts = opts
 
-    #@tvm = TinyVolumeManager::VM.new
-    #@tvm.add_allocation_volume(ssd_dev)
-    #@tvm.add_volume(linear_vol('ssd', cache_size == :all ? @tvm.free_space : cache_size))
+    @tvm = TinyVolumeManager::VM.new
+    @tvm.add_allocation_volume(ssd_dev)
+    @tvm.add_volume(linear_vol('ssd', cache_size == :all ? @tvm.free_space : cache_size))
 
     @data_tvm = TinyVolumeManager::VM.new
     @data_tvm.add_allocation_volume(spindle_dev)
-
-    @data_tvm.add_volume(linear_vol('ssd', cache_size == :all ? @tvm.free_space : cache_size))
     @data_tvm.add_volume(linear_vol('origin', origin_size == :all ? @data_tvm.free_space : origin_size))
   end
 
@@ -53,7 +51,7 @@ class WriteCacheStack
   end
 
   def activate_support_devs(&block)
-    with_devs(@data_tvm.table('ssd'),
+    with_devs(@tvm.table('ssd'),
               @data_tvm.table('origin')) do |ssd, origin|
       @ssd = ssd
       @origin = origin
@@ -71,7 +69,7 @@ class WriteCacheStack
   end
 
   def activate(&block)
-    with_devs(@data_tvm.table('ssd'),
+    with_devs(@tvm.table('ssd'),
               @data_tvm.table('origin')) do |ssd, origin|
       @ssd = ssd
       @origin = origin
