From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 35/39] libmultipath: mark return value from dup()
	as unused
Date: Thu, 16 Jun 2016 11:47:41 +0200
Message-ID: <1466070465-1021-36-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

We are redirecting stderr, and can safely ignore any
errors from dup() here. So mark the return value as
unused.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/callout.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/callout.c b/libmultipath/callout.c
index d671b0c..4d1b067 100644
--- a/libmultipath/callout.c
+++ b/libmultipath/callout.c
@@ -76,8 +76,10 @@ int execute_program(char *path, char *value, int len)
 		/* Ignore writes to stderr */
 		null_fd = open("/dev/null", O_WRONLY);
 		if (null_fd > 0) {
+			int err_fd __attribute__ ((unused));
+
 			close(STDERR_FILENO);
-			retval = dup(null_fd);
+			err_fd = dup(null_fd);
 			close(null_fd);
 		}
 
-- 
2.6.6
