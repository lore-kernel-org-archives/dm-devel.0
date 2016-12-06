From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: Replace -fstack-protector
	with -fstack-protector-strong
Date: Tue,  6 Dec 2016 02:26:26 +0100
Message-ID: <20161206012627.10415-2-xose.vazquez@gmail.com>
References: <20161206012627.10415-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161206012627.10415-1-xose.vazquez@gmail.com>
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

-fstack-protector-strong
    Like -fstack-protector but includes additional functions to be protected
    --- those that have local array definitions, or have references to local
    frame addresses.

gcc-4.9.0(April 22, 2014) required.

This flag is used by default in Fedora:
https://pagure.io/fesco/issue/1128

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index e7f4e05..fa3c595 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -63,7 +63,7 @@ INSTALL_PROGRAM	= install
 
 OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 \
 		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
-		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector \
+		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong \
 		  --param=ssp-buffer-size=4
 
 CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
-- 
2.11.0
