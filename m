From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 40/42] multipathd: sighandlers might use
	uninitialized gvecs
Date: Tue,  8 Jan 2013 14:54:17 +0100
Message-ID: <1357653259-62650-40-git-send-email-hare@suse.de>
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

gvecs are initialized after signal handlers, which in turn
might access the vectors.
So the signal handlers might access uninitialized variables.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3a6e88f..f491a24 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1617,14 +1617,14 @@ child (void * param)
 
 	}
 
-	signal_init();
-	setscheduler();
-	set_oom_adj();
 	vecs = gvecs = init_vecs();
-
 	if (!vecs)
 		exit(1);
 
+	signal_init();
+	setscheduler();
+	set_oom_adj();
+
 	conf->daemon = 1;
 	udev_set_sync_support(0);
 	/*
-- 
1.7.4.2
