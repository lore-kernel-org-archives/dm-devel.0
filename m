Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E52C21D8
	for <dm-devel@lists.linux.dev>; Sat, 20 Sep 2025 20:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400391; cv=none; b=aOXrhbSU6DLhFVXeajUmO/+994e7Ftln9YUIsf6994QqjhrE1mQaRtTCX9OhnXtBRme+hFXIN20QjDtOYjUrfp/XaQM6C9a05Ne3ynIGyY/hb7muMRGMnLoJ2ivzFU925uSR+/H4BBkYDSp1k1IAzaA6RBLZe6OsDkqFSTDrgeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400391; c=relaxed/simple;
	bh=PElu1Bg5caLMkZhWd+SJ6GCHwCirVP2c8eWEjSJBtTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sgWlHxImoDuUHZyiUCYOo2i4n3YBojSrP1lklwLiG/v7Q0+0FA/eWN+yDP8EYwcieI9YiaiccBW4P8c4ciV2/zN2tIpVXm0M6EEfcWSWYlAr7MRYpUAwgVvXO7i2fvx0u8HrrV+m8+QAXvaz0MUgkcoY+H7zDXOmTVXtBB8NNho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlIQ1m0l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlIQ1m0l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758400388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=58SYZDQdnPXBgRIog1595iqKTWT7WxzWJLnuBMXPOtQ=;
	b=YlIQ1m0lEWce21Kq12/P1BiAQ3aFnnRS46Cr+7eyYJEl0GMJRJIyYky27Dc+MFj3/MHiRk
	HR5UX+G0o3v4DDUgWE6VwLtj3ifJHlAZbEgHMF3RA2NTXZkxUcBmZBHGhNtQhksrlmNnm2
	7k+Jz2pENOB4fIiQZ2wfDInxIjL+aqI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-JdnpHbwTMBS87IMkgwdxqg-1; Sat, 20 Sep 2025 16:33:07 -0400
X-MC-Unique: JdnpHbwTMBS87IMkgwdxqg-1
X-Mimecast-MFC-AGG-ID: JdnpHbwTMBS87IMkgwdxqg_1758400387
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-79390b83c48so63925906d6.1
        for <dm-devel@lists.linux.dev>; Sat, 20 Sep 2025 13:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400386; x=1759005186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58SYZDQdnPXBgRIog1595iqKTWT7WxzWJLnuBMXPOtQ=;
        b=E+2fqKRdzbp1hM0tegR4a+y1goJdSX8g0YeMdyknQRSA4GKip9NoFtVWx8O2uMsOkX
         xJoAneWVSpIFkvYXvUzhHc1+LzZ8yWNn3JmtVXyPaiHSR+kW2WWeiPoAQgR0Y2ENGMm/
         +to46qQHJqiPyGYcqxJqSuboV7wo3j6Q7bpG3rquPdVLbCzOm47LB3UiRGz0qJ/L1R96
         iG11kqu1p42MEljSXHfCauKkq72L4gdg5rizD0EHtwLZ7GA7H9mMEAioqp4UVxJrj3dA
         QxkdXxK830tegRZmzJ7LxJE1woa7yYCF/jROm4FILVFJU6Rxmx/Cjnlx+ozW1WgjSeJl
         NsGQ==
X-Gm-Message-State: AOJu0YymrbaeTW6B6tCRzYRXwPHNjTxrzaBc7ptoET/HVPcO22ikqx19
	bBDMhIfvNGB8sDqrYJ5qiPLXybvruwbnZFYpWCp6sdyCaNsL0FTbdHogxbTizLjrTcQEnoS48NH
	axdTPKgUyZ9prgOkXSBtaHKuFZKyLelM86vX7Lgs7eCBQm1E7S3EUaooKRyiGaAmrrZ8=
X-Gm-Gg: ASbGncvLXxCIXunb6zkXj7kmVeeHRzcmViRPKSE6Ta71ul8ZU9vkb/BWuhCgUnJEQLS
	znOlGeaDvrZ7V9cacPS1vk6M0FX7DQUgYFNfIWg5Qpw9a/baWJk3ymj+zR/1433lgO1Vqtn08aB
	HkKM4squOEtHQ+rBL+Lc8k1hhOxr3QbSlG5XSu14A0YbW2K45WZ6bYKwyVOHrMY37nqUfcDt1y4
	Ne4Nh3ViUNlBkHkbqL8MykUFMFaYUlfZC6RECaCMROcVT6Ei2+mcV81fOoMyC88x9F6W8+o1CQY
	hs4TKW+1V42tl5Tf6ISutYeKEw7LSJRUXusDosmQxNn9Ow==
X-Received: by 2002:a05:6214:1d2a:b0:78d:4a9e:e95f with SMTP id 6a1803df08f44-79910ca6225mr87627006d6.13.1758400386380;
        Sat, 20 Sep 2025 13:33:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGURKoZu4DJJmi2RmG5zbSPCV1QBJX+idkgnfegZPG7AFHoqM88GdaLwXyfcnCAQW4pNSSNtw==
X-Received: by 2002:a05:6214:1d2a:b0:78d:4a9e:e95f with SMTP id 6a1803df08f44-79910ca6225mr87626896d6.13.1758400386055;
        Sat, 20 Sep 2025 13:33:06 -0700 (PDT)
Received: from localhost ([68.160.190.125])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-793516d7c7dsm47665366d6.35.2025.09.20.13.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:33:05 -0700 (PDT)
Date: Sat, 20 Sep 2025 16:33:04 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Augusto <augusto7743@gmail.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm cache in BTRFS
Message-ID: <aM8PgD26y00J2i48@redhat.com>
References: <38bddf47-aac6-f10e-ed17-86166f9a93fc@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <38bddf47-aac6-f10e-ed17-86166f9a93fc@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mZhay8aDF-zdxLCt8H9ptMv9O1AYQK-Y5wHyvrou4nw_1758400387
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 20, 2025 at 09:11:02AM -0300, Augusto wrote:
> Hello.
> Thanks for reading that message.
> Please excuse if here not was the correct area to contact you.
> I use Linux with dm-cache writeback. You are the dm cache developer ? If yes
> thanks very much for making it.
> I want report an issue using dm-cache writeback with BTRFS.
> If the dm-cache writeback is full will happen an partial write of files in
> BTRFS file system and doing it create the terrible "Parent Transid Verify
> Failed" that in some times is fatal error.
> I understand that writeback cache can damage file system if not is done an
> full flush to disk, but BTRFS is extremely fragile compared with others file
> systems.
> I want continue using dm-cache writeback in BTRFS file system.
> Perhaps implementing an new feature in dm-cache that when the writeback
> cache is full is done an partial flush to disk in reference for some files
> in wb cache, but that partial number of files will be totally writen to disk
> avoiding partial writen of any file that is the because happen errors in
> BTRFS using wb cache.
> In others words if the cache is full will be done writen some files to disk
> with correct file size not doing partial flush to any file.
> In moment I not see any dm cache command setting to avoid that issue.
> Have an nice next week and excuse me if here not was the correct way to
> contact you about it.
> 

Please be specific about which DM targets you're using.

Please run and share output from:

  lsblk
  mount
  dmsetup table

But once you have that info, you'd do well to post any further
questions you might have to dm-devel@lists.linux.dev (now cc'd).

Thanks,
Mike

