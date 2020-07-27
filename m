From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6/6] multipath: deal with delegation failures
	correctly
Date: Mon, 27 Jul 2020 14:24:28 -0500
Message-ID: <1595877868-5595-7-git-send-email-bmarzins@redhat.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

delegate_to_multipathd() was returning success, even if the multipathd
command failed. Also, if the command was set to fail with NOT_DELEGATED,
it shouldn't print any errors, since multipath will try to issue to
command itself.

Fixes: "multipath: delegate flushing maps to multipathd"
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 4c43314e..3da692dc 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -861,9 +861,12 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 		goto out;
 	}
 
-	if (reply != NULL && *reply != '\0' && strcmp(reply, "ok\n"))
-		printf("%s", reply);
-	r = DELEGATE_OK;
+	if (reply != NULL && *reply != '\0') {
+		if (strcmp(reply, "fail\n"))
+			r = DELEGATE_OK;
+		if (r != NOT_DELEGATED && strcmp(reply, "ok\n"))
+			printf("%s", reply);
+	}
 
 out:
 	FREE(reply);
-- 
2.17.2
