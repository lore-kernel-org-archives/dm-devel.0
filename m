From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/6] Makefile.inc: trim extra information from
	systemd version
Date: Mon, 27 Jul 2020 14:24:23 -0500
Message-ID: <1595877868-5595-2-git-send-email-bmarzins@redhat.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Some systemd versions print extra information in the
"pkg-config --modversion" output, which confuses make. Trim this
off.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index e7256e3a..8ea3352d 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -37,7 +37,7 @@ endif
 
 ifndef SYSTEMD
 	ifeq ($(shell pkg-config --modversion libsystemd >/dev/null 2>&1 && echo 1), 1)
-		SYSTEMD = $(shell pkg-config --modversion libsystemd)
+		SYSTEMD = $(shell pkg-config --modversion libsystemd | awk '{print $$1}')
 	else
 		ifeq ($(shell systemctl --version >/dev/null 2>&1 && echo 1), 1)
 			SYSTEMD = $(shell systemctl --version 2> /dev/null | \
-- 
2.17.2
