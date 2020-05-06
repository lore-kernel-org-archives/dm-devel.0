From: Christian Hesse <list@eworm.de>
Subject: [PATCH 1/2] libmpathpersist: depend on libmultipath
Date: Wed,  6 May 2020 09:35:47 +0200
Message-ID: <20200506073548.41756-1-list@eworm.de>
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
To: dm-devel@redhat.com
Cc: Christian Hesse <mail@eworm.de>
List-Id: dm-devel.ids

From: Christian Hesse <mail@eworm.de>

Without this the build fails with:

/usr/bin/ld: cannot find -lmultipath

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1dee3680..ba1d73ba 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ all:	$(BUILDDIRS)
 $(BUILDDIRS):
 	$(MAKE) -C $@
 
-multipath multipathd mpathpersist: libmultipath
+libmpathpersist multipath multipathd mpathpersist: libmultipath
 mpathpersist:  libmpathpersist
 
 $(BUILDDIRS.clean):
