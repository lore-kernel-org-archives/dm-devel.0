From: mwilck@suse.com
Subject: [PATCH 11/11] multipath-tools tests/directio: fix
	-Wmaybe-uninitalized warning
Date: Tue, 12 May 2020 00:39:31 +0200
Message-ID: <20200511223931.18261-12-mwilck@suse.com>
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

Initialize aio_grp to satisfy gcc.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/directio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/directio.c b/tests/directio.c
index 3cd7a520..66aaf0eb 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -316,7 +316,7 @@ static void test_init_free(void **state)
 {
 	int i, count = 0;
 	struct checker c[4096] = {0};
-	struct aio_group *aio_grp;
+	struct aio_group *aio_grp = NULL;
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-- 
2.26.2
