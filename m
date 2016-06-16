From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/39] libmultipath: memory leak in iet.c
Date: Thu, 16 Jun 2016 11:47:23 +0200
Message-ID: <1466070465-1021-18-git-send-email-hare@suse.de>
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

'pmatch' was never freed.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/prioritizers/iet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 0bcc48b..3549665 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -59,10 +59,11 @@ char *find_regex(char * string, char * regex)
 				if (result) {
 					strncpy(result, &string[start], size);
 					result[size] = '\0';
+					free(pmatch);
 					return result;
 				}
 			}
-			else return NULL;
+			free(pmatch);
 		}
 	}
 	return NULL;
-- 
2.6.6
