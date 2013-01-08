From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/42] Double free in disassemble_map()
Date: Tue,  8 Jan 2013 14:53:59 +0100
Message-ID: <1357653259-62650-22-git-send-email-hare@suse.de>
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

Label 'out1' already frees 'word'; no need to do it here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dmparser.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index a45854d..5184c41 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -276,7 +276,6 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 			num_pg_args = atoi(word);
 
 			if (merge_words(&mpp->selector, word, 1)) {
-				FREE(word);
 				goto out1;
 			}
 			FREE(word);
-- 
1.7.4.2
