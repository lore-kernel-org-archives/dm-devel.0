From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/2] Allow zero priority groups
Date: Mon, 02 Jun 2008 10:52:23 +0200
Message-ID: <20080602085224.4393E18C717@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Alasdair Kergon <agk@redhat.com>
Cc: Christophe@suse.de, dm-devel@redhat.com, Varoqui@suse.de, christophe.varoqui@free.fr
List-Id: dm-devel.ids


Lower the number of valid priority groups to zero, as
this is a perfectly valid configuration.

Signed-off-by: Hannes Reinecke <hare@suse.de>
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e8f704a..1984f40 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -719,8 +719,8 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 {
 	/* target parameters */
 	static struct param _params[] = {
-		{1, 1024, "invalid number of priority groups"},
-		{1, 1024, "invalid initial priority group number"},
+		{0, 1024, "invalid number of priority groups"},
+		{0, 1024, "invalid initial priority group number"},
 	};
 
 	int r;
