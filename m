From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/57] 11-dm-mpath.rules: Only import ID_FS_XXX
	variables if not set
Date: Wed, 27 Apr 2016 13:10:27 +0200
Message-ID: <1461755458-29225-27-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

We should only import ID_FS_XXX variables if they are not set,
otherwise we might be overwriting existing results.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/11-dm-mpath.rules | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 2e7076d..5559af3 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -7,11 +7,11 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 # We'd like to avoid this, especially within udev processing.
 ENV{DM_NR_VALID_PATHS}!="?*", IMPORT{db}="DM_NR_VALID_PATHS"
 ENV{DM_NR_VALID_PATHS}!="0", GOTO="mpath_blkid_end"
-IMPORT{db}="ID_FS_TYPE"
-IMPORT{db}="ID_FS_USAGE"
-IMPORT{db}="ID_FS_UUID"
-IMPORT{db}="ID_FS_UUID_ENC"
-IMPORT{db}="ID_FS_VERSION"
+ENV{ID_FS_TYPE}!="?*", IMPORT{db}="ID_FS_TYPE"
+ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
+ENV{ID_FS_UUID}!="?*", IMPORT{db}="ID_FS_UUID"
+ENV{ID_FS_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
+ENV{ID_FS_VERSION}!="?*", IMPORT{db}="ID_FS_VERSION"
 LABEL="mpath_blkid_end"
 
 # Also skip all foreign rules if no path is available.
-- 
2.6.6
