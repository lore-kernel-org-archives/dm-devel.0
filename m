From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/2] dm-flakey: Check for null arg_name
Date: Sun,  3 Dec 2017 21:14:12 -0600
Message-ID: <20171204031412.2435-2-rgoldwyn@suse.de>
References: <20171204031412.2435-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171204031412.2435-1-rgoldwyn@suse.de>
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
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

One can crash dm-flakey by specifying more number of feature arguments
than the number of features supplied. Checking for null in arg_name
avoids this.

dmsetup create flakey-test --table "0 66076080 flakey /dev/sdb9 0 0 180 2 \
drop_writes"

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/dm-flakey.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index e18c29672a88..995b69e98f9f 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -70,6 +70,11 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
+		if (!arg_name) {
+			ti->error = "Insufficient feature arguments";
+			return -EINVAL;
+		}
+
 		/*
 		 * drop_writes
 		 */
-- 
2.14.2
