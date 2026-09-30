Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5A4F68A7
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780444; cv=none; b=nSWAPDkQgInlKuUa62ywiEGiAx9MZoZ0EpcYKzc1XvOa1H9rdY0LtFLzYCS/icMOF28K9fJtAmntZz9njED9Mn9vblDQCw7ZupnN2X8vCK7xGM9Q6uuH7NzqQSqJyUPRpX3BZpQIAng23LU3k9p6pbhGksIyOcbb9VomcKdFylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780444; c=relaxed/simple;
	bh=/a0FN8TPTH+ZWPDCO0F2/9QcJbvbJKS+B4rNAXxKr6o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fpMzR2SI8+4akgHV7oaZ/WDiuiUoiitA+d476G6OF25lYWLwjn4DeQgpw2TSyNWXLolNXW3GwLcObXzGmkey9GdOMJeo1iSV0YWuNfx5peIXERUBdaYxM6YVi4SW5XGJiFTj9k9Ktzoj9Ck71UIrT0KfyOIjD3i6vh6vBSEwOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUxG2qxA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUxG2qxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790780432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S93pEZ/6C/TPD2WqdlM9j2cbq6p6AoqHGSar5KAdPig=;
	b=cUxG2qxAt1vYGC+tGlmJBoKgZSjdqm/wGO0O4mPWFxhCnuKf78bQxVE5kc0Z0wDZGnqFW9
	YDN5dY9twKfYb6bRPwRizYSWfAnlehfF6ERWPQhFgYW3hIOWVbjTfhf+3W5Rv7tbunAPQN
	NdT6ZX6PdEOXLcQ29IGBRWhwp5qyovw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-ntzu5yWEMLGH5lq2ozvX4Q-1; Wed,
 30 Sep 2026 11:00:29 -0400
X-MC-Unique: ntzu5yWEMLGH5lq2ozvX4Q-1
X-Mimecast-MFC-AGG-ID: ntzu5yWEMLGH5lq2ozvX4Q_1790780427
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A2641953948;
	Wed, 30 Sep 2026 15:00:27 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB19830000E7;
	Wed, 30 Sep 2026 15:00:24 +0000 (UTC)
Date: Wed, 30 Sep 2026 17:00:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenz Kofler <lorenz@sigma-star.at>
cc: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    upstream+dm@sigma-star.at
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel
 keyring
In-Reply-To: <20260928062734.3805458-2-lorenz@sigma-star.at>
Message-ID: <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com>
References: <20260928062734.3805458-1-lorenz@sigma-star.at> <20260928062734.3805458-2-lorenz@sigma-star.at>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Ua9QWsSPOGXI-IZE0CPKdkd2jPmra9CT4QG1p0kLSbQ_1790780427
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Generally, the approach in this patch is OK.

Here I have some comments for the patch:

Mikulas



The patch should increase target version - from "{1, 15, 0}" to "{1, 16, 
0}".


On Mon, 28 Sep 2026, Lorenz Kofler wrote:

> The keys of internal_hash, journal_crypt and journal_mac can only be
> given as hex strings in the table. Keys that never leave the kernel,
> such as trusted keys, cannot be used.
> 
> In addition to hex strings, accept keys from the kernel keyring in the
> same format as dm-crypt: ":<key_size>:<key_type>:<key_description>".
> The lookup is the same as in dm-crypt.
> 
> Like DM_CRYPT, DM_INTEGRITY must not be built in when the encrypted or
> trusted key types are modules.
> 
> Signed-off-by: Lorenz Kofler <lorenz@sigma-star.at>
> ---
>  .../device-mapper/dm-integrity.rst            |  25 +++
>  drivers/md/Kconfig                            |   2 +
>  drivers/md/dm-integrity.c                     | 164 ++++++++++++++++++
>  3 files changed, 191 insertions(+)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> index 9c21301423c9..2b7f82912962 100644
> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> @@ -146,6 +146,8 @@ internal_hash:algorithm(:key)	(the key is optional)
>  	from an upper layer target, such as dm-crypt. The upper layer
>  	target should check the validity of the integrity tags.
>  
> +	The format of the key is described below the list of arguments.
> +
>  recalculate
>  	Recalculate the integrity tags automatically. It is only valid
>  	when using internal hash.
> @@ -162,6 +164,8 @@ journal_crypt:algorithm(:key)	(the key is optional)
>  	the size of files that were written. To protect against this
>  	situation, you can encrypt the journal.
>  
> +	The format of the key is described below the list of arguments.
> +
>  journal_mac:algorithm(:key)	(the key is optional)
>  	Protect sector numbers in the journal from accidental or malicious
>  	modification. To protect against accidental modification, use a
> @@ -173,6 +177,8 @@ journal_mac:algorithm(:key)	(the key is optional)
>  	the journal. Thus, modified sector number would be detected at
>  	this stage.
>  
> +	The format of the key is described below the list of arguments.
> +
>  block_size:number (default 512)
>  	The size of a data block in bytes. The larger the block size the
>  	less overhead there is for per-block integrity metadata.
> @@ -225,6 +231,25 @@ legacy_recalculate
>  	set recalc_sector to zero, and the kernel would not detect the
>  	modification.
>  
> +The key of internal_hash, journal_crypt and journal_mac is encoded either as
> +a hexadecimal number or it can be passed as <key_string> prefixed with single
> +colon character (':') for keys residing in kernel keyring service.

