From: Kent Overstreet <koverstreet@google.com>
Subject: [Bcache v15 05/16] Export __lockdep_no_validate__
Date: Mon, 23 Jul 2012 16:50:48 -0700
Message-ID: <1343087459-17645-6-git-send-email-koverstreet@google.com>
References: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com, joe@perches.com
List-Id: dm-devel.ids

Bcache's garbage collection needs a way around lockdep; this might not
be the best way but it'll do for the moment.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/lockdep.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ea9ee45..a554e7f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2997,6 +2997,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
+EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
-- 
1.7.7.3
