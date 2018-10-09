From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 10/19] libmultipath: fix memory issue in
	path_latency prio
Date: Tue,  9 Oct 2018 18:03:07 -0500
Message-ID: <1539126196-28926-11-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

The path_latency prioriziter was assuming that prepare_directio_read()
always succeeds. However, it doesn't, and when it fails, the prioritizer
used buf without it pointing to alloced memory. Found by coverity.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/path_latency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 765265c..eeee01e 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -237,7 +237,8 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 	lg_maxavglatency = log(MAX_AVG_LATENCY) / lg_base;
 	lg_minavglatency = log(MIN_AVG_LATENCY) / lg_base;
 
-	prepare_directio_read(pp->fd, &blksize, &buf, &restore_flags);
+	if (prepare_directio_read(pp->fd, &blksize, &buf, &restore_flags) < 0)
+		return PRIO_UNDEF;
 
 	temp = io_num;
 	while (temp-- > 0) {
-- 
2.7.4
