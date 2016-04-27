From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 42/57] Use multipath wwid if path wwid is empty
Date: Wed, 27 Apr 2016 13:10:43 +0200
Message-ID: <1461755458-29225-43-git-send-email-hare@suse.de>
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

During booting udev might not be fully initialized, causing
it to not return any information for a path.
The multipath map, however, would still be present.
In these cases we should use the multipath map as the
path wwid to avoid spurious path failures during boot.
The situation will be corrected anyway as udev will
be sending out the 'real' events very soon after.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dmparser.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 2209b2d..c19c5d2 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -336,10 +336,16 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 					goto out1;
 
 				strncpy(pp->dev_t, word, BLK_DEV_SIZE);
-
+				if (strlen(mpp->wwid)) {
+					strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
+				}
 				/* Only call this in multipath client mode */
 				if (!conf->daemon && store_path(pathvec, pp))
 					goto out1;
+			} else {
+				if (!strlen(pp->wwid) &&
+				    strlen(mpp->wwid))
+					strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
 			}
 			FREE(word);
 
-- 
2.6.6