The documentation omits the fact that you need double colon "::" - one 
colon to end the argument name and one colon as the key prefix.

> +
> +<key_string>
> +	The kernel keyring key is identified by string in following format:
> +	<key_size>:<key_type>:<key_description>.
> +
> +<key_size>
> +	The key size in bytes. The kernel key payload size must match
> +	the value passed in <key_size>.
> +
> +<key_type>
> +	Either 'logon', 'user', 'encrypted' or 'trusted' kernel key type.
> +
> +<key_description>
> +	The kernel keyring key description integrity target should look for
> +	when loading key of <key_type>.
> +
>  The journal mode (D/J), buffer_sectors, journal_watermark, commit_time and
>  allow_discards can be changed when reloading the target (load an inactive
>  table and swap the tables with suspend and resume). The other arguments
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index df27c7d066d2..e93bf0c3119d 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -653,6 +653,8 @@ config DM_LOG_WRITES
>  config DM_INTEGRITY
>  	tristate "Integrity target support"
>  	depends on BLK_DEV_DM
> +	depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
> +	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
>  	select BLK_DEV_INTEGRITY
>  	select DM_BUFIO
>  	select CRYPTO
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 92970e12267a..6995c870cbf5 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -25,6 +25,11 @@
>  #include <crypto/utils.h>
>  #include <linux/async_tx.h>
>  #include <linux/dm-bufio.h>
> +#include <linux/ctype.h>
> +#include <linux/key.h>
> +#include <keys/user-type.h>
> +#include <keys/encrypted-type.h>
> +#include <keys/trusted-type.h>
>  
>  #include "dm-audit.h"
>  
> @@ -4415,6 +4420,152 @@ static void free_alg(struct alg_spec *a)
>  	memset(a, 0, sizeof(*a));
>  }
>  
> +#ifdef CONFIG_KEYS
> +
> +static bool contains_whitespace(const char *str)
> +{
> +	while (*str)
> +		if (isspace(*str++))
> +			return true;
> +	return false;
> +}
> +
> +static int set_key_user(struct alg_spec *a, struct key *key)
> +{
> +	const struct user_key_payload *ukp;
> +
> +	ukp = user_key_payload_locked(key);
> +	if (!ukp)
> +		return -EKEYREVOKED;
> +
> +	if (a->key_size != ukp->datalen)
> +		return -EINVAL;
> +
> +	memcpy(a->key, ukp->data, a->key_size);
> +
> +	return 0;
> +}
> +
> +static int set_key_encrypted(struct alg_spec *a, struct key *key)
> +{
> +	const struct encrypted_key_payload *ekp;
> +
> +	ekp = key->payload.data[0];
> +	if (!ekp)
> +		return -EKEYREVOKED;
> +
> +	if (a->key_size != ekp->decrypted_datalen)
> +		return -EINVAL;
> +
> +	memcpy(a->key, ekp->decrypted_data, a->key_size);
> +
> +	return 0;
> +}
> +
> +static int set_key_trusted(struct alg_spec *a, struct key *key)
> +{
> +	const struct trusted_key_payload *tkp;
> +
> +	tkp = key->payload.data[0];
> +	if (!tkp)
> +		return -EKEYREVOKED;
> +
> +	if (a->key_size != tkp->key_len)
> +		return -EINVAL;
> +
> +	memcpy(a->key, tkp->key, a->key_size);
> +
> +	return 0;
> +}

