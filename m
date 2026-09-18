Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715C33BFAEB;
	Fri, 18 Sep 2026 02:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789698585; cv=none; b=VS6oDG5emjTTizhcSowoU7yTTLss1lm6CYqqU+KaFVzGQs4TeeUJNm+V1ckvpLZAhMsHpSvWYwH0AR52W/qMrslsdl/EoxOTCKuOpSGbMah1aIjuB13xMsvau8zBdzyfNhmwoeZuWZFYM4SdFCkBnsvpEU1fuiOE//H+5dv3OEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789698585; c=relaxed/simple;
	bh=zr6RZjqy8zkfck/Pdh/SCIhM1e3d18vR1boWvALaMiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALesK0gG8O1NK9BtxfC4gme2ctV6XKet6bbZz17U53CPwfHelV3jowQoLgNLimNDyuccrNghTJ12y8yIwBMxj60AsJLU3D2Y6Q/bcEPWEp2pRzSOwzeswMZ4f8vi83Npdafyy5dfbKeFFcQ3BlltX8LQ66uoKPZzcca9JdZoxeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITubRvvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITubRvvc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A94C41F000FF;
	Fri, 18 Sep 2026 02:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789698573;
	bh=g9YcUG3szeoayvwUqM/cv8sctvahn3Ihcoi9jbjGOnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ITubRvvc3F/vvkNNV3easTtv4kW2t5sTGcQTrFimYGHRTwrI36hleEBj04p+G4rD+
	 NamNYIZiDAoFX0JrbXdOJ6jo1MW4JQvtJnZely7Mw/DeVKHz4e/H85J6KnkgRoEc5I
	 cLgsJVPAcMhvkwd6xKrLPl8G7InF+UXtNbbg8ngK7txU/xCUsC+I9gO05MwuE3doN2
	 /gdrMcCm4IwXBvGjSc4UnL+t92rx9lkE502wmrjLTerz13U0wjK5mG4QN8XgBagAGv
	 EMbNmlXejAvA43Xb6vzKXOfltB7g1Z9/tWbDe2iu9Z8WZCKSMHvXSmuAd1wqPLTC/4
	 Z4KrVoDpwIZWQ==
Date: Fri, 18 Sep 2026 05:29:29 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andrew Halaney <andrew@amutable.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
	fsverity@lists.linux.dev, linux-doc@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Message-ID: <aqyiCavj3xeNqyAo@kernel.org>
References: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
 <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>

On Mon, Sep 14, 2026 at 11:41:42AM -0500, Andrew Halaney wrote:
> The .dm-verity keyring is not linked into any process keyring, so
> request_key() and KEYCTL_SEARCH cannot find it. Userspace has to scrape
> /proc/keys for the serial to use.
> 
> That's not great, one could put in a bogus description containing
> a newline to confuse userspace further. For example, thanks to AI
> models, which I run as root but you could show off as any old user:
> 
>     # DESC=$'.dm-verity: 1\n0badf00d I--Q---     1 perm 082f0000     0     0 keyring   .dm-verity'
>     # k=$(echo -n "1234567" | keyctl padd user "$DESC" @s)
>     # keyctl setperm "$k" 0x3f010001
> 
>     # cat /proc/keys | grep dm-verity
>     10402023 I------     2 perm 082f0000     0     0 keyring   .dm-verity: empty
>     12e0bee6 I--Q---     1 perm 3f010001     0     0 user      .dm-verity: 1
>     0badf00d I--Q---     1 perm 082f0000     0     0 keyring   .dm-verity: 7
> 
> 0x0badf00d is not a keyring, it is the text inside our user's key
> description. Telling the two apart needs a KEYCTL_DESCRIBE per row
> which is annoying to do. i.e.:
> 
>     # keyctl rdescribe 0x10402023
>     keyring;0;0;082f0000;.dm-verity
>     # keyctl rdescribe 0x0badf00d
>     keyctl_describe: Required key not available
> 
> Let's just give it a well known identifier, i.e.:
> 
>     # keyctl rdescribe -10
>     keyring;0;0;082f0000;.dm-verity
> 
> This is exactly what
> commit 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")
> did, and was the inspiration for this commit minus the spinlock bits
> required due to dm-verity being a module.

This is great for discussion but what we want for the commit message
is just motivation and resolution.

I don't think we need all this just to say that /proc/keys in a racy
query mechanism for production, which is an issue for dm-verity, given
that nothing else is available.

And secondly special keys are meant for implicit keyrings so isn't
that all there's to it?


