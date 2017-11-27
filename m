From: amulhern@redhat.com
Subject: [PATCH 2/7] dm: documentation fix
Date: Mon, 27 Nov 2017 10:02:40 -0500
Message-ID: <20171127150245.27959-2-amulhern@redhat.com>
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

Use possessive pronoun where appropriate

Instead of contraction.

Signed-off-by: mulhern <amulhern@redhat.com>
---
 Documentation/device-mapper/cache-policies.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/cache-policies.txt b/Documentation/device-mapper/cache-policies.txt
index d3ca8af..86786d8 100644
--- a/Documentation/device-mapper/cache-policies.txt
+++ b/Documentation/device-mapper/cache-policies.txt
@@ -60,7 +60,7 @@ Memory usage:
 The mq policy used a lot of memory; 88 bytes per cache block on a 64
 bit machine.
 
-smq uses 28bit indexes to implement it's data structures rather than
+smq uses 28bit indexes to implement its data structures rather than
 pointers.  It avoids storing an explicit hit count for each block.  It
 has a 'hotspot' queue, rather than a pre-cache, which uses a quarter of
 the entries (each hotspot block covers a larger area than a single
@@ -84,7 +84,7 @@ resulting in better promotion/demotion decisions.
 
 Adaptability:
 The mq policy maintained a hit count for each cache block.  For a
-different block to get promoted to the cache it's hit count has to
+different block to get promoted to the cache its hit count has to
 exceed the lowest currently in the cache.  This meant it could take a
 long time for the cache to adapt between varying IO patterns.
 
-- 
2.9.5
