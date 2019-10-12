From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 37/72] libmultipath: use -Wno-unused-parameter
	for dict.c
Date: Sat, 12 Oct 2019 21:28:23 +0000
Message-ID: <20191012212703.12989-38-martin.wilck@suse.com>
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

This file contains just too many "handler" and "snprintf" methods
which don't use every argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index a2be42ea..e5651e49 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -50,6 +50,11 @@ all: $(LIBS)
 nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
 	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
 
+# there are lots of "unused parameters" in dict.c
+# because not all handler / snprint methods nees all parameters
+dict.o:	dict.c
+	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
+
 make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
 
 nvme-ioctl.c: nvme/nvme-ioctl.c
-- 
2.23.0
