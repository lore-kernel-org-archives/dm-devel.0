From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 08/16] multipathd: Add envp variable
Date: Wed, 11 Dec 2013 00:43:02 -0600
Message-ID: <1386744190-1295-9-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

A missing variable declaration was keeping multipathd from compiling.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index c388e42..204fbb1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1617,6 +1617,7 @@ child (void * param)
 	struct multipath * mpp;
 	int i;
 	int rc, pid_rc;
+	char *envp;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	sem_init(&exit_sem, 0, 0);
-- 
1.8.4.2
