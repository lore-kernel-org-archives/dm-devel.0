From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] bio: don't write "bio: create slab" messages to syslog
Date: Tue, 18 Feb 2014 13:09:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402181307200.30436@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

When using device mapper, there are many "bio: create slab" messages in
the log. Device mapper targets have different front_pad, so each time when
we load a target that wasn't loaded before, we allocate a slab with the
appropriate front_pad and there is associated "bio: create slab" message.

This patch removes these messages, there is no need for them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/bio.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-3.14-rc3/fs/bio.c
===================================================================
--- linux-3.14-rc3.orig/fs/bio.c	2014-02-18 18:53:30.000000000 +0100
+++ linux-3.14-rc3/fs/bio.c	2014-02-18 18:53:38.000000000 +0100
@@ -116,7 +116,6 @@ static struct kmem_cache *bio_find_or_cr
 	if (!slab)
 		goto out_unlock;
 
-	printk(KERN_INFO "bio: create slab <%s> at %d\n", bslab->name, entry);
 	bslab->slab = slab;
 	bslab->slab_ref = 1;
 	bslab->slab_size = sz;
