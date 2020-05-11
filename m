From: mwilck@suse.com
Subject: [PATCH 08/11] multipath-tools tests/Makefile: add
	-lmpathcmd to LIBDEPS
Date: Tue, 12 May 2020 00:39:28 +0200
Message-ID: <20200511223931.18261-9-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Make sure the linker finds libmpathcmd.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 77ff3249..028c9ea7 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -10,7 +10,7 @@ W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
 
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
 	-Wno-unused-parameter $(W_MISSING_INITIALIZERS)
-LIBDEPS += -L$(multipathdir) -lmultipath -lcmocka
+LIBDEPS += -L$(multipathdir) -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 	 alias directio
-- 
2.26.2
