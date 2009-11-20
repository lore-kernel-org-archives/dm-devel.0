From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/4] dm-mpath: reject message when the device is
	suspended
Date: Fri, 20 Nov 2009 16:15:25 +0900
Message-ID: <4B06420D.3070702@ct.jp.nec.com>
References: <4B06408A.1080700@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B06408A.1080700@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch rejects messages that can generate I/O while the device itself
is suspended.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6.32-rc7/drivers/md/dm-mpath.c
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm-mpath.c
+++ 2.6.32-rc7/drivers/md/dm-mpath.c
@@ -1421,6 +1421,11 @@ static int multipath_message(struct dm_t
 
 	mutex_lock(&m->work_mutex);
 
+	if (dm_suspended(ti)) {
+		r = -EBUSY;
+		goto out;
+	}
+
 	if (argc == 1) {
 		if (!strnicmp(argv[0], MESG_STR("queue_if_no_path"))) {
 			r = queue_if_no_path(m, 1, 0);
