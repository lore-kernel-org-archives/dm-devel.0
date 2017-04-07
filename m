From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/9] libdmmp: move libdmmp.pc install location
Date: Fri,  7 Apr 2017 01:16:34 -0500
Message-ID: <1491545798-22183-6-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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

/usr/share/pkgconfig is for non-architecture specific modules, and
/usr/lib/pkgconfig is for architecture specific modules. libdmmp.pc is
architecture specific, so it belongs in /usr/lib/pkgconfig

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index c8b1142..8361e6c 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -62,7 +62,7 @@ mpathcmddir	= $(TOPDIR)/libmpathcmd
 thirdpartydir	= $(TOPDIR)/third-party
 libdmmpdir	= $(TOPDIR)/libdmmp
 includedir	= $(prefix)/usr/include
-pkgconfdir	= $(prefix)/usr/share/pkgconfig
+pkgconfdir	= $(prefix)/$(LIB)/pkgconfig
 
 GZIP		= gzip -9 -c
 RM		= rm -f
-- 
1.8.3.1
