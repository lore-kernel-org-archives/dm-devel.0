From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 27/72] libmultipath: hp_sw: remove usused
	argument in do_inq()
Date: Sat, 12 Oct 2019 21:28:11 +0000
Message-ID: <20191012212703.12989-28-martin.wilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/hp_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index 1a820223..eabfa93c 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -44,7 +44,7 @@ void libcheck_free (struct checker * c)
 
 static int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
-       void *resp, int mx_resp_len, int noisy, unsigned int timeout)
+       void *resp, int mx_resp_len, unsigned int timeout)
 {
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] =
 		{ INQUIRY_CMD, 0, 0, 0, 0, 0 };
@@ -130,7 +130,7 @@ do_tur (int fd, unsigned int timeout)
 int libcheck_check(struct checker * c)
 {
 	char buff[MX_ALLOC_LEN];
-	int ret = do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0, c->timeout);
+	int ret = do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, c->timeout);
 
 	if (ret == PATH_WILD) {
 		c->msgid = CHECKER_MSGID_UNSUPPORTED;
-- 
2.23.0
