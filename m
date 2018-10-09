From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 18/19] libmultipath: Don't blank intialized
	paths
Date: Tue,  9 Oct 2018 18:03:15 -0500
Message-ID: <1539126196-28926-19-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

When pathinfo fails for some likely transient reason, it clears the path
wwid, but otherwise returns successfully, to keep the path around but
not usable until it gets fully initialized. However, if the path has
already been initialized, and pathinfo hits a transient error, it
shouldn't clear the wwid.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 301093f..b267f07 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2004,9 +2004,9 @@ blank:
 	/*
 	 * Recoverable error, for example faulty or offline path
 	 */
-	memset(pp->wwid, 0, WWID_SIZE);
 	pp->chkrstate = pp->state = PATH_DOWN;
-	pp->initialized = INIT_FAILED;
+	if (pp->initialized == INIT_FAILED)
+		memset(pp->wwid, 0, WWID_SIZE);
 
 	return PATHINFO_OK;
 }
-- 
2.7.4
