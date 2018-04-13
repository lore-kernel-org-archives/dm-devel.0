From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH ALT] multipath-tools: add licence info to README
Date: Fri, 13 Apr 2018 18:17:07 +0200
Message-ID: <20180413161707.4739-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Gris Ge <fge@redhat.com>, DM ML <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Alternative patch to [PATCH v2 2/2] multipath-tools: link LICENSES/LGPL-2.0 to LICENSE.default

Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Gris Ge <fge@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/README b/README
index 89bab74..2fc4a81 100644
--- a/README
+++ b/README
@@ -51,3 +51,10 @@ Maintainer
 ==========
 Christophe Varoqui <christophe.varoqui@opensvc.com>
 Device-mapper development mailing list <dm-devel@redhat.com>
+
+Licence
+=======
+The multipath-tools source code is covered by several different
+licences. Refer to the individual source files for details.
+Source files which do not specify a licence are shipped under
+LGPL-2.0 (see LICENSES/LGPL-2.0).
-- 
2.17.0
