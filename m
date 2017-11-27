From: amulhern@redhat.com
Subject: [PATCH 4/7] dm: documentation fix
Date: Mon, 27 Nov 2017 10:02:42 -0500
Message-ID: <20171127150245.27959-4-amulhern@redhat.com>
References: <20171127150245.27959-1-amulhern@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171127150245.27959-1-amulhern@redhat.com>
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
Cc: mulhern <amulhern@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: mulhern <amulhern@redhat.com>

Be consistent in specifying sectors and SI units

Signed-off-by: mulhern <amulhern@redhat.com>
---
 Documentation/device-mapper/cache.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index 0435244..79c7b6d 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -59,7 +59,7 @@ Fixed block size
 The origin is divided up into blocks of a fixed size.  This block size
 is configurable when you first create the cache.  Typically we've been
 using block sizes of 256KB - 1024KB.  The block size must be between 64
-(32KB) and 2097152 (1GB) and a multiple of 64 (32KB).
+sectors (32KB) and 2097152 sectors (1GB) and a multiple of 64 sectors (32KB).
 
 Having a fixed block size simplifies the target a lot.  But it is
 something of a compromise.  For instance, a small part of a block may be
@@ -119,7 +119,7 @@ doing here to avoid migrating during those peak io moments.
 
 For the time being, a message "migration_threshold <#sectors>"
 can be used to set the maximum number of sectors being migrated,
-the default being 204800 sectors (or 100MB).
+the default being 204800 sectors (100MB).
 
 Updating on-disk metadata
 -------------------------
-- 
2.9.5
