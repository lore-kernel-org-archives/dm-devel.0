From: Jose Castillo <jcastillo@redhat.com>
Subject: [RFC PATCH] dm-multipath: Print more explicit warnings
	when dealing with multipath messages
Date: Wed, 29 Jan 2014 17:52:45 +0100
Message-ID: <1391014365-4180-1-git-send-email-jcastillo@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The following warning message "Unrecognised multipath message received" is displayed
in two different situations inside the function multipath_message: when
the number of arguments passed is invalid and when the string passed in argv[0]
is not recognized. With this patch, both warnings are more specific to each case
and is easier to identify where the problem is.

Signed-off-by: Jose Castillo <jcastillo@redhat.com>
---
 drivers/md/dm-mpath.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6eb9dc9..95c4044 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1552,7 +1552,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (argc != 2) {
-		DMWARN("Unrecognised multipath message received.");
+		DMWARN("Invalid multipath message arguments. Expected 2 arguments, got %d.", argc);
 		goto out;
 	}
 
@@ -1570,7 +1570,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 	else if (!strcasecmp(argv[0], "fail_path"))
 		action = fail_path;
 	else {
-		DMWARN("Unrecognised multipath message received.");
+		DMWARN("Unrecognised multipath message received: %s", argv[0]);
 		goto out;
 	}
 
-- 
1.8.4.2
