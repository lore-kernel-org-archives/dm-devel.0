From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] dm-crypt: check key payload pointer not null
Date: Wed, 23 Nov 2016 21:51:17 +0100
Message-ID: <1479934277-14913-1-git-send-email-okozina@redhat.com>
References: <20161121154049.GA13248@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161121154049.GA13248@redhat.com>
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
Cc: dhowells@redhat.com, aryabinin@virtuozzo.com, mpatocka@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Hi Mike,

those are fixes for latest version (including your cleanup patch). I've fixed one
awkward bug the rest is based on David's sugestions he gave me earlier today.

David, may I also kindly ask you for oficial 'Reviewed-by' stamp provided 
it's correct now (with regard to kernel keyring bits)?

bugfix: harden checks for 'user' or 'logon' keywords in key_string (it allowed
to pass with :logo:... or "use:...)

bugfix: we have to check user_key_payload reference after rcu_read_lock().
Otherwise keys revoked between request_key() and rcu_read_lock() calls would
return NULL pointer.

improvement: calling key_validate() right after request_key() is
useless. Exactly same check is performed inside request_key()
routine.

improvement: do not check the whole key_type string again. We already know
it's either 'logon' or 'user'. Read just first char.
---
 drivers/md/dm-crypt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c6ff083..78ab5e8 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1501,31 +1501,31 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
 		return -EINVAL;
 
-	if (strncmp(key_string, "logon", key_desc - key_string) &&
-	    strncmp(key_string, "user", key_desc - key_string))
+	if (strncmp(key_string, "logon:", key_desc - key_string + 1) &&
+	    strncmp(key_string, "user:", key_desc - key_string + 1))
 		return -EINVAL;
 
 	new_key_string = kstrdup(key_string, GFP_KERNEL);
 	if (!new_key_string)
 		return -ENOMEM;
 
-	key = request_key(strncmp(key_string, "user", 4) ? &key_type_logon : &key_type_user,
+	key = request_key(key_string[0] == 'l' ? &key_type_logon : &key_type_user,
 			  key_desc + 1, NULL);
 	if (IS_ERR(key)) {
 		kzfree(new_key_string);
 		return PTR_ERR(key);
 	}
 
-	ret = key_validate(key);
-	if (ret < 0) {
+	rcu_read_lock();
+
+	ukp = user_key_payload(key);
+	if (!ukp) {
+		rcu_read_unlock();
 		key_put(key);
 		kzfree(new_key_string);
-		return ret;
+		return -EKEYREVOKED;
 	}
 
-	rcu_read_lock();
-
-	ukp = user_key_payload(key);
 	if (cc->key_size != ukp->datalen) {
 		rcu_read_unlock();
 		key_put(key);
-- 
2.7.4
