Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D0421219F
	for <dm-devel@lists.linux.dev>; Fri, 25 Oct 2024 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729863103; cv=none; b=TXkuMz2oQDZxS3eFm006b1LzA+wjur9irwPIgIBSXTU6q3PFEWqTIuZ5GhJtofRgN2eKFI2/XmTxeNLiTbbQ2vcz8HNHbTOwJtuMc0uj5U3mZ7jt4s3PrmOBsKxO9g77Hg8r2i1/XV2ydY18qstTynpVo22ZFFK++Fo5r80AJ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729863103; c=relaxed/simple;
	bh=uf7UAsZwUXG0HjIitsk7ytpb6VBUhLGUqiOtbx3qVkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DSaQ7ETk8PZbH+GTJTA3ITA00cKMMSxZL1EjUUwfXltQY+5mN2kzbY3qtEJz419IJbg/fRoRI7HpMfu2EkrGMYThFlfCX/5xbd2aXmlSMVLuSPP6KK5QAzI1Gh2Vl0JhlwHe8BgbB0kEeNh73akrC+4j45/1DziCtEgTqJAEniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=CaSnTONV; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="CaSnTONV"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7e9f377a3c9so254649a12.3
        for <dm-devel@lists.linux.dev>; Fri, 25 Oct 2024 06:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1729863101; x=1730467901; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uf7UAsZwUXG0HjIitsk7ytpb6VBUhLGUqiOtbx3qVkc=;
        b=CaSnTONVuus3s7xVCMYtiNu4L7utATKO91TdtZ2GA8dDI7cNqzdfmmznmXLcyNijeQ
         hs5Wcy1/fHC+ZjyEHstlCPKKYn0rZsUrbQcMziH5B0nPZlD4Via+H5Yqvmfa5tBeXtUE
         oBJqTBh0GfSiT1UzHTFmWycTYSVPW9yH87ZP+8hqspwggAOlA4y5DrLFA+/4CDfsf+vu
         3Sue7tJ+5zemrGrw2yCXo1D8Fm5X9KL/GfaxGjcIAKv+WTA8GfBLTcYRBBlN9qyJpAu6
         husvsHKjeQPssN1D6Z8CRyIy/5Z6N+0pXHtmlc7X10uqaKlohD0BBLQXRBVPGPpMjs1Y
         zZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729863101; x=1730467901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uf7UAsZwUXG0HjIitsk7ytpb6VBUhLGUqiOtbx3qVkc=;
        b=qovFvViKDC7DIFGCmALD4wfpBKV2fhRLiHn6CV6fC4n1sKrnqVDFCOAZu7Ivs7SwTP
         lFMmErvFQY5F/0B7M2XJDRk3dfbpTb+BIOy2kIp+0VxPFtdoBuJcj3w8qBPHQ+GmZjjp
         EAST3zowLzfvOMuoSAnFwZONWvgP48JAEdf0dibD4sDSp3MJPA8bWPt/DiS2jQswGHb+
         zXHZA1E0Zcqd9eOchjZt0+p6OTh/mQ3kUQjnWHJULyV1cnn7W4RdZgRbimEtJ8eaA8rm
         4gmd6HRI7sHnPVPfTVGto5pDjc76QNJkRDJ/Y2o+5dQLzU2+Lm93jB6W+0Xth79caR5A
         mx3Q==
X-Forwarded-Encrypted: i=1; AJvYcCV9lc9/OaPipbHNqTLsaAOh2W9fMsDsAol7AIvihdQ6gjtTIlfJ+RQ6vy9ecD8NlxlrBAqw1gLPFw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKfZWBvv6/vT1SSeZRQFcP9A9EvavyurEkkhiJnOBzI44U/76K
	0pI7Rzox/PWebwBBDhyQoFBzz6jMkYdcWiWr/AFjTHGa2m9rFzlH+J0f9eGxZyzCOPCTwlTWcgO
	JfSyWGvATarvwo8ZfdZTRVjowOkg=
X-Google-Smtp-Source: AGHT+IGcBTijq7YlHWuft9iqzC9HKlPlFEjSGZ5kx05SSgeEyV16VuL+kSy8D7Ey8WV2hSbLLNtJmY9/iSIK+7/XZUA=
X-Received: by 2002:a17:90a:d80d:b0:2e2:abab:c456 with SMTP id
 98e67ed59e1d1-2e76b5b7e1emr4603265a91.1.1729863100658; Fri, 25 Oct 2024
 06:31:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io> <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home> <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com> <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io> <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io> <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io> <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io> <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io> <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io> <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
In-Reply-To: <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Fri, 25 Oct 2024 15:31:29 +0200
Message-ID: <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Take this with a grain of salt,
since I'm not a kernel developer:

If you can trigger the issue with bitmap=3Dnone
I would say that is a valuable data point.

On Fri, 25 Oct 2024 at 10:40, Christian Theune <ct@flyingcircus.io> wrote:
>
> Hi,
>
> I=E2=80=99m working on getting a test without bitmap. To make things simp=
le for myself: is it helpful if I just use =E2=80=9Cmdadm --grow --bitmap=
=3Dnone=E2=80=9D to disable it or is that futile?
>
> Christian
>
> > On 23. Oct 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >
