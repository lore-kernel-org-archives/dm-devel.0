Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794290801;
	b=bvkR+uUGf6/kjKNJcuD2xtW+5MrZzEqwicSArPhBLijiMXem1FgAEr840wm0wiiSc53S
	 B384iC949ke3PgIkB38eejMt1n/GVt3r2/OQou9+qEuWPdPGGAWk7Y0Y+Tz+8gqgUv0yr
	 pH7yB5LN8cpIpsHMYS7KmkXdeZK21jFk1iR1w1wRDsABdufINkg/UP4DYnUvljaJe+6nR
	 qVFFc3/pSWXdCm7cPTPBLnyI2FuzFwSCp9fI9XQ6gv3R+hm0LmZHXQfp6nJ54sdJewAWQ
	 qBTZ9oQGYrOpdZfyrBbrLlKUmmgdfGW2lupuLrDhwz+xlWmWscALb8K1TWFcROBu6pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794290801;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Hnh10F1zQfs5wctp+i2aDmqIYavrqW0fRXfCXxRBWTE=;
	b=Y+IrpMwTBYWDBW7NLei4ErsrHYLdkaPn1wTv5MvWYoNTpjOxJCeF8JCknAZDgkKU8Dqj
	 Vu+amg0YiKqlxshfaPjOHb5yMlsrc7H/WMJ08E8KzjW/+5L84AQ7/7TflOFIjD/oYIRlW
	 YFaSgHJX4WjZrTlsyHygfRJdjTEpP/157ss2ClwKTzxgxL969LL88ueNmleCV0xRfqfX6
	 hKJDRjWHdnMwLTDqRjCsamNAzcZ1TXz14TjFGNkioiDGRRbhpOaTQ46yQBMLG3ZHgiJ4C
	 DqWWj8xt9WGuXZVnJY6r3Xise0Au1aGhYHoPCaModqa9pYdqa27BcYWMHOc8zm0TQ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eb8TtXll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DC7CA606A321;
	Tue, 10 Nov 2026 06:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eb8TtXll
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9088E1F0089F;
	Tue, 10 Nov 2026 06:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290800;
	bh=Hnh10F1zQfs5wctp+i2aDmqIYavrqW0fRXfCXxRBWTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eb8TtXllKp/I2wuhSS3q+9ykKbgSIsPs7gk7VfGNWmGNU+WjweUEnFKh9TgZTVkGq
	 sMrc6PQ+88V8fzudWMldoKc2AVHklkzkYa0+40xfi3AW18Q/K4K9h/OocoZpCsVTc7
	 P3U7Lk6TDzGXSUBWVX72i99ctq9fxpCEAf7EPOcoxKbQ5HoOJlAOSS9DWUBbMFrSGs
	 wq0Ih3E/DaXojtDOLNMTToD5a4szza7K5jiOH90rJg25i7q+WgS1YpUPqvG8ck732L
	 facfIldhFjw/2ZFAetpxsSvQgpdMsJ0r4OYiQPZlv8X139dzSSBMZ5/L3G1OVKmP/B
	 +37+kwO7JItFQ==
Date: Tue, 10 Nov 2026 08:06:36 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
	keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ignat Korchagin <ignat@linux.win>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Morris <jmorris@namei.org>, Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>, Song Liu <song@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v9 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <avK0bC5VmO7LXlfS@kernel.org>
References: <20261110053323.2936729-1-jarkko@kernel.org>
 <20261110053323.2936729-3-jarkko@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110053323.2936729-3-jarkko@kernel.org>

On Tue, Nov 10, 2026 at 07:33:22AM +0200, Jarkko Sakkinen wrote:
>  /*
>   * Preallocate memory so that a key can be linked into to a keyring.
>   */
>  int __key_link_begin(struct key *keyring,
>  		     const struct keyring_index_key *index_key,
> -		     struct assoc_array_edit **_edit)
> +		     struct keyring_edit *edit)
>  {
> -	struct assoc_array_edit *edit;
> +	struct keyring_link *link = NULL;
> +	struct keyring_link *replace;
> +	struct keyring_index *links;
>  	int ret;
>  
>  	kenter("%d,%s,%s,",
>  	       keyring->serial, index_key->type->name, index_key->description);
>  
> -	BUG_ON(index_key->desc_len == 0);
> -	BUG_ON(*_edit != NULL);
> +	if (WARN_ON(index_key->desc_len == 0) || WARN_ON(edit->new)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
> -	*_edit = NULL;
> +	edit->new = NULL;
> +	edit->old = NULL;
>  
> -	ret = -EKEYREVOKED;
> -	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
> -		goto error;
> +	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags)) {
> +		ret = -EKEYREVOKED;
> +		goto out;
> +	}
>  
> -	/* Create an edit script that will insert/replace the key in the
> -	 * keyring tree.
> -	 */
> -	edit = assoc_array_insert(&keyring->keys,
> -				  &keyring_assoc_array_ops,
> -				  index_key,
> -				  NULL);
> -	if (IS_ERR(edit)) {
> -		ret = PTR_ERR(edit);
> -		goto error;
> +	links = keyring_get_index(keyring);
> +	if (IS_ERR(links)) {
> +		ret = PTR_ERR(links);
> +		goto out;
>  	}
>  
> -	/* If we're not replacing a link in-place then we're going to need some
> +	link = kzalloc_obj(struct keyring_link);
> +	if (!link) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	link->hash = index_key->hash;
> +
> +	replace = keyring_find_link(links, index_key);
> +
> +	/*
> +	 * If we're not replacing a link in-place then we're going to need some
>  	 * extra quota.
>  	 */
> -	if (!edit->dead_leaf) {
> +	if (!replace) {
>  		ret = key_payload_reserve(keyring,
>  					  keyring->datalen + KEYQUOTA_LINK_BYTES);
>  		if (ret < 0)
> -			goto error_cancel;
> +			goto out;
> +
> +		ret = rhashtable_insert_fast(&links->ht, &link->node,
> +					     keyring_link_params);
> +		if (ret < 0) {
> +			key_payload_reserve(keyring,
> +					    keyring->datalen - KEYQUOTA_LINK_BYTES);
> +			goto out;
> +		}
>  	}
>  
> -	*_edit = edit;
> -	kleave(" = 0");
> -	return 0;
> +	edit->new = link;
> +	edit->old = replace;
> +	ret = 0;
>  
> -error_cancel:
> -	assoc_array_cancel_edit(edit);
> -error:
> +out:
> +	if (ret && link)
> +		kfree(link);
>  	kleave(" = %d", ret);
>  	return ret;
>  }

No additional Sashiko complains.

Despite a few unfortunate extra rounds I'm happy how this shaped in the
end. It has a sane flow now I think.

And it definitely made sense to drop cleanup.h shenanigans from
__key_link_begin().

Br, Jarkko
