Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795834039;
	b=ZEvlfb9mt46Bh1c5XjFcLgqizRB1AiqoDi1EXXVQgyEuAdhyFjM6+l+6BDTDQpomX2b0
	 mG34ovvyhZG27h/CgrOblzlbnL9qPQe3KzdzBqQ0HvJH2e1oHLg8ooYRLKO0pj12hYDc/
	 QfdHCpV78wAOr+G6qCCsHLRuRBcxPEK1CNlVzD/4rshvcRyIS9Z8mH37dgOt20nrAH1NT
	 /d6HQGffVBbNFAu4VN+pmSK+D1up0pvzti0A1oyvXPHZsGKUnN2n/K+x6Uy4xpc+Sycjp
	 yohBz4ksK1SBWmhx9ADo2pYeMTHbI1OrSfnej7YTdKMwJW/rgp1G+xvTdwbsqZ7Sf/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795834039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=6WKT27fdX/tFqhewESdRPtk5HTiyQzUxICUqNBuVX0M=;
	b=GtT2xsHwZA2RkLon4BbwzSpTOZMshuMoYj/FaUQJBM6P+MJLOL5zi+v4nuxKSIa8my2I
	 GsBQA2WkA2HugO6NsNfnT9wWyP0Y5F3X0FroCxq5/2EU/NcqQQC2YB2i6CPe4jy7bYHlu
	 vCs4ybQqfsHGuqiDVrSElRdRON9Tu+onNzV/VRvNN6ycBhBNoy/r+IvakPRYcFDRfO7L0
	 lakZWedQjQXx7AxB0ycmJmC4ANqUvhDfrhi5t4ACez2yPe5C4yWlG+BlnP2AGIR0gC3EC
	 DJaIL6kJlMh1SKejI4w5kTg/Wt+Q6Dbt+Fto41KcDwT+2fJMawUnyW+zsGikLPraVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel.dk header.i=@kernel.dk header.a=rsa-sha256 header.s=google header.b=tKUcTibZ;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F404606A31C
	for <dm-devel@lists.linux.dev>; Sat, 28 Nov 2026 02:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F404606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.dk header.i=@kernel.dk header.a=rsa-sha256 header.s=google header.b=tKUcTibZ
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-380c28f9e35so9526279eec.1
        for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 18:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel.dk; s=google; t=1795834037; x=1796438837; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6WKT27fdX/tFqhewESdRPtk5HTiyQzUxICUqNBuVX0M=;
        b=tKUcTibZZt1XfpNmpb46bQLJr2BWQ8R0wu5S/UvYp8e7MsHp54XDVB45G4m/EVhJ7R
         Bp9WAQBJnXcYjgDzZg9ImRBlXXvArPTlc+IhtIsXBdQvaN94ItVJDqnF9LCbi7CQS4v8
         FTCsiJjeC6aAJFBHGfJUw62c+8YCjlhNvyp6dahQoxEaEJIP1gapTO5Tff7ibvQTNdtD
         b1/ZoVzS5v1LoU2+oeASkmUOe0oJRp6FrXidLy8UKDaslC8hX4AxLnH303uei8svO1fy
         yWJps2tanT8yKRE6F6Y70J0aNIXaMole1jd3ITvKqJ6L4GFgtz/4lCqCeO2444GmVYZ4
         NU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795834037; x=1796438837;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6WKT27fdX/tFqhewESdRPtk5HTiyQzUxICUqNBuVX0M=;
        b=otc0Uuj+AXWuHqtMDvP/Wgmjy0Hezbg5kzdZPfUuQQh24rQbgTNTPavLu5Icvl4aLj
         73HouDPrzIcgYZ3oxgTvPMagni5Trl6im4jwuOD2Q3v1gjrZUU6lVLxhPWQj87uqrXbZ
         u5BuiDLO68WaADBCePODLcRzRH0VKYRsmiAVU87KcMsgR7vdeAxWo0lUJM6nYwJw6784
         BfOj8X91vuf7atud2mof9q6EJaz6hSVuaGlLOJwzAQf5eR45ayvtwlVWlkyzyVO80knO
         y9S9hUZWnA4jLytya9TlT7dPUzfxlD9JHPAqATrJG3ZPWfo6ENn6QgsV/Hz08aSL/9Dr
         23EA==
