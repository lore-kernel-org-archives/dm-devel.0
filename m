Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B01B10E3
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 00:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733185034; cv=none; b=lIuCHj6C85rC77DIdrEjuZ2UyCc5t6VBViL4PoQNC7ghH9YIwq1/1BAr6PBaGpFkuo3f3PIeHT/hkH0Yp8FIlC5TQbEV8faIaPF6soxnuBDi/Jsl5kM03l8n7sWPk9gEjrVz70jK38PqCfJExEapooezleQZies26iZf070zwIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733185034; c=relaxed/simple;
	bh=vXUaeoWOctlEor5ADms0SRlUXfRgh8Zuu4VFsV4huj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=SiX6HiVvuHnGectRiyHxkz2F9pAUcOQpf6OuNBPEd9nhlLZMp9MY2lQwrgyzKqJKWX589hWMTtx0876bJQs46X+M8z3fdJzMBL68lp0beAM5bGZyNz/by+zBfEYzLKKOfzugVE92PxkX+RZiPexfIF3QGQsDo7CCstxykAo0T9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZpUuURF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZpUuURF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733185031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jkwpo7U8uLLi1bUpVokHP+849munELT601U+7VjwSoA=;
	b=WZpUuURFDEFwxSG+BjeYBywJHwxRyUVUjdjXHTbc9rEQj6UcWjdcp8h3f68M5k23VD1Gsn
	jPcdcxN4u7TkvHSbm5F6aiSyIoHS8PLhrmXlRGoHefCKjht2CV2bXm0WDt9gRlWsWsMZzP
	bjjwTlgcIFVMYTTNiikeSjf5fj8rOFw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-vmVtEvOxNXGtMGwnWm_KFw-1; Mon,
 02 Dec 2024 19:17:10 -0500
X-MC-Unique: vmVtEvOxNXGtMGwnWm_KFw-1
X-Mimecast-MFC-AGG-ID: vmVtEvOxNXGtMGwnWm_KFw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB5CB1955D91;
	Tue,  3 Dec 2024 00:17:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81AE21956052;
	Tue,  3 Dec 2024 00:17:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B30H6ej1146285
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 2 Dec 2024 19:17:07 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B30H6711146284;
	Mon, 2 Dec 2024 19:17:06 -0500
Date: Mon, 2 Dec 2024 19:17:06 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 5/8] libmultipath: re-implement pgcmp without the
 pathgroup id
Message-ID: <Z05OAl5bhpsruTLh@redhat.com>
References: <20241127230430.139639-1-mwilck@suse.com>
 <20241127230430.139639-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241127230430.139639-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eNJ3BTCPzBbNVba-68pStMjVoNWOcmJSuw0JHQsY0SQ_1733185029
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 28, 2024 at 12:04:27AM +0100, Martin Wilck wrote:
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
> ---
>  libmultipath/configure.c | 94 ++++++++++++++++++++++++++--------------
>  libmultipath/dmparser.c  |  1 -
>  libmultipath/structs.h   |  1 -
>  3 files changed, 61 insertions(+), 35 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 9ab84d5..bd71e68 100644
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
> @@ -445,32 +435,74 @@ static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
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

Nitpick. I'm pretty sure we can't call pgcmp() unless mpp and cmpp are
set. It seems like we should either trust the parameters (this is a
static function with one caller) or check both of them.

>  	if (!mpp)
>  		return 0;
>  
> -	vector_foreach_slot (mpp->pg, pgp, i) {
> -		compute_pgid(pgp);
> +	if (VECTOR_SIZE(mpp->pg) != VECTOR_SIZE(cmpp->pg))
> +		return 1;
>  
> -		vector_foreach_slot (cmpp->pg, cpgp, j) {
> -			if (pgp->id == cpgp->id &&
> -			    !pathcmp(pgp, cpgp)) {
> -				r = 0;
> -				break;
> -			}
> -			r++;
> -		}
> -		if (r)
> -			return r;
> +	/* handle the unlikely case of more than 64 pgs */
> +	if ((unsigned int)VECTOR_SIZE(cmpp->pg) > bits_per_slot) {
> +		bf__ = alloc_bitfield(VECTOR_SIZE(cmpp->pg));
> +		if (bf__ == NULL)
> +			/* error - if in doubt, assume not equal */
> +			return 1;
> +		bf = bf__;
>  	}
> -	return r;
> +
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +
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
> +			}
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
> +		}
> +	}
> +	return 0;
>  }
>  
>  void trigger_partitions_udev_change(struct udev_device *dev,
> @@ -763,11 +795,7 @@ void select_action (struct multipath *mpp, const struct vector_s *curmp,
>  		select_reload_action(mpp, "minio change");
>  		return;
>  	}
> -	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
> -		select_reload_action(mpp, "path group number change");
> -		return;
> -	}
> -	if (pgcmp(mpp, cmpp)) {
> +	if (!cmpp->pg || pgcmp(mpp, cmpp)) {

I know that the code did this before, but is there a reason why we
always reload if cmpp->pg is NULL? I'm pretty sure it's possible to call
select action when neither mpp nor cmpp have any paths. (cli_reload on a
pathless device should do that). In this case, the topology isn't
changing, and AFAICS pgcmp() should work with no pathgroups.

-Ben

>  		select_reload_action(mpp, "path group topology change");
>  		return;
>  	}
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

