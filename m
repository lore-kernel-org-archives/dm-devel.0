From: Nicolas Kaiser <nikai@nikai.net>
Subject: [KJ] [PATCH] dm: uninitialize static variables v2
Date: Sat, 10 Dec 2005 20:32:26 +0100
Message-ID: <20051210203226.297058d0@lucky.kitzblitz>
References: <20051205132800.34631bbf@lucky.kitzblitz>
	<20051210153129.GA2003@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============60804637086858726=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20051210153129.GA2003@mipter.zuzino.mipt.ru>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: kernel-janitors@lists.osdl.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============60804637086858726==
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

uninitialize static variables initialized to 0, to make them go
to .bss instead of .data.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/md/dm.c     |    4 ++--
 drivers/md/kcopyd.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -urpN a/drivers/md/dm.c b/drivers/md/dm.c
--- a/drivers/md/dm.c	2005-10-02 15:53:35.000000000 +0200
+++ b/drivers/md/dm.c	2005-12-10 20:24:13.000000000 +0100
@@ -20,8 +20,8 @@
 
 static const char *_name = DM_NAME;
 
-static unsigned int major = 0;
-static unsigned int _major = 0;
+static unsigned int major;
+static unsigned int _major;
 
 /*
  * One of these is allocated per bio.
diff -urpN a/drivers/md/kcopyd.c b/drivers/md/kcopyd.c
--- a/drivers/md/kcopyd.c	2005-10-02 15:53:35.000000000 +0200
+++ b/drivers/md/kcopyd.c	2005-12-10 20:26:16.000000000 +0100
@@ -588,7 +588,7 @@ static void client_del(struct kcopyd_cli
 }
 
 static DECLARE_MUTEX(kcopyd_init_lock);
-static int kcopyd_clients = 0;
+static int kcopyd_clients;
 
 static int kcopyd_init(void)
 {

--===============60804637086858726==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============60804637086858726==--
