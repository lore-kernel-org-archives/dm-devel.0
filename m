From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 3/3] dm-crypt: modifications to previous patch
Date: Sun, 13 Nov 2016 18:22:49 +0100
Message-ID: <afaabcf3-0ea0-375d-c0f2-6892dd70de2a@gmail.com>
References: <1478511495-20306-1-git-send-email-okozina@redhat.com>
	<1478511495-20306-4-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478511495-20306-4-git-send-email-okozina@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com
Cc: aryabinin@virtuozzo.com, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids


I think that this patch should be merged with the previous one...

On 11/07/2016 10:38 AM, Ondrej Kozina wrote:
> 1) if we load kernel keyring key referenced by key description we
> should also return same key description via later status call. First
> the table should remain the same, second it's not reasonable to expose
> kernel key payload that could already have been be invalidated/expired
> by kernel keyring API.
> 
> 2) search 'logon' key type instead of 'user' key type. 'logon' type
> key payloads can't be read from uspace. Not sure this is _the_ correct
> way either. Do we want dm-crypt to be able to load arbitrary key
> type? If so perhaps we should prefix a key description with key type?

I definitely prefer that userspace cannot access the key in keyring once
it is set (this was one of the design goals for keyring use).

Unfortunately key length is determined (in userspace) only by parsing
hexa representation in DM table.
(For example you will check if AES-128/AES-256 is used according the key length.)

I would say we should put expected key length into dm table, something like this:
<cipher> [<raw_hex_key>|:<key_bytes>:<keyring_id>] ...

(Key length is not secret attribute, moreover it was always visible
through hexa string there even if it was zeroed by dmsetup.)

Some notes:

- In previous patch, raw key is copied to cc->key always,
this patch wipes it if keyring key is used
(merging two patches avoid this).

- increase dm-crypt target version (maybe increasing minor is enough, just
old userspace will fail while parsing the new keyring string)

- please add your signed-of-by line :)

- shouldn't be a key description validated before passing it to keyring api?
(so we avoid similar surprises as just mikulas found with '+' in key :)

- please also fix Documentation/device-mapper/dm-crypt.txt

Anyway, I think this is a good start for the keyring use in dm-crypt.

Thanks,
Milan

