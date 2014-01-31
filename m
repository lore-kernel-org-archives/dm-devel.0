From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] dm-multipath: Do not call pg_init twice
Date: Fri, 31 Jan 2014 10:10:40 +0100
Message-ID: <1391159444-17987-2-git-send-email-hare@suse.de>
References: <1391159444-17987-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391159444-17987-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When pg_init is running we shouldn't be calling the same
routine twice; we need to wait for the first pg_init to
complete.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6eb9dc9..d45290a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -261,6 +261,9 @@ static void __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
+	if (m->pg_init_in_progress || m->pg_init_disabled)
+		return;
+
 	m->pg_init_count++;
 	m->pg_init_required = 0;
 	if (m->pg_init_delay_retry)
-- 
1.7.12.4
