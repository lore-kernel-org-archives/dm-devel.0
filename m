From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] multipath: fixup check for out-of-scope maps
Date: Tue,  9 Aug 2016 09:31:13 +0200
Message-ID: <1470727873-10502-4-git-send-email-hare@suse.de>
References: <1470727873-10502-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470727873-10502-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

The 'wwid' in struct multipath is a static array, so a check for
the existence of 'wwid' is pointless. We should rather check if
the argument 'refwwid' is not NULL and has a length larger then '0'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipath/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 93376a9..ee00fdbd 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -212,7 +212,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 		/*
 		 * discard out of scope maps
 		 */
-		if (mpp->wwid && refwwid &&
+		if (refwwid && strlen(refwwid) &&
 		    strncmp(mpp->wwid, refwwid, WWID_SIZE)) {
 			condlog(3, "skip map %s: out of scope", mpp->alias);
 			free_multipath(mpp, KEEP_PATHS);
-- 
2.6.6
