From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: integrity errors should not cause
	failover
Date: Mon, 28 Mar 2011 15:37:10 -0400
Message-ID: <1301341030-28997-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Integrity errors need to be passed to the owner of the integrity
metadata for processing. Consequently EILSEQ should be passed up the
stack.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

[resubmitting to dm-devel to get this in through the DM tree, next
merge window, now that this change missed the 2.6.39 merge window]

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a550a05..aa4e570 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1290,7 +1290,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
 		return error;
 
 	if (mpio->pgpath)
