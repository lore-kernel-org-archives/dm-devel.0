Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C493023F417
	for <dm-devel@lists.linux.dev>; Mon,  3 Aug 2026 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785767072; cv=none; b=kEpK0wnHThKkzRGGj0CZEqH8OmjoCmCTxDNbAVF85tUzyfZw/O/rS8WonYXBGWbNBdpp8508Sad/CdIMDX5eKKj38M2ZCmb3I3EofIU3BPT6kh1CHbbtN8/WkbRTyqxqeoDtVdqK1ho+UtoVR+WfSvLDcmKRqOIMZccZ4R8Gnf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785767072; c=relaxed/simple;
	bh=eErD/bID+evwJPubTneOWAn8Vw7Id5dUUNNY5FDhi50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Amxa8BMjiWcRtttaHAIlKL+mFwcEvrH59k6Pdl5GHANwnM2OcRDuzY0WH2Y4c4PUq830DHUEZTQfXZLu8nqyXU2pSVYPABBA/ib58moLo2EJ3IInVaI1DSfUBpWDeZDe9LP7Nsczr0yTeAiqHEkI6T78nP6wFHFt07UaW6RJ/js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AgUvGSWB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AgUvGSWB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785767069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eErD/bID+evwJPubTneOWAn8Vw7Id5dUUNNY5FDhi50=;
	b=AgUvGSWBCJK4p0y8FMLFCmdaVNUT4TfxU1ftWDfpkhhlDx4sCMqUyuNVGked+Z2T4oebAo
	GQ6mJn9PcqMQoJ2bjJzwo/leR/L25/EaACz91miMpx7nqKeon1HbnYB1mdfje7isDLZOJU
	fNOiQwza6QmFb7YscDDMp+EXD4NjNTs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-H7cem2jmP5y_idYr6FTDag-1; Mon, 03 Aug 2026 10:24:23 -0400
X-MC-Unique: H7cem2jmP5y_idYr6FTDag-1
X-Mimecast-MFC-AGG-ID: H7cem2jmP5y_idYr6FTDag_1785767062
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-39f72d86889so10941041fa.1
        for <dm-devel@lists.linux.dev>; Mon, 03 Aug 2026 07:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785767062; x=1786371862;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eErD/bID+evwJPubTneOWAn8Vw7Id5dUUNNY5FDhi50=;
        b=SB3OV7yingIoaYKYvzIhYzaqWulCSy9xt+ghGQSDNV0oO5hplgvmNn7KGCmkCncBq3
         NqeoVd6/2zS60dv/3qC8ipB/fdNUdQUQ/BbJOb5fX9HeXlTYncGZRhF0jOEUddTPWQTs
         cu8WKySUXzyKAP548VofjVbotx3xw3PB7fFhHPXoIBgT8pW+VYMjcQuBgFsXzcPRg0t0
         jeXT3OcVdAKlELBcK0Qjpa/2e63JBct/fGHMlIp2NB7m7W2up13jXRxo8bTZDKIn2vnT
         7HXVW36Io9Mc7DhruyZIXO6c1AXLMDN9yFSNZR8WUYSoUj7yMHt/Q2LtObj3szmFMcUj
         ZcYA==
X-Forwarded-Encrypted: i=1; AHgh+RrPbpCrYoT2lCcFML60mOSIbpNfhTi0RT14TL+zQvroHXQyYghj4dyWWKEvKK2mhFjbuS3OF3cggw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzJIniE6P1Tx9GmLTZst7dBA6p/wF3BVBO9FCa9UcIkA6dDsD9g
	ITcMEe2ViVa7rAFIurZj4ZtUBPtK0xsxO+CHgtojSvlR6PTthZ3bkn3WNhQxq0fgBKhn8polR5a
	uIKqUWzegqtNcF7TL+80f9AuAVr4RHM2rXqNuff74qMbCVS4WHoyswLqO8k3WYWw3/g1CTPc2vs
	/IF++sheeVXferiB90MesSzcTGEQ8GD8ObXQ==
X-Gm-Gg: AR+sD13bilHtQkGl+jDtvXNbcpCnJFCZxV3i3lvFM/DII0h0O4NzUWBFxk3NqJZkej2
	GAnzQfTNJqNsUp2Fx8BYaA7tcEplwWk8UZhsfynMLsspSg0apNRf163d41tJqYvXtPI0l+eKTXv
	X8hnxPnSiZ2EpFILNcAprl3cHBRS2YndvlUeYUzGh0o4gfXXb9Ki8QToM=
X-Received: by 2002:a2e:a888:0:b0:39c:6b77:aa4e with SMTP id 38308e7fff4ca-39f862e3d13mr24045401fa.33.1785767062200;
        Mon, 03 Aug 2026 07:24:22 -0700 (PDT)
X-Received: by 2002:a2e:a888:0:b0:39c:6b77:aa4e with SMTP id
 38308e7fff4ca-39f862e3d13mr24045301fa.33.1785767061803; Mon, 03 Aug 2026
 07:24:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me> <20260731-b4-disp-4fd3bed9-v2-2-7b1835e4e7f6@proton.me>
In-Reply-To: <20260731-b4-disp-4fd3bed9-v2-2-7b1835e4e7f6@proton.me>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Mon, 3 Aug 2026 22:24:10 +0800
X-Gm-Features: AUfX_myDz8Jb9ZS7BCio44K9RfRDITPl-vxjncfcjhlknQzxXUddHwqlCP9q4r4
Message-ID: <CALjSBEvYWGOryNrLiCM3SNivnzv_LXSFfcXonFfqrBQFQyyU=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dm array: reject an array block whose value size
 is not the caller's
To: hexlabsecurity@proton.me
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
	Joe Thornber <ejt@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x2PzZtpX-zuREw8g5MG_1qTPNemi3W4-wvVUK-tkp1Y_1785767062
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 6:55=E2=80=AFAM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> array_block_check() can only compare the header against itself, so a bloc=
k
> with value_size 4 and max_entries 1018 is internally consistent and passe=
s.
> dm-cache keeps two arrays -- mappings at 8 bytes and hints at 4 -- and th=
e
> roots for both live in the superblock. Point the mappings root at a hint
> block and __load_mappings() walks it through an info whose value size is =
8,
> so element_at() strides 8 bytes over 4-byte entries and reaches offset 81=
60
> of a 4096-byte block.
>
> get_ablock() and __shadow_ablock() are the two places that hold the block
> and the caller at once. Reject there when the two value sizes disagree.
> Arrays only ever read their own blocks, so this fires on crafted metadata
> only.
>
> Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
> Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

The fix addresses more than crafted metadata. A lost write on disk
drives can cause a stale block that was freed as a hint block,
triggering this out-of-bounds access issue.

