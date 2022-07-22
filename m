Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B93C43334
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658509969;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dxtXrUvQlf/2PHHaAP65n9qZcPe7iMoj04t9JsUS9Xc=;
	b=J/mr+/JHKSiqPclUvE5zsY7eCFcr5jN8TENrKgLAySnbZ2SGlro5jb2IRHhABS9S3dl0b2
	ci7bepxhe+/kGO4AVBkxRgEg4iHQn7o+IhZreqomZClb6K6gFahAMrpSpQDiGQtzYNMDD1
	v1fQzj07VKGYGUoIQ3CA2BU6EmZTh5M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-zPRZ3AlvMUSMa1q8i9zHqA-1; Fri, 22 Jul 2022 13:12:46 -0400
X-MC-Unique: zPRZ3AlvMUSMa1q8i9zHqA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C7223C0D841;
	Fri, 22 Jul 2022 17:12:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 70F31492C3B;
	Fri, 22 Jul 2022 17:12:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D65A194704D;
	Fri, 22 Jul 2022 17:12:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C1F121947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 17:12:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B04E0401E7B; Fri, 22 Jul 2022 17:12:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACC37492C3B
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 17:12:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93B6A900040
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 17:12:40 +0000 (UTC)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com
 [209.85.222.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-30jG888uNAGD8vvqyN_1SQ-1; Fri, 22 Jul 2022 13:12:38 -0400
X-MC-Unique: 30jG888uNAGD8vvqyN_1SQ-1
Received: by mail-qk1-f174.google.com with SMTP id n2so4074013qkk.8
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 10:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5HIE2XRg2pmYksgv53CszllxeDL9cUCYZVBiJXmaPPY=;
 b=Z8Cx1Ty7bnUK3w1qDJazhnj5r5deHo02wATVFYqy894xDlnm4jHDeoGrC4s0HLy6Il
 iu5FCEi+AkUkqHHS9zm8U4D5cFfx1ZsHNYQpvWJIwIXwxysq7Q++ivI/H0LOANcdp4dL
 d+6DkSvOW6dEaqMVl091iQtv28v4OgLWSyfe/0bZEkv5eixOyAVhDlm74x3WNh4jGfQD
 Ja5sGXqJ1woO+ADBh2HTAwoQjg9h6mo6YprkMh5vFOGn/pNGvvh0yvhI1GIrYK6o+HD2
 ebZI2672mhdgZCm9+xBYCPKIu7unjCohVaBEXAdIdY+EsLiC0Pu+6xTKG/4RsvxbQ+kV
 quhw==
X-Gm-Message-State: AJIora89XdCFHQtfffxtyBS1fVL1VIRBpThaW2txWiWbA1mbbRrBE7WV
 hfp2zDd8MNEu9pQy2sRgCZJg7K0=
X-Google-Smtp-Source: AGRyM1vb/Yi2b2pTwi2g5I/3Hlh4uoo9GpjHqEw45DCSCLbRf0voZ3dJDwnDwSNXa64ME/af5qHvig==
X-Received: by 2002:a05:620a:4403:b0:6b5:e1ad:75a7 with SMTP id
 v3-20020a05620a440300b006b5e1ad75a7mr725045qkp.177.1658509958037; 
 Fri, 22 Jul 2022 10:12:38 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 s13-20020a05622a178d00b003172da668desm3528305qtk.50.2022.07.22.10.12.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Jul 2022 10:12:37 -0700 (PDT)
Date: Fri, 22 Jul 2022 13:12:36 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YtrahFs5wgweeB7f@redhat.com>
References: <20220722093823.4158756-1-nhuck@google.com>
 <YtrTI/CJMoLihA/1@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YtrTI/CJMoLihA/1@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 0/3] dm-verity: optionally use tasklets in
 dm-verity
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
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, Nathan Huckleberry <nhuck@google.com>,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 22 2022 at 12:41P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> We've been tying to kill off task lets for about 15 years.  I don't
> think adding new users will make you a whole lot of friends..

I don't have perspective on how serious that effort is. But ~2 years
ago DM introduced another consumer of tasklets in dm-crypt, see:
39d42fa96ba1 dm crypt: add flags to optionally bypass kcryptd workqueues

Given that, and other numerous users, is the effort to remove tasklets
valid? What is the alternative to tasklets?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

