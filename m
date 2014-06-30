From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 03/12] enable gcc format-security check
Date: Mon, 30 Jun 2014 00:13:54 -0500
Message-ID: <1404105243-5071-4-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

-Wformat-security warns about format-strigs that represent possible
security problems.  This is check is now enabled for fedora builds, and it
seems like a reasonable thing to always be checking.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 0669d32..1486721 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -46,7 +46,7 @@ GZIP        = gzip -9 -c
 INSTALL_PROGRAM = install
 
 ifndef RPM_OPT_FLAGS
-	RPM_OPT_FLAGS = -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
+	RPM_OPT_FLAGS = -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4
 endif
 
 OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
-- 
1.8.3.1