> ---
>  drivers/md/dm-crypt.c | 83 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 60 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 3b0f2a3..a038942 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -142,6 +142,7 @@ struct crypt_config {
>  
>  	char *cipher;
>  	char *cipher_string;
> +	char *key_description;
>  
>  	struct crypt_iv_operations *iv_gen_ops;
>  	union {
> @@ -1495,13 +1496,20 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
>  #ifdef CONFIG_KEYS
>  static int crypt_set_keyring_key(struct crypt_config *cc, char *key_desc)
>  {
> -	int ret = 0;
> +	char *new_key_desc;
> +	int ret;
>  	struct key *key;
>  	const struct user_key_payload *ukp;
>  
> -	key = request_key(&key_type_user, key_desc, NULL);
> -	if (IS_ERR(key))
> +	new_key_desc = kstrdup(key_desc, GFP_KERNEL);
> +	if (!new_key_desc)
> +		return -ENOMEM;
> +
> +	key = request_key(&key_type_logon, key_desc, NULL);
> +	if (IS_ERR(key)) {
> +		kzfree(new_key_desc);
>  		return PTR_ERR(key);
> +	}
>  
>  	rcu_read_lock();
>  	ret = key_validate(key);
> @@ -1514,9 +1522,30 @@ static int crypt_set_keyring_key(struct crypt_config *cc, char *key_desc)
>  		goto out;
>  	}
>  	memcpy(cc->key, ukp->data, cc->key_size);
> +
> +	rcu_read_unlock();
> +	key_put(key);
> +
> +	/* clear the flag since following operations may invalidate previously valid key */
> +	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +
> +	ret = crypt_setkey_allcpus(cc);
> +
> +	/* wipe the kernel key payload in each case */
> +	memset(cc->key, 0, cc->key_size * sizeof(u8));
> +
> +	if (!ret) {
> +		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +		kzfree(cc->key_description);
> +		cc->key_description = new_key_desc;
> +	} else
> +		kzfree(new_key_desc);
> +
> +	return ret;
>  out:
>  	rcu_read_unlock();
>  	key_put(key);
> +	kzfree(new_key_desc);
>  	return ret;
>  }
>  
> @@ -1528,17 +1557,14 @@ static int get_key_size(const char *key_desc)
>  	if (key_desc[0] != ':')
>  		return strlen(key_desc) >> 1;
>  
> -	key = request_key(&key_type_user, key_desc + 1, NULL);
> +	key = request_key(&key_type_logon, key_desc + 1, NULL);
>  	if (IS_ERR(key))
>  		return PTR_ERR(key);
>  
>  	rcu_read_lock();
>  	ret = key_validate(key);
> -	if (ret < 0)
> -		goto out;
> -
> -	ret = user_key_payload(key)->datalen;
> -out:
> +	if (!ret)
> +		ret = user_key_payload(key)->datalen;
>  	rcu_read_unlock();
>  	key_put(key);
>  	return ret;
> @@ -1566,25 +1592,30 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
>  
>  	/* ':' means that the key is in kernel keyring */
>  	if (key[0] == ':') {
> -		if (crypt_set_keyring_key(cc, key + 1))
> +		if (key_string_len < 2)
>  			goto out;
> +
> +		r = crypt_set_keyring_key(cc, key + 1);
>  	} else {
>  		/* The key size may not be changed. */
>  		if (cc->key_size != (key_string_len >> 1))
>  			goto out;
> -	}
>  
> -	/* clear the flag since following operations may invalidate previously valid key */
> -	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +		/* clear the flag since following operations may invalidate previously valid key */
> +		clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
>  
> -	if (key[0] != ':' && cc->key_size &&
> -		crypt_decode_key(cc->key, key, cc->key_size) < 0)
> -		goto out;
> +		/* wipe references to any kernel keyring key */
> +		kzfree(cc->key_description);
> +		cc->key_description = NULL;
>  
> -	r = crypt_setkey_allcpus(cc);
> -	if (!r)
> -		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +		if (cc->key_size &&
> +		    crypt_decode_key(cc->key, key, cc->key_size) < 0)
> +			goto out;
>  
> +		r = crypt_setkey_allcpus(cc);
> +		if (!r)
> +			set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +	}
>  out:
>  	/* Hex key string not needed after here, so wipe it. */
>  	memset(key, '0', key_string_len);
> @@ -1596,6 +1627,8 @@ static int crypt_wipe_key(struct crypt_config *cc)
>  {
>  	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
>  	memset(&cc->key, 0, cc->key_size * sizeof(u8));
> +	kzfree(cc->key_description);
> +	cc->key_description = NULL;
>  
>  	return crypt_setkey_allcpus(cc);
>  }
> @@ -1633,6 +1666,7 @@ static void crypt_dtr(struct dm_target *ti)
>  
>  	kzfree(cc->cipher);
>  	kzfree(cc->cipher_string);
> +	kzfree(cc->key_description);
>  
>  	/* Must zero key material before freeing */
>  	kzfree(cc);
> @@ -2035,10 +2069,13 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>  	case STATUSTYPE_TABLE:
>  		DMEMIT("%s ", cc->cipher_string);
>  
> -		if (cc->key_size > 0)
> -			for (i = 0; i < cc->key_size; i++)
> -				DMEMIT("%02x", cc->key[i]);
> -		else
> +		if (cc->key_size > 0) {
> +			if (cc->key_description)
> +				DMEMIT(":%s", cc->key_description);
> +			else
> +				for (i = 0; i < cc->key_size; i++)
> +					DMEMIT("%02x", cc->key[i]);
> +		} else
>  			DMEMIT("-");
>  
>  		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
> 
