From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] dm raid1: Use struct_size() in kzalloc()
Date: Mon, 5 Aug 2019 19:18:25 -0500
Message-ID: <20190806001825.GA6854@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: dm-devel.ids

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct mirror_set {
	...
        struct mirror mirror[0];
};

size = sizeof(struct mirror_set) + count * sizeof(struct mirror);
instance = kzalloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, mirror, count), GFP_KERNEL)

Notice that, in this case, variable len is not necessary, hence it
is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/md/dm-raid1.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 5a51151f680d..f7226ab57fc8 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -878,12 +878,9 @@ static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 					struct dm_target *ti,
 					struct dm_dirty_log *dl)
 {
-	size_t len;
 	struct mirror_set *ms = NULL;
 
-	len = sizeof(*ms) + (sizeof(ms->mirror[0]) * nr_mirrors);
-
-	ms = kzalloc(len, GFP_KERNEL);
+	ms = kzalloc(struct_size(ms, mirror, nr_mirrors), GFP_KERNEL);
 	if (!ms) {
 		ti->error = "Cannot allocate mirror context";
 		return NULL;
-- 
2.22.0
