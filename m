From: Kent Overstreet <koverstreet@google.com>
Subject: [Bcache v14 05/16] Export blk_fill_rwbs()
Date: Tue, 12 Jun 2012 08:39:11 -0700
Message-ID: <1339515562-14638-6-git-send-email-koverstreet@google.com>
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

Used by bcache's tracepoints.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 kernel/trace/blktrace.c |    1 +
 1 file changed, 1 insertion(+)

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
1.7.9.3.327.g2980b
