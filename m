From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] multipath-tools: Intialize pointer passed to
	get_cmdvec
Date: Thu, 22 Jul 2010 18:36:48 +0200
Message-ID: <20100722163918.296646000@de.ibm.com>
References: <20100722163646.585967000@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=init-ptr.diff
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Christof Schmitt <christof.schmitt@de.ibm.com>

get_cmdvec can return before the vector argument has been initialized. Fix this
by initializing the pointer before passing it to get_cmdvec. This fixes a
segfault in the interactive mode when hitting the tab key directly on the
command prompt.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 multipathd/cli.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -363,7 +363,7 @@ parse_cmd (char * cmd, char ** reply, in
 {
 	int r;
 	struct handler * h;
-	vector cmdvec;
+	vector cmdvec = NULL;
 
 	r = get_cmdvec(cmd, &cmdvec);
 
@@ -467,7 +467,7 @@ key_generator (const char * str, int sta
 	struct key * kw;
 	int i;
 	struct handler *h;
-	vector v;
+	vector v = NULL;
 
 	if (!state) {
 		index = 0;
