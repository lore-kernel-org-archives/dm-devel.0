From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/42] libmultipath: Fix typo in mp_prio_handler()
Date: Tue,  8 Jan 2013 14:53:46 +0100
Message-ID: <1357653259-62650-9-git-send-email-hare@suse.de>
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

The mpentry is found in conf->mptable, not conf->hwtable.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dict.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ebc49a3..fe1362e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1622,7 +1622,7 @@ mp_flush_on_last_del_handler(vector strvec)
 static int
 mp_prio_handler(vector strvec)
 {
-	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->hwtable);
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
 
 	if (!mpe)
 		return 1;
-- 
1.7.4.2
