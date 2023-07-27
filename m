Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0603EC00528
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 22:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690498794;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DAvo3zoFuCpBKQTJ1sgmG0SXHaLRbGlgv/vM3yg3YEE=;
	b=NDAvhVY3YQY2MeFpzSTDAzK6zuNrO6z4Vd90EuOQ13sOut1NWWdmkHkXbAnm6oGPtXYbLE
	D314XCHv9BKLLNTaZVxHjmkJAm0RYGnSBZeOr0AMoarlaeP/QtBPcx2RxGuPs2u3nX7QnN
	Kep8829jM50U/Ci3MxuoE/ZuV0RcTTs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-BemeJhqdOSCoFcG1KR3wcQ-1; Thu, 27 Jul 2023 18:59:50 -0400
X-MC-Unique: BemeJhqdOSCoFcG1KR3wcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C447A85A58A;
	Thu, 27 Jul 2023 22:59:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62CE6C57964;
	Thu, 27 Jul 2023 22:59:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3392F1946A6A;
	Thu, 27 Jul 2023 22:59:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB5AA1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 22:59:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DB123111F3B6; Thu, 27 Jul 2023 22:59:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D29F5111F3B0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 22:59:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A70BE185A78F
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 22:59:44 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-E6sKv4BoO6CrssoBXRFwfQ-1; Thu, 27 Jul 2023 18:59:42 -0400
X-MC-Unique: E6sKv4BoO6CrssoBXRFwfQ-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-686f94328a4so673974b3a.0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 15:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690498781; x=1691103581;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=8CTrna5t3S7P99W+zrM1I2ApZYIkXTVQedDFVAI6oIw=;
 b=W9iAagOh0fjE+zAs1vHu0ETLLwttbInolcgE/geSviR7AVcBw8GQoB0NSSxg2C8jDC
 EXOfNiXb3eA5ab5cAqCt1qoMZTmeqxGkqu3eVq/K1pncit4s3qDNj+bpoyO30W0IcdC/
 gMa/eEk+OLzIeMRDSo3+pQx3oqSvzN1X/GUKEXEMuy0SiFvn6JositrnYsGpkGOvVYic
 ZxIdlRgK3/dXYRXPWHNBn8PuTMx29x5i/qnINb9fvdDCLidOf+7lUZxqhvvTFi59h18K
 BporRD6ZJ/wje2NIurJ9alJnHBOfLS6fZw0cu6eXf1Ij5CNtjnAo36ZUIrwU0hPl4kDv
 T2Tw==
X-Gm-Message-State: ABy/qLbQxdcHEm3wTQchU1A6ObCVKO2GAJfdsm0a43YD5Byj00b9/7HS
 8XmbVCg37oHV0j/dLngkShs9vg==
X-Google-Smtp-Source: APBJJlGFE8oAcAZu2XvzWjC5bjR81v7OIjjTfZ8m+EaEe6Rjpq3cuwvHN3I08mErFwOZJpneP9Ly1g==
X-Received: by 2002:a05:6a00:17a8:b0:64d:42b9:6895 with SMTP id
 s40-20020a056a0017a800b0064d42b96895mr61072pfg.5.1690498780930; 
 Thu, 27 Jul 2023 15:59:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au.
 [49.186.119.116]) by smtp.gmail.com with ESMTPSA id
 p24-20020aa78618000000b0068702b66ab1sm1115813pfn.174.2023.07.27.15.59.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 27 Jul 2023 15:59:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qP9xJ-00BKKZ-1O;
 Fri, 28 Jul 2023 08:59:37 +1000
Date: Fri, 28 Jul 2023 08:59:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Damien Le Moal <dlemoal@kernel.org>
Message-ID: <ZML22YJi5vPBDEDj@dread.disaster.area>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
 <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
 <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
 <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
MIME-Version: 1.0
In-Reply-To: <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v3 28/49] dm zoned: dynamically allocate the
 dm-zoned-meta shrinker
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Muchun Song <songmuchun@bytedance.com>, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 netdev@vger.kernel.org, muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2023 at 07:20:46PM +0900, Damien Le Moal wrote:
> On 7/27/23 17:55, Qi Zheng wrote:
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 goto err;
> >>> =A0=A0=A0=A0=A0 }
> >>> =A0 +=A0=A0=A0 zmd->mblk_shrinker->count_objects =3D dmz_mblock_shrin=
ker_count;
> >>> +=A0=A0=A0 zmd->mblk_shrinker->scan_objects =3D dmz_mblock_shrinker_s=
can;
> >>> +=A0=A0=A0 zmd->mblk_shrinker->seeks =3D DEFAULT_SEEKS;
> >>> +=A0=A0=A0 zmd->mblk_shrinker->private_data =3D zmd;
> >>> +
> >>> +=A0=A0=A0 shrinker_register(zmd->mblk_shrinker);
> >>
> >> I fail to see how this new shrinker API is better... Why isn't there a
> >> shrinker_alloc_and_register() function ? That would avoid adding all t=
his code
> >> all over the place as the new API call would be very similar to the cu=
rrent
> >> shrinker_register() call with static allocation.
> >=20
> > In some registration scenarios, memory needs to be allocated in advance=
.
> > So we continue to use the previous prealloc/register_prepared()
> > algorithm. The shrinker_alloc_and_register() is just a helper function
> > that combines the two, and this increases the number of APIs that
> > shrinker exposes to the outside, so I choose not to add this helper.
>=20
> And that results in more code in many places instead of less code + a sim=
ple
> inline helper in the shrinker header file...

It's not just a "simple helper" - it's a function that has to take 6
or 7 parameters with a return value that must be checked and
handled.

This was done in the first versions of the patch set - the amount of
code in each caller does not go down and, IMO, was much harder to
read and determine "this is obviously correct" that what we have
now.

> So not adding that super simple
> helper is not exactly the best choice in my opinion.

Each to their own - I much prefer the existing style/API over having
to go look up a helper function every time I want to check some
random shrinker has been set up correctly....

-Dave.
--=20
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

