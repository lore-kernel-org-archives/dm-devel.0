From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/42] Accept several whitespaces in bindings file
Date: Tue,  8 Jan 2013 14:53:44 +0100
Message-ID: <1357653259-62650-7-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Prior versions of multipathd would accept several whitespaces
in the bindings file.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/alias.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index e1f3073..2b42606 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -99,7 +99,7 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 		curr_id = scan_devname(alias, prefix);
 		if (curr_id >= id)
 			id = curr_id + 1;
-		wwid = strtok(NULL, "");
+		wwid = strtok(NULL, " \t");
 		if (!wwid){
 			condlog(3,
 				"Ignoring malformed line %u in bindings file",
-- 
1.7.4.2
