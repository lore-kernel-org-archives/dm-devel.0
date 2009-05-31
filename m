From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Do not process sysfs attributes when device is
	being destructed
Date: Sun, 31 May 2009 22:55:00 +0200
Message-ID: <4A22EEA4.5010708@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Do not process sysfs attributes when device is being destructed.

Otherwise code can cause 
  BUG_ON(test_bit(DMF_FREEING, &md->flags));
in dm_put() call.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f43b099..9d3595b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1806,6 +1806,10 @@ struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 	if (&md->kobj != kobj)
 		return NULL;
 
+	if (test_bit(DMF_FREEING, &md->flags) ||
+	    test_bit(DMF_DELETING, &md->flags))
+		return NULL;
+
 	dm_get(md);
 	return md;
 }
