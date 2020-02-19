From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 03/18] Fix leak in mpathpersist
Date: Wed, 19 Feb 2020 00:48:25 -0600
Message-ID: <1582094920-9883-4-git-send-email-bmarzins@redhat.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
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

If the persistent in command fails, the response buffer must be freed.
Found by Coverity

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 mpathpersist/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 56761668..28bfe410 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -499,6 +499,7 @@ static int handle_args(int argc, char * argv[], int nline)
 		if (ret != MPATH_PR_SUCCESS )
 		{
 			fprintf (stderr, "Persistent Reserve IN command failed\n");
+			free(resp);
 			goto out_fd;
 		}
 
-- 
2.17.2
