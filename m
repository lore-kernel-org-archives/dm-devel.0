Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6F039856
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 21:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706736755; cv=none; b=VlGRsPr24MGRbfGCugOrnaX0iO4g3Vxo4mogIODDvZ2p0ankAqlEnTZY10qbYb0r0gvd1MIc/RTyg+pkG6JCuIwCt8dXU/rzzF9rLomwvYJDdlqHVsfmSC8K5BofzAPi7A59Zo1E7m+kP+U4gsECvjlFFgj9K8dSJqGz8NSCBmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706736755; c=relaxed/simple;
	bh=OPLlnkShPkDfpkes/8TXUTg03uQrES6q+f1wxtN714Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2fjq0f8zAREfMYV9HWV3xy9tET8EbBp+Y+KSFx7R/wZCojVxm71DcTgOKN9ntfXRd//ux61T/1VZ965+Okq7c3QdIfXvMSGufJsQ3dVNfXJunLjMb9gcGvWBb8tdBpOxtGDoi9eccVZbr7FfPlM+Ge4O0k41Ve1mApzSSIdo1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PeDmIPrv; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeDmIPrv"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5dbd519bde6so254025a12.1
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 13:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706736754; x=1707341554; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFmzHu5ktzDR5khDgjr495NTAW/wkz8lMozFpGfYzLY=;
        b=PeDmIPrvOE+adNBwiQmGDC9tSEZmzF/83LZ+sK9oBPKpbk/MvJoJ3ZpNJJ0YW2PU0p
         8BOz5XKHVJwKFoqhRZFOolXwYnRz3+65m0pA+a94tDZxN3f58E/HfjMkcsBuYLZujmC6
         igNRmDJXHrZsyXL4RuO2dWG2yW8w4UlussJrIkuHJ1wL2Vl/Le9VA0JY/JDR29heJMPx
         YD946HHvg3XZB46D5swNBji4X4pN+gYgWF6nOBoX61BhXX4vMCupp1dHKy9XjNRX+DVL
         0xqQ8zM3USm6E+W2zWJgwKKWGvYcyku1dvSlj9GbVzeqtJk4jXaswz2XIDeY9o+xjg/w
         fwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706736754; x=1707341554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFmzHu5ktzDR5khDgjr495NTAW/wkz8lMozFpGfYzLY=;
        b=D6jiUzdzoYj3U/cadxNuiQHTTsOWLu4w6DPJ+tUhJlKle5T4+I9nf6Qveo691t6wrG
         rVAmpZLWvFrgHmUw3BmSY5Iw5sUtCmjJvV5DV5WleIFaZXBGzae5qIhQj9nNcuDRS1wF
         KjuTj0rLOstuujVZzNZC2wAx05F1CeXdv5X93ctzxvPFHU37coINikaPbWsZq1NkofrR
         oa6/MQUmi7qq8rfnC/0sJ+CBOZGYIziqlzV35yUtX29ca3ScrQp8PVf+yB0B2fGV5XXL
         fBj4Mi7SMP8C0UrWmLOj1pvy0vzdrcqJjMnW7yvT0hTBO/aVCfUEipSkIDF5y1OiMkXo
         DoZg==
X-Gm-Message-State: AOJu0YzcEJDa7w7SZ/2ZTIaMu+ef2PKdNpGxMquG4CZYH33fEIazAU5C
	AeAj3kIGP7AI8yvoKmP2gnKG+3tVirKkxsiqOkikKMWLtR3j6NC5
X-Google-Smtp-Source: AGHT+IEpmHN/DNRIANW5YYSpE26RvQKmubELfaV5A42tZ4DYpL2qxuRBcFzMnkJ+Da9TID3wIvqjnA==
X-Received: by 2002:a05:6a20:3b94:b0:19c:7c49:4cf with SMTP id b20-20020a056a203b9400b0019c7c4904cfmr2582707pzh.43.1706736753446;
        Wed, 31 Jan 2024 13:32:33 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e20400b001d93bb0c9c8sm966974plb.85.2024.01.31.13.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 13:32:33 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 31 Jan 2024 11:32:32 -1000
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com,
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com,
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org,
	allen.lkml@gmail.com, kernel-team@meta.com,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
Message-ID: <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-9-tj@kernel.org>
 <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com>

Hello,

On Wed, Jan 31, 2024 at 10:19:07PM +0100, Mikulas Patocka wrote:
> > @@ -83,7 +83,7 @@ struct dm_verity_io {
> >  	struct bvec_iter iter;
> >  
> >  	struct work_struct work;
> > -	struct tasklet_struct tasklet;
> > +	struct work_struct bh_work;
> >  
> >  	/*
> >  	 * Three variably-size fields follow this struct:
> 
> Do we really need two separate work_structs here? They are never submitted 
> concurrently, so I think that one would be enough. Or, am I missing 
> something?

I don't know, so just did the dumb thing. If the caller always guarantees
that the work items are never queued at the same time, reusing is fine.
However, the followings might be useful to keep on mind:

- work_struct is pretty small - 4 pointers.

- INIT_WORK() on a queued work item isn't gonna be pretty.

- Flushing and no-concurrent-execution guarantee are broken on INIT_WORK().
  e.g. If you queue_work(), INIT_WORK(), flush_work(), the flush isn't
  actually going to wait for the work item to finish. Also, if you do
  queue_work(), INIT_WORK(), queue_work(), the two queued work item
  instances may end up running concurrently.

Muxing a single work item carries more risks of subtle bugs, but in some
cases, the way it's used is clear (e.g. sequential chaining) and that's
fine.

Thanks.

-- 
tejun
