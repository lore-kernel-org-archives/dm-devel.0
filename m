Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB33B0AE5
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148932; cv=none; b=jiQbtV3L2UTY7e9veYPOkNrzTET0YVEYrv09a6helyUSQJ5vchYp1UCbu944HyKL8IeSb30TW+oUmUJDaWdLm/CReWBY6U7bsttgOg9WQQgQgyJH1rVMxyNBVPpGDbBHSUwdh+tEcNOKbsYidujOsNGiDwNE2GjcANs/UYBk2ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148932; c=relaxed/simple;
	bh=7C48eJwQxF2SZSyojjO4eehKdtPdDBqSboD/LkVXOwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=SK0o1wICFHUcqgkJj0MXzfOKnqTi9oJalIXCdqEcBLe7v13HGyTP+NYcKaWzbhSt1U/UJNFPBlkmaxQVNKWvBmJL5M2yOhHAK9OC9ly+5+xTdgU8Qx7MTQoLfcoqegOyP2CaW2b+1zgRrXvjJ81Bcg/yySYapxb9IfQqD/epCgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E51kNjIN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E51kNjIN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773148927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=E51kNjIN4UKbGW9DyZ5aBLaeo/X1fN08TYjWYCgYq8Q8qw25+tZQtb5W5ajU6MN7BBBW11
	0YDBivfD6ObYrVaZ07AfmguXniohVg3EyJDviAgsAuscNKdssFGgICyGTgh1yznjOgNpE3
	ekU6IHdwiHFWZVShb4nqu/2AD28lhx4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-Qc4_vw2INZWrmbopGIwi_Q-1; Tue, 10 Mar 2026 09:22:06 -0400
X-MC-Unique: Qc4_vw2INZWrmbopGIwi_Q-1
X-Mimecast-MFC-AGG-ID: Qc4_vw2INZWrmbopGIwi_Q_1773148926
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cd773dd39bso2180681785a.2
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 06:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773148926; x=1773753726;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=FQGbZKuLVgMGByatfn5od7zjo31vuJb8uo13J0unO+4L60W+nx2HdGCSVoM++Ps96S
         mIEB5qlrKBFf7LYMOUrl4uEk5i6ylK1f4D8nhlyGdxsj2q3F0VGnlLOQz1gYlGtQgwPg
         flcJMpvZgNJBkXrb+JeEd+Kj+Zn1ph5k9OG5pAS5/Zog41y2lEQ1XeSRZJvnhgDbLgAc
         VEeWGZDwW3lBKjK/lm2HlRNr09T3bjMg0FqtOqQXkCjB39stLoHEphFk+bcDa2Fup2Wn
         fRh7x4XLFgYYPc+HA01yNY6d7eNDufhov20PH6/5BO96C1vEW7mBPZ5tHGZHUPVIB5TF
         89hg==
X-Forwarded-Encrypted: i=1; AJvYcCVOvwODyL4qJKTK4B9ymijZ4cZUZdqi6Wa9rXTzj+CabAfeHjC8YnnRjrxkfSEDLbeOJvnsGbNgJA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyutrN00nz6NU0kHxjq0Ol2xEyBTfz2NLxOvccz+rV09Da/zicM
	rUtXEqm6Nskw1t2KHh6jCusTQou2tmClxEj+mjIpSp3XBoPf46zVy+Adlu6aY/Suj7CtgObkI2b
	qu/f+HmnKTLPX1pgue8t2vQgpjbht6wfMrzNFmuLNrd3Rz8K9tBRp4RBGT7fo
X-Gm-Gg: ATEYQzykKjr950DCAKyQZ1+msDGzEZ4QPMSKe3Epl2ydfP1rKI4WmNVo+/KcKs2UxbM
	uo33ShLKZhojMhRdyYs3w5uABhH0/2XTVTufFVwbHvxHXHy6FlZLzAbp3aRgzVJccCmxDaWgMWi
	geoMEhKmIEDXpz8pmIBW7ccXjiP7K5PlOZKcgUgEG75AsBEgshiftP8E1okT7/DCfQMjeEVbhzi
	a3oDUvRLmhHLez2jh7LBP1dKieNXPBY+G2TyUsxXmiGjbeNQKboLztS0Hx4icP27Vum4gH85CTP
	O56DAW2fXEl3kAjVZBrGroAdC89XggCphy7/GJt+J9mF2PZE9mqRA3wv/3+c4/XvKOKXyE/QDGQ
	PiS8Mhg0zzFn5DJjuk60r0kND6H9SRjfxRQdhX2HGlhKLEHclYLoe06N8
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830783985a.45.1773148924653;
        Tue, 10 Mar 2026 06:22:04 -0700 (PDT)
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830766185a.45.1773148922638;
        Tue, 10 Mar 2026 06:22:02 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8576db0esm474754485a.47.2026.03.10.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 06:22:01 -0700 (PDT)
Date: Tue, 10 Mar 2026 09:21:58 -0400
From: Brian Masney <bmasney@redhat.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAa9vQg4BSxl1BJ@redhat.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lqNGtCjyo5o41R6Pf5ErQiJ6rOsx-joEcS9W9vfH1no_1773148926
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 10, 2026 at 12:49:22PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,

Semantic ...

> but not when the pointer was NULL. Now the warning is printed in both
> cases!
> 
> Change found with coccinelle.
> 
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

With the minor typo addressed:

Reviewed-by: Brian Masney <bmasney@redhat.com>

