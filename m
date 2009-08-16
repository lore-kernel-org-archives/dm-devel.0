From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] dm-log-userspace: fix  printk format warning
Date: Sun, 16 Aug 2009 07:33:30 -0700
Message-ID: <4A8818BA.2030309@oracle.com>
References: <alpine.LFD.2.01.0908131601100.3162@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0908131601100.3162@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/md/dm-log-userspace-transfer.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

Previously posted and acked, but apparently lost.
http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/02074.html

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2631-rc6.orig/drivers/md/dm-log-userspace-transfer.c
+++ lnx-2631-rc6/drivers/md/dm-log-userspace-transfer.c
@@ -108,7 +108,7 @@ static int fill_pkg(struct cn_msg *msg,
 				*(pkg->data_size) = 0;
 		} else if (tfr->data_size > *(pkg->data_size)) {
 			DMERR("Insufficient space to receive package [%u] "
-			      "(%u vs %lu)", tfr->request_type,
+			      "(%u vs %zu)", tfr->request_type,
 			      tfr->data_size, *(pkg->data_size));
 
 			*(pkg->data_size) = 0;
