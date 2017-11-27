From: amulhern@redhat.com
Subject: [PATCH 7/7] dm: documentation fix
Date: Mon, 27 Nov 2017 10:02:45 -0500
Message-ID: <20171127150245.27959-7-amulhern@redhat.com>
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

Extend thinpool status format string with omitted fields.

Signed-off-by: mulhern <amulhern@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index fb10d18..4bcd4b7 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -276,7 +276,8 @@ ii) Status
 
     <transaction id> <used metadata blocks>/<total metadata blocks>
     <used data blocks>/<total data blocks> <held metadata root>
-    ro|rw|out_of_data_space [no_]discard_passdown
+    ro|rw|out_of_data_space [no_]discard_passdown [error|queue]_if_no_space
+    needs_check|-
 
     transaction id:
 	A 64-bit number used by userspace to help synchronise with metadata
-- 
2.9.5
