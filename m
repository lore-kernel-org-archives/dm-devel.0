Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24E3303A19
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 09:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542892; cv=none; b=a1pdfKR6ywT9ZKfe0TMFwR+aVwwsdqOOus+llN0v+1H6vZKAvV+g9kiVND7qXpEWsgryz8qBM2c/T9owrwHkVCnag8/OqAe4vKHEbPYnw6naT56clR+fKI+ccTQ27Hm794AH3WXANIW5fx1oQ31YoefYG615fQvUg4L+HDbLnpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542892; c=relaxed/simple;
	bh=4EDcTMtUXRiP5/oiPgmKQMtRlWiTOuRDmEqu9oU5vpg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rK1Zuv/SR5e82hAHxM5bebcTaTSChnlhaYq2IYe/FEMEkTOTra9sVSu0ixMZ/GpdR/czJsSPo3dOeoER7f+3Ju3GRR+VLEPSumV6ZiKsmrgD02WjyaNQAjyKgUsQ2I4X2iuyj7lDM+FQT/2EQlYCR4s4zaa7ATdnZGgS3d1Wmbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hp4olb90; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hp4olb90"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-595825c8eb3so6460847e87.0
        for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 01:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763542889; x=1764147689; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pgv8WweCjZjRXsGx7FBMT5UEZaI78BGzLzzNeY09KWA=;
        b=hp4olb905oPQ0Ep4KRNbuvlQ54Er6K9j1r7o0n+T08QMvE8nkhxQ6jAO5lhMxgVZIq
         Fc8EhQ/Sqg8geZ6GbTnTROpjLSld5CC7zz6rAdv0dAUyyS8goGavyGQU/HyEdknu+iJh
         CUL81udS5SgrSy5/QqwXbXp+X9us4/73GpPGmvRZ3Kt69MmU7bZR/Tx8n1Yy8HYSrKHD
         /M/2dNmC3dxL1CeFBTvVCaQ+/Z0v8U4KD1/Uuxe3Pb3FX8krwUAxrnFiv00nHLizOBtR
         dEslrBE9d5IkflpgymXRlINJ6MmRSFH6VumTMZpXperVYuH6viFnLeww1VnI2+bsd+Ua
         tGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763542889; x=1764147689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgv8WweCjZjRXsGx7FBMT5UEZaI78BGzLzzNeY09KWA=;
        b=Bub3L5PJ8BplgWuBaJlCCVJtpQFlin2nLyVAehwRCm91p9EczSqLnUMlR3x9GiR5vG
         zh/t8YYtxwcIXT3n1TJuFQRzSEHD4sFVAKkTJUqKBdJcea0Dp19Dt0HQAIn++DFp00PM
         XH63yn+HdJidFBnFEBu6YKfABboUpa/JZLtIgUj211PZZcnwfqPNIvcciunGiB0n2XNC
         +iyM+v178do6ZiK2jPAyG6sQOrUN71CQLqVEWhpMJethzMtLD7rrJZd5+5aPkj0JSmmC
         JRu0AWxVMzj1yRWpKwmpUSYiOg6j/K4O2XAnW7p6eUNW938BY4yhi3JEWB4G8qa1C6QX
         aCCg==
X-Forwarded-Encrypted: i=1; AJvYcCXOCUZxNCCh3d10sqrIL5jxO3knO/A43mwA8VyzL7ImE7KLltEPcWbY8/ZLK4F4mzW117EX06o1ZQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwweXrlKvnrUg60UsRytrSPUquHvneByG6eFv1KJu41peu++bTK
	uemnq+k2GDlQyIL8Ly8VTuTNF4JKzXC33araIY+MkeWNFIr493E6cTya
X-Gm-Gg: ASbGncvTMX/czqqfFxj88pOEABeszpnVotxFBtrVM7jVnkB5yvENRBG/twq5H4gygNo
	WfeonJZZgvzSUZ6HXpFqVyVpVeWx6CIhnpQlPbGPeIj4huLrX75EkWtAKW/mmo5TIeydXw0PWMV
	rAhi0xG6Bz4bHAySOG9saDD3N2ucwvJFBre3xlQ/udBydZtso/TCRDyTQJFIryDf2CyODIRNGCU
	9HZL1oPQfamLOC/Ou3vx4R83a+365GzB/ZNNCeUl+gAHEWPJBTTgC28dZhYXlvWBv+oMy2Nt/Zt
	YuSY2101yguTytPOgmwQaVDiAsKjk2E56SKA+jwBDYnxBj4WVDVCY88wMoDG31GxD5fhlBTLizG
	20qQS3lFDgIGq8uiCQGnM2L7AwsLy0M5gGHXsogqaoFy1Xb82UwsEQ02+8reFAaPcvlJjwjvrAH
	8lYf8teeLWeI9/K04latjYxsQjz5Ea1I5ZpUIJowZj
X-Google-Smtp-Source: AGHT+IEo11AhIVWcAAb6qhCTnNMRL2xtbY5/xGZKYdMRrSYu8DfrXg/DIUySxF+Au+hC/CYgik5Pag==
X-Received: by 2002:a05:6512:1250:b0:594:282d:f40c with SMTP id 2adb3069b0e04-59584252447mr7315517e87.31.1763542888433;
        Wed, 19 Nov 2025 01:01:28 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5958040c7ccsm4498931e87.100.2025.11.19.01.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 01:01:27 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Nov 2025 10:01:25 +0100
To: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aR2HZWE-v-umP7jI@pc636>
References: <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <aR2DIXsymZWD9EvG@pc636>
 <20251119085328.GA24461@lst.de>
 <aR2GjRaNWrfHbDGQ@pc636>
 <20251119090010.GA24598@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119090010.GA24598@lst.de>

On Wed, Nov 19, 2025 at 10:00:10AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 19, 2025 at 09:57:49AM +0100, Uladzislau Rezki wrote:
> > On Wed, Nov 19, 2025 at 09:53:28AM +0100, Christoph Hellwig wrote:
> > > On Wed, Nov 19, 2025 at 09:43:13AM +0100, Uladzislau Rezki wrote:
> > > > Well. LBA is fixed in my case. Just only one format which is 512B.
> > > > 
> > > > Whereas the I/O can not be performed by using LBAs sizes. It is fixed
> > > > and bigger.
> > > 
> > > Then it is not an LBA.  The LBA is defined as the minimum block size
> > > you can do I/O on.  Aka your device is really gravely broken.  What
> > > device is this and who is selling it?
> > > 
> > I define UBS - underlying block size. The lower layer expects BIOs in
> > that sizes but this is not true.
> > 
> > I am not allowed to disclose and answer your last question.
> 
> Well.  Let's frame it differently:  this device is just to broken
> to be used with Linux.  In theory we could quirk based on the vendor
> ID to correctly report the logical block size, but for that we'd
> need the information.
> 
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

Again i rely on this.

--
Uladzislau Rezki
