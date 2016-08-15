From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 05/16] DM: allocation/free helper routines.
Date: Mon, 15 Aug 2016 10:36:42 -0700
Message-ID: <1471282613-31006-6-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, snitzer@redhat.com, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

Helper functions to allocate/reallocate and free memory.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index bf18028..c11567c 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -774,6 +774,23 @@ static void dm_icomp_get_req(struct dm_icomp_req *req)
 	atomic_inc(&req->io_pending);
 }
 
+static void *dm_icomp_kmalloc(size_t size, gfp_t flags)
+{
+	return  kmalloc(size, flags);
+}
+
+static void *dm_icomp_krealloc(void *addr, size_t size,
+		 size_t orig_size, gfp_t flags)
+{
+	return krealloc(addr, size, flags);
+}
+
+static void dm_icomp_kfree(void *addr, unsigned int size)
+{
+	kfree(addr);
+}
+
+
 static void dm_icomp_free_io_range(struct dm_icomp_io_range *io)
 {
 	kfree(io->decomp_data);
-- 
1.7.1
