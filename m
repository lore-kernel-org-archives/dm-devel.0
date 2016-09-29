From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 05/10] dm snapshot: Delete unnecessary variable
 initialisations in pending_complete()
Date: Thu, 29 Sep 2016 11:13:14 +0200
Message-ID: <9cb9e644-7d2e-0630-f26b-2143fc82eea6@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 29 Sep 2016 08:25:47 +0200

Three local variables will be set to an appropriate pointer a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-snap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index a6b797f..7bbd3c4 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1450,9 +1450,9 @@ static void pending_complete(void *context, int success)
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
-	struct bio *origin_bios = NULL;
-	struct bio *snapshot_bios = NULL;
-	struct bio *full_bio = NULL;
+	struct bio *origin_bios;
+	struct bio *snapshot_bios;
+	struct bio *full_bio;
 	int error = 0;
 
 	if (!success) {
-- 
2.10.0

