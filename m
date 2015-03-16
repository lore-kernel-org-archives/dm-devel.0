From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/78] libmultipath: Prefer deprecated 'getuid'
	callout
Date: Mon, 16 Mar 2015 13:35:53 +0100
Message-ID: <1426509425-15978-7-git-send-email-hare@suse.de>
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

We need first to check if the deprecated 'getuid' callout
should be used, otherwise it might never be called.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/propsel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 46f8f63..f64d5e4 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -351,12 +351,12 @@ select_getuid (struct path * pp)
 {
 	char *origin;
 
-	pp_set_ovr(uid_attribute);
 	pp_set_ovr(getuid);
-	pp_set_hwe(uid_attribute);
+	pp_set_ovr(uid_attribute);
 	pp_set_hwe(getuid);
-	pp_set_conf(uid_attribute);
+	pp_set_hwe(uid_attribute);
 	pp_set_conf(getuid);
+	pp_set_conf(uid_attribute);
 	pp_set_default(uid_attribute, DEFAULT_UID_ATTRIBUTE);
 out:
 	if (pp->uid_attribute)
-- 
1.8.4.5
