From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] Fix systemd version detection
Date: Thu,  4 Apr 2019 17:03:21 -0500
Message-ID: <1554415401-26011-1-git-send-email-bmarzins@redhat.com>
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
Cc: Igor Gnatenko <ignatenkobrain@fedoraproject.org>, device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Igor Gnatenko <ignatenkobrain@fedoraproject.org>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index fc728ca..5b2f6d4 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -37,7 +37,7 @@ endif
 
 ifndef SYSTEMD
 	ifeq ($(shell systemctl --version > /dev/null 2>&1 && echo 1), 1)
-		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\)/\1/p')
+		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\).*/\1/p')
 	endif
 endif
 
-- 
2.17.2
