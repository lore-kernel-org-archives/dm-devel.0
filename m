From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/57] multipath: use option '-i' when called
	from udev
Date: Wed, 27 Apr 2016 13:10:23 +0200
Message-ID: <1461755458-29225-23-git-send-email-hare@suse.de>
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

multipath should be using the option '-i' to ignore the wwids
file when called from udev. Otherwise we might run into a race
condition with systemd and the system might not boot up correctly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index c8fb7e6..6b0d1cd 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -15,7 +15,7 @@ ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
 ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
-	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
+	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -i -u %k", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="none", \
 	ENV{SYSTEMD_READY}="0"
 
-- 
2.6.6
