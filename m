From: Nicolas Kaiser <nikai@nikai.net>
Subject: [KJ] [PATCH] dm: uninitialize static variables
Date: Mon, 5 Dec 2005 13:28:00 +0100
Message-ID: <20051205132800.34631bbf@lucky.kitzblitz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============71703601335763079=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: dm-devel@redhat.com
Cc: kernel-janitors@lists.osdl.org
List-Id: dm-devel.ids

--===============71703601335763079==
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

uninitialize static variables initialized to 0, to make them go
to .bss instead of .data.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 dm.c     |    4 ++--
 kcopyd.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -urpN a/drivers/md/dm.c b/drivers/md/dm.c
--- a/drivers/md/dm.c	2005-10-02 15:53:35.000000000 +0200
+++ b/drivers/md/dm.c	2005-12-05 00:01:26.000000000 +0100
@@ -20,8 +20,8 @@
 
 static const char *_name = DM_NAME;
 
-static unsigned int major = 0;
-static unsigned int _major = 0;
+static unsigned int major; /* = 0 */
+static unsigned int _major; /* = 0 */
 
 /*
  * One of these is allocated per bio.
diff -urpN a/drivers/md/kcopyd.c b/drivers/md/kcopyd.c
--- a/drivers/md/kcopyd.c	2005-10-02 15:53:35.000000000 +0200
+++ b/drivers/md/kcopyd.c	2005-12-05 00:00:33.000000000 +0100
@@ -588,7 +588,7 @@ static void client_del(struct kcopyd_cli
 }
 
 static DECLARE_MUTEX(kcopyd_init_lock);
-static int kcopyd_clients = 0;
+static int kcopyd_clients; /* = 0 */
 
 static int kcopyd_init(void)
 {

--===============71703601335763079==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============71703601335763079==--
