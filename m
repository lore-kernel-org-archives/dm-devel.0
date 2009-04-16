From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] crash in multipath argument parsing
Date: Thu, 16 Apr 2009 19:48:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904161947370.312@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Fin a parsing crash with this command:

dmsetup create mpath --table "0 `blockdev --getsize /dev/mapper/cr0` multipath 0 0 2 1 round-robin 1000 0 1 1 /dev/mapper/cr0 round-robin 0 1 1 /dev/mapper/cr1 1000"
kernel BUG at drivers/md/dm-mpath.c:530!

The parser reads argument count as a number but doesn't check that sufficient
number of arguments is supplied. This triggers the bug.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-mpath.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-mpath.c	2009-04-10 06:33:51.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-mpath.c	2009-04-10 06:33:57.000000000 +0200
@@ -553,6 +553,11 @@ static int parse_path_selector(struct ar
 		dm_put_path_selector(pst);
 		return -EINVAL;
 	}
+	if (ps_argc > as->argc) {
+		dm_put_path_selector(pst);
+		ti->error = "not enough arguments for path selector";
+		return -EINVAL;
+	}
 
 	r = pst->create(&pg->ps, ps_argc, as->argv);
 	if (r) {
