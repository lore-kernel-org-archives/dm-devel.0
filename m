Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D701D52D
	for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-77f3c84e0f6so442640285a.1
        for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 08:58:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702486705; x=1703091505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fko4jEZO7IcAc5n2WrXVozicqYAVH+5PpOz25KhjD+M=;
        b=HLTinxH6pGiW20MHIieu1I4yYKlFY41R8mAqcEwfnolw7wFc6TSHUUXuZUisX49JY9
         Yx0u/s1EdnDT8XUtBLz7cA0b8CBDb8pUWIbj5JPW1Kqb/f/nkVP+jiRoO/P5BAcBJL5B
         IkHAgyXKpeK/xuB1QsU19YUhJkX7plEH8u7axxSPYJdfTyDXAWYDo+J/zAy0UuNNhhGy
         llII4HlKA7PcfBcokvA31d+m1S1Te6J5yd3UDZufylq24CVnfWhUxlfn3d67OWlVLWMO
         d00rasEK8su1yLehIXCulAsiVrcJTgxVk1oQRTCj63QlmacF3hfQNtdxMVvLofYR/24e
         Nm5A==
X-Gm-Message-State: AOJu0Yw2Gg5rSHg3wZuk2lJEolGHAhdajDYtaNB7xy6yNANHbaUjpCGh
	Y8/r+SZkRXVgcdFb6MxXmfXf
X-Google-Smtp-Source: AGHT+IFvVkIflp9TiGbkJvpAu1da6qN2nmcyxFmltt+dcHVJ2+E3ImsBHyyCd+RBhaSCAT0Tc+H6Gg==
X-Received: by 2002:ad4:5046:0:b0:67e:f3e3:8291 with SMTP id m6-20020ad45046000000b0067ef3e38291mr2273884qvq.12.1702486705405;
        Wed, 13 Dec 2023 08:58:25 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id mi14-20020a056214558e00b0067a276fd8d5sm131380qvb.54.2023.12.13.08.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 08:58:24 -0800 (PST)
Date: Wed, 13 Dec 2023 11:58:23 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Hongyu Jin <hongyu.jin.cn@gmail.com>
Cc: agk@redhat.com, mpatocka@redhat.com, axboe@kernel.dk,
	ebiggers@kernel.org, zhiguo.niu@unisoc.com, ke.wang@unisoc.com,
	yibin.ding@unisoc.com, hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v5 1/5] block: Fix bio IO priority setting
Message-ID: <ZXnir8x6127EW7Gp@redhat.com>
References: <CAMQnb4MQUJ0VnA5XO-enrXTJvHbo6FJCVPGszGaq-R34hfbeeg@mail.gmail.com>
 <20231213104216.27845-1-hongyu.jin.cn@gmail.com>
 <20231213104216.27845-2-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213104216.27845-2-hongyu.jin.cn@gmail.com>

On Wed, Dec 13 2023 at  5:42P -0500,
Hongyu Jin <hongyu.jin.cn@gmail.com> wrote:

> From: Hongyu Jin <hongyu.jin@unisoc.com>
> 
> Move bio_set_ioprio() into submit_bio():
> 1. Only call bio_set_ioprio() once to set the priority of original bio,
>    the bio that cloned and splited from original bio will auto inherit
>    the priority of original bio in clone process.
> 
> 2. The IO priority can be passed to module that implement
>    struct gendisk::fops::submit_bio, help resolve some
>    of the IO priority loss issues.
> 
> This patch depends on commit 82b74cac2849 ("blk-ioprio: Convert from
> rqos policy to direct call")
> 
> Fixes: a78418e6a04c ("block: Always initialize bio IO priority on submit")
> 
> Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
> Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
> Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>

Would be nice to get this block core fix upstream ASAP independent of
your various DM changes.

Please simplify this patch's header like was requested in review of v4:
https://patchwork.kernel.org/project/dm-devel/patch/20231212111150.18155-2-hongyu.jin.cn@gmail.com/
