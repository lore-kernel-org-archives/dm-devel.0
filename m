From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/42] Incorrect inquiry vendor length in hds
	prioritizer
Date: Tue,  8 Jan 2013 14:53:51 +0100
Message-ID: <1357653259-62650-14-git-send-email-hare@suse.de>
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

The inquiry vendor length is 8 bytes, but snprintf writes
the given number of bytes _including_ the NULL byte. So
we need to supply a 9 byte buffer here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/prioritizers/hds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 5d75f84..f748707 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -87,7 +87,7 @@
 int hds_modular_prio (const char *dev, int fd)
 {
 	int k;
-	char vendor[8];
+	char vendor[9];
 	char product[32];
 	char serial[32];
 	char ldev[32];
@@ -125,7 +125,7 @@ int hds_modular_prio (const char *dev, int fd)
 		return -1;
 	}
 
-	snprintf (vendor, 8, "%.8s", inqBuffp + 8);
+	snprintf (vendor, 9, "%.8s", inqBuffp + 8);
 	snprintf (product, 17, "%.16s", inqBuffp + 16);
 	snprintf (serial, 5, "%.4s", inqBuffp + 40);
 	snprintf (ldev, 5, "%.4s", inqBuffp + 44);
-- 
1.7.4.2
