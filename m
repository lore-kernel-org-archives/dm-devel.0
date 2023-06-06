Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4121C77B73
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686068030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9hJKALK4MClNB/A2bmnEq5x7K5W+hF7d0g6AnFCM1Fs=;
	b=AhJLsyBOdcbWUndZUplgCCK8rKOyGyv7sOS1IoMy9r4k8uLoEqVHiNg47ooW0/uVY90W9h
	z/k8HKD8gvL68815s4XcynDF12Zp8CqwJLNxGt/6ubOTwwdwDVo+AdOoUUtcy3EjwKpFeb
	N3ZJsBbNsUihiq1KZ3IvXGkCMXlshTc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-LPqQsQklMgKdHRYEnqEbyw-1; Tue, 06 Jun 2023 12:13:47 -0400
X-MC-Unique: LPqQsQklMgKdHRYEnqEbyw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65ADF2A2AD50;
	Tue,  6 Jun 2023 16:13:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55DE71121314;
	Tue,  6 Jun 2023 16:13:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2585D19465BC;
	Tue,  6 Jun 2023 16:13:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D4D619465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 16:13:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBFFB1121315; Tue,  6 Jun 2023 16:13:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4B4C1121314
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:13:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C63D03C0F22D
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:13:43 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-4sLj8wNVO8W27-CXkeDKyg-1; Tue, 06 Jun 2023 12:13:42 -0400
X-MC-Unique: 4sLj8wNVO8W27-CXkeDKyg-1
Received: by mail-qv1-f41.google.com with SMTP id
 6a1803df08f44-626149fbc8eso62394396d6.3
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 09:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686068021; x=1688660021;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=pvoMJuSZUTE86J2NoS1R2Wk8beN5EcZS9dtT2PpXBBE=;
 b=Gt5zMv9rtdq4TKYHblkBTx5wFdbWLWofX/X/37qz5RlaO8PQj7a6wXpvJMrdvqTbeh
 NjCvY94jyEeyDhxgYxiOSPPk0ybOoenCwsjY7e3kEB8l4t1Rac5ASBL+uNTwMwvS7O/s
 KSiVVAduEGavqdDPZSm3cvKbcxmCrbqh+M2KN1hc68zAOixRxNYHJOYBjKbgjOPmKbqP
 UnVCp1r9ndtLIycv6MowVz+Lb1hJUd68d8BNafSn40JMMAZPYYeR+YPEQRGBcPgIDVkE
 iKZ8hJ2/l2C9wjNhsNtzlDpVVAtluGwkk6ggXo8fOJgO/BNuPVYhTooJyhFAOf8nyifg
 9CLw==
X-Gm-Message-State: AC+VfDwMzjYVXaL6tyGLYjOAuB+0e8hKV0gu/Egi2IUBmIErELIqEGLg
 7pE1fywhSxWW9wjlHra9gWJAUC0=
X-Google-Smtp-Source: ACHHUZ5qzOXOek98pMB0JPWvzatF/yDipaVz04OAtt6PZwHKRW9nr0BfKhp8DQ35Rjx+AlLCeBpRGg==
X-Received: by 2002:a05:6214:2263:b0:625:aa49:9abc with SMTP id
 gs3-20020a056214226300b00625aa499abcmr2762701qvb.64.1686068020628; 
 Tue, 06 Jun 2023 09:13:40 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 cc21-20020a05622a411500b003f6b32a1049sm3021766qtb.55.2023.06.06.09.13.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 09:13:40 -0700 (PDT)
Date: Tue, 6 Jun 2023 12:13:39 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZH9bMx10optlZZlf@redhat.com>
References: <20230601072829.1258286-1-hch@lst.de>
 <20230601072829.1258286-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230601072829.1258286-4-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 3/3] block: fail writes to read-only devices
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 01 2023 at  3:28P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Currently callers can happily submit writes to block devices that are
> marked read-only, including to drivers that don't even support writes
> and will crash when fed such bios.
> 
> While bio submitter should check for read-only devices, that's not a
> very robust way of dealing with this.
> 
> Note that the last attempt to do this got reverted by Linus in commit
> a32e236eb93e ("Partially revert "block: fail op_is_write() requests to
> read-only partitions") because device mapper relyied on not enforcing
> the read-only state when used together with older lvm-tools.
> 
> The lvm side got fixed in:
> 
>     https://sourceware.org/git/?p=lvm2.git;a=commit;h=a6fdb9d9d70f51c49ad11a87ab4243344e6701a3
> 
> but if people still have older lvm2 tools in use we probably need
> to find a workaround for this in device mapper rather than lacking
> the core block layer checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

