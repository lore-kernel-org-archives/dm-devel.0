From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 12/15] multipath-tools: remove patchwork reference
Date: Wed, 10 Aug 2016 18:20:35 +0200
Message-ID: <1470846038-6590-12-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

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
2.7.4
