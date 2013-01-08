From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/42] Add TAGS makefile target
Date: Tue,  8 Jan 2013 14:53:45 +0100
Message-ID: <1357653259-62650-8-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Makefile |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 5b0c61a..baf7753 100644
--- a/Makefile
+++ b/Makefile
@@ -66,6 +66,13 @@ install:	recurse_install
 
 uninstall:	recurse_uninstall
 
+.PHONY:	TAGS
+TAGS:
+	etags -a libmultipath/*.c
+	etags -a libmultipath/*.h
+	etags -a multipathd/*.c
+	etags -a multipathd/*.h
+
 release:
 	sed -e "s/__VERSION__/${VERSION}/" \
 	multipath-tools.spec.in > multipath-tools.spec
-- 
1.7.4.2
