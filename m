From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH] dm-log: fix return value in create_log_context
	function
Date: Thu, 18 Dec 2008 16:23:51 -0500
Message-ID: <494ABF67.2030103@redhat.com>
References: <49372F1E.5060200@redhat.com> <494A8BD3.1020708@redhat.com>
	<1FD128DB-404C-4758-A276-6149DAAE8F74@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1FD128DB-404C-4758-A276-6149DAAE8F74@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Jon,

Thanks for reviewing this patch.

> We might also want to change the message in that case then too,  
> right?  Maybe "Unable to create disk io client"?

Thanks, "create disk io client" is better. But I changed as
"couldn't create disk io client" for consistency with other
messages.

Regards,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.



When dm_io_client_create function fails in create_log_context function,
return value is set to r but it is not used. r should be returned.
In addition, the warning message is properly corrected so that it doesn't
indicate memory allocation.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-log.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.28-rc8/drivers/md/dm-log.c
===================================================================
--- linux-2.6.28-rc8.orig/drivers/md/dm-log.c
+++ linux-2.6.28-rc8/drivers/md/dm-log.c
@@ -459,9 +459,9 @@ static int create_log_context(struct dm_
 								   PAGE_SIZE));
 		if (IS_ERR(lc->io_req.client)) {
 			r = PTR_ERR(lc->io_req.client);
-			DMWARN("couldn't allocate disk io client");
+			DMWARN("couldn't create disk io client");
 			kfree(lc);
-			return -ENOMEM;
+			return r;
 		}
 
 		lc->disk_header = vmalloc(buf_size);
