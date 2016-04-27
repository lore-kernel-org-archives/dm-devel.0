From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/57] multipathd: print error message for
	invalid arguments
Date: Wed, 27 Apr 2016 13:10:14 +0200
Message-ID: <1461755458-29225-14-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 18b225a..59f0c68 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2234,7 +2234,9 @@ main (int argc, char *argv[])
 			conf->ignore_new_devs = 1;
 			break;
 		default:
-			;
+			fprintf(stderr, "Invalid argument '-%c'\n",
+				optopt);
+			exit(1);
 		}
 	}
 	if (optind < argc) {
-- 
2.6.6
