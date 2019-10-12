From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 66/72] multipath-tools: Makefile.inc: fix
	TEST_CC_OPTION
Date: Sat, 12 Oct 2019 21:28:59 +0000
Message-ID: <20191012212703.12989-67-martin.wilck@suse.com>
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

The test works only if the compiler actually errors out for an
unsupported warning option, which requires setting -Werror.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 0c800ab3..d4d08fe9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -81,7 +81,8 @@ INSTALL_PROGRAM	= install
 # Test if the C compiler supports the option.
 # Evaluates to "option" if yes, and "fallback" otherwise.
 TEST_CC_OPTION = $(shell \
-	if echo 'int main(void){return 0;}' | $(CC) -o /dev/null -c "$(1)" -xc - >/dev/null 2>&1; \
+	if echo 'int main(void){return 0;}' | \
+		$(CC) -o /dev/null -c -Werror "$(1)" -xc - >/dev/null 2>&1; \
 	then \
 		echo "$(1)"; \
 	else \
-- 
2.23.0
