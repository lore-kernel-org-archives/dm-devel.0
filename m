From: Kent Overstreet <koverstreet@google.com>
Subject: [Bcache v14 06/16] Export __lockdep_no_validate__
Date: Tue, 12 Jun 2012 08:39:12 -0700
Message-ID: <1339515562-14638-7-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, dan.j.williams@intel.com, agk@redhat.com
List-Id: dm-devel.ids

Bcache's garbage collection needs a way around lockdep; this might not
be the best way but it'll do for the moment.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/lockdep.c |    1 +
 1 file changed, 1 insertion(+)

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
1.7.9.3.327.g2980b
