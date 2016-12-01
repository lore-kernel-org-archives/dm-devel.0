From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] dm-crypt: reject key strings containing
	whitespace chars
Date: Thu,  1 Dec 2016 18:20:52 +0100
Message-ID: <1480612852-19878-1-git-send-email-okozina@redhat.com>
References: <bb229097-56f7-0ef8-88f0-db2246a2c0c9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bb229097-56f7-0ef8-88f0-db2246a2c0c9@redhat.com>
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
Cc: snitzer@redhat.com, mpatocka@redhat.com, Ondrej Kozina <okozina@redhat.com>, aryabinin@virtuozzo.com, agk@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Well, I was wrong. Unfortunately key_string may theoreticaly contain
whitespace even after it's processed by dm_split_args(). The dm core
driver supports escaping of almost all chars including any whitespace.

if uspace passes key in the kernel in format ":32:logon:my_prefix:my\ key"
the dm-crypt will look up key "my_prefix:my key" in kernel keyring
service. So far everything's fine.

Unfortunately if uspace later calls DM_TABLE_STATUS ioctl, it will not
receive back expected ":32:logon:my_prefix:my\ key" but the unescaped version
instead. Also uspace (most notably cryptsetup) is not ready to parse
single target argument containing (even escaped) whitespace chars and any
whitespace is simply taken as delimiter of another argument.

This efect is mitigated by the fact libdevmapper curently performs
double escaping of '\' char. Any user input in format "x\ x" is transformed
into "x\\ x" before being passed to the kernel. Nonetheless dm-crypt may be
used without go-between libdevmapper. Therefore I propose following patch
to reject any key string containing whitespace.

---
 drivers/md/dm-crypt.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 78ab5e8..11df7a9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -24,6 +24,7 @@
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <linux/rbtree.h>
+#include <linux/ctype.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
@@ -1489,6 +1490,14 @@ static int crypt_setkey(struct crypt_config *cc)
 
 #ifdef CONFIG_KEYS
 
+static int contains_whitespace(const char *str)
+{
+	while (*str)
+		if (isspace(*str++))
+			return 1;
+	return 0;
+}
+
 static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
 	char *new_key_string, *key_desc;
@@ -1496,6 +1505,15 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	struct key *key;
 	const struct user_key_payload *ukp;
 
+	/*
+	 * Reject key_string with whitespace. dm core currently lacks code for
+	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
+	 */
+	if (contains_whitespace(key_string)) {
+		DMERR("whitespace chars currently not allowed in key string");
+		return -EINVAL;
+	}
+
 	/* look for next ':' separating key_type from key_description */
 	key_desc = strpbrk(key_string, ":");
 	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
-- 
2.7.4
