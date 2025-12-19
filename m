Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78495176FB1
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 00:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766103457; cv=none; b=QMzU/+55cmfcPum88ANxJAxWQvprkBiPDKN+MrcEzlZt8Ubk0XC7GhJflpoywJ1riE3S52J+Se6VvdjOCmq9ml5K2gNY4M/GGd2PYQWxd54CklvEbUL6eGpjx0vOMc+iXJsjND6ke7enZVKuh1KAHJqVktX/il1fQWSFyt4nwKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766103457; c=relaxed/simple;
	bh=yqR3TpCdhgyIduBx9mADZfR2KOmGXpwt6lCLKXc3zMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QBDpm1cPNyv77N9HVzFV2ZWZWTb9wFkIbjoBxcdOuTwbGf0AccSUbZGBBX4puucOUiga1ijtqdFjUA8e3dt1fAWvnyviS2xObrYCDu0r8TOIbUD9jbxHccddyk2fN6YpJJJh98TCzCfZp/aB2pz5oi5UUQHHd5sYqt5CP6ayuKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZzIu8ze; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZzIu8ze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766103454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R+SJPtXlnpFNf6QsDkXi/yF6i/JQin2xvTFk0hsXvzE=;
	b=ZZzIu8zeK1zPrXY6erezZW6PoYAZk+CaeqtrCgX8nqXgxygXiHNkB0rGwWac3ENpNqTcRr
	k0SdcMr6r9Ia7WHCdwqAfoaqAFrwC5e4B+n0iliX2ERl7WbMMG1plZ3gayngrppwCFGxRz
	bY2qD7+5RbeJmdqgu7MFGMbR/AZFEzo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-5pN51_m9N52bpQE7YHHgcQ-1; Thu,
 18 Dec 2025 19:17:31 -0500
X-MC-Unique: 5pN51_m9N52bpQE7YHHgcQ-1
X-Mimecast-MFC-AGG-ID: 5pN51_m9N52bpQE7YHHgcQ_1766103450
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A7961956068;
	Fri, 19 Dec 2025 00:17:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C96411956056;
	Fri, 19 Dec 2025 00:17:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BJ0HSsH2124252
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:17:28 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BJ0HSkm2124251;
	Thu, 18 Dec 2025 19:17:28 -0500
