From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 54/57] multipathd: Increase uxclnt timeout
Date: Wed, 27 Apr 2016 13:10:55 +0200
Message-ID: <1461755458-29225-55-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When calling uxclnt we need to increase the timeout, otherwise
we will not be able to get a reply if the daemon runs into an
uxlsnr timeout.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index a58dae5..77eb498 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2293,7 +2293,7 @@ main (int argc, char *argv[])
 		case 'k':
 			if (load_config(DEFAULT_CONFIGFILE, udev_new()))
 				exit(1);
-			uxclnt(optarg, conf->uxsock_timeout);
+			uxclnt(optarg, uxsock_timeout + 100);
 			exit(0);
 		case 'B':
 			conf->bindings_read_only = 1;
@@ -2323,7 +2323,7 @@ main (int argc, char *argv[])
 			optind++;
 		}
 		c += snprintf(c, s + CMDSIZE - c, "\n");
-		uxclnt(s, conf->uxsock_timeout);
+		uxclnt(s, uxsock_timeout + 100);
 		exit(0);
 	}
 
-- 
2.6.6
