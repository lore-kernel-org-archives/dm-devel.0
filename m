Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C901C68E
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708957; cv=none; b=PCnSr1qVdGkRvpFx0lmOhtQQoGZ6j+8eUK2g13rYMwSWg4htjXbTMl6j88VR1525BglCrXfT1+IRLY1sbxcH7vk1Ud1WkQ6YKQCvF1F9hzl0Qpd+AMvJbKi14rOTX9ccKkFCGrXBtpv9EZuLZNf+asNJ2z4/4jzbDiVT5CL9o/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708957; c=relaxed/simple;
	bh=SvkupoeribjXt1qO0/10r6stz8J1dmq6EiW8AL+wx9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOmKGNFiIGIC/xN2lIMAlpWBnY5l6pgS72wsrbVL1PmpAK56kE0jCZBMRhBuhjEQtXwB0yAgIRGiQmqHq4Agnx8WnUYohnWW/t3svaerdd8p5DfTFKyCxNcvUxHZjngh8U1m9bzsMmQcycxO9trrrNZbLXV8hKMAgsbDfRZtIkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hgn0z9yZ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hgn0z9yZ"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d7431e702dso4837625ad.1
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 09:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708708955; x=1709313755; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O1qB8qiWWm1+KnuGpJ58yy4A/Vx3gsfPagJr/34wvao=;
        b=Hgn0z9yZI92h0/ivP+Qz82Z/YUz2htLMlAIPGQ6MR17Y7nxljNJouEihdQrd0+SNHB
         CBDPBwlvi8oS0mMaAvl/TgSs4MUNvb3i0RcIxjEcJgTdbS8kLID9xbCeY7TFHDyUrXqi
         RG8zLLlmyxsytO77U8TTDZmf/617/vJN4DqXkbZLa1tDiHuy8nRcmTaIF314aEtyI30W
         fg6HrSOcU4a39TDCPDOX3RuFbXNaSaoA/+eA3p/l5wEpkyoShvBN994YCYCIxaUVq/oD
         l4YhpmpReOkBoKALlgXZeal6oDVVQbAdcS9GyFo1Sm42T+TnFeUf7Jimo+qOmKYoi9GR
         4efQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708708955; x=1709313755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O1qB8qiWWm1+KnuGpJ58yy4A/Vx3gsfPagJr/34wvao=;
        b=MHzN1KoL/PiwVBe/X/hBwKZ6jvS0vYtKsfVPHLYEf7fL6LV+TCtw50oeMFoJoWLvtD
         tbSCwwyFfTE6s9wUcMnm6nlyMLnWRojjFX0G/tlEAzgwrkbzziSFRkV2XnmhNTSffQRI
         G8i11oRGykpipu+LhZ59c98W97YhBkP5Glqmmqz7beJVoSyDF+nTe57HU9xzrLDKEl9Y
         zsw0otgYYBsblRxJaOgRmASqMDkma18sok9ryR9/Zp4SbOgwJzrK7udy3fuAMqkww5g1
         3ugp0hDwkxWbCrMK4E24kuODF3GHjiKXujYyMugbOvAdVDChnKyg+LVG3OwexfOWDxZV
         bkXw==
X-Forwarded-Encrypted: i=1; AJvYcCXlXgHY0UQBsEzMrhYPMiEbpe7cvA5wqlx33YUzjUqrBD79EPqbvwdlfAcZuL91mrJkpejop547W4dHEcOjHrLiKSIQ6gdnQlI=
X-Gm-Message-State: AOJu0YzEI/lWJ80smgt77vmwD/f+CCXHNg4SQabj6hTaK1g5v8V0CCle
	fn0lipAueLndUC5P1vUFzEGG91Awa2kt+o6ZiX8SXot3fV8/j06U
X-Google-Smtp-Source: AGHT+IHsUCKVimVlZp1C0rBkdkNvHrz1AxRrnvYYXHkv5kCUK97hyDvETtILF5TK+bLfMS/m69cSpg==
X-Received: by 2002:a17:902:ee84:b0:1db:e837:4091 with SMTP id a4-20020a170902ee8400b001dbe8374091mr420817pld.3.1708708955358;
        Fri, 23 Feb 2024 09:22:35 -0800 (PST)
Received: from localhost (dhcp-141-239-158-86.hawaiiantel.net. [141.239.158.86])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b001d95d47cce4sm11875205plg.138.2024.02.23.09.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 09:22:34 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Fri, 23 Feb 2024 07:22:33 -1000
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
Message-ID: <ZdjUWVkLbxSmJS48@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-9-tj@kernel.org>
 <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com>
 <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
 <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>
 <ZbrgCPEolPJNfg1x@slm.duckdns.org>
 <ZbrjhJFMttj8lh3X@redhat.com>
 <ZdUBHQQEN5-9AHBe@redhat.com>
 <ZdUGFqLCpWez42Js@slm.duckdns.org>
 <Zde7nXVx8oFepINV@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zde7nXVx8oFepINV@redhat.com>

On Thu, Feb 22, 2024 at 04:24:45PM -0500, Mike Snitzer wrote:
> I've rebased and made the changes available in this dm-6.9-bh-wq branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.9-bh-wq
> 
> I left them both DM conversion commits attributed to use despite the
> rebase (and churn of renames I did in the dm-verity commit); hopefully
> you're fine with that but if not I can split the renames out.

Looks good to me.

Thanks.

-- 
tejun
