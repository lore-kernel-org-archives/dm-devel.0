From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] dm: Integrity errors should not cause failover
Date: Tue, 08 Mar 2011 01:54:00 -0500
Message-ID: <yq1aah6drw7.fsf@sermon.lab.mkp.net>
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
List-Id: dm-devel.ids


Integrity errors need to be passed to the owner of the integrity
metadata for processing. Consequently EILSEQ should be passed up the
stack.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f336c69..57f7dd3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1215,7 +1215,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP)
+	if (error == -EOPNOTSUPP || error == -EILSEQ)
 		return error;
 
 	if (mpio->pgpath)
