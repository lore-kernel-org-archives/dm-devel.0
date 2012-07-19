From: Daniel Wisehart <daniel.wisehart@eladian.com>
Subject: [Bcache v14 PATCH] fix compiler error
Date: Thu, 19 Jul 2012 16:53:26 -0400 (EDT)
Message-ID: <0d1ae163-7cde-4a78-852a-04fba827249f@mail.eladian.com>
References: <1abe2159-2201-46c4-9c60-afc4f358ff6a@mail.eladian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1abe2159-2201-46c4-9c60-afc4f358ff6a@mail.eladian.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Kent, 

This patch keeps gcc 4.7.0 happy.  The static function dump_bset() could be moved, but that would have made a bigger patch.  :-)

Thanks,
Daniel



diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 3c9c24d..4dc0ba5 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -83,6 +83,8 @@ struct keyprint_hack bch_pbtree(const struct btree *b)
 
 #ifdef CONFIG_BCACHE_DEBUG
 
+static void dump_bset(struct btree *b, struct bset *i);
+
 void bch_btree_verify(struct btree *b, struct bset *new)
 {
        struct btree *v = b->c->verify_data;


This communication is restricted - please see http://www.eladian.com for further information.
