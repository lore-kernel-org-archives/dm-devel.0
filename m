From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 3/8] dm-integrity: report size in the status
Date: Tue, 01 May 2018 15:55:19 +0200
Message-ID: <20180501135601.700507424@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-report-size.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Report provided data sectors in the status.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-01-31 13:43:07.701126000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2018-02-01 20:38:17.038213000 +0100
@@ -2243,7 +2243,9 @@ static void dm_integrity_status(struct d
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%llu", (unsigned long long)atomic64_read(&ic->number_of_mismatches));
+		DMEMIT("%llu %llu",
+			(unsigned long long)atomic64_read(&ic->number_of_mismatches),
+			(unsigned long long)ic->provided_data_sectors);
 		break;
 
 	case STATUSTYPE_TABLE: {
