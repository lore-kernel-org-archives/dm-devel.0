From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/42] Checker name is not displayed on failure
Date: Tue,  8 Jan 2013 14:53:49 +0100
Message-ID: <1357653259-62650-12-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If add_checker() isn't able to locate the checker
it won't display the name in free_checker().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/prio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index cf97fad..8e6b93e 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -86,6 +86,7 @@ struct prio * add_prio (char * name)
 	p = alloc_prio();
 	if (!p)
 		return NULL;
+	snprintf(p->name, PRIO_NAME_LEN, "%s", name);
 	snprintf(libname, LIB_PRIO_NAMELEN, "%s/libprio%s.so",
 		 conf->multipath_dir, name);
 	if (stat(libname,&stbuf) < 0) {
@@ -107,7 +108,6 @@ struct prio * add_prio (char * name)
 		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
 	if (!p->getprio)
 		goto out;
-	snprintf(p->name, PRIO_NAME_LEN, "%s", name);
 	list_add(&p->node, &prioritizers);
 	return p;
 out:
-- 
1.7.4.2
