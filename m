Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2157D1D88BB
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 13:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725454988; cv=none; b=CpVcvtsrS8xT9s6sVGuJJc8gsoB6S5RH1iMOV/jBMvOb1MbW4JEZMVoEzrHB+OTOpJ6kBZYYQuDnTSOHfhZm8NUzuNyd5cYVlo+FW5AW4fhbT/r76GuWN0a01D3wqTf3XSgirjIMSX6d0wafqQIgk12yCcm/C5sJrNhReUKZ26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725454988; c=relaxed/simple;
	bh=uMbn66TtshGa3YU31X3Gw5391g9ZvSIZhpzDYDCHC9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=abV+e5BYzGQazUNR4LC0I+pytna7tWEaXPA0KmeAx7QSTMC9VtCmriZH/KybW2M9Ed1dl+J6rISqle8pJ29xbb4vgoB4YhLvi6rSn1x2gS320pR7BegSKI3vZG9xeoeVj6u37opn9zhcjnX6rSKjHuUIuE/DqPpbLIO4mdWRN6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TnNdC0I9; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnNdC0I9"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-709339c91f9so3471762a34.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 06:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725454986; x=1726059786; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMbn66TtshGa3YU31X3Gw5391g9ZvSIZhpzDYDCHC9c=;
        b=TnNdC0I9Hjk6elnuu4npP48NRuhckkRfonE3YBPsEEzeWCZLWAQ7fhLBgOzigBYvgQ
         xBT3cH2g2g7LhP/ZFBUEowz29bVw+nYGKVJrNdni0e8WrysWHkquaISLwckdmLlq+OYW
         w4ODwFgeQljSWUU5EIBJPqh/pw2eXv6103bQHS+PEfsCqnZ2XswpxsryljWsAjsEh2LA
         G6LPe0TBFLMWsqCI8NeoIk/PveD7/jxq81J4ZOocGYV1iq0kfxO7AsYhq3SrxzQ7i/on
         q3Fzs3mJReWblUHkselm/qDtv9xw115L8x3e32OvkHUZTFbHrR3dYaDrDXbqeEsvduLQ
         FAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725454986; x=1726059786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMbn66TtshGa3YU31X3Gw5391g9ZvSIZhpzDYDCHC9c=;
        b=EgMIoGvUSZLiqWhYLA/1iqeHgjL1zmyJqD4fpp4eB8BJOGSFZaESIGqs0c+W61XLNN
         1NhLyq6KaldWockWkARJHphzDVWF+GF2BUyhezGtijDv95NXmsYNxj29Sx4+DzTuaaiY
         F+W3WEp4/sN504sW/CmUV5k8UvQtoQQnvMqns3NRBBaXSBnpNBWxT09blkpi0fFpunfE
         Fjdv3Jyy7ys6CkvW4pYdOFIFEd/PiIAuT9HjR5kXpx8WuboHsY9kAcbF1ISV0bGQkeNb
         vQKqSSAu1EpZzGswMqT/apFfnNUxiuOnBSqIqooZBrWjONoN34spJeNt8o44D6u6hVXE
         uqhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX7WtKNa1hkpDiyJekmaht54DAloMcOBq2t2pC4nrEFVSMqWRsRxg4EeiLCGfJsd36Y3z7XGwKLg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ5TY+FnsqR0kysPcEBVwy2y2PbMfnA80K+IE+bjx31v0E92fx
	NFmX44BSlJm+NmGS3PWTBWmnNTrCTweAecATll2XSQRBQIhumFLKY0svChnfaCAIxEkRjKbBjoP
	1DyGPl8tfikuPbNsWxoe8PgXIBg==
X-Google-Smtp-Source: AGHT+IEdulZw6u98/TxISvhCEB+PWEUOXDMgrcbat3567ZXIVe3pY1VGDwAU8mWSXTM+ZMpWQFg57+LANpm3aH7l26s=
X-Received: by 2002:a05:6358:7e0e:b0:1b5:f74e:ae3a with SMTP id
 e5c5f4694b2df-1b7e37f1111mr1915202055d.15.1725454983839; Wed, 04 Sep 2024
 06:03:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e41b3b8e-16c2-70cb-97cb-881234bb200d@redhat.com>
In-Reply-To: <e41b3b8e-16c2-70cb-97cb-881234bb200d@redhat.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 4 Sep 2024 18:32:26 +0530
Message-ID: <CACzX3Av88j1mAq7-VRcbO+azSTN+P=c-0-h5Jy=L7GyaHVrt_Q@mail.gmail.com>
Subject: Re: [PATCH] bio-integrity: don't restrict the size of integrity metadata
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jinyoung Choi <j-young.choi@samsung.com>, 
	Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 1:18=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> Hi Jens
>
> I added dm-integrity inline mode in the 6.11 merge window. I've found out
> that it doesn't work with large bios - the reason is that the function
> bio_integrity_add_page refuses to add more metadata than
> queue_max_hw_sectors(q). This restriction is no longer needed, because
> big bios are split automatically. I'd like to ask you if you could send
> this commit to Linus before 6.11 comes out, so that the bug is fixed
> before the final release.

Tested-by: Anuj Gupta <anuj20.g@samsung.com>
