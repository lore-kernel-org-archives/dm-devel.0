From: sayli karnik <karniksayli1995@gmail.com>
Subject: [PATCH] Documentation: device-mapper: cache.txt: Fix
	typos
Date: Sun, 19 Mar 2017 03:04:24 +0530
Message-ID: <20170318213424.GA21394@sayli-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: outreachy-kernel@googlegroups.com
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: dm-devel.ids

The patch fixes a spelling error (hexidecimal->hexadecimal).

Signed-off-by: sayli karnik <karniksayli1995@gmail.com>
---
 Documentation/device-mapper/cache.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index f228604..cdfd0fe 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -290,7 +290,7 @@ message, which takes an arbitrary number of cblock ranges.  Each cblock
 range's end value is "one past the end", meaning 5-10 expresses a range
 of values from 5 to 9.  Each cblock must be expressed as a decimal
 value, in the future a variant message that takes cblock ranges
-expressed in hexidecimal may be needed to better support efficient
+expressed in hexadecimal may be needed to better support efficient
 invalidation of larger caches.  The cache must be in passthrough mode
 when invalidate_cblocks is used.
 
-- 
2.7.4
