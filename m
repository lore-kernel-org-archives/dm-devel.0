From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/78] Revert 'return PATH_DOWN for quiesced
	paths'
Date: Mon, 16 Mar 2015 13:36:19 +0100
Message-ID: <1426509425-15978-33-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

Has been superseded by commit 00a2549a42707e5e1ef51ef6f638dc5ceaa15740

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6d6a508..cf37813 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -958,7 +958,6 @@ path_offline (struct path * pp)
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
 	if (!strncmp(buff, "offline", 7) ||
-	    !strncmp(buff, "quiesce", 7) ||
 	    !strncmp(buff, "transport-offline", 17)) {
 		pp->offline = 1;
 		return PATH_DOWN;
-- 
1.8.4.5
