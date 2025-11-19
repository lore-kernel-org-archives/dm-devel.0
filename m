Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BB72765D7
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 08:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763541800; cv=none; b=Axy3B5dyJIGSyLChQOLvoPIxQaG4EsTrPf2DiqgQKVPNTxgQHLbNhliM7Pm6PF9wQDkw+YX0avkqLG5b9UNGjWvst0pMv+bkrbYintSptK3kG11KV5U8IBjf+2uxlRaLTQ2JkC2nvnMQKfHQqExrC5NvulreUSDVTo+an6/ypD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763541800; c=relaxed/simple;
	bh=bdYyLvIYP1aH94dbshsALIDBnw0PfPRI2/SyDHOEpRY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asIVzsn3j+62lPeSDPSqI/dbqVksUVaOYDBXIQrz66h5kndRv1hXdF1pck/2wc7ENHlUiqHozINkWE36+R+SoFVeXoEGv0mnCBJBFVIeANTHmQsKctFEVbuGXC8ItGJSjI/fFvu1HLR03ukjn5hRrJ28CmLnQt/bCeGX0Uo3eQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eszz/DQj; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eszz/DQj"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3761e5287c9so57566061fa.2
        for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 00:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763541796; x=1764146596; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=INaB9EDIenz4qmIu9d6URvGNxpB4f3VMssLlJTGmYI8=;
        b=Eszz/DQjigOcFbmeifWCHJ+2cqA0B4d4vhN/Cpeprx0+IjBKYyVPoVe/4J8vZQaqeV
         3d29UYNvW5oPs1bNtMRHufePiaTy1DH201YXBm1ZfA1XZ+/vVi+4lyA6D2DG71fdUhBZ
         6d8rbI20oll8LxN70j8VDPtgfyNENAs2KK7bZtyKsgfw5eijqFZodNSyxyDjery6rxHf
         w0Q/+fqMoYWrL0nG+hNt9EPFV0QtwETRqtWHq+sW4GwR7GaL7BhOL9cTvTC4ZyIQj+sB
         R22Sezo7mamBc0OyNYkhFMAzXTtj0vxyaYUIxcg3bBsWfbUbJ1lLYsbr7YHJIn/78A0C
         jiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763541796; x=1764146596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=INaB9EDIenz4qmIu9d6URvGNxpB4f3VMssLlJTGmYI8=;
        b=d7Y81nCoeKaeel6Igei60sR2twlDfXvSRx8zyEQ5yQNULmy7uIQmwPNBJuXAKGpbWR
         Re1uUCjWQxNbmXY2cNCKADOqd7R+sxMe7BePWK9rVueKnxBfEHWLPtauxaaDHfC0UdKQ
         N+HvFaoY/MSByCtidRPFxwYgbKHrljVpjDaAK81b6nwcURUmM1XoFq8Rg5Q9HlETPotM
         +kXH6bnAb+ZhLZ53kZSdZKTuFIjGe9q9IGStiQk46ZClv11m/eQO4XIp1KEG98LDPtJC
         alvfLcZurm+l6dTFJvAt67oXqKx+d0ObaDTWyECBYhyIzqou87TDho2n3Z8MVPv7U5/e
         9gPg==
X-Forwarded-Encrypted: i=1; AJvYcCWFv2Lv5T/u7BCzszRpNP95DLFuE/vb57bFt8B8VqP4QhDclFRWWRFFuCpANorNNT4UAGBbAIn2hQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy514CQQg4I0AxBhwgEFTTlx0lZk7swQzTX/6HxPLCrMle+b0BG
	YgtDmKe0RenC0fLE3AX1B/RmkW6cEW91KbrVo1cMlg2t7NHP68FkCxwC
X-Gm-Gg: ASbGnctcFNkR/X3uiuTboO+dwf6e8PScAksXHWOM9jIhmw0xpa4cF6fmpmEBLdQ9A9y
	vnFUVWPDCVYRbfz16tPGW1+tXAfippP5XYg/0g8RZ5UKf/eQmypkj4umOExqO7MQK1NrdrP/9AM
	kj8NeKl2Uk6QWjPMonDVl4Yt11S1+q9qj777bv9uHi+M3q9dIcRdOK59R1RiFiiW9QNzJnWxgUj
	36KMA1Dt7oXBevqpYd1YVAtwAhRy1cziciELckREgSX0hj/5kbnTQwC5E9b4DsPC7nWUkEAsj5/
	nLrVpcstzOdU5Hq1pNwW8lSW/K4VDW2Lo1v3S73EeXMSg7zE0NP6MPAwu9AvpIRIIRv7EWNQtyW
	dL66h1SQQDtnjD2g8UPuN3E1I6JtZDwnLooGlr+S7fjOu4aQL0mQ2oU7BMvLiLxsbmMXYY1ZUjO
	GDDa1TaPo9EFv6s2kGhNrb4XHRXNe3iHdUtMR+4ANIaBfgskk7LgU=
X-Google-Smtp-Source: AGHT+IFPJ30Mh/UuQhQXXD+Y1U03K89TzBiGVqJdMh5JBZoXViEpYNLAH4zmr8rXdLIQpSXMsSJEwg==
X-Received: by 2002:a05:651c:325a:b0:372:8d61:c26f with SMTP id 38308e7fff4ca-37babbc92b5mr58796551fa.11.1763541796102;
        Wed, 19 Nov 2025 00:43:16 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37b9ced4abesm37688641fa.31.2025.11.19.00.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 00:43:15 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Nov 2025 09:43:13 +0100
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aR2DIXsymZWD9EvG@pc636>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119054635.GB19993@lst.de>

On Wed, Nov 19, 2025 at 06:46:35AM +0100, Christoph Hellwig wrote:
> On Tue, Nov 18, 2025 at 06:21:56PM +0100, Mikulas Patocka wrote:
> > OK - I accepted Uladzislau's patch. As logical block size and physical 
> > block size seem to be unreliable, it's better to set the size in dm-ebs.
> 
> logical and physical block size are reliable.  Uladzislau just seems
> to have a completely broken device that needs fixing, because it will
> run into all kinds of other problems otherwise.
> 
Well. LBA is fixed in my case. Just only one format which is 512B.

Whereas the I/O can not be performed by using LBAs sizes. It is fixed
and bigger.

I rely on this:

<snip>
/*
 * Construct an emulated block size mapping: <dev_path> <offset> <ebs> [<ubs>]
 *
 * <dev_path>: path of the underlying device
 * <offset>: offset in 512 bytes sectors into <dev_path>
 * <ebs>: emulated block size in units of 512 bytes exposed to the upper layer
 * [<ubs>]: underlying block size in units of 512 bytes imposed on the lower layer;
 *	    optional, if not supplied, retrieve logical block size from underlying device
 */
static int ebs_ctr(struct dm_target *ti, unsigned int argc, char **argv)
{
...
<snip>

to do RMW. It says if UBS is set, data has to impose to lower layer
in sizes of UBS and aligned to UBS. I specify the UBS what my device
is capable of reading/writing.

The buffer is correctly updated in terms of RMW in UBS window. But it
flushes partly leading to I/O errors. I find it wrong. Because i set
the desired underlying block size.

That is my concern.

--
Uladzislau Rezki
