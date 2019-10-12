From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 38/72] multipathd: use -Wno-unused-parameter for
 cli_handlers.c
Date: Sat, 12 Oct 2019 21:28:24 +0000
Message-ID: <20191012212703.12989-39-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This file contains many handlers that don't use all their arguments.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/Makefile b/multipathd/Makefile
index d1a98637..8d901178 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -36,6 +36,9 @@ $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
+cli_handlers.o:	cli_handlers.c
+	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
+
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
-- 
2.23.0
