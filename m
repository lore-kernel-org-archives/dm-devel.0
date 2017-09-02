From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 22/31] multipath.rules: set ID_FS_TYPE to
	"mpath_member"
Date: Sun,  3 Sep 2017 00:38:51 +0200
Message-ID: <20170902223900.7339-23-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

... for devices that have been identified as such.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 86defc0c..bc1a8529 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -21,7 +21,7 @@ TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
 ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
 	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
-	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="none", \
+	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="mpath_member", \
 	ENV{SYSTEMD_READY}="0"
 
 LABEL="end_mpath"
-- 
2.14.0
