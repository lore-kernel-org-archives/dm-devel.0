From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] dm: fix dm-log-userspace printk format
Date: Fri, 19 Jun 2009 11:24:18 -0700
Message-ID: <4A3BD7D2.6020803@oracle.com>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090619172622.05adb236.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Brassow <dm-devel@redhat.com>dm-devel@redhat.com
List-Id: dm-devel.ids

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/md/dm-log-userspace-transfer.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Brassow <dm-devel@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090619.orig/drivers/md/dm-log-userspace-transfer.c
+++ linux-next-20090619/drivers/md/dm-log-userspace-transfer.c
@@ -108,7 +108,7 @@ static int fill_pkg(struct cn_msg *msg, 
 				*(pkg->data_size) = 0;
 		} else if (tfr->data_size > *(pkg->data_size)) {
 			DMERR("Insufficient space to receive package [%u] "
-			      "(%u vs %lu)", tfr->request_type,
+			      "(%u vs %zu)", tfr->request_type,
 			      tfr->data_size, *(pkg->data_size));
 
 			*(pkg->data_size) = 0;


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
