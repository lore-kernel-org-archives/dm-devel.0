From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 67/72] multipath-tools: Makefile.inc: use -Wp,
 ... for compiling only
Date: Sat, 12 Oct 2019 21:29:01 +0000
Message-ID: <20191012212703.12989-68-martin.wilck@suse.com>
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

clang-3.9 errors out if -Wp,... preprocessor flags are used in the
linking stage.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index d4d08fe9..f309a274 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -96,9 +96,8 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  -Wno-clobbered \
 		  -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) \
-		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
-		  --param=ssp-buffer-size=4
-
+		  $(STACKPROT) --param=ssp-buffer-size=4
+CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
 CFLAGS		:= $(OPTFLAGS) -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
 		   -MMD -MP $(CFLAGS)
 BIN_CFLAGS	= -fPIE -DPIE
@@ -135,4 +134,4 @@ check_file = $(shell \
 
 %.o:	%.c
 	@echo building $@ because of $?
-	$(CC) $(CFLAGS) -c -o $@ $<
+	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
-- 
2.23.0
