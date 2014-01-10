From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dmts: update CacheStatus to parse new status
	output
Date: Thu, 9 Jan 2014 19:09:30 -0500
Message-ID: <20140110000929.GB6154@redhat.com>
References: <20140109210412.GA5288@redhat.com>
	<684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
	<20140109221323.GA5555@redhat.com>
	<20140109235506.GA6154@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140109235506.GA6154@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ejt@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

---
 lib/dmtest/cache-status.rb |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/dmtest/cache-status.rb b/lib/dmtest/cache-status.rb
index 6c8d6c5..6fc5f96 100644
--- a/lib/dmtest/cache-status.rb
+++ b/lib/dmtest/cache-status.rb
@@ -3,8 +3,9 @@ require 'dmtest/log'
 #----------------------------------------------------------------
 
 class CacheStatus
-  attr_accessor :md_used, :md_total, :read_hits, :read_misses, :write_hits, :write_misses
-  attr_accessor :demotions, :promotions, :residency, :nr_dirty, :features, :core_args, :policy_args
+  attr_accessor :md_block_size, :md_used, :md_total, :cache_block_size, :residency, :cache_total
+  attr_accessor :read_hits, :read_misses, :write_hits, :write_misses
+  attr_accessor :demotions, :promotions, :nr_dirty, :features, :core_args, :policy_args
 
   PATTERN ='\d+\s+\d+\s+cache\s+(.*)'
 
@@ -14,14 +15,16 @@ class CacheStatus
 
     @a = m[1].split
 
+    shift_int :md_block_size
     shift_ratio :md_used, :md_total
+    shift_int :cache_block_size
+    shift_ratio :residency, :cache_total
     shift_int :read_hits
     shift_int :read_misses
     shift_int :write_hits
     shift_int :write_misses
     shift_int :demotions
     shift_int :promotions
-    shift_int :residency
     shift_int :nr_dirty
     shift_features :features
     shift_pairs :core_args
