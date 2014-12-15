From: Loic Pefferkorn <loic@loicp.eu>
Subject: [PATCH] Update CONFIG_DM_CRYPT help-text link
Date: Mon, 15 Dec 2014 22:18:43 +0100
Message-ID: <81c1a7329d2146d37b22d7efa96b3a449cb66d14.1418677931.git.loic@loicp.eu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

This patch fixes the obsolete help-text link of CONFIG_DM_CRYPT.
Applies against next-20141215.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=75111

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/md/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5bdedf6..09c89a4b 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -230,9 +230,8 @@ config DM_CRYPT
 	  transparently encrypts the data on it. You'll need to activate
 	  the ciphers you're going to use in the cryptoapi configuration.
 
-	  Information on how to use dm-crypt can be found on
-
-	  <http://www.saout.de/misc/dm-crypt/>
+	  For further information on dm-crypt and userspace tools see:
+	  <http://code.google.com/p/cryptsetup/wiki/DMCrypt>
 
 	  To compile this code as a module, choose M here: the module will
 	  be called dm-crypt.
-- 
2.1.3
