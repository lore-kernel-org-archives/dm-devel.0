From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 62/72] multipath tests: hwtable: fix strncat()
	invocation
Date: Sat, 12 Oct 2019 21:28:54 +0000
Message-ID: <20191012212703.12989-63-martin.wilck@suse.com>
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

clang detected this error.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 977a5663..473028b7 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -261,7 +261,7 @@ static void write_defaults(const struct hwt_state *hwt)
 	defaults[0].value = hwt->dirname;
 	defaults[1].value = buf;
 	assert_ptr_not_equal(getcwd(dirbuf, sizeof(dirbuf)), NULL);
-	strncat(dirbuf, "/lib", sizeof(dirbuf));
+	strncat(dirbuf, "/lib", sizeof(dirbuf) - 5);
 	defaults[2].value = dirbuf;
 	write_section(hwt->config_file, "defaults",
 		      ARRAY_SIZE(defaults), defaults);
-- 
2.23.0
