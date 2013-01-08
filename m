From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/42] Syntax error in /etc/init.d/boot.multipath
Date: Tue,  8 Jan 2013 14:54:11 +0100
Message-ID: <1357653259-62650-34-git-send-email-hare@suse.de>
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

The multipath init script has a syntax error in line 113.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.init.suse |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/multipath/multipath.init.suse b/multipath/multipath.init.suse
index cc7c04b..c7cd5c7 100644
--- a/multipath/multipath.init.suse
+++ b/multipath/multipath.init.suse
@@ -110,7 +110,7 @@ case "$1" in
 		partlist=$(/sbin/kpartx -l -p _part /dev/disk/by-id/dm-name-$map | sed 's/\([^ ]*\) :.*/\1/p')
 		for part in $partlist; do
 		    [ -e /dev/disk/by-id/dm-name-$part ] && continue
-		    num$((num + 1))
+		    num=$((num + 1))
 		done
 	    done
 	    [ $num -eq 0 ] && break
-- 
1.7.4.2