Date: Thu, 18 Dec 2025 19:17:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 17/21] libmpathutil: use union for bitfield
Message-ID: <aUSZmCKh12TEqq86@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
 <20251217212113.234959-18-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217212113.234959-18-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k04fjDKTS5bn5V4l0WIgCLDyDcfIvj_yPSsn5_x_58c_1766103450
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2025 at 10:21:09PM +0100, Martin Wilck wrote:
> The macro BITFIELD used a cast of a pointer to a different anonymous struct
> to (struct bitfield *). This violates strict aliasing rules, because the
> two structs aren't compatible types in the sense of the language
> specification. With -O2, gcc 15.1 generates code that makes th pgcmp()
> function fail, because the compiler doesn't initialize bf->len aka
> __storage_for__bf.len to 64.
> 
> The problem will show through error messages like this:
> 
> multipathd[1974208]: is_bit_set_in_bitfield: bitfield overflow: 1 >= 0
> 
> Fix this by using a union
> 
> Fixes: 9a2f173 ("libmpathutil: change STATIC_BITFIELD to BITFIELD")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/util.c       |  8 ++++----
>  libmpathutil/util.h       | 41 +++++++++++++++++++++++----------------
>  libmultipath/configure.c  |  4 ++--
>  libmultipath/pgpolicies.c |  2 +-
>  tests/util.c              | 10 +++++-----
>  5 files changed, 36 insertions(+), 29 deletions(-)
> 
> diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> index 37412c6..5e45750 100644
> --- a/libmpathutil/util.c
> +++ b/libmpathutil/util.c
> @@ -337,15 +337,15 @@ void cleanup_fclose(void *p)
>  		fclose(p);
>  }
>  
> -void cleanup_bitfield(struct bitfield **p)
> +void cleanup_bitfield(union bitfield **p)
>  {
>  	free(*p);
>  }
>  
> -struct bitfield *alloc_bitfield(unsigned int maxbit)
> +union bitfield *alloc_bitfield(unsigned int maxbit)
>  {
>  	unsigned int n;
> -	struct bitfield *bf;
> +	union bitfield *bf;
>  
>  	if (maxbit == 0) {
>  		errno = EINVAL;
> @@ -353,7 +353,7 @@ struct bitfield *alloc_bitfield(unsigned int maxbit)
>  	}
>  
>  	n = (maxbit - 1) / bits_per_slot + 1;
> -	bf = calloc(1, sizeof(struct bitfield) + n * sizeof(bitfield_t));
> +	bf = calloc(1, sizeof(union bitfield) + (n - 1) * sizeof(bitfield_t));
>  	if (bf)
>  		bf->len = maxbit;
>  	return bf;
> diff --git a/libmpathutil/util.h b/libmpathutil/util.h
> index 3799fd4..1ec6a46 100644
> --- a/libmpathutil/util.h
> +++ b/libmpathutil/util.h
> @@ -86,29 +86,36 @@ typedef unsigned int bitfield_t;
>  #endif
>  #define bits_per_slot (sizeof(bitfield_t) * CHAR_BIT)
>  
> -struct bitfield {
> -	unsigned int len;
> -	bitfield_t bits[];
> +union bitfield {
> +	struct {
> +		unsigned int len;
> +		bitfield_t bits[];
> +	};
> +	/* for initialization in the BITFIELD macro */
> +	struct {
> +		unsigned int __len;
> +		bitfield_t __bits[1];
> +	};
>  };
>  
> -#define BITFIELD(name, length)					\
> -	struct {							\
> -		unsigned int len;					\
> -		bitfield_t bits[((length) - 1) / bits_per_slot + 1];	\
> -	} __storage_for__ ## name = {					\
> -		.len = (length),					\
> -		.bits = { 0, },						\
> +/*
> + * gcc 4.9.2 (Debian Jessie) raises an error if the initializer for
> + * .__len comes first. Thus put .__bits first.
> + */
> +#define BITFIELD(name, length)						\
> +	union bitfield __storage_for__ ## name = {			\
> +		.__bits = { 0 },					\
> +		.__len = (length),					\
>  	}; \

It looks like this only allocates one bitfield_t, regardless of length.
Am I missing something here?

-Ben

> -	struct bitfield *name = (struct bitfield *)& __storage_for__ ## name
> +	union bitfield *name = & __storage_for__ ## name
>  
> -struct bitfield *alloc_bitfield(unsigned int maxbit);
> +union bitfield *alloc_bitfield(unsigned int maxbit);
>  
>  void log_bitfield_overflow__(const char *f, unsigned int bit, unsigned int len);
>  #define log_bitfield_overflow(bit, len) \
>  	log_bitfield_overflow__(__func__, bit, len)
>  
> -static inline bool is_bit_set_in_bitfield(unsigned int bit,
> -				       const struct bitfield *bf)
> +static inline bool is_bit_set_in_bitfield(unsigned int bit, const union bitfield *bf)
>  {
>  	if (bit >= bf->len) {
>  		log_bitfield_overflow(bit, bf->len);
> @@ -118,7 +125,7 @@ static inline bool is_bit_set_in_bitfield(unsigned int bit,
>  		  (1ULL << (bit % bits_per_slot)));
>  }
>  
> -static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
> +static inline void set_bit_in_bitfield(unsigned int bit, union bitfield *bf)
>  {
>  	if (bit >= bf->len) {
>  		log_bitfield_overflow(bit, bf->len);
> @@ -127,7 +134,7 @@ static inline void set_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
>  	bf->bits[bit / bits_per_slot] |= (1ULL << (bit % bits_per_slot));
>  }
>  
> -static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
> +static inline void clear_bit_in_bitfield(unsigned int bit, union bitfield *bf)
>  {
>  	if (bit >= bf->len) {
>  		log_bitfield_overflow(bit, bf->len);
> @@ -146,5 +153,5 @@ static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
>  void cleanup_charp(char **p);
>  void cleanup_ucharp(unsigned char **p);
>  void cleanup_udev_device(struct udev_device **udd);
> -void cleanup_bitfield(struct bitfield **p);
> +void cleanup_bitfield(union bitfield **p);
>  #endif /* UTIL_H_INCLUDED */
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index a8e18a2..41b6a9f 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -440,7 +440,7 @@ static int pgcmp(struct multipath *mpp, struct multipath *cmpp)
>  	int i, j;
>  	struct pathgroup *pgp, *cpgp;
>  	BITFIELD(bf, bits_per_slot);
> -	struct bitfield *bf__  __attribute__((cleanup(cleanup_bitfield))) = NULL;
> +	union bitfield *bf__ __attribute__((cleanup(cleanup_bitfield))) = NULL;
>  
>  	if (VECTOR_SIZE(mpp->pg) != VECTOR_SIZE(cmpp->pg))
>  		return 1;
> @@ -1049,7 +1049,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
>  	vector newmp;
>  	struct config *conf = NULL;
>  	int allow_queueing;
> -	struct bitfield *size_mismatch_seen;
> +	union bitfield *size_mismatch_seen;
>  	struct multipath * cmpp;
>  
>  	/* ignore refwwid if it's empty */
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index 2e1a543..57b7485 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -201,7 +201,7 @@ int group_by_match(struct multipath * mp, vector paths,
>  		   bool (*path_match_fn)(struct path *, struct path *))
>  {
>  	int i, j;
> -	struct bitfield *bitmap;
> +	union bitfield *bitmap;
>  	struct path * pp;
>  	struct pathgroup * pgp;
>  	struct path * pp2;
> diff --git a/tests/util.c b/tests/util.c
> index da192ba..67d8148 100644
> --- a/tests/util.c
> +++ b/tests/util.c
> @@ -198,7 +198,7 @@ static uint64_t maybe_swap(uint64_t v)
>  
>  static void test_bitmask_1(void **state)
>  {
> -	struct bitfield *bf;
> +	union bitfield *bf;
>  	uint64_t *arr;
>  	int i, j, k, m, b;
>  
> @@ -240,7 +240,7 @@ static void test_bitmask_1(void **state)
>  
>  static void test_bitmask_2(void **state)
>  {
> -	struct bitfield *bf;
> +	union bitfield *bf;
>  	uint64_t *arr;
>  	int i, j, k, m, b;
>  
> @@ -307,7 +307,7 @@ static void test_bitmask_2(void **state)
>   */
>  static void test_bitmask_len_0(void **state)
>  {
> -	struct bitfield *bf;
> +	union bitfield *bf;
>  
>  	bf = alloc_bitfield(0);
>  	assert_null(bf);
> @@ -329,7 +329,7 @@ static unsigned int maybe_swap_idx(unsigned int i)
>  
>  static void _test_bitmask_small(unsigned int n)
>  {
> -	struct bitfield *bf;
> +	union bitfield *bf;
>  	uint32_t *arr;
>  	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
>  
> @@ -378,7 +378,7 @@ static void _test_bitmask_small(unsigned int n)
>  
>  static void _test_bitmask_small_2(unsigned int n)
>  {
> -	struct bitfield *bf;
> +	union bitfield *bf;
>  	uint32_t *arr;
>  	unsigned int size = maybe_swap_idx((n - 1) / 32) + 1, i;
>  
> -- 
> 2.52.0

