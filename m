From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-integrity: Add proper description of module
	to KConfig.
Date: Thu,  4 May 2017 09:50:44 +0200
Message-ID: <20170504075044.5766-1-gmazyland@gmail.com>
References: <CAMuHMdWafrUq0tbHsOS2Gm579Amv0LpYAqk=Kqg4t8fqgbWDgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMuHMdWafrUq0tbHsOS2Gm579Amv0LpYAqk=Kqg4t8fqgbWDgw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Add more descriptive text to explain what it the dm-integrity
when it should be enabled.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/Kconfig | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 7468a22f9d10..3e96fccbbdb2 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -509,6 +509,20 @@ config DM_INTEGRITY
 	select CRYPTO
 	select ASYNC_XOR
 	---help---
-	   This is the integrity target.
+	  This device-mapper target emulates a block device that has additional
+	  per-sector tags that can be used for storing integrity information.
+
+	  The dm-integrity target is used with the dm-crypt target to provide
+	  authenticated disk encryption or it can also be used as a standalone
+	  target. In standalone mode it calculates and verifies the data integrity
+	  internally.
+
+	  You should enable this option if you plan to use dm-crypt target
+	  in authenticated disk encryption mode.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-integrity.
+
+	  If unsure, say N.
 
 endif # MD
-- 
2.11.0
