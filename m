From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] docs: dm-integrity: remove reference to ARC4
Date: Fri,  6 Dec 2019 19:59:21 -0800
Message-ID: <20191207035921.94780-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

ARC4 is no longer considered secure, so it shouldn't be used, even as
just an example.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 594095b54b29..c00f9f11e3f3 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -144,7 +144,7 @@ journal_crypt:algorithm(:key)	(the key is optional)
 	Encrypt the journal using given algorithm to make sure that the
 	attacker can't read the journal. You can use a block cipher here
 	(such as "cbc(aes)") or a stream cipher (for example "chacha20",
-	"salsa20", "ctr(aes)" or "ecb(arc4)").
+	"salsa20" or "ctr(aes)").
 
 	The journal contains history of last writes to the block device,
 	an attacker reading the journal could see the last sector nubmers
-- 
2.24.0
