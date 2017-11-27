From: amulhern@redhat.com
Subject: [PATCH 5/7] dm: documentation fix
Date: Mon, 27 Nov 2017 10:02:43 -0500
Message-ID: <20171127150245.27959-5-amulhern@redhat.com>
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

Add a remark about the representation of <highest mapped sector> when there
is none.

Signed-off-by: mulhern <amulhern@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index ef63996..3852dad 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -396,3 +396,6 @@ ii) Status
 	If the pool has encountered device errors and failed, the status
 	will just contain the string 'Fail'.  The userspace recovery
 	tools should then be used.
+
+    In the case where <nr mapped sectors> is 0, there is no highest
+    mapped sector and the value of <highest mapped sector> is unspecified.
-- 
2.9.5