X-Forwarded-Encrypted: i=1; AL+hErHW2iTRa4uIEbZzZqGbKvyhyFDd4gH/R8BucFEbBuwhUQp3Q2GeCvlX21/Mh3YA/vlld+/+a7UmCw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/JAdeR/WuLSbdimFEAaeSbrH0Xm7WkpduVkVoqX0ZIGNPwBYuf
	Ec6UFzDVlLgl0SWGQngMx7aNHpoh8bf0/byDGtteR210puuQkrL20v5j5/9jnwAhbp8=
X-Gm-Gg: AZFdTZcgM4es29ntU78fK/x6O8kmLei2AzxfJhSkXQX4nFQtrUQ9KeZK2DIy4qvJwK7
	xCS7JYorzj8ceIjbREP4T8mCNOLwq6ZS9ur7hTWyALZfwMFDZQJk91WKMeho5+5cr+98OS3OqW6
	LESwDMqZrcKXumwJWkkH3B5eEGJgG3GtV0nyNE6rS4PBooT3kA2cnqkpmH8ZK57ZPxhuHjtvQy/
	0jiTojeMLtugT0qD+UmTk05b8baeKjeWbGybaT2otEy/os8rWQUBuCpYtbY1FcTCROgXcqTTqWC
	o2rbEzkno5h0ckr5Y8XYNcyzkR6QKX3qhuiqWMLlclV6TFMiOBqmadJGTUibV0K5+YUqa5v2H7n
	lA2SssQe2LzWysxA90bbvC7lHbeFYWxBk5yk7WTu8uGHRwHL6tInuLFwjgbaLRRM1UgGw4Iu4Ja
	XbWKvCNVXndkreMP87X4U+lt431DsBzM2UX3lKTlHkDl+8k7erUZDE2p4rhJA+U65kmLC1OcbEr
	dfMUZThcjaanMnHbCi0IJknRVpPU35XHu9w0GiNBLhn0IUSNB2xdKHGDd8STVjRBU4xGHSsxSDT
	J/j1vWQnD/i818IXxkW4D7+O2hdTJtda5Itz/RCYAjVeug5Wuik0soMITwmiZmbrPSWZshP1eFj
	C/ElSBzTMhTwvxMEVLw6otl+wP990GK+Tqa2YrNWDWb9/9Kj+
X-Received: by 2002:a05:693c:88d5:10b0:386:9e9c:867 with SMTP id 5a478bee46e88-3869e9c2df2mr21137020eec.10.1795834037229;
        Fri, 27 Nov 2026 18:47:17 -0800 (PST)
Received: from [192.168.1.142] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385646633d0sm134059672eec.3.2026.11.27.18.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 18:47:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: hch@infradead.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, mtsai@redhat.com, 
 stable@vger.kernel.org, hch@lst.de
In-Reply-To: <20261120101758.45513-1-dennylin0707@gmail.com>
References: <20261120101758.45513-1-dennylin0707@gmail.com>
Subject: Re: [PATCH v4] block: fix discard alignment for non-power-of-two
 granularities
Message-Id: <179583403624.86956.1820367114895807728.b4-ty@b4>
Date: Fri, 27 Nov 2026 19:47:16 -0700
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Fri, 20 Nov 2026 10:17:58 +0000, Hungyu Lin wrote:
> bio_discard_limit() uses round_up() and round_down(), which require a
> power-of-two alignment. However, discard_granularity need not be a power
> of two. For example, dm-thin supports data block sizes that are arbitrary
> multiples of 64 KiB and advertises the block size as its granularity.
> 
> With a 192 KiB granularity, discarding one complete block at offset
> 384 KiB is split into 128 KiB and 64 KiB bios. Neither covers a complete
> thin block, so dm-thin ignores both and the mapping remains allocated.
> 
> [...]

Applied, thanks!

[1/1] block: fix discard alignment for non-power-of-two granularities
      commit: f6ce3d09d6480b56e357336ac080952f9525eab0

Best regards,
-- 
Jens Axboe



