From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/39] libmultipath: missing break in hds
	prioritizer
Date: Thu, 16 Jun 2016 11:47:29 +0200
Message-ID: <1466070465-1021-24-git-send-email-hare@suse.de>
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

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/prioritizers/hds.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 8043b5b..db8c4c0 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -151,6 +151,7 @@ int hds_modular_prio (const char *dev, int fd)
 			return 0;
 			break;
 		}
+		break;
 	case '1': case '3': case '5': case '7': case '9':
 		switch (ldev[3]) {
 		case '0': case '2': case '4': case '6': case '8': case 'A': case 'C': case 'E':
@@ -162,6 +163,7 @@ int hds_modular_prio (const char *dev, int fd)
 			return 1;
 			break;
 		}
+		break;
 	}
 	return -1;
 }
-- 
2.6.6
