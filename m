From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/78] Make checker_put() and prio_put()
	idempotent
Date: Mon, 16 Mar 2015 13:36:07 +0100
Message-ID: <1426509425-15978-21-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

checker_put() and prio_put() should check whether an instance
was selected prior to dropping a reference to it.
Otherwise they'll be dropping a reference which they haven't
increased in the first place.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers.c | 2 +-
 libmultipath/prio.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 1dd5525..ef1d099 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -195,7 +195,7 @@ void checker_put (struct checker * dst)
 {
 	struct checker * src;
 
-	if (!dst)
+	if (!dst || !dst->check)
 		return;
 	src = checker_lookup(dst->name);
 	if (dst->free)
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 6ee0b9c..ab8eca9 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -132,7 +132,7 @@ int prio_getprio (struct prio * p, struct path * pp)
 
 int prio_selected (struct prio * p)
 {
-	if (!p || !p->getprio)
+	if (!p)
 		return 0;
 	return (p->getprio) ? 1 : 0;
 }
@@ -169,7 +169,7 @@ void prio_put (struct prio * dst)
 {
 	struct prio * src;
 
-	if (!dst)
+	if (!dst || !dst->getprio)
 		return;
 
 	src = prio_lookup(dst->name);
-- 
1.8.4.5
