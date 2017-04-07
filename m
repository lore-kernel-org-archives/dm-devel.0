From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/9] libdmmp: don't disconnect from multipathd
	twice
Date: Fri,  7 Apr 2017 01:16:32 -0500
Message-ID: <1491545798-22183-4-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

libdmmp already disconnects from multipathd at the end of the
dmmp_mpath_array_get, so it doesn't need to do it earlier in the
function as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libdmmp/libdmmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index e29a639..3906335 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -174,7 +174,6 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 		errno_save = errno;
 		memset(errno_str_buff, 0, _ERRNO_STR_BUFF_SIZE);
 		strerror_r(errno_save, errno_str_buff, _ERRNO_STR_BUFF_SIZE);
-		mpath_disconnect(socket_fd);
 		if (errno_save == ETIMEDOUT) {
 			rc = DMMP_ERR_IPC_TIMEOUT;
 			_error(ctx, "IPC communication timeout, try to "
-- 
1.8.3.1
