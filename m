From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH] dm integrity: Reject mappings too large for
	device
Date: Mon,  5 Jun 2017 17:52:39 +0200
Message-ID: <20170605155239.12223-1-omosnacek@gmail.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, Ondrej Mosnacek <omosnacek@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Before this patch, dm-integrity would successfully create mappings with
the number of sectors greater than the provided data sector count.
Attempts to read sectors of this mapping that were beyond the provided
data sector count would then yield run-time messages of the form
"device-mapper: integrity: Too big sector number: ...".

This patch fixes this by emitting an error when the requested mapping
size is bigger than the provided data sector count.

Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 drivers/md/dm-integrity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 7910bfe50da4..4ab10cf718c9 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3040,6 +3040,11 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		ti->error = "The device is too small";
 		goto bad;
 	}
+	if (ti->len > ic->provided_data_sectors) {
+		r = -EINVAL;
+		ti->error = "Not enough provided sectors for requested mapping size";
+		goto bad;
+	}
 
 	if (!buffer_sectors)
 		buffer_sectors = 1;
-- 
2.11.0
