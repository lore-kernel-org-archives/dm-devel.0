From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [Bcache v13 04/16] Fix ratelimit macro to compile in c99 mode
Date: Wed, 9 May 2012 23:09:00 -0400
Message-ID: <d7cfd6b70316efc3fe2ce575203d906a610e3670.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids


Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/ratelimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.9.rc2
