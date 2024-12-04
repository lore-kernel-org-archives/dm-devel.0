Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC51A14287
	for <dm-devel@lists.linux.dev>; Wed,  4 Dec 2024 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332228; cv=none; b=nlN416nCjcsKYxIZWv7mtTqDd7iH/sBes5wqIAI3f+FC3E/dvuhrQHDlQmGIqBvUqCNC/bolHfd1A54LdaJWo33KB6FHbyh/0qKjFH7maWoix35FbGNXanaSVL4S+gBB0ckiDuXI5kbsugK64OcUdQmDalQORVPt2z4+/zx6jtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332228; c=relaxed/simple;
	bh=5c06fUlPUQvUk8H7EcfZn4NjPsnf/f2yz793zWozwKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=nkEVY1dP8Hjn8fdjWJ9XUlG9QubYe9crP5Ifun7kwXYyfpFpE7kz81+eowMOMg9IcvFsxWHoXEWu2v0RDMy3FGQfrceTU99g0whxHAGEkZ1j6OuSmxaDvufM5Oh2CI/bvjC7yu3CjWuYDictcRaWiBU+8KcICb/7fL8zb2UY5Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sw07tUxf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sw07tUxf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733332224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+paZgBmhd6Qlp001VFNuT00WnceoHsAQqEYg22YY9r8=;
	b=Sw07tUxfH2UQD8heqn7qtajSKPuqqBXu27RiCkZ5yTh86803W6/+XTgKyJR+aIpSmePuWH
	qs+PQ7Dfyvb4eKjkO54T51eCOKQ8WHD1x9I7xl7JYD1k1xTv2L+XeFS1SrvibxdSnKPAh1
	pkioKHVhqUffBQ2n2i4RewqJl4H6gMg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-mi0AI-eKMzmUd2W6_NZAzQ-1; Wed,
 04 Dec 2024 12:10:21 -0500
X-MC-Unique: mi0AI-eKMzmUd2W6_NZAzQ-1
X-Mimecast-MFC-AGG-ID: mi0AI-eKMzmUd2W6_NZAzQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 488C91956087;
	Wed,  4 Dec 2024 17:10:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6B101955F42;
	Wed,  4 Dec 2024 17:10:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B4HAI3Y1201563
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Dec 2024 12:10:18 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B4HAHGc1201562;
	Wed, 4 Dec 2024 12:10:17 -0500
Date: Wed, 4 Dec 2024 12:10:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 5/8] libmultipath: re-implement pgcmp without the
 pathgroup id
