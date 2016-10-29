From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 10/10] set retrigger_tries to 0 for multipath
Date: Fri, 28 Oct 2016 21:55:26 -0500
Message-ID: <1477709726-5442-11-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Multipathd uses retrigger_tries to give udev more chances to to fill in
the uid_attribute, so that the path device is correctly set up in the
udev database. However the multipath command can't do this, so it should
just immediately give up on udev, and try to get the wwid directly.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipath/main.c b/multipath/main.c
index ee00fdb..06add30 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -521,6 +521,7 @@ main (int argc, char *argv[])
 	if (!conf)
 		exit(1);
 	multipath_conf = conf;
+	conf->retrigger_tries = 0;
 	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
-- 
1.8.3.1
