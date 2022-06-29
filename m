Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A104CCA482
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574293;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PBY4O/apTocR/Q0FRiWxf14E3/quvJB9vdV+zHdZ1lM=;
	b=SQVANA6QHkd/1dNZd5WlcpgAzAq3kkLTKo3R1STgpTZ7qtRxuIcMSgRjB5UBw/5pRfS31R
	mUjGA0plxwIeyF7WDO1ZE4KsizWUtBNeQ4EsGsdnrlAYWlAAOVIRAVEifw+m+oUcxxuVqG
	Cp5NaN5wg8uVgGeYEDwKlOHVgXDCTFs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-dj1SU4PGOpWPPeo528u8TA-1; Thu, 30 Jun 2022 03:31:30 -0400
X-MC-Unique: dj1SU4PGOpWPPeo528u8TA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24A2F100B8E8;
	Thu, 30 Jun 2022 07:31:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD651112132C;
	Thu, 30 Jun 2022 07:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6193B19451F0;
	Thu, 30 Jun 2022 07:31:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B88381947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 18:40:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89D8F1415108; Wed, 29 Jun 2022 18:40:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 857271410F3B
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 18:40:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BD80185A7BA
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 18:40:05 +0000 (UTC)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com
 [209.85.219.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-GyVvwKnaNhqyqLmzFNn6RQ-1; Wed, 29 Jun 2022 14:40:03 -0400
X-MC-Unique: GyVvwKnaNhqyqLmzFNn6RQ-1
Received: by mail-qv1-f54.google.com with SMTP id n15so26110059qvh.12;
 Wed, 29 Jun 2022 11:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZTPGx2N1jpuiUT68Zx+rA9I6AVj18IKzWfibl/qcoIc=;
 b=NwGh/zxWciRNRwjPLFLL0Tn+H6+J2ndHaACgcjlgVPXQTfk8Oy0zaIkkDPi0rPDE2g
 /Q+tRr3STUrYmLs1helvWAV6SuuR9IcPxVMEbFY9geFrDwQ91fnHSxxcYSvcT46DkUi2
 UCYz6QRKXGe/+c+ocUBbYI1cYyt5DDe7MDQADMeOYf7X+YTCdovbPH6ATUSW6d+E3jfj
 tHrevW3bjKD1VE/5rYhyHuuxUxFtm1tlqpz+BgSCzjTdkJFt3v3G/2WxJf6qS0oxUGHa
 fAfipKS7yuiPdBn2ZhcNXxYJlRa8fohHRBdeGqkajzJe2g9QpLphBzUnmVTBu2yxdLP9
 L7+w==
X-Gm-Message-State: AJIora9lCZO9Tr05KhGpRRkOJIE4Ch+GdgzPMlBHX+Ix+WTZLmAd2BgE
 2XhgWO7wyve+QCD2dKbSHg==
X-Google-Smtp-Source: AGRyM1t+k/LSavzJpNR9L3NcEUGUmQ3ZTiAl/yvrznRdJZcWrAFcC888FmZXs9k/HBhEyicxMrvcOw==
X-Received: by 2002:a05:622a:174e:b0:319:5b72:173b with SMTP id
 l14-20020a05622a174e00b003195b72173bmr3863832qtk.13.1656528002961; 
 Wed, 29 Jun 2022 11:40:02 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 o1-20020a05620a2a0100b006a6f68c8a87sm3941480qkp.126.2022.06.29.11.40.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 11:40:01 -0700 (PDT)
Date: Wed, 29 Jun 2022 14:40:01 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20220629184001.b66bt4jnppjquzia@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 30 Jun 2022 07:31:23 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 11:16:10AM -0600, Jens Axboe wrote:
> Not sure what Christoph change you are referring to, but all the ones
> that I did to improve the init side were all backed by numbers I ran at
> that time (and most/all of the commit messages will have that data). So
> yes, it is indeed still very noticeable. Maybe not at 100K IOPS, but at
> 10M on a core it most certainly is.

I was referring to 609be1066731fea86436f5f91022f82e592ab456. You signed off on
it, you must remember it...?

> I'm all for having solid and maintainable code, obviously, but frivolous
> bloating of structures and more expensive setup cannot be hand waved
> away with "it doesn't matter if we touch 3 or 6 cachelines" because we
> obviously have a disagreement on that.

I wouldn't propose inflating struct _bio_ like that. But Jens, to be blunt - I
know we have different priorities in the way we write code. Your writeback
throttling code was buggy for _ages_ and I had users hitting deadlocks there
that I pinged you about, and I could not make heads or tails of how that code
was supposed to work and not for lack of time spent trying!

You should be well aware that I care about performance too - I was the one who
pushed through the patches to not separately allocate mempools and biosets, and
a lot of the work I did ages ago was specifically to work towards getting rif of
the counting segments pass (work I believe Ming completed); that was a _major_
chunk of cpu time in any block layer profile I've looked at. So sure, tell me I
don't care about performance enough.

*sigh*

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

