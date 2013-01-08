From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/42] libmultipath: error checking in
	remove_features()
Date: Tue,  8 Jan 2013 14:53:54 +0100
Message-ID: <1357653259-62650-17-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

An error check was missing in remove_features().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 88e8706..049f17d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -559,6 +559,9 @@ remove_feature(char **f, char *o)
 	 * about to be removed
 	 */
 	p = strchr(*f, ' ');
+	if (!p)
+		/* Internal error, feature string inconsistent */
+		return 1;
 	while (*p == ' ')
 		p++;
 	p--;
-- 
1.7.4.2
