Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6F1EDD
	for <dm-devel@lists.linux.dev>; Sun, 18 Feb 2024 02:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708223275; cv=none; b=p11iPG0MAokU45k9TQGSEBf2QfklC+hb8SjOyAILldOteVdlZXkVu1cW4NI/ZBJO3LqeyriVooKF2mj0fsenrlbw0J9LopWh+pcSsdpdobcmsV7DtsKZ9b+wQpgo9UOAaLsPIlzJqymqEdTalfDegua7+XWiGPnGrBb0DoWaOoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708223275; c=relaxed/simple;
	bh=nKsx+TvlDRCfg/EURkIhikZLmq+YLEYvNN++aBLHASQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LiuzPgRdy4+IlVyUMDT6NXVJrYjcdvv3jP+pUDXm3DcySWD5iBCy1AVOWINbar0shehnw57ncrkH2wBgj2doF05+A7xKukKKg0iXQhOQh4/8UXgBih4vglN1+xo29xTaEGKOwidwlIps5kAyFFCUesjMjNRpeMi1Yc3hcxY5gHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N84lRDD1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N84lRDD1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708223272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKsx+TvlDRCfg/EURkIhikZLmq+YLEYvNN++aBLHASQ=;
	b=N84lRDD15aXus10mUmm7eVvxpS0Y0UUttX98ym/kcUf77eltjBaOlqtt7yKINqdHKV2hz6
	3KM5LuqjgBRk25ERopWMtYKwAaozZ0+lSQ+1wbtpX1IERzxBnZNSnNn2GpAzwCXkzQOhPH
	cT0z80TNoztXbI0aFKz2AFvIYY7gAPA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-NmGypL1LMw2Ad1oNq-bO5g-1; Sat, 17 Feb 2024 21:27:50 -0500
X-MC-Unique: NmGypL1LMw2Ad1oNq-bO5g-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-29955bf2116so541368a91.2
        for <dm-devel@lists.linux.dev>; Sat, 17 Feb 2024 18:27:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708223270; x=1708828070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nKsx+TvlDRCfg/EURkIhikZLmq+YLEYvNN++aBLHASQ=;
        b=IbZUIUJr2yAw/6UCZZnbDoXv1jfVFtwwaEuzbcx41Q7TrXIuYAEwrZUYDk8sRM2k3D
         ivlKPHi0fCh+k5ISzoxetFhuJ7jn4E+/a2LkXumvBToxI0Qtpk2HD1oLwC0h6bdYiQ3a
         LfR0mHnAdWokz7Ug+l4euYEM41X7TAoYX0E3YQtRLqaFa5/oDDISrII5pG86ndp/l1KC
         I82g7xYWNmM53PVj/wiEoCG/VIw8+kD9GAKDq23Nyd7fljzkoLKKfw93/SbIlfj7NVIf
         kO8UQYzMF6fVK6esQVNShNK62Zg4Zs9+eXygIaNdGJlaDVRXLZhiiydITQRdwAoxWCK6
         6mzw==
X-Forwarded-Encrypted: i=1; AJvYcCUhKXKaAymSExMs4PFqKrnmGoxjWieLHsXq0zHPLeiT4bFeV7qWdKCVIHI/nLYi29twdwPfN05Tilru45BEpOclwR+jzbl2CS8=
X-Gm-Message-State: AOJu0YzqLGCPSOlsqfmD+UznV0d/bmuHv1Q9XcRoq55EaLcTnLpWpR4Z
	ws4WZJl1J+lOX1MMEylfVv4Xqemym6p7T6QY5aUBk5egcOGyKW44j0TmJboAM/dV9N8cvv/WBpK
	F0Vwv0l/3aio5xc+fiZvOHyy16x82QvlgErNmkJRM/UJ+AWH89nSQc9FyAHXRHyREi1NueVg9LC
	yjgGOMhgKjxyQZrUCWih7p4yCaogRG09s=
X-Received: by 2002:a17:90b:78e:b0:299:3e54:83fe with SMTP id l14-20020a17090b078e00b002993e5483femr3558426pjz.36.1708223269829;
        Sat, 17 Feb 2024 18:27:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGO+Z325KAFI0GSZHw8iD5qIOQx10QeQ1N76fEOCkdUvi6n8sFtZCH4pi9EU3V0YpRBSBxKSb8bnmRvh9gR8PM=
X-Received: by 2002:a17:90b:78e:b0:299:3e54:83fe with SMTP id
 l14-20020a17090b078e00b002993e5483femr3558413pjz.36.1708223269552; Sat, 17
 Feb 2024 18:27:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
 <20240201092559.910982-2-yukuai1@huaweicloud.com> <CALTww2-ZhRBJOD3jXs=xKFaD=iR=dtoC9h2rUQi5Stpi+tJ9Bw@mail.gmail.com>
 <64d27757-9387-09dc-48e8-a9eedd67f075@huaweicloud.com> <CALTww28E=k6fXJURG77KwHb7M2OByLrcE8g7GNkQDTtcOV48hQ@mail.gmail.com>
 <d4a2689e-b5cc-f268-9fb2-84c10e5eb0f4@huaweicloud.com>
In-Reply-To: <d4a2689e-b5cc-f268-9fb2-84c10e5eb0f4@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 18 Feb 2024 10:27:38 +0800
Message-ID: <CALTww28bUzmQASme3XOz0CY=o86f1EUU23ENmnf42UVyuGzQ4Q@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 18, 2024 at 9:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/18 9:33, Xiao Ni =E5=86=99=E9=81=93:
> > The deadlock problem mentioned in this patch should not be right?
>
> No, I think it's right. Looks like you are expecting other problems,
> like mentioned in patch 6, to be fixed by this patch.

Hi Kuai

Could you explain why step1 and step2 from this comment can happen
simultaneously? From the log, the process should be
The process is :
dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_targets(raid_pos=
tsuspend)
-> dm_table_destroy(raid_dtr).
After suspending the array, it calls raid_dtr. So these two functions
can't happen simultaneously.


>
> Noted that this patch just fix one case that MD_RECOVERY_RUNNING can't
> be cleared, I you are testing this patch alone, please make sure that
> you still triggered the exactly same case:
>
> - MD_RCOVERY_RUNNING can't be cleared while array is suspended.

I'm not testing this patch. I want to understand the patch well. So I
need to understand the issue first. I can't understand how this
deadlock (step1,step2) happens.

Regards
Xiao
>
> Thanks,
> Kuai
>

