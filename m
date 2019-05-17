From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 3/7] mpathpersist: no need to treat error
	close() as fatal
Date: Sat, 18 May 2019 00:56:59 +0200
Message-ID: <20190517225703.16295-4-mwilck@suse.com>
References: <20190517225703.16295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190517225703.16295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dbond@redhat.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Simplify code a bit.
---
 mpathpersist/main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index c1a6d3c8..b204647f 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -154,7 +154,7 @@ static int do_batch_file(const char *batch_fn)
 
 static int handle_args(int argc, char * argv[], int nline)
 {
-	int fd, c, res;
+	int fd, c;
 	const char *device_name = NULL;
 	int num_prin_sa = 0;
 	int num_prout_sa = 0;
@@ -179,7 +179,6 @@ static int handle_args(int argc, char * argv[], int nline)
 	char *batch_fn = NULL;
 	void *resp = NULL;
 	struct transportid * tmp;
-	struct config *conf = multipath_conf;
 
 	memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));
 
@@ -558,13 +557,7 @@ static int handle_args(int argc, char * argv[], int nline)
 		printf("PR out: command failed\n");
 	}
 
-	res = close (fd);
-	if (res < 0)
-	{
-		mpath_lib_exit(conf);
-		udev_unref(udev);
-		return MPATH_PR_FILE_ERROR;
-	}
+	close (fd);
 
 out :
 	if (ret == MPATH_PR_SYNTAX_ERROR) {
-- 
2.21.0