Message-ID: <Z1CM-ZsJxEy197kg@redhat.com>
References: <20241203214702.107918-1-mwilck@suse.com>
 <20241203214702.107918-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241203214702.107918-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N4Vcnsm4RgXhU9aAgutcERehA9hPFfO9VxWpZNI4Iuk_1733332220
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2024 at 10:47:02PM +0100, Martin Wilck wrote:
> pgp->id is not only calculated with a weak XOR hash, it can also
> get wrong if any path regrouping occurs. As it's not a big gain
> performance-wise, just drop pgp->id and compare path groups
> directly.
> 
> The previous algorithm didn't detect the case case where cpgp
> contained a path that was not contained in pgp. Fix this, too,
> by comparing the number of paths in the path groups and making
> sure that each pg of mpp is matched by exactly one pg of cmpp.
> 
> Fixes: 90773ba ("libmultipath: resolve hash collisions in pgcmp()")
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/configure.c | 87 ++++++++++++++++++++++++++--------------
>  libmultipath/dmparser.c  |  1 -
>  libmultipath/structs.h   |  1 -
>  3 files changed, 56 insertions(+), 33 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 9ab84d5..bfa8a39 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -416,16 +416,6 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
>  	return 0;
>  }
>  
> -static void
> -compute_pgid(struct pathgroup * pgp)
> -{
> -	struct path * pp;
> -	int i;
> -
> -	vector_foreach_slot (pgp->paths, pp, i)
> -		pgp->id ^= (long)pp;
> -}
> -
>  static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
>  {
>  	int i, j;
> @@ -445,32 +435,71 @@ static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
>  	return pnum - found;
>  }
>  
> -static int
> -pgcmp (struct multipath * mpp, struct multipath * cmpp)
> +static int pgcmp(struct multipath *mpp, struct multipath *cmpp)
>  {
>  	int i, j;
> -	struct pathgroup * pgp;
> -	struct pathgroup * cpgp;
> -	int r = 0;
> +	struct pathgroup *pgp, *cpgp;
> +	BITFIELD(bf, bits_per_slot);
> +	struct bitfield *bf__  __attribute__((cleanup(cleanup_bitfield))) = NULL;
>  
> -	if (!mpp)
> -		return 0;
> +	if (VECTOR_SIZE(mpp->pg) != VECTOR_SIZE(cmpp->pg))
> +		return 1;
> +
> +	/* handle the unlikely case of more than 64 pgs */
> +	if ((unsigned int)VECTOR_SIZE(cmpp->pg) > bits_per_slot) {
> +		bf__ = alloc_bitfield(VECTOR_SIZE(cmpp->pg));
> +		if (bf__ == NULL)
> +			/* error - if in doubt, assume not equal */
> +			return 1;
> +		bf = bf__;
> +	}
>  
>  	vector_foreach_slot (mpp->pg, pgp, i) {
> -		compute_pgid(pgp);
>  
> -		vector_foreach_slot (cmpp->pg, cpgp, j) {
> -			if (pgp->id == cpgp->id &&
> -			    !pathcmp(pgp, cpgp)) {
> -				r = 0;
> -				break;
> +		if (VECTOR_SIZE(pgp->paths) == 0) {
> +			bool found = false;
> +
> +			vector_foreach_slot (cmpp->pg, cpgp, j) {
> +				if (!is_bit_set_in_bitfield(j, bf) &&
> +				    VECTOR_SIZE(cpgp->paths) == 0) {
> +					set_bit_in_bitfield(j, bf);
> +					found = true;
> +					break;
> +				}
>  			}
> -			r++;
> +			if (!found)
> +				return 1;
> +		} else {
> +			bool found = false;
> +			struct path *pp = VECTOR_SLOT(pgp->paths, 0);
> +
> +			/* search for a pg in cmpp that contains pp */
> +			vector_foreach_slot (cmpp->pg, cpgp, j) {
> +				if (!is_bit_set_in_bitfield(j, bf) &&
> +				    VECTOR_SIZE(cpgp->paths) == VECTOR_SIZE(pgp->paths)) {
> +					int k;
> +					struct path *cpp;
> +
> +					vector_foreach_slot(cpgp->paths, cpp, k) {
> +						if (cpp != pp)
> +							continue;
> +						/*
> +						 * cpgp contains pp.
> +						 * See if it's identical.
> +						 */
> +						set_bit_in_bitfield(j, bf);
> +						if (pathcmp(pgp, cpgp))
> +							return 1;
> +						found = true;
> +						break;
> +					}
> +				}
> +			}
> +			if (!found)
> +				return 1;
>  		}
> -		if (r)
> -			return r;
>  	}
> -	return r;
> +	return 0;
>  }
>  
>  void trigger_partitions_udev_change(struct udev_device *dev,
> @@ -763,10 +792,6 @@ void select_action (struct multipath *mpp, const struct vector_s *curmp,
>  		select_reload_action(mpp, "minio change");
>  		return;
>  	}
> -	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
> -		select_reload_action(mpp, "path group number change");
> -		return;
> -	}
>  	if (pgcmp(mpp, cmpp)) {
>  		select_reload_action(mpp, "path group topology change");
>  		return;
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 1d0506d..c8c47e0 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -307,7 +307,6 @@ int disassemble_map(const struct vector_s *pathvec,
>  
>  			free(word);
>  
> -			pgp->id ^= (long)pp;
>  			pp->pgindex = i + 1;
>  
>  			for (k = 0; k < num_paths_args; k++)
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 49d9a2f..2159cb3 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -531,7 +531,6 @@ static inline int san_path_check_enabled(const struct multipath *mpp)
>  }
>  
>  struct pathgroup {
> -	long id;
>  	int status;
>  	int priority;
>  	int enabled_paths;
> -- 
> 2.47.0

