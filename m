From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/4] libmultipath: fix over-long NVME WWIDs
Date: Tue, 18 Jul 2017 09:29:16 +0200
Message-ID: <20170718072916.24275-5-mwilck@suse.com>
References: <20170718072916.24275-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170718072916.24275-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-nvme@lists.infradead.org, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

Fix for NVME wwids looking like this (line continuations inserted here
for readability):

nvme.0000-3163653363666438366239656630386200-\
4c696e75780000000000000000000000000000000000000000000000000000000000000000000000-\
00000002

which are encountered in some combinations of Linux NVME host and target,
where the 2nd field represents the serial number (SN) and the 3rd the
model number (MN).

The device mapper allows map names only up to 128 characters.
Strip the "00" sequences at the end of the serial and model field,
they are hex-encoded 0-bytes which are forbidden by the NVME spec
anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>
---
 libmultipath/discovery.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 419a148b..17ab1913 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1598,6 +1598,82 @@ get_prio (struct path * pp)
 	return 0;
 }
 
+/*
+ * Mangle string of length *len starting at start
+ * by removing character sequence "00" (hex for a 0 byte),
+ * starting at end, backwards.
+ * Changes the value of *len if characters were removed.
+ * Returns a pointer to the position where "end" was moved to.
+ */
+static char
+*skip_zeroes_backward(char* start, int *len, char *end)
+{
+	char *p = end;
+
+	while (p >= start + 2 && *(p - 1) == '0' && *(p - 2) == '0')
+		p -= 2;
+
+	if (p == end)
+		return p;
+
+	memmove(p, end, start + *len + 1 - end);
+	*len -= end - p;
+
+	return p;
+}
+
+/*
+ * Fix for NVME wwids looking like this:
+ * nvme.0000-3163653363666438366239656630386200-4c696e75780000000000000000000000000000000000000000000000000000000000000000000000-00000002
+ * which are encountered in some combinations of Linux NVME host and target.
+ * The '00' are hex-encoded 0-bytes which are forbidden in the serial (SN)
+ * and model (MN) fields. Discard them.
+ * If a WWID of the above type is found, sets pp->wwid and returns a value > 0.
+ * Otherwise, returns 0.
+ */
+static int
+fix_broken_nvme_wwid(struct path *pp, const char *value, int size)
+{
+	static const char _nvme[] = "nvme.";
+	int len, i;
+	char mangled[256];
+	char *p;
+
+	len = strlen(value);
+	if (len >= sizeof(mangled))
+		return 0;
+
+	/* Check that value starts with "nvme.%04x-" */
+	if (memcmp(value, _nvme, sizeof(_nvme) - 1) || value[9] != '-')
+		return 0;
+	for (i = 5; i < 9; i++)
+		if (!isxdigit(value[i]))
+			return 0;
+
+	memcpy(mangled, value, len + 1);
+
+	/* search end of "model" part and strip trailing '00' */
+	p = memrchr(mangled, '-', len);
+	if (p == NULL)
+		return 0;
+
+	p = skip_zeroes_backward(mangled, &len, p);
+
+	/* search end of "serial" part */
+	p = memrchr(mangled, '-', p - mangled);
+	if (p == NULL || memrchr(mangled, '-', p - mangled) != mangled + 9)
+	    /* We expect exactly 3 '-' in the value */
+		return 0;
+
+	p = skip_zeroes_backward(mangled, &len, p);
+	if (len >= size)
+		return 0;
+
+	memcpy(pp->wwid, mangled, len + 1);
+	condlog(2, "%s: over-long WWID shortened to %s", pp->dev, pp->wwid);
+	return len;
+}
+
 static int
 get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 {
@@ -1610,6 +1686,9 @@ get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 	if (value && strlen(value)) {
 		len = strlcpy(pp->wwid, value, WWID_SIZE);
 		if (len >= WWID_SIZE) {
+			len = fix_broken_nvme_wwid(pp, value, WWID_SIZE);
+			if (len > 0)
+				return len;
 			condlog(0, "%s: wwid overflow", pp->dev);
 			len = WWID_SIZE;
 		}
-- 
2.13.2
