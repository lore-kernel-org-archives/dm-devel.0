From: michaelc@cs.wisc.edu
Subject: [PATCH] multipathd: revert mpp size update if map update
	fails
Date: Thu, 24 Oct 2013 19:50:55 -0500
Message-ID: <1382662255-7861-1-git-send-email-michaelc@cs.wisc.edu>
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
To: dm-devel@redhat.com, christophe.varoqui@gmail.com
List-Id: dm-devel.ids

From: Mike Christie <michaelc@cs.wisc.edu>

If updating the dm device in the kernel fails we cannot leave
the mpp size updated, because if we correct the problem and
try to resize later multipathd prevents resizing the device
of the size has not changed.

I hit this when all paths to a dm-multipath device where not
yet updated but multipathd resize was run.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 multipathd/cli_handlers.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4b860bb..58a5643 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -567,6 +567,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors * vecs)
 {
 	char params[PARAMS_SIZE] = {0};
+	unsigned long long orig_size = mpp->size;
 
 	mpp->size = size;
 	update_mpp_paths(mpp, vecs->pathvec);
@@ -575,6 +576,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	if (domap(mpp, params) <= 0) {
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
+		mpp->size = orig_size;
 		return 1;
 	}
 	return 0;
-- 
1.7.1
