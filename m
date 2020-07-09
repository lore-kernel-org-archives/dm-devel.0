From: mwilck@suse.com
Subject: [PATCH 15/35] libmultipath: fix missing initializer
	warning from clang 3.9
Date: Thu,  9 Jul 2020 12:16:00 +0200
Message-ID: <20200709101620.6786-16-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

clang 3.9 needs designators to accept implicit struct initialization.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 503519e..f73cbe3 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -256,7 +256,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 {
 	struct io_event events[128];
 	int i, nr, got_events = 0;
-	struct timespec zero_timeout = {0};
+	struct timespec zero_timeout = { .tv_sec = 0, };
 	struct timespec *timep = timeout;
 
 	do {
-- 
2.26.2
