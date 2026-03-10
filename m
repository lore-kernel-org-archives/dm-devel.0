Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D7392C27
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773162742; cv=none; b=lLy9BPjiu+fzS3t972/lr9rBLT5wPRoa92x8RfLTAaYb5og1OffV7ZbikR8i6yAR5lpe7kE2fUOQmn+hpQmmGkFmSoNFqfGATCvUyvp/ByhLamvl0lXz6ZEfq2W0izSYqCLPZpL5dN/UpZ4bXB1xrLepDi4oUQgRO0WLaJSBmW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773162742; c=relaxed/simple;
	bh=p+2VWtAfEqnbV6BjTW/bbvyRS5EdJraErOLfFzFtBRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uIFZcLsseFYl7xiG9uLUUXnAhXq/YIRG1EJKo1W5WaYDHcToAejaI/6VhBRoClVPFGPztYSXYqTHv4LO9yi67EUWv5PaAWZMkGf0vrr3jMh6/AjHXmVQDPDoboTHFW5uF9366wBzexEpo6SB0LeTfWAoJOeZUB8RRYRlDX2+IkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B8hvWFf5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B8hvWFf5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773162740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BI3+yo6UUBZ3ZK+Qz66GzbgSeWE4IqJN0CQI+lHktj8=;
	b=B8hvWFf5y2Q8jTLLWzyJCGpqCqE5ms4JZrMgamyhxvZvpkLNVfm0kGE7ZqA52y8A17LPfS
	kDv70tYAjp5DBLoGOfRSbBp6uZvZ3D6eIiZkRwcZxNzVWi4zzHhK6xCkmA+vWbnEvzvaw4
	LcJLQKHl2J7pINOdRAIJn5M3EsIkitw=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-NriaR6kMOIutGDdkEgmlNg-1; Tue, 10 Mar 2026 13:12:17 -0400
X-MC-Unique: NriaR6kMOIutGDdkEgmlNg-1
X-Mimecast-MFC-AGG-ID: NriaR6kMOIutGDdkEgmlNg_1773162737
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7983f854288so252911597b3.3
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 10:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773162737; x=1773767537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BI3+yo6UUBZ3ZK+Qz66GzbgSeWE4IqJN0CQI+lHktj8=;
        b=qxepEGZIlgdTqfsrDRAuu62HZsSw0fM7UbtU5y7kGBXoa7aUlEO8zwihZG7GitlMzM
         gdhJ8HIqvYL26Zyqf18CLHXvTMmBMuKXVUuShzmMYumeKOhUUeqWm1wJf8kfa+owE61J
         wJ9fNQQapu3lq/xF78fXYeC1O8s81p50/r/cfddA4ZAnoM/Sf7RS0a3bqxnKbuYLZVPy
         igOJN1JW2pI4HPrFewBw+ByQRifU5gQTpv+DPrXFyllowotFx9/9bihC7r3O/CZ+9Cb8
         fnHlQBdmIT6uorRmtkDuPQWynGifJOewTLDzuSgxkdAkNofS6/UJ4QlbY70CCWtEaYzI
         NMsg==
X-Forwarded-Encrypted: i=1; AJvYcCVaoh3wUYInFCsb+w+Jgyo3xS60RNo9nLp4Zxp8CLDrLIc2aPyXVLCprwRLTvLmgdpqlSOnqAgRgA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwlngTFVWv6+EmMwLJ9SksHDNpS7ch3+Pn6CZwyXPIP7HeYF0uB
	EiYzmT7wY3qdr1Z2NfT3iD6tlCr4NkN8nMM2MEXNbLz2KO9SjkDWLkeutavcQbaxhB1f92NUlNr
	m1VoeGgapIttB053Qrg/E9MOavqNwsSpbKwkmEqSXvM2k6XWvspqRatzpKG2VpMXzfaEt9PVAxS
	Vrm364Tvjax9FQUhT62FSprwHnMKSCve8nB2c=
