Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8013312EBCF
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712764984; cv=none; b=gxU0lEneh1/PcnGau2EqA5frj3tc9IjBQh7340axIxqoOCamtQGw2DRWbGUpKcMavKLD8SjPm1OYpMMJARxyWq6rZTmv5T3H2AbHFpd0Lx8BL/Ax0zx5vIIe3uE7cnBV19O1u+XrvYBblCFsi8SevU+ePSmATeypRJuBpSqvx54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712764984; c=relaxed/simple;
	bh=IVFSM0BCrE6A1xc/CVbkYEQb9Y79P40NL3fUgUD7vSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mul3iWPczYiY3PmbseC0hJkeTm4RHMS5JKmRO9n2/y5rzUj8RSuFTbNUtQ6lvwh+eB/KGWUa1wgdIwvXLS/x+dmX979el5MMkb1esmMCNixJ/NFsXZ4fd8Wwf2zF5eQKomMBCQRt91nrUeqref8+8Q+ZC3NYkZCTgxw5VJzlgps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-69b265a1ae7so14084826d6.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 09:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712764981; x=1713369781;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18asjn701EnXrAEa1lUJTVnwwXNqBx4Xp3ynvhhCH1I=;
        b=h6ZdccIiVDZWCkbpb1Ox2c10R6YWxeKGR13VmvVzOSIUpJQfv0f3aqwbOanqD/edOD
         hRhDbtpAAc1xEDZpMM5DfXsuHPOfii/Jfab893gaHh85uf7ePyj00IvoCEOtuTNrtItN
         VB0fcvNQbI9/dMNRe/CGB0AZK3mzQ35nRdgpIWwXyaKeefMK5fjR7E5bNG5CB3gY5AgQ
         NMlU06WwiVSQY84FDuJ6famZ3WYMFZL8CvPVyahDhrOka4HrWuvNP+77XaHTmjJXuLiy
         x//p1O4vuzCKiflu+ccebHycgPsf0KnLCkCNNKWFxxhpHiCZuP6JCBW/sHtCfppsuqXg
         j32w==
X-Forwarded-Encrypted: i=1; AJvYcCX+NPBE800dE3zAzayTR1FFOsDYDgTFQHeNZEt9BH9k8zyFkBVlI2hASQMHcKVKVcpP+4lvknNUy2DGzXbb9sC2ioZT1jXyEdU=
X-Gm-Message-State: AOJu0YyW21SmX71pyE4Mt8/7UUfWsdlZ/DVp1Iqy04v3RVkUCQxtL9d3
	LPiID8guYMQitG9pHdzzUWmC5S6upBGKDDUAFw5Le8Hyko5anSZ8BuefUBnQKw==
X-Google-Smtp-Source: AGHT+IF8DD3k/ay27V0TzqAnwQU2YrT2+ssEUXP45hpptOlU0L0qggnwSGMqk5i2u9rLAEYt7M81tw==
X-Received: by 2002:a0c:fac3:0:b0:69b:4608:72a4 with SMTP id p3-20020a0cfac3000000b0069b460872a4mr74678qvo.25.1712764981034;
        Wed, 10 Apr 2024 09:03:01 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id mx18-20020a0562142e1200b0069b3f41d402sm578169qvb.21.2024.04.10.09.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 09:03:00 -0700 (PDT)
Date: Wed, 10 Apr 2024 12:02:59 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: yangerkun <yangerkun@huaweicloud.com>
Cc: mpatocka@redhat.com, agk@redhat.com, tj@kernel.org,
	dm-devel@lists.linux.dev, yangerkun@huawei.com, yukuai3@huawei.com,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3] dm-crypt: reexport sysfs of kcryptd workqueue
Message-ID: <Zha4M0ru46QrKYgq@redhat.com>
References: <20230711061129.2706759-1-yangerkun@huaweicloud.com>
 <45a09f8d-d167-c78c-7ac8-3ed27db18653@huaweicloud.com>
 <Zhaxz1ZkGzbfW0RQ@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zhaxz1ZkGzbfW0RQ@redhat.com>

[resend after rebase and fixing dm-devel mailing list address]

