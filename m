From: li.minghui7@zte.com.cn
Subject: [PATCH] multipath-tools:replace the "strict_timinig"
	with "strict_timing"
Date: Fri, 4 Nov 2016 11:26:54 +0800
Message-ID: <1478230014-8968-1-git-send-email-li.minghui7@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, "li.minghui" <li.minghui7@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "li.minghui" <li.minghui7@zte.com.cn>

multipath-tools:replace the "strict_timinig" with "strict_timing"
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b7d7e59..4f90cf5 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -692,7 +692,7 @@ Default value is: \fBno\fR
 .
 .
 .TP
-.B strict_timinig
+.B strict_timing
 If set to
 .I yes
 , multipathd will start a new path checker loop after exactly one second,
-- 
2.8.1.windows.1