These four functions are copied from dm-crypt.c and dm-inlinecrypt.c. 
Copying code is generally malpattern, they should be unified and moved to 
an include file (that would be included in all three targets) or to the 
key management code (that would be called from all three targets).

> +/*
> + * Load the key from the kernel keyring. a->key_string has the format
> + * ":<key_size>:<key_type>:<key_description>".
> + */
> +static int get_alg_key_from_keyring(struct alg_spec *a)
> +{
> +	int (*set_key)(struct alg_spec *a, struct key *key);
> +	const char *key_type_desc, *key_desc;
> +	struct key_type *type;
> +	unsigned int key_size;
> +	struct key *key;
> +	char dummy;
> +	int r;
> +
> +	/*
> +	 * Reject key_string with whitespace. dm core currently lacks code for
> +	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
> +	 */
> +	if (contains_whitespace(a->key_string))
> +		return -EINVAL;
> +
> +	if (sscanf(a->key_string, ":%u%c", &key_size, &dummy) != 2 || dummy != ':')
> +		return -EINVAL;
> +	if (!key_size || key_size > KMALLOC_MAX_SIZE)
> +		return -EINVAL;

KMALLOC_MAX_SIZE allocations are unreliable, they may fail randomly 
anytime.

You should use "PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER" as the limit (I 
assume that this is enough for the key) - this is the reliability 
threshold for kmalloc.

If you really need larger allocation, you should use vmalloc or kvmalloc.

> +	/* skip ":<key_size>:", the sscanf() above guarantees the second ':' */
> +	key_type_desc = strchr(a->key_string + 1, ':') + 1;
> +
> +	/* look for next ':' separating key_type from key_description */
> +	key_desc = strchr(key_type_desc, ':');
> +	if (!key_desc || key_desc == key_type_desc || !strlen(key_desc + 1))
> +		return -EINVAL;
> +
> +	if (!strncmp(key_type_desc, "logon:", key_desc - key_type_desc + 1)) {
> +		type = &key_type_logon;
> +		set_key = set_key_user;
> +	} else if (!strncmp(key_type_desc, "user:", key_desc - key_type_desc + 1)) {
> +		type = &key_type_user;
> +		set_key = set_key_user;
> +	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
> +		   !strncmp(key_type_desc, "encrypted:", key_desc - key_type_desc + 1)) {
> +		type = &key_type_encrypted;
> +		set_key = set_key_encrypted;
> +	} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
> +		   !strncmp(key_type_desc, "trusted:", key_desc - key_type_desc + 1)) {
> +		type = &key_type_trusted;
> +		set_key = set_key_trusted;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	a->key = kmalloc(key_size, GFP_KERNEL);
> +	if (!a->key)
> +		return -ENOMEM;
> +	a->key_size = key_size;
> +
> +	key = request_key(type, key_desc + 1, NULL);
> +	if (IS_ERR(key)) {
> +		r = PTR_ERR(key);
> +		goto free_key;
> +	}
> +
> +	down_read(&key->sem);
> +	r = set_key(a, key);
> +	up_read(&key->sem);
> +	key_put(key);
> +	if (r < 0)
> +		goto free_key;
> +
> +	return 0;
> +
> +free_key:
> +	kfree_sensitive(a->key);
> +	a->key = NULL;
> +	a->key_size = 0;
> +	return r;
> +}
> +
> +#else
> +
> +static int get_alg_key_from_keyring(struct alg_spec *a)
> +{
> +	return -EINVAL;
> +}
> +
> +#endif /* CONFIG_KEYS */
> +
>  static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, char *error_inval)
>  {
>  	char *k;
> @@ -4429,6 +4580,19 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
>  	if (k) {
>  		*k = 0;
>  		a->key_string = k + 1;
> +
> +		if (a->key_string[0] == ':') {
> +			int r = get_alg_key_from_keyring(a);
> +
> +			if (r == -ENOMEM)
> +				goto nomem;
> +			if (r == -EINVAL)
> +				goto inval;
> +			if (r)
> +				*error = "Cannot get key from the kernel keyring";
> +			return r;
> +		}
> +
>  		if (strlen(a->key_string) & 1)
>  			goto inval;
>  
> -- 
> 2.55.0
> 

