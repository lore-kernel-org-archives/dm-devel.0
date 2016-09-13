From: tang.junhui@zte.com.cn
Subject: [PATCH] multipathd: uxsock_timeout should be assigned by
	conf->uxsock_timeout
Date: Tue, 13 Sep 2016 18:08:49 +0800
Message-ID: <1473761329-8712-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

uxsock_timeout should be assigned by conf->uxsock_timeout
before using it in uxclnt() as a CLI client timeout value,
otherwise its default value is 0, and the CLI client timeout
value is 0 + 100(ms), so the CLI client will be timeout very
quickly.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 96ef01f..a08f1a5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2549,6 +2549,7 @@ main (int argc, char *argv[])
 				exit(1);
 			if (verbosity)
 				conf->verbosity = verbosity;
+			uxsock_timeout = conf->uxsock_timeout;
 			uxclnt(optarg, uxsock_timeout + 100);
 			exit(0);
 		case 'B':
@@ -2573,6 +2574,7 @@ main (int argc, char *argv[])
 			exit(1);
 		if (verbosity)
 			conf->verbosity = verbosity;
+		uxsock_timeout = conf->uxsock_timeout;
 		memset(cmd, 0x0, CMDSIZE);
 		while (optind < argc) {
 			if (strchr(argv[optind], ' '))
-- 
2.8.1.windows.1
