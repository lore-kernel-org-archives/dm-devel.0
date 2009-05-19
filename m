From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] Add 'suspended' item in dm's sysfs directory
Date: Tue, 19 May 2009 10:16:52 +0200
Message-ID: <4A126AF4.9030303@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Expose DM device's suspended state information through a file named
'suspended' in dm directory under sysfs. The value is 0 for active
state and 1 for suspended state.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>

---
 drivers/md/dm-sysfs.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index a2a45e6..4b04590 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -57,12 +57,21 @@ static ssize_t dm_attr_uuid_show(struct mapped_device *md, char *buf)
 	return strlen(buf);
 }
 
+static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
+{
+	sprintf(buf, "%d\n", dm_suspended(md));
+
+	return strlen(buf);
+}
+
 static DM_ATTR_RO(name);
 static DM_ATTR_RO(uuid);
+static DM_ATTR_RO(suspended);
 
 static struct attribute *dm_attrs[] = {
 	&dm_attr_name.attr,
 	&dm_attr_uuid.attr,
+	&dm_attr_suspended.attr,
 	NULL,
 };
