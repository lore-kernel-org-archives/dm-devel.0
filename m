From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] libmultipath: fallback to const prio if
	getprio() fails
Date: Tue, 20 Mar 2018 17:50:09 +0100
Message-ID: <20180320165010.15259-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Some storage controllers don't support ALUA even though they have
hwtable entries telling so. One such example is the IBM IPR SAS controller
found on certain IBM Power systems. IBM has confirmed that reliable
detection of ALUA support for this controller by vendor/model/rev is
impossible.

For such cases, instead of simply failing to setup multipath, fall back
to const prio.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9f2a9c907914..a51eb0b82f53 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1637,9 +1637,26 @@ get_prio (struct path * pp)
 	pp->priority = prio_getprio(p, pp, conf->checker_timeout);
 	put_multipath_config(conf);
 	if (pp->priority < 0) {
-		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
-		pp->priority = PRIO_UNDEF;
-		return 1;
+		const char origin[] = "(fallback after error)";
+
+		if (strcmp(prio_name(p), DEFAULT_PRIO)) {
+			conf = get_multipath_config();
+			prio_get(conf->multipath_dir, p, DEFAULT_PRIO,
+				 DEFAULT_PRIO_ARGS);
+			pp->priority = prio_getprio(p, pp,
+						    conf->checker_timeout);
+			put_multipath_config(conf);
+		}
+
+		if (pp->priority < 0) {
+			condlog(1, "%s: %s prio error", pp->dev, prio_name(p));
+			pp->priority = PRIO_UNDEF;
+			return 1;
+		}
+
+		condlog(3, "%s: new prio = %s %s", pp->dev, prio_name(p), origin);
+		condlog(3, "%s: new prio args = \"%s\" %s", pp->dev, prio_args(p),
+			origin);
 	}
 	condlog(3, "%s: %s prio = %u",
 		pp->dev, prio_name(p), pp->priority);
-- 
2.16.1
