From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3] dm-crypt: add ability to use keys from
 the kernel key retention service
Date: Mon, 21 Nov 2016 10:40:49 -0500
Message-ID: <20161121154049.GA13248@redhat.com>
References: <1479329231-4572-1-git-send-email-okozina@redhat.com>
	<1479740331-31573-1-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1479740331-31573-1-git-send-email-okozina@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: aryabinin@virtuozzo.com, dm-devel@redhat.com, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 21 2016 at  9:58P -0500,
Ondrej Kozina <okozina@redhat.com> wrote:

> Changes since v2:
>   - moved rcu_read_lock() closer to key payload processing (thanks Mikulas)
>   - updated dm-crypt documentation
>   - updated code comments and unified parameter names in kernel keyring function stubs
>     (#CONFIG_KEYS undefined)
> 
> The kernel key service is a generic way to store keys for the use of
> other subsystems. Currently there is no way to use kernel keys in dm-crypt.
> This patch aims to fix that. Instead of key userspace may pass a key
> description with preceding ':'. So message that constructs encryption
> mapping now looks like this:
> 
>   <cipher> [<key>|:<key_string>] <iv_offset> <dev_path> <start> [<#opt_params> <opt_params>]
> 
> where <key_string> is in format: <key_size>:<key_type>:<key_description>
> 
> Currently we only support two elementary key types: 'user' and 'logon'.
> Keys may be loaded in dm-crypt either via <key_string> or using
> classical method and pass the key in hex representation directly.
> 
> dm-crypt device initialised with a key passed in hex representation may be
> replaced with key passed in key_string format and vice versa.
> 
> (Patch is based on original work by Andrey Ryabinin)
> 
> Signed-off-by: Ondrej Kozina <okozina@redhat.com>

Other than the following cleanup patch that I've put ontop of your v3,
looks good to me.

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7c2bbef..8fcc924 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1508,12 +1508,8 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	if (!new_key_string)
 		return -ENOMEM;
 
-	/*
-	 * FIXME: are there any key descriptions we should disallow users
-	 * from loading to dm-crypt? i.e.: kernel keys starting with '.'
-	 */
-
-	key = request_key(strncmp(key_string, "user", 4) ? &key_type_logon : &key_type_user, key_desc + 1, NULL);
+	key = request_key(strncmp(key_string, "user", 4) ? &key_type_logon : &key_type_user,
+			  key_desc + 1, NULL);
 	if (IS_ERR(key)) {
 		kzfree(new_key_string);
 		return PTR_ERR(key);
@@ -1602,25 +1598,25 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	if (!cc->key_size && strcmp(key, "-"))
 		goto out;
 
-	/* ':' means that the key is in kernel keyring */
-	if (key[0] == ':')
+	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
+	if (key[0] == ':') {
 		r = crypt_set_keyring_key(cc, key + 1);
-	else {
-		/* clear the flag since following operations may invalidate previously valid key */
-		clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
+		goto out;
+	}
 
-		/* wipe references to any kernel keyring key */
-		kzfree(cc->key_string);
-		cc->key_string = NULL;
+	/* clear the flag since following operations may invalidate previously valid key */
+	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-		if (cc->key_size &&
-		    crypt_decode_key(cc->key, key, cc->key_size) < 0)
-			goto out;
+	/* wipe references to any kernel keyring key */
+	kzfree(cc->key_string);
+	cc->key_string = NULL;
 
-		r = crypt_setkey(cc);
-		if (!r)
-			set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
-	}
+	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
+		goto out;
+
+	r = crypt_setkey(cc);
+	if (!r)
+		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 out:
 	/* Hex key string not needed after here, so wipe it. */
 	memset(key, '0', key_string_len);
