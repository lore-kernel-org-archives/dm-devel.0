From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 13/25] dm io:ctl remove vmalloc void cast
Date: Fri, 12 Oct 2007 18:18:58 +0100
Message-ID: <20071012171858.GY24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Jesper Juhl <jesper.juhl@gmail.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/md/dm-ioctl.c::copy_params() there's a call to vmalloc()
where we currently cast the return value, but that's pretty pointless
given that vmalloc() returns "void *".

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-ioctl.c	2007-10-12 13:15:29.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-ioctl.c	2007-10-12 13:18:07.000000000 +0100
@@ -1358,7 +1358,7 @@ static int copy_params(struct dm_ioctl _
 	if (tmp.data_size < sizeof(tmp))
 		return -EINVAL;
 
-	dmi = (struct dm_ioctl *) vmalloc(tmp.data_size);
+	dmi = vmalloc(tmp.data_size);
 	if (!dmi)
 		return -ENOMEM;
 
