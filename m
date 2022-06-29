Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FFC5C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656530495;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/ie3AMHBKzDSS/W6yEyY+uGjPLqIkPGRMwJ5Zbz0vjo=;
	b=QvEBR2svWo1ljlmQTPqoDZA+m+wrkNhqkvyW3KTGhVQRTqTb8BRKueyf4hW5YDLzplB4pC
	lE0XJ5+kYexxfxL4IMVQCzqxOSa9uU3Lc3koprHJEARKCXTjO5WqBhWCoZKueoH27GvXVK
	teXIkyuV1n086AI7K3rRexRmGB6VvGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-BPW0EzpiN4CYZVcaNBQoRw-1; Wed, 29 Jun 2022 15:21:31 -0400
X-MC-Unique: BPW0EzpiN4CYZVcaNBQoRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 320A781D9E7;
	Wed, 29 Jun 2022 19:21:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A2B0240D0160;
	Wed, 29 Jun 2022 19:21:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 515BC194705D;
	Wed, 29 Jun 2022 19:21:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32C3C1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 18:51:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8B1A414A7E9; Wed, 29 Jun 2022 18:51:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4412414A7E7
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 18:51:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC8A929AA3B4
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 18:51:36 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-woq90X6EN8qkhkW80Z8JdQ-1; Wed, 29 Jun 2022 14:51:30 -0400
X-MC-Unique: woq90X6EN8qkhkW80Z8JdQ-1
Received: by mail-pg1-f182.google.com with SMTP id 23so16144273pgc.8;
 Wed, 29 Jun 2022 11:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:from
 :subject:to:cc:references:content-language:in-reply-to
 :content-transfer-encoding;
 bh=T+oozTQlQ42ccub3rMo4I+T7tGXFbD0SrcDYsujPpEE=;
 b=BQoEB4UhCNwRhxCoazFG7ktlMehDlrObnEoDy/Kz69yOdBeVL1BuyRLxBT1y2FcRYt
 gjjmsbBmdPAe1BvUDgDDT7Plhm3QtCf+H+xL8B8N5Di/+PmCY+8Rw3yeQ8Ulbn+KlFyq
 Y1SDmD9W6CG0AvrBdrgaES/5IevAz2xBrD/wYEDg1RnIZqJS81xlKUVjvD4LCUXJiZR0
 xWd3x3AR/3Ghmf92tOZP1R66I8r7r+X2aVxIBQTIUfCaaaDBqiNoKafkrNdbHoKFH8IW
 c/UtInXwCnl1TzFczy3FPIPUiDVU1pa+t1CI7e8hqAfzdUYG3pBdykGik6lr3rBCESs0
 L+0g==
X-Gm-Message-State: AJIora8ZToue8EDCILuZGbq3HucujLpDzjjzggjF65xxTkhLzE7rAl1O
 srQig3SeRp4m/GpFih5nhaJvwiCGl3c=
X-Google-Smtp-Source: AGRyM1tezh0Yi6yXeVRNuhvBo6IeNw8LHBMmcTK9z18nYaQP+iUSik7xJLRjTMluK1bxx7HBGbBvRA==
X-Received: by 2002:a05:6a00:23d2:b0:525:951a:edf1 with SMTP id
 g18-20020a056a0023d200b00525951aedf1mr11598228pfc.62.1656528689342; 
 Wed, 29 Jun 2022 11:51:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e57f:78b4:1672:b207?
 ([2620:15c:211:201:e57f:78b4:1672:b207])
 by smtp.gmail.com with ESMTPSA id
 q15-20020a17090311cf00b0016a61e965f0sm4151865plh.280.2022.06.29.11.51.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Jun 2022 11:51:28 -0700 (PDT)
Message-ID: <486ec9e2-d34d-abd5-8667-f58a07f5efad@acm.org>
Date: Wed, 29 Jun 2022 11:51:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Bart Van Assche <bvanassche@acm.org>
To: Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan> <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
 <20220629184001.b66bt4jnppjquzia@moria.home.lan>
In-Reply-To: <20220629184001.b66bt4jnppjquzia@moria.home.lan>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/29/22 11:40, Kent Overstreet wrote:
> But Jens, to be blunt - I know we have different priorities in the way we write code.

Please stay professional in your communication and focus on the 
technical issues instead of on the people involved.

BTW, I remember that some time ago I bisected a kernel bug to one of 
your commits and that you refused to fix the bug introduced by that 
commit. I had to spend my time on root-causing it and sending a fix 
upstream.

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

