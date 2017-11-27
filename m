From: amulhern@redhat.com
Subject: [PATCH 3/7] dm: documentation fix
Date: Mon, 27 Nov 2017 10:02:41 -0500
Message-ID: <20171127150245.27959-3-amulhern@redhat.com>
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

Delete obsoleted paragraph

The 'mq' policy is no longer the default policy, and the default policy,
'smq', does not store hit counts.

Signed-off-by: mulhern <amulhern@redhat.com>
---
 Documentation/device-mapper/cache.txt | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index cdfd0fe..0435244 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -143,11 +143,6 @@ the policy how big this chunk is, but it should be kept small.  Like the
 dirty flags this data is lost if there's a crash so a safe fallback
 value should always be possible.
 
-For instance, the 'mq' policy, which is currently the default policy,
-uses this facility to store the hit count of the cache blocks.  If
-there's a crash this information will be lost, which means the cache
-may be less efficient until those hit counts are regenerated.
-
 Policy hints affect performance, not correctness.
 
 Policy messaging
-- 
2.9.5
