From: tang.wenjun3@zte.com.cn
Subject: [PATCH 23/94] multipath-tools: remove patchwork reference
Date: Fri, 14 Oct 2016 09:56:05 +0800
Message-ID: <1476410236-9368-23-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

It is only for kernel dm patches.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 1 -
 1 file changed, 1 deletion(-)

diff --git a/README b/README
index c1c53fc..77b79b8 100644
--- a/README
+++ b/README
@@ -25,6 +25,5 @@ To get latest devel code: git clone http://git.opensvc.com/multipath-tools/.git
 
 Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
 Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
-Patchwork: http://patchwork.kernel.org/project/dm-devel/list/
 
 Current maintainer is Christophe Varoqui <christophe.varoqui@opensvc.com>
-- 
2.8.1.windows.1
