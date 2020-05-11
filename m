From: mwilck@suse.com
Subject: [PATCH 01/11] multipath-tools: Makefile: more dependency
	fixes for parallel build
Date: Tue, 12 May 2020 00:39:21 +0200
Message-ID: <20200511223931.18261-2-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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

Extend the late fixes from Christian.

Cc: Christian Hesse <mail@eworm.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index ba1d73ba..fec3b73b 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +28,9 @@ all:	$(BUILDDIRS)
 $(BUILDDIRS):
 	$(MAKE) -C $@
 
-libmpathpersist multipath multipathd mpathpersist: libmultipath
-mpathpersist:  libmpathpersist
+libmultipath libdmmp: libmpathcmd
+libmpathpersist multipath multipathd: libmultipath
+mpathpersist multipathd:  libmpathpersist
 
 $(BUILDDIRS.clean):
 	$(MAKE) -C ${@:.clean=} clean
-- 
2.26.2
