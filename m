From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/3] dm-ioctl: report event number in
	DM_LIST_DEVICES
Date: Tue,  9 May 2017 12:10:28 -0700
Message-ID: <20170509191028.6898-4-agrover@redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170509191028.6898-1-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

This patch reports the event numbers for all the devices, so that the
user doesn't have to ask them one by one. The event number is reported
after the name field in the dm_name_list structure.

The location of the next record is specified in the dm_name_list->next
field, that means that we can put the new data after the end of name and
it is backward compatible with the old code. The old code just skips the
event number without interpreting it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 84930a3..0029776 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -518,6 +518,7 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 			needed += sizeof(struct dm_name_list);
 			needed += strlen(hc->name) + 1;
 			needed += ALIGN_MASK;
+			needed += (sizeof(uint32_t) + ALIGN_MASK) & ~ALIGN_MASK;
 		}
 	}
 
@@ -538,6 +539,7 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 	 */
 	for (i = 0; i < NUM_BUCKETS; i++) {
 		list_for_each_entry (hc, _name_buckets + i, name_list) {
+			uint32_t *event_nr;
 			if (old_nl)
 				old_nl->next = (uint32_t) ((void *) nl -
 							   (void *) old_nl);
@@ -547,7 +549,9 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 			strcpy(nl->name, hc->name);
 
 			old_nl = nl;
-			nl = align_ptr(((void *) ++nl) + strlen(hc->name) + 1);
+			event_nr = align_ptr(((void *) (nl + 1)) + strlen(hc->name) + 1);
+			*event_nr = dm_get_event_nr(hc->md);
+			nl = align_ptr(event_nr + 1);
 		}
 	}
 
-- 
2.9.3
