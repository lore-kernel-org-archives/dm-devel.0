Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BC4C19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660073492;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yFpcobgimi4BceRseDebbSMakEjhVBL8nXySgPXwBq8=;
	b=gG5Q3TxQEBPVE+QGi5oOmQHS4Icyw/IOBK9gbte7tSNzy/43/aBV27smmXSFYQgLxpdFSc
	PJIl68kyrXg7JOAkVhjPmq7yH8ksIv9kWn9WdkwO6cOP+hxNLs1DwOxb0BzIpjHFitp1Wg
	TimCfkWF3wplfKfibPE5jn5SKlFjR8I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-mKGdAjM7MvOpMwjYWwSHDA-1; Tue, 09 Aug 2022 15:31:29 -0400
X-MC-Unique: mKGdAjM7MvOpMwjYWwSHDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F17A19705B1;
	Tue,  9 Aug 2022 19:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16FB41121315;
	Tue,  9 Aug 2022 19:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C46AA1946A4C;
	Tue,  9 Aug 2022 19:31:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F08BA1946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 19:31:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D21AD9457F; Tue,  9 Aug 2022 19:31:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CEA5F9459C
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 19:31:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD35E19705B3
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 19:31:24 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-EPeUa9VWNgW66JQbS-HEQA-1; Tue, 09 Aug 2022 15:31:23 -0400
X-MC-Unique: EPeUa9VWNgW66JQbS-HEQA-1
Received: by mail-pl1-f171.google.com with SMTP id g13so5315410plo.6
 for <dm-devel@redhat.com>; Tue, 09 Aug 2022 12:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=tEEBECMt2JMCyk8XPkBX4uFGE3X1j9GMANI0TyJE5wc=;
 b=Kza0OUA6NR0ex+Eeo/dgR7pD98aIA3FFgB9GYlr3X+gCS9+v52FsurmsJRZb0g7svq
 w3RA5lqbFezwdcx4Jw+pyi7tr4t5mgIZ9yp423l8H4gCX2rpkAQ0+/ojvb4EtKPKlD98
 XD44OWfRxCy2MSmIygiHVQz8QTLj+zxylhoAJnXFaNXDw4ne87UZJl9i/b/A3cCW5bvt
 Ddu/xjGMR35cqQ1oi36JtM4XxVz7c5jAENyOulvh8AnTPGg5xkfKyDYfMG84Ke9pzRxP
 90x4W0u+NALxlIgmcB3EKBjcSQom7hUCPgof0X/I3Rn5uX+DmNiD+xNN42DCc1xHMQMN
 4PsQ==
X-Gm-Message-State: ACgBeo1HQpD65yuTQdFrUGtv5P+vVqzbTk0TQsT4ZDNHFPKzfyW8I91V
 KB0/iwyyPLGhsQTd8V7ECl0=
X-Google-Smtp-Source: AA6agR5ZL0koW3EeIcBB5kMJj6MK9Gs4GzdlJ/nY6Ucb+iCE6MSghHnDdd0Y6rdswP+L8s03kMtJug==
X-Received: by 2002:a17:902:e5cc:b0:16f:1153:c519 with SMTP id
 u12-20020a170902e5cc00b0016f1153c519mr24584729plf.151.1660073481696; 
 Tue, 09 Aug 2022 12:31:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d?
 ([2620:15c:211:201:61e9:2f41:c2d4:73d])
 by smtp.gmail.com with ESMTPSA id
 np15-20020a17090b4c4f00b001f31d6fe0f3sm13133214pjb.57.2022.08.09.12.31.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Aug 2022 12:31:20 -0700 (PDT)
Message-ID: <c6e96f39-69e0-b1f3-93c5-b9912e2af270@acm.org>
Date: Tue, 9 Aug 2022 12:31:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Christie <michael.christie@oracle.com>, Christoph Hellwig <hch@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-15-michael.christie@oracle.com>
 <20220809071632.GA11161@lst.de>
 <bf55356d-24fe-7a8e-c766-cdf33e7304c2@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bf55356d-24fe-7a8e-c766-cdf33e7304c2@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 14/20] scsi: Retry pr_ops commands if a UA
 is returned.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/9/22 09:24, Mike Christie wrote:
> On 8/9/22 2:16 AM, Christoph Hellwig wrote:
>> On Mon, Aug 08, 2022 at 07:04:13PM -0500, Mike Christie wrote:
>>> It's common to get a UA when doing PR commands. It could be due to a
>>> target restarting, transport level relogin or other PR commands like a
>>> release causing it. The upper layers don't get the sense and in some cases
>>> have no idea if it's a SCSI device, so this has the sd layer retry.
>>
>> This seems like another case for the generic in-kernel passthrugh
>> command retry discussed in the other thread.
> 
> It is.

Has it been considered to introduce a flag that makes scsi_noretry_cmd() 
retry passthrough commands?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

