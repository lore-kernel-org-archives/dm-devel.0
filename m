From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 01/18] Adding fflush after yes/no prompt
Date: Mon,  2 Nov 2009 15:20:05 +0100
Message-ID: <1257171622-8380-2-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Add fflush in case the log is redirected to buffered file.
It might not be obvious why the application wait on stdin as the
prompt might not be flushed to the file without this patch.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 lib/display/display.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/display/display.c b/lib/display/display.c
index 5277743..a7ca9ec 100644
--- a/lib/display/display.c
+++ b/lib/display/display.c
@@ -824,6 +824,7 @@ char yes_no_prompt(const char *prompt, ...)
 			va_start(ap, prompt);
 			vprintf(prompt, ap);
 			va_end(ap);
+			fflush(stdout);
 		}
 
 		if ((c = getchar()) == EOF) {
-- 
1.6.5.1
