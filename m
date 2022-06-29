Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA40CCA47E
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574290;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H9jM5gq+oXdIdw+dmsIraNgOjw/WW4/GkgChw4JIURc=;
	b=NRjzXOgzMiZpSVATZpiP/hVu4xWDUtIJXIWSZMqv6iftt+OseX2Dae0UkW0pByEtE1kvo/
	0sJMbsMl06MNILenQv4rLYxJdw22t3vGn5qXKTaIfNH7X42EK8vgrDBhEZJaaOPjDavb8M
	VxW5N1NSCvUlts91WmjGA0ifqVNMDtA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-CAh8gGoTPwWT5Z5HM1hNNA-1; Thu, 30 Jun 2022 03:31:27 -0400
X-MC-Unique: CAh8gGoTPwWT5Z5HM1hNNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A9062919ECF;
	Thu, 30 Jun 2022 07:31:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 480491415108;
	Thu, 30 Jun 2022 07:31:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 62FF81947070;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D7AE81947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 19:05:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C64B940334D; Wed, 29 Jun 2022 19:05:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C21AC40336E
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:05:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A91DF3C0E218
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:05:44 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-__WVWlNIOc-8HPrxLBfbsQ-1; Wed, 29 Jun 2022 15:05:42 -0400
X-MC-Unique: __WVWlNIOc-8HPrxLBfbsQ-1
Received: by mail-qk1-f175.google.com with SMTP id z12so12788532qki.3;
 Wed, 29 Jun 2022 12:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+/ROI7j6XCNaDwyMGvVc2IaTPuaglS7jy5/jfdxPf9U=;
 b=zAALsMBLlyN2zsBE2pQ7sNW9O4e6xKhnhMNk2xuTpjYRtet/JDuOCKNYSCWchv0vu9
 MicZBZ4qOXL3ZAwcI0ys4NLFBJiCMzB+YWd0PX+zM3XdlkXdLE3PwflZDRhdNQv5NXE/
 xuzgtXHJUontRRKU6/aQE6Z32iyBcb+kMUAux4R9rxVFYQbtIFwMJ4T/qA766ljJWOe0
 jRGJGS4RAg+z1TmUJEWgd495oH8l736HgzcOvgAY7ppOhyjVYPmoRJjro+37i9+TyK7/
 /+i0kSKvS9FtNxJz2GuUY1oB+UD1nyztnSCUDRMb/vAOs7bC93WjxTRFIdF4xmS3XqLI
 oVnA==
X-Gm-Message-State: AJIora8dIgN5Qcxgv8HvBX8mhbNcAg6qzChPUNNKLVNwFiMEx+ZFtl61
 pwZ2UW2j8Ym4e5x+KuGteywOZ5kx/NXW34g=
X-Google-Smtp-Source: AGRyM1tVeCJUGS2aol+VvZfxynL1eHutTl8RCZi/SI3TvJoy/Vatp2e3ezxQ0Pclb5eXY/ZcZ+EfKw==
X-Received: by 2002:ae9:f718:0:b0:6af:5c0:6cdf with SMTP id
 s24-20020ae9f718000000b006af05c06cdfmr3381385qkg.426.1656529541996; 
 Wed, 29 Jun 2022 12:05:41 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 g19-20020ac87d13000000b00307aed25fc7sm11799668qtb.31.2022.06.29.12.05.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 12:05:41 -0700 (PDT)
Date: Wed, 29 Jun 2022 15:05:40 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20220629190540.fwspv66a4byzqxmg@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
 <20220629184001.b66bt4jnppjquzia@moria.home.lan>
 <486ec9e2-d34d-abd5-8667-f58a07f5efad@acm.org>
MIME-Version: 1.0
In-Reply-To: <486ec9e2-d34d-abd5-8667-f58a07f5efad@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 11:51:27AM -0700, Bart Van Assche wrote:
> On 6/29/22 11:40, Kent Overstreet wrote:
> > But Jens, to be blunt - I know we have different priorities in the way we write code.
> 
> Please stay professional in your communication and focus on the technical
> issues instead of on the people involved.
> 
> BTW, I remember that some time ago I bisected a kernel bug to one of your
> commits and that you refused to fix the bug introduced by that commit. I had
> to spend my time on root-causing it and sending a fix upstream.

I'd be genuinely appreciative if you'd refresh my memory on what it was. Because
yeah, if I did that that was my fuckup and I want to learn from my mistakes.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

