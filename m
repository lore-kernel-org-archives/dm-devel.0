From: Kent Overstreet <koverstreet@google.com>
Subject: [Bcache v15 04/16] Export blk_fill_rwbs()
Date: Mon, 23 Jul 2012 16:50:47 -0700
Message-ID: <1343087459-17645-5-git-send-email-koverstreet@google.com>
References: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com, joe@perches.com
List-Id: dm-devel.ids

Exported so it can be used by bcache's tracepoints

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/trace/blktrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..dbe1667 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1806,6 +1806,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 
 	rwbs[i] = '\0';
 }
+EXPORT_SYMBOL_GPL(blk_fill_rwbs);
 
 #endif /* CONFIG_EVENT_TRACING */
 
-- 
1.7.7.3
