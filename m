Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7F976914
	for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 20:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708459546; cv=none; b=Aye/PYm7uJyUbelCazf2VbIv1WUVWpkhMg6FAncCat9Ij+bO2Kw+R0JfmIUYqDSgjHvAwP8K6WsXpKFCyO4OzvlQnLOUPdPycsKPCdkkfa9VfOTWhcnm5yQoxyDc1n05gvCjBTY5kSpqNHgBUeHbg3D7NreH3Kijl8s5lwb64pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708459546; c=relaxed/simple;
	bh=0TezNLJVdcLshluzbqu/T/BkOu7/M8fDbBUUIqa/jb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTUoW3JwQguugWvcwbVNlKZzkjOv6+6yddfqaFatW9fzVDDsLw4feOHGJW1rKEJFpqNlZhmKm2dxGTzWiOP3b4OjY6Rd6fF2Xy0qqpEl/acPRvDbIOnhEZsoyWP5N6mhWPYsyIywZDhCubftJrrdwtdPaP5evXRMX1xYzbTgD2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ryau5z3N; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ryau5z3N"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e457fab0e2so1446810b3a.0
        for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 12:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708459544; x=1709064344; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gW7vTF8rfNG49dpSnGO33E9gPKbjVpE73uaPhoG4koU=;
        b=Ryau5z3NK5gnK1ZZEgh8PAvTmu8iwT5bT7ArnM7aC/1WxzjNLkgsP2Rx93GSFOXPRS
         wh1iQJhYrHNCBOmKzGNfNZF8QvV8nnRFSN3+FgixwHEz77b84FbiyUm5V5xiHVbinCag
         5DTD167mxaUdk6M3Ih/sFDf6zVmKtXaCxgFsYw0emjTirzhadXeuLGGg2N4P/8eTcXKI
         Krw6Y+BSHChBoyA9ZdMakrxr36g10lU2UIQeCQuQYRmABTY8JGiKWTkptBiqMvL8aUbb
         KKlwyEt7ziNWVr1DNRYcLN0ysCunF8RHnlBnmvwS8QsLMXZLNB5yBnAWaRM8fkwqd6rk
         7Qdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708459544; x=1709064344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gW7vTF8rfNG49dpSnGO33E9gPKbjVpE73uaPhoG4koU=;
        b=OcKVmn4R0EuBhG2tcRpSFBL1coMFxwrXx8YUx/IGxwBYYmLiJsWe/lL7sk6d+EoHc9
         T9HbSVHtn71n0x/QS9wJAaV4+bvVSTKXQYd2woQ2MQ+bJHxOzwlqyCgiYosxxe57RcVr
         HxF/GsUsgNKAjlGNN6vHsOHAeHPh3eSS4X0tAzbL1MYN3aKcsNap7ipjSiWn+js04bqo
         ZxfKi8iJyqmQpG37Ts9MBXrdOuUOgtHHVafmzxVS3o26J4Z9yyyJ7WLwEEaugVizR+wW
         bDxUZKQC/u5lJqF+Ygenzy5jcgGDro3OKx/Uq8VK1WGb+18rN/3k0v5CTmIdMTy8JR8v
         qofA==
X-Forwarded-Encrypted: i=1; AJvYcCW2bKYxQQ2MMgp+jaEZpaK7VAGUqXq52siLmjvFYDLPC+7hegJ2mzOHxfA0JD8rUgGxMqMbUCp4WEFamQgETPq62cwJjFqGWn0=
X-Gm-Message-State: AOJu0YzsQNNcIT4r8PYunRhsxoDWU2PRQq4JWAbe9gvf4oGuDItdOrxt
	edN2cwP3NMiCFI6JXPQpfH9TRgp4UGS6viJcovHa2vWInbaSNNZ/
X-Google-Smtp-Source: AGHT+IEFpe+TQnBO6E2Zo9LcH0NoW7qj2OoD0B8VMDIQsbL3NhuZGX/D86CD8PdMSwC3kb5ysijS/A==
X-Received: by 2002:a05:6a00:93a5:b0:6e4:69ea:1f6d with SMTP id ka37-20020a056a0093a500b006e469ea1f6dmr6952335pfb.5.1708459543718;
        Tue, 20 Feb 2024 12:05:43 -0800 (PST)
Received: from localhost (dhcp-141-239-158-86.hawaiiantel.net. [141.239.158.86])
        by smtp.gmail.com with ESMTPSA id s12-20020aa7828c000000b006e0651ec05csm7283639pfm.43.2024.02.20.12.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 12:05:43 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 20 Feb 2024 10:05:42 -1000
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com,
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com,
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org,
	allen.lkml@gmail.com, kernel-team@meta.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
Message-ID: <ZdUGFqLCpWez42Js@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-9-tj@kernel.org>
 <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com>
 <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
 <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>
 <ZbrgCPEolPJNfg1x@slm.duckdns.org>
 <ZbrjhJFMttj8lh3X@redhat.com>
 <ZdUBHQQEN5-9AHBe@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdUBHQQEN5-9AHBe@redhat.com>

Hello, Mike.

On Tue, Feb 20, 2024 at 02:44:29PM -0500, Mike Snitzer wrote:
> I'm not sure where things stand with the 6.9 workqueue changes to add
> BH workqueue.  I had a look at your various branches and I'm not
> seeing where you might have staged any conversion patches (like this
> dm-verity one).

Yeah, the branch is for-6.9-bh-conversions in the wq tree but I haven't
queued the DM patches yet. Wanted to make sure the perf signal from TCP
conversion is okay first. FWIW, while Eric still has concerns, the initial
test didn't show any appreciable regression with production memcache
workload on our side.

> I just staged various unrelated dm-verity and dm-crypt 6.8 fixes from
> Mikulas that I'll be sending to Linus later this week (for v6.8-rc6).
> Those changes required rebasing 'dm-6.9' because of conflicts, here is
> the dm-6.9 branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.9
> 
> So we'll definitely need to rebase your changes on dm-6.9 to convert
> dm-crypt and dm-verity over to your BH workqueue.  Are you OK with
> doing that or would you prefer I merge some 6.9 workqueue branch that
> you have into dm-6.9? And then Mikulas and I work to make the required
> DM target conversion changes?

Oh, if you don't mind, it'd be best if you could pull wq/for-6.9 into dm-6.9
and do the conversions there.

Thank you.

-- 
tejun
