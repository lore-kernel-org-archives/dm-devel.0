Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9D416DEC0
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712763215; cv=none; b=qIu+cFooYSuvIDt2SUr8Ngf5lvQB2xJqyeuBy2pIMvfINfxmJheQisJMq0FW1zHZNbeM2MBrFkAWAvbyOzxuajy7pQ8B8pMyKobvxg7g2R5PYq8qa5VwOAZw7Ffz/Xwi5dDUuWQQute2qWSXTgxO4ssVQCyKyuAUYQkJEGtNlss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712763215; c=relaxed/simple;
	bh=CJjivhgSNW12vuz1FW4XwUCLmaHE+k6cRCIhcVoI+CM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lspfen7mm6j4GIDRnq7QOQx5UGYFVDBYkyC90MZ5qJiSuqtZO4LfkSNuskSwOUaA/pGtNcZgx9Q/M0wJGnIghEY7vDKbliYx4MIu8A3Z6IMmnxG+HjZ/YEOub7KeCaG4i9H9/3Oq3z7GwFCWkOojxiO6lvDeGgEobu05LW0nPpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-78a2a97c296so396994185a.2
        for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 08:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712763213; x=1713368013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBcTgV/x7+DUqETyOP/TINXC8TYCNHdQ6atrZMG2KUw=;
        b=MT3BQ49zcUBflO0ju8QH8ilm/jasV3dPLHDSMXEQHFIUnUS16UIv8w4NF2ONerV0i9
         BM0cbdMWH/6BGeuNVES436WkYolpPVE990w6TcpLHiTGISOy1A0whooblhP5WNLeqk0M
         CpLAiKCO1A596J5X0Q/jRjoTbioydbmbL4wpCPvBOb1dtutJ4bO6jprscU6p1KWjOf3t
         Hg5TcNCXqP1oUavOLl5lNtKEZpwQbJiXNGoz6xmelKx8cHHO+SLPkZCMIUem0JHoZQAT
         N7oKvcnyFnrQlAzGgmCcxJcOksMNptsRCtdOPlN/ncMON9lDc9dctIvvSGrsPUCO2SeW
         LTBg==
X-Forwarded-Encrypted: i=1; AJvYcCUkSmmYWd/8rDB6UOaYEjJpT6naTT1+yHWXdij97tqPmx8M+LhVNh7mgGIgrR+Km0GzMBLHZ8FzUfa/ApmzXEmHpWJn+5z322g=
X-Gm-Message-State: AOJu0YyPLANqII6nXmUHghSUNTJOMOGygsbbHCAw67FEcwdrN6drQ3ZL
	/lj3VhY3jS2Pw1pl4pUNnn5SCGkTUMGBpwEoQIUEP719v7mgEdg2/HCkka/3fg==
X-Google-Smtp-Source: AGHT+IF40H+zfzvTCc8lOAb6ssYNizrJGhjkKPfwcSdhI4uPd7CUvflJjzizYUYVVVZjpSz9oQ4/Ww==
X-Received: by 2002:a05:6214:18d3:b0:69b:3a49:106f with SMTP id cy19-20020a05621418d300b0069b3a49106fmr1813853qvb.15.1712763212909;
        Wed, 10 Apr 2024 08:33:32 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id qf12-20020a0562144b8c00b0069b412e3716sm436565qvb.80.2024.04.10.08.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 08:33:32 -0700 (PDT)
Date: Wed, 10 Apr 2024 11:33:31 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	yangerkun@huawei.com, Bart Van Assche <bvanassche@acm.org>,
	"Alasdair G. Kergon" <agk@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH resend] dm-crypt: add the "high_priority" flag
Message-ID: <ZhaxSyT3qq6i9Wg_@redhat.com>
References: <f53ff8a9-da8e-da35-cdf8-3bd260d9af33@redhat.com>
 <970419e5-9f14-4b73-97a8-ceea45da240c@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970419e5-9f14-4b73-97a8-ceea45da240c@gmail.com>

Hey Milan,

Hope things are good for you!

On Tue, Apr 09 2024 at  9:04P -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 4/8/24 9:36 PM, Mikulas Patocka wrote:
> > It was reported that dm-crypt performs badly when the system is loaded[1].
> > So I'm adding an option "high_priority" that sets the workqueues and the
> > write_thread to nice level -20. This used to be default in the past, but
> > it caused audio skipping, so it had to be reverted - see the commit
> > f612b2132db529feac4f965f28a1b9258ea7c22b. This commit makes it optional,
> > so that normal users won't be harmed by it.
> > 
> > [1] https://listman.redhat.com/archives/dm-devel/2023-February/053410.html
> 
> It is pity that we need an optional flag here leaving decision to the user
> (I would prefer a magic workqueue setting that will self-tune automagically.)
> 
> I guess people will set it and forgot about it (until some problem reappears)
> - as we can store persistent performance flags for LUKS2, so this one will
> be a new option there.
> 
> ...
> 
> > @@ -3399,18 +3401,22 @@ static int crypt_ctr(struct dm_target *t
> >   	}
> >   	ret = -ENOMEM;
> > -	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
> > +	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM |
> > +				       test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
> > +				       1, devname);
> 
> Just one nitpicking though:
> 
>    test_bit(...) ? WQ_HIGHPRI : 0
> 
> looks more clear/readable to me (but I guess test_bit should always return 0/1 only).

I agree, but I actually cleaned stuff up in further with the following
incremental patch:

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index fad4b920008f..eabc576d8d28 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3234,6 +3234,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	const char *devname = dm_table_device_name(ti->table);
 	int key_size;
 	unsigned int align_mask;
+	unsigned int common_wq_flags;
 	unsigned long long tmpll;
 	int ret;
 	size_t iv_size_padding, additional_req_size;
@@ -3401,23 +3402,25 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM |
-				       test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
-				       1, devname);
+	common_wq_flags = WQ_MEM_RECLAIM;
+	if (test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags))
+		common_wq_flags |= WQ_HIGHPRI;
+
+	cc->io_queue = alloc_workqueue("kcryptd_io/%s", common_wq_flags, 1, devname);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
-	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
-						  test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
+	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags)) {
+		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
+						  common_wq_flags | WQ_CPU_INTENSIVE,
 						  1, devname);
-	else
+	} else {
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND |
-						  test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags) * WQ_HIGHPRI,
+						  common_wq_flags | WQ_CPU_INTENSIVE | WQ_UNBOUND,
 						  num_online_cpus(), devname);
+	}
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;

The end result is here (also revised commit header):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.10&id=fdca2c9cb999e781fbb3171541c709bf0e43fbda

Doing it this way made sense given the following commit I staged (to
reintroduce the use of WQ_SYSFS, will send mail on that next).

Thanks,
Mike
