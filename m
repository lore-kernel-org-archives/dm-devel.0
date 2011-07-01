From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] dm-ioctl: Don't allow multiple device
	specifiers
Date: Fri, 1 Jul 2011 15:05:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107011505230.32620@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-ioctl: Don't allow multiple device specifiers

Exactly one of name, uuid, device has to be specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.39-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-ioctl.c	2011-07-01 19:52:31.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-ioctl.c	2011-07-01 19:53:04.000000000 +0200
@@ -739,10 +739,16 @@ static struct hash_cell *__find_device_h
 	struct hash_cell *hc = NULL;
 
 	if (*param->uuid) {
+		if (*param->name || param->dev)
+			return NULL;
+
 		hc = __get_uuid_cell(param->uuid);
 		if (!hc)
 			return NULL;
 	} else if (*param->name) {
+		if (param->dev)
+			return NULL;
+
 		hc = __get_name_cell(param->name);
 		if (!hc)
 			return NULL;
