From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/39] libmultipath: Ignore errors from fcntl()
	in directio.c
Date: Thu, 16 Jun 2016 11:47:42 +0200
Message-ID: <1466070465-1021-37-git-send-email-hare@suse.de>
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

Mark the return value from fcntl() as unused to avoid compiler
warnings.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/checkers/directio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 46fe6a7..94bf8f7 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -104,9 +104,11 @@ void libcheck_free (struct checker * c)
 
 	if (ct->reset_flags) {
 		if ((flags = fcntl(c->fd, F_GETFL)) >= 0) {
+			int ret __attribute__ ((unused));
+
 			flags &= ~O_DIRECT;
 			/* No point in checking for errors */
-			fcntl(c->fd, F_SETFL, flags);
+			ret = fcntl(c->fd, F_SETFL, flags);
 		}
 	}
 
-- 
2.6.6
