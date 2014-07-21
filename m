From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: revert fstack-protector-strong gcc
	option
Date: Mon, 21 Jul 2014 18:12:57 -0500
Message-ID: <1405984377-26466-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

In my "enable gcc format-security check" (9b7741c) commit, I changed
fstack-protector to fstack-protector-strong. This new option only exists
in gcc 4.9, which is relatively new.  This patch reverts to the
fstack-protector option for now, until gcc 4.9 has been around for longer.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 1486721..20ae23e 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -46,7 +46,7 @@ GZIP        = gzip -9 -c
 INSTALL_PROGRAM = install
 
 ifndef RPM_OPT_FLAGS
-	RPM_OPT_FLAGS = -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4
+	RPM_OPT_FLAGS = -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
 endif
 
 OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
-- 
1.8.3.1