On Wed, Apr 10 2024 at 11:35P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Sat, Mar 30 2024 at  4:05P -0400,
> yangerkun <yangerkun@huaweicloud.com> wrote:
> 
> > Hi,
> > 
> > Ping for this patch!
> > 
> > 在 2023/7/11 14:11, yangerkun 写道:
> > > From: yangerkun <yangerkun@huawei.com>
> > > 
> > > Once there is a heavy IO load, so many encrypt/decrypt work will occupy
> > > all of the cpu, which may lead the poor performance for other service.
> > > So the idea like 'a2b8b2d97567 ("dm crypt: export sysfs of kcryptd
> > > workqueue")' said seems necessary. We can export "kcryptd" workqueue
> > > sysfs, the entry like cpumask/max_active and so on can help us to limit
> > > the usage for encrypt/decrypt work.
> > > 
> > > However, that commit does not consider the reload table will call .ctr
> > > before .dtr, so the reload for dm-crypt will fail since the same sysfs
> > > problem, and then we revert that commit('48b0777cd93d ("Revert "dm
> > > crypt: export sysfs of kcryptd workqueue"")').
> > > 
> > > Actually, what we should do is give a unique name once we try reload
> > > table, we can use ida to fix the problem.
> > > 
> > > Signed-off-by: yangerkun <yangerkun@huawei.com>
> > > ---
> > >   drivers/md/dm-crypt.c | 28 +++++++++++++++++++++++-----
> > >   1 file changed, 23 insertions(+), 5 deletions(-)
> > > 
> > > v1->v2:
> > > rewrite the commit msg
> > > 
> > > v2->v3:
> > > no logical change, just rebase to latest linux kernel
> > > 
> > > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > > index 1dc6227d353e..f4678eb71322 100644
> > > --- a/drivers/md/dm-crypt.c
> > > +++ b/drivers/md/dm-crypt.c
> > > @@ -47,6 +47,8 @@
> > >   #define DM_MSG_PREFIX "crypt"
> > > +static DEFINE_IDA(crypt_queue_ida);
> > > +
> > >   /*
> > >    * context holding the current state of a multi-part conversion
> > >    */
> > > @@ -182,6 +184,7 @@ struct crypt_config {
> > >   		struct crypto_aead **tfms_aead;
> > >   	} cipher_tfm;
> > >   	unsigned int tfms_count;
> > > +	int crypt_queue_id;
> > >   	unsigned long cipher_flags;
> > >   	/*
> > > @@ -2735,6 +2738,9 @@ static void crypt_dtr(struct dm_target *ti)
> > >   	if (cc->crypt_queue)
> > >   		destroy_workqueue(cc->crypt_queue);
> > > +	if (cc->crypt_queue_id)
> > > +		ida_free(&crypt_queue_ida, cc->crypt_queue_id);
> > > +
> > >   	crypt_free_tfms(cc);
> > >   	bioset_exit(&cc->bs);
> > > @@ -3371,12 +3377,24 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> > >   	}
> > >   	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
> > > -		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> > > +		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> > >   						  1, devname);
> > > -	else
> > > -		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
> > > -						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
> > > -						  num_online_cpus(), devname);
> > > +	else {
> > > +		int id = ida_alloc_min(&crypt_queue_ida, 1, GFP_KERNEL);
> > > +
> > > +		if (id < 0) {
> > > +			ti->error = "Couldn't get kcryptd queue id";
> > > +			ret = id;
> > > +			goto bad;
> > > +		}
> > > +
> > > +		cc->crypt_queue_id = id;
> > > +		cc->crypt_queue = alloc_workqueue("kcryptd-%s-%d",
> > > +						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
> > > +						  WQ_UNBOUND | WQ_SYSFS,
> > > +						  num_online_cpus(), devname, id);
> > > +	}
> > > +
> > >   	if (!cc->crypt_queue) {
> > >   		ti->error = "Couldn't create kcryptd queue";
> > >   		goto bad;
> > 
> 
> I'm OK with adding WQ_SYSFS to export workqueue info.  dm-crypt's
> performance is very tighly coupled with its use of workqueues.  So
> allowing more visibility into workqueues makes sense.
> 
> That said, I'm not loving that the sysfs entry will have a dynamic
> name (made possible with ida) -- but I can live with it.
> 
> However, I do think it is useful to always use WQ_SYSFS (even if
> DM_CRYPT_SAME_CPU, and also for the IO wq).
> 
> So I've made the use of ida common to all dm-crypt wq. I was able to
> do this more cleanly by rebasing ontop of dm-6.10 (which now includes
> recent dm-crypt patch to allow WQ_HIGHPRI to be configured), see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.10&id=6bd1e0b331ddd7bb4d6b2abc8472a36602180aa5
> 
> Thanks,
> Mike
