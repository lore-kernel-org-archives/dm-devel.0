From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] dm: Integrity errors should not cause failover
Date: Wed, 18 May 2011 00:49:49 -0400
Message-ID: <yq18vu4fw9e.fsf@sermon.lab.mkp.net>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


Integrity errors need to be passed to the owner of the integrity
metadata for processing. Consequently EILSEQ should be passed up the
stack.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>

---

Ping on this one?

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
