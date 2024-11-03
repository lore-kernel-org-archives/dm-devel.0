Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752B917BEA4
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730650606; cv=none; b=TKxgfPxsa8Tbg/fhWYTAryE9weEnWecazY3Ffs0IBGWxssV/qIrapK2IWqIwihNMYKPeLonqTi5X8lYgpT+D+jo5AyHez8iHqretLYjDaqJjNjEmrbtZWlMFrRDKwckb+/AbuvStMQ+RQKomAaaUliUayj9CTIqERdaYj5CY9nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730650606; c=relaxed/simple;
	bh=9UJvROld1nNyMIMBZeKybMqWRrUbfmouF7rDcZQ0d04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QL4SfCI2zfs17e89Pma0r92MQjnre5z8hlBcsEDZNkS8+nBKsARpqdx4f+Sgzj81VvjeYyFLnxMILnjD/dS/BFdf6z+DL7KF1BqIXCqtQ3yagFkZjLxrjzkpupy4BmxsKc3LSIN1IBHLgLYS8ZJJzeJImGUAW/lvN6bdRzVq8KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=YHglQyKO; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="YHglQyKO"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7c3d415f85eso597448a12.0
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 08:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1730650603; x=1731255403; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UJvROld1nNyMIMBZeKybMqWRrUbfmouF7rDcZQ0d04=;
        b=YHglQyKOav8QxDNegASJPj0ytOcHYSlM2KQdk+ogov5TuWfxATBu76JiL2fYxDLsh6
         AvYwGtvY2hJAy5gU7oaxtiysv+O7WBKz4tpPBkHIzp152LHOZvVS6/M2P6KeuOqQALNn
         Xuw1ojXS56ry6fABLNzTtz7k1nxH3tfdtjE62qidmdNl0bBHOrEqM1lTCEBAw7tw0V6B
         7yx23/0SSjr7XVtC8LqNsgFgtVkbvhhjv+1L50TyzlkGBh3R1rmxRzmdVGsz7bg2hz9U
         xjytEUIZ6XNma9oKn0MAgphUIKf4jZIQwbN6wOH6nMso3fBTttiG6FHxlWv6NZVJKMpA
         Inug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730650603; x=1731255403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UJvROld1nNyMIMBZeKybMqWRrUbfmouF7rDcZQ0d04=;
        b=nA3iqYPZzbjOw88PrJC6OED3iGgqiQuspjA5ObW4B0WaxgFXc3A9ALhd4e2ms7/aC/
         +GiZ7QgFBy8l23kSLB+OAtSCPAgwlrApuQB0hvq3MsazpqTUO+qL6rmO5T4NSbnXSWfP
         Oh1T8Ta2bZAnEeA246PqhoWR07vukffk2Bam/X3ukHeYl8jF3FJV09cd7Bcg5kLqHnO/
         99hlHDiZCPcxy/RKFddXWG0JQBOaLho0eYM7v5XsLPtH6NvMvGiRV8nVnA+c4ptM3NEk
         /ggwlxQz3QewIXK5kfcfZ+uQK+kCf5+6/HMhSFPWUtVLYynnRDiIRlbye6SkzUiiupXk
         pRdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHDOb3iDstgOaDu+GK1T26RbYbhSe7vxInC/jqrisMM+Q/jC4ua/c+OclR/khnceGGOYCYsonFmA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyf4MA5euXyg4O31eD3wwhl4iYoPbdZrEHelXgP/KQRt3Cztn3s
	90OmbX95UnWt1Hx6UpvUtg5I8yEwkGdrnC+UiHCN3ko1zUNO+J5xU1vqw7GSfZ+PMJ6trBbZpeq
	BDLTp1J1sfg1rGdzI6XIutlY7Pa0=
X-Google-Smtp-Source: AGHT+IFNtryVrpA/GFB2oSAlRbklg4p8/W+gqCZTneLBWKvOn6bxEBr+2V5ngFKkYUZ+uzlXrrop0mUqoIFnStRKLuE=
X-Received: by 2002:a17:90a:77c5:b0:2e2:da8c:3fb8 with SMTP id
 98e67ed59e1d1-2e8f11c0f04mr14694874a91.6.1730650603433; Sun, 03 Nov 2024
 08:16:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io> <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io> <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io> <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com> <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io> <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io> <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io> <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io> <26403.59789.480428.418012@quad.stoffel.home>
 <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com> <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io>
 <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io> <87E347A1-059E-4F0B-865D-6862EEBE0C64@flyingcircus.io>
In-Reply-To: <87E347A1-059E-4F0B-865D-6862EEBE0C64@flyingcircus.io>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Sun, 3 Nov 2024 17:16:31 +0100
Message-ID: <CALtW_ahmXeCococH2PpEzsswOcr+f9nuxp4hFBZYy2eZBxguHg@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Nov 2024 at 16:54, Christian Theune <ct@flyingcircus.io> wrote:
>
> Hi,
>
> running without the debug patch again on 6.11.5 I=E2=80=99m still able to=
 reproduce with bitmap enabled. I=E2=80=99ve gathered the full list of all =
stuck tasks.
>
> Just as a reminder on the setup, the layering here is:
>
> nvme drives =E2=86=92 mdraid =E2=86=92 lvm =E2=86=92 dmcrypt =E2=86=92 xf=
s
>

If you have the time (this is just a hunch) could you test with
--bitmap-chunk=3D2G
