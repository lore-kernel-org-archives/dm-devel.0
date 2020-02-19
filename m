From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 04/18] libmultipath: remove unused
	path->prio_args
Date: Wed, 19 Feb 2020 00:48:26 -0600
Message-ID: <1582094920-9883-5-git-send-email-bmarzins@redhat.com>
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

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c978fb8a..250623af 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -273,7 +273,6 @@ struct path {
 	char * uid_attribute;
 	char * getuid;
 	struct prio prio;
-	char * prio_args;
 	struct checker checker;
 	struct multipath * mpp;
 	int fd;
-- 
2.17.2