> 
> Suggested-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Signed-off-by: Andrew Halaney <andrew@amutable.com>
> ---
>  drivers/md/dm-verity-verify-sig.c |  3 +++
>  include/linux/key.h               |  1 +
>  include/uapi/linux/keyctl.h       |  1 +
>  security/keys/process_keys.c      | 33 +++++++++++++++++++++++++++++++++
>  4 files changed, 38 insertions(+)
> 
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index b2b55c41e2cb..da509dcdd7e5 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -189,11 +189,14 @@ int __init dm_verity_verify_sig_init(void)
>  	    keyring_restrict(make_key_ref(dm_verity_keyring, true), NULL, NULL))
>  		panic("dm-verity can't seal keyring\n");
>  
> +	key_register_dm_verity_keyring(dm_verity_keyring);
> +
>  	return 0;
>  }
>  
>  void dm_verity_verify_sig_exit(void)
>  {
> +	key_register_dm_verity_keyring(NULL);
>  	key_revoke(dm_verity_keyring);
>  	key_put(dm_verity_keyring);
>  }
> diff --git a/include/linux/key.h b/include/linux/key.h
> index bd10fe45819d..ae8d3314fd93 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -441,6 +441,7 @@ extern int keyring_restrict(key_ref_t keyring, const char *type,
>  			    const char *restriction);
>  
>  extern void key_register_bpf_keyring(struct key *keyring);
> +extern void key_register_dm_verity_keyring(struct key *keyring);
>  
>  extern struct key *key_lookup(key_serial_t id);
>  
> diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> index fa85b9760391..75923941f1b3 100644
> --- a/include/uapi/linux/keyctl.h
> +++ b/include/uapi/linux/keyctl.h
> @@ -25,6 +25,7 @@
>  #define KEY_SPEC_REQKEY_AUTH_KEY	-7	/* - key ID for assumed request_key auth key */
>  #define KEY_SPEC_REQUESTOR_KEYRING	-8	/* - key ID for request_key() dest keyring */
>  #define KEY_SPEC_BPF_KEYRING		-9	/* - key ID for the BPF-specific keyring */
> +#define KEY_SPEC_DM_VERITY_KEYRING	-10	/* - key ID for the .dm-verity keyring */
>  
>  /* request-key default keyrings */
>  #define KEY_REQKEY_DEFL_NO_CHANGE		-1
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 44358388e395..dba3df41638b 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -25,6 +25,10 @@ static DEFINE_MUTEX(key_session_mutex);
>  /* BPF keyring reachable through KEY_SPEC_BPF_KEYRING */
>  static struct key *bpf_keyring __ro_after_init;
>  
> +/* dm-verity keyring reachable through KEY_SPEC_DM_VERITY_KEYRING */
> +static struct key *dm_verity_keyring;
> +static DEFINE_SPINLOCK(dm_verity_keyring_lock);
> +
>  /* The root user's tracking struct */
>  struct key_user root_key_user = {
>  	.usage		= REFCOUNT_INIT(3),
> @@ -607,6 +611,24 @@ void key_register_bpf_keyring(struct key *keyring)
>  	bpf_keyring = keyring;
>  }
>  
> +/**
> + * key_register_dm_verity_keyring - Publish the keyring for KEY_SPEC_DM_VERITY_KEYRING
> + * @keyring: The keyring to publish, or NULL to withdraw it
> + *
> + * Make @keyring reachable by userspace through the KEY_SPEC_DM_VERITY_KEYRING
> + * special key ID, so that provisioning it does not require scraping its
> + * serial out of /proc/keys first. dm-verity can be unloaded as a module
> + * and the keyring deregistered, as such serialize access with
> + * dm_verity_keyring_lock.
> + */
> +void key_register_dm_verity_keyring(struct key *keyring)
> +{
> +	spin_lock(&dm_verity_keyring_lock);
> +	dm_verity_keyring = keyring;
> +	spin_unlock(&dm_verity_keyring_lock);
> +}
> +EXPORT_SYMBOL_GPL(key_register_dm_verity_keyring);
> +
>  /*
>   * Look up a key ID given us by userspace with a given permissions mask to get
>   * the key it refers to.
> @@ -766,6 +788,17 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
>  		key_ref = make_key_ref(key, 0);
>  		break;
>  
> +	case KEY_SPEC_DM_VERITY_KEYRING:
> +		spin_lock(&dm_verity_keyring_lock);
> +		key = dm_verity_keyring;
> +		if (key)
> +			__key_get(key);
> +		spin_unlock(&dm_verity_keyring_lock);
> +		if (!key)
> +			goto error;
> +		key_ref = make_key_ref(key, 0);
> +		break;
> +
>  	default:
>  		key_ref = ERR_PTR(-EINVAL);
>  		if (id < 1)
> 
> -- 
> 2.55.0
> 

BR, Jarkko
