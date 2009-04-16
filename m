From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] crash in multipath argument parsing
Date: Thu, 16 Apr 2009 19:48:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904161948210.312@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904161947370.312@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904161947370.312@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Fix possible parsing error in hw handlers.

When making the previous patch I reviewed the code and found a similar
possible crash in hardware handler parsing. I didn't try it though, because
I don't have hardware multipath.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-mpath.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-mpath.c	2009-04-10 06:33:57.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-mpath.c	2009-04-10 06:34:00.000000000 +0200
@@ -705,6 +705,11 @@ static int parse_hw_handler(struct arg_s
 	if (!hw_argc)
 		return 0;
 
+	if (hw_argc > as->argc) {
+		ti->error = "not enough arguments for hardware handler";
+		return -EINVAL;
+	}
+
 	m->hw_handler_name = kstrdup(shift(as), GFP_KERNEL);
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
