From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/5] multipath-tools: delete spec/rpm traces from
	Makefile
Date: Thu, 30 Jun 2016 15:42:12 +0200
Message-ID: <1467294136-19275-2-git-send-email-xose.vazquez@gmail.com>
References: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
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

spec file was deleted time ago.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Makefile b/Makefile
index 06f50c8..bd7cfc1 100644
--- a/Makefile
+++ b/Makefile
@@ -60,8 +60,6 @@ recurse_uninstall:
 	done
 
 clean:	recurse_clean
-	rm -f multipath-tools.spec
-	rm -rf rpms
 
 install:	recurse_install
 
@@ -73,10 +71,3 @@ TAGS:
 	etags -a libmultipath/*.h
 	etags -a multipathd/*.c
 	etags -a multipathd/*.h
-
-release:
-	sed -e "s/__VERSION__/${VERSION}/" \
-	multipath-tools.spec.in > multipath-tools.spec
-
-rpm: release
-	rpmbuild -bb multipath-tools.spec
-- 
2.7.4
