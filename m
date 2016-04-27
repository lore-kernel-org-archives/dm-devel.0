From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/57] multipathd: fixup a crash when invoking
	CLI commands
Date: Wed, 27 Apr 2016 13:10:13 +0200
Message-ID: <1461755458-29225-13-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The command buffer wasn't cleared, so the CLI might crash on startup.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index d9c0b8b..18b225a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2244,6 +2244,7 @@ main (int argc, char *argv[])
 
 		if (load_config(DEFAULT_CONFIGFILE, udev_new()))
 			exit(1);
+		memset(cmd, 0x0, CMDSIZE);
 		while (optind < argc) {
 			if (strchr(argv[optind], ' '))
 				c += snprintf(c, s + CMDSIZE - c, "\"%s\" ", argv[optind]);
-- 
2.6.6
