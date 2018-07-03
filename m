From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/9] dm-integrity: report size in the status
Date: Tue, 03 Jul 2018 20:13:28 +0200
Message-ID: <20180703181358.125843920@debian-a64.vm>
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
To: Milan Broz <mbroz@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Report provided data sectors in the status.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-06-29 23:14:00.170000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-06-29 23:14:00.170000000 +0200
@@ -2298,7 +2298,9 @@ static void dm_integrity_status(struct d
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%llu", (unsigned long long)atomic64_read(&ic->number_of_mismatches));
+		DMEMIT("%llu %llu",
+			(unsigned long long)atomic64_read(&ic->number_of_mismatches),
+			(unsigned long long)ic->provided_data_sectors);
 		break;
 
 	case STATUSTYPE_TABLE: {
