From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] bio: use kmalloc alignment for bio slab
Date: Sun, 23 Feb 2014 18:46:51 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402231843260.15413@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Hi

Here I'm sending the patches to avoid mempool allocations from dm-crypt.

It needs a small patch to fs/bio.c that makes bio slab cache aligned, so 
I'm posting this to Jens.


From: Mikulas Patocka <mpatocka@redhat.com>

Various subsystems can ask the bio subsystem to create a bio slab cache
with some free space before the bio. This free space can be used for any
purpose. Device mapper uses this feature to place some target-specific and
device-mapper specific data before the bio, so that the target-specific
data doesn't have to be allocated separatedly.

This mechanism is used in place of kmalloc, so we need that the allocated
slab have the same memory alignment as memory allocated with kmalloc.

This patch changes the function bio_find_or_create_slab so that it uses
ARCH_KMALLOC_MINALIGN alignment when creating the slab cache. This patch
is needed so that dm-crypt can use per-bio data for encryption - the
crypto subsystem assumes that these data have the same alignment as
kmallocated memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/bio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.14-rc3/fs/bio.c
===================================================================
--- linux-3.14-rc3.orig/fs/bio.c	2014-02-23 23:53:50.000000000 +0100
+++ linux-3.14-rc3/fs/bio.c	2014-02-23 23:55:00.000000000 +0100
@@ -112,7 +112,8 @@ static struct kmem_cache *bio_find_or_cr
 	bslab = &bio_slabs[entry];
 
 	snprintf(bslab->name, sizeof(bslab->name), "bio-%d", entry);
-	slab = kmem_cache_create(bslab->name, sz, 0, SLAB_HWCACHE_ALIGN, NULL);
+	slab = kmem_cache_create(bslab->name, sz, ARCH_KMALLOC_MINALIGN,
+				 SLAB_HWCACHE_ALIGN, NULL);
 	if (!slab)
 		goto out_unlock;
 
