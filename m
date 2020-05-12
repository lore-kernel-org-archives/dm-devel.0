From: mwilck@suse.com
Subject: [PATCH 2/2] multipath-tools Makefile: add install
	dependency
Date: Tue, 12 May 2020 22:38:22 +0200
Message-ID: <20200512203822.18910-3-mwilck@suse.com>
References: <20200512203822.18910-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200512203822.18910-1-mwilck@suse.com>
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
Cc: Christian Hesse <mail@eworm.de>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

$(libdir) must exist before running "make install" on prioritizer, checker,
and foreign libraries.

Cc: Christian Hesse <mail@eworm.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index fec3b73b..8bcaba66 100644
--- a/Makefile
+++ b/Makefile
@@ -32,6 +32,10 @@ libmultipath libdmmp: libmpathcmd
 libmpathpersist multipath multipathd: libmultipath
 mpathpersist multipathd:  libmpathpersist
 
+libmultipath/checkers.install \
+	libmultipath/prioritizers.install \
+	libmultipath/foreign.install: libmultipath.install
+
 $(BUILDDIRS.clean):
 	$(MAKE) -C ${@:.clean=} clean
 
-- 
2.26.2
