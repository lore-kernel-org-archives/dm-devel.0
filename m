From: NeilBrown <neilb@suse.com>
Subject: [PATCH 2/2] dm-io: remove BIOSET_NEED_RESCUER flag from
	bios bioset
Date: Wed, 30 Aug 2017 08:10:18 +1000
Message-ID: <150404461891.12966.4056527092142829944.stgit@noble>
References: <150404441182.12966.7067251378068944343.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <150404441182.12966.7067251378068944343.stgit@noble>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

BIOSET_NEED_RESCUER is only need on a bioset is
allocations will be made inside a make_request_fn()
call.

dm_io() is called from make_request_fn() context.
The closest it comes is in chunk_io() in
dm-snap-persistent.  Here the code uses a separate
thread to avoid problems.

So BIOSET_NEED_RESCUER is not needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/dm-io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 25039607f3cb..bafd9f79aa3b 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -58,8 +58,7 @@ struct dm_io_client *dm_io_client_create(void)
 	if (!client->pool)
 		goto bad;
 
-	client->bios = bioset_create(min_ios, 0, (BIOSET_NEED_BVECS |
-						  BIOSET_NEED_RESCUER));
+	client->bios = bioset_create(min_ios, 0, BIOSET_NEED_BVECS);
 	if (!client->bios)
 		goto bad;
 
