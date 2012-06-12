From: Kent Overstreet <koverstreet@google.com>
Subject: [Bcache v14 02/16] Fix ratelimit macro to compile in c99 mode
Date: Tue, 12 Jun 2012 08:39:08 -0700
Message-ID: <1339515562-14638-3-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com, dan.j.williams@intel.com
List-Id: dm-devel.ids


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/ratelimit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index e11ccb4..9ad57d3 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -20,7 +20,7 @@ struct ratelimit_state {
 #define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
 									\
 	struct ratelimit_state name = {					\
-		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.lock		= __RAW_SPIN_LOCK_INITIALIZER(name.lock),\
 		.interval	= interval_init,			\
 		.burst		= burst_init,				\
 	}
-- 
1.7.9.3.327.g2980b
