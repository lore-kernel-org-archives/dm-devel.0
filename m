From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/2] multipath: Build with standard rpm cflags
Date: Thu, 24 May 2012 23:57:42 -0500
Message-ID: <1337921863-26482-2-git-send-email-bmarzins@redhat.com>
References: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
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

This patch makes multipath build with the standard redhat rpm cflags, which
can help catch some code errors.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 02aef4f..b0c68f4 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -38,7 +38,11 @@ mpathpersistdir = $(TOPDIR)/libmpathpersist
 GZIP        = /bin/gzip -9 -c
 INSTALL_PROGRAM = install
 
-OPTFLAGS     = -pipe -g -Wall -Wunused -Wstrict-prototypes
+ifndef RPM_OPT_FLAGS
+	RPM_OPT_FLAGS = -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
+endif
+
+OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
 CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\"
 SHARED_FLAGS = -shared
 
-- 
1.7.7
