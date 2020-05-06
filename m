From: Christian Hesse <list@eworm.de>
Subject: [PATCH 2/2] libmultipath: create libdir on install
Date: Wed,  6 May 2020 09:35:48 +0200
Message-ID: <20200506073548.41756-2-list@eworm.de>
References: <20200506073548.41756-1-list@eworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200506073548.41756-1-list@eworm.de>
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

Without this installation fails with:

install: target '$DESTDIR/usr/lib/multipath' is not a directory
Signed-off-by: Christian Hesse <mail@eworm.de>
---
 libmultipath/prioritizers/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 9d0fe03c..11da5be2 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -35,6 +35,7 @@ libprio%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
 install: $(LIBS)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libdir)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
 
 uninstall:
