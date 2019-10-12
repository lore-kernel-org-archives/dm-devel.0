From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 41/72] multipath-tools tests: add
	-Wno-unused-parameter
Date: Sat, 12 Oct 2019 21:28:28 +0000
Message-ID: <20191012212703.12989-42-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Too many unused "void **state" parameters unders tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 0dce8571..60338f14 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -1,6 +1,6 @@
 include ../Makefile.inc
 
-CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
+CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) -Wno-unused-parameter
 LIBDEPS += -L$(multipathdir) -lmultipath -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy alias
@@ -56,6 +56,7 @@ dep_clean:
 	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
 		sort -u | tr '\n' ' ' >$@
 
+
 # COLON will get expanded during second expansion below
 COLON:=:
 .SECONDEXPANSION:
-- 
2.23.0
