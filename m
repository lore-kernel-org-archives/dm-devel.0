From: akpm@linux-foundation.org
Subject: [patch 2/3] md: dm-log: fix cn_ulog_callback declaration
Date: Fri, 18 Sep 2009 12:45:08 -0700
Message-ID: <200909181945.n8IJj8rN010429@imap1.linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, davem@davemloft.net, vapier@gentoo.org, akpm@linux-foundation.org, jirislaby@gmail.com
List-Id: dm-devel.ids

From: Jiri Slaby <jirislaby@gmail.com>

The third parameter of cn_add_callback accepts functions with void
*()(struct cn_msg *) prototype.  Change cn_ulog_callback to match it by
removing void * and adding struct cn_msg * directly.

It's introduced by commit:
connector: make callback argument type explicit

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log-userspace-transfer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/md/dm-log-userspace-transfer.c~md-dm-log-fix-cn_ulog_ca=
llback-declaration drivers/md/dm-log-userspace-transfer.c
--- a/drivers/md/dm-log-userspace-transfer.c~md-dm-log-fix-cn_ulog_callba=
ck-declaration
+++ a/drivers/md/dm-log-userspace-transfer.c
@@ -129,9 +129,8 @@ static int fill_pkg(struct cn_msg *msg,=20
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(void *data)
+static void cn_ulog_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg =3D (struct cn_msg *)data;
 	struct dm_ulog_request *tfr =3D (struct dm_ulog_request *)(msg + 1);
=20
 	spin_lock(&receiving_list_lock);
_