X-Gm-Gg: ATEYQzzk1al3/IT1ptRYCOolaralmjyqqa7Bt1aWMTYjWwt59BvpzioWQmPGVzbOvPU
	n3HXMoL4qmGf52r+ih4WNcopFYxHxXEDAF8ItnECi2pihZzqUmQcrpmCzncsJE1f/gJS5eYlM7E
	DyGCmrxhaAfPqwEO1zphxsvWhZNoCwwzXikwTrRRHqUytAyZv9u3j2FspukyYr6U9U370guEHf5
	uwihqmZqX30FQclIOnL8jQKgpQCJKYLSm/QTSaNczNAUP9W0Xzs7X/R+HFlilU=
X-Received: by 2002:a05:690e:b8c:b0:64c:9f87:ffc8 with SMTP id 956f58d0204a3-64d14113af0mr15223655d50.27.1773162737133;
        Tue, 10 Mar 2026 10:12:17 -0700 (PDT)
X-Received: by 2002:a05:690e:b8c:b0:64c:9f87:ffc8 with SMTP id
 956f58d0204a3-64d14113af0mr15223605d50.27.1773162736479; Tue, 10 Mar 2026
 10:12:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <aZnuSC0qYfw0hiwM@kernel.org> <aZ5GbVxDT3gcS6WE@redhat.com>
 <0a6ec8d3-7623-4809-b275-3eccb94419d4@suse.de> <a1e5c1ac-fb5f-46f7-ad7c-e21a545e128d@oracle.com>
In-Reply-To: <a1e5c1ac-fb5f-46f7-ad7c-e21a545e128d@oracle.com>
From: Ewan Milne <emilne@redhat.com>
Date: Tue, 10 Mar 2026 13:12:04 -0400
X-Gm-Features: AaiRm51xvGgBZM7WloiUzJR7AfTdxoMiAkW59yuvLN8gxk-OMb2WC5hFQKpQwAY
Message-ID: <CAGtn9rnreF=AjejdZ_66Wicc6dhQjbjkK3BY4wdaRm3_bgC8tw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org, 
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3S0lkpcSZUcmpnQURV1oBD--L0CiJtAZf49kx6T1C_U_1773162737
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John-

Sorry, I was out for a couple of weeks and have been catching up...

Re: sg support, there were issues in the past with people attempting
to do SG_IO through dm-mp
assuming that DM would handle retry on other paths, which it didn't.
You also have to be aware
that non-idempotent commands don't work right if retried.  My
recommendation would be to avoid
implementing it, although there has been interest in a better way to
do multipathed "generic"
commands (e.g. virt pass-through) I think that is a more involved
project than you want to do here.

I see the discussion has progressed re: ALUA support in your later
patch postings, which is good.
As Hannes said, a Native SCSI MP would be useless without it.  You
don't have to support the
older non-ALUA mechanisms though, those arrays are way, way old.

SCSI does not have the equivalent of NVMe's AEN, so you need a way to
ensure that your
ALUA info is up-to-date.  DM-MP's path checker normally does this by
sending commands on
which the Unit Attention can be reported so that the code can fetch
up-to-date ALUA info.
Hannes made some optimizations years ago to avoid excessive RTPG
commands with large
numbers of LUNs which we would need also.

It will be necessary for the functionality to be enabled via a module
option, at least initially.
Introducing this in general use will be a big change for people who
have Enterprise SAN
configurations with their own custom path monitoring tools.  I believe
we put some functionality
into usespace multipath tools so e.g. Native NVMe devices can still be
monitored/observed
which made things a bit easier for people.

Unfortunately I will not be able to attend LSF/MM this year.  I am
sure it will be a good discussion.

-Ewan

On Wed, Feb 25, 2026 at 4:27=E2=80=AFAM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 25/02/2026 08:11, Hannes Reinecke wrote:
> > And I _still_ want to have a blktests for persistent reservations ...
> nvme/054 supports resv testing.
>
> For scsi PR, we could use util-linux, which has blkpr.
>
>
>

