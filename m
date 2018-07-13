From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 09/10] multipath tests: change to work with old
	make versions
Date: Fri, 13 Jul 2018 14:39:14 -0500
Message-ID: <1531510755-16046-10-git-send-email-bmarzins@redhat.com>
References: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

the $(file <) operation only works with make 4.2 and above. I tried
running the tests on an old machine and it failed. The $shell function
can do the same thing and multipath has been using that in its
Makefiles for a while.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 78755ed..d293c87 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -51,4 +51,4 @@ COLON:=:
 		$(multipathdir)/libmultipath.so Makefile
 	$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $< $($@_TESTDEPS) $($@_OBJDEPS) \
 		$(LIBDEPS) $($@_LIBDEPS) \
-		$(file <$<.wrap) $(foreach dep,$($@_TESTDEPS),$(file <$(dep).wrap))
+		$(shell cat $<.wrap) $(foreach dep,$($@_TESTDEPS),$(shell cat $(dep).wrap))
-- 
2.7.4
