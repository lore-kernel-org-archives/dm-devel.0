Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1584C6FD1C
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679687183;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FjzT20XhLKKt5kWOU1VEMBSOScXL43xakpCT/UcVaAE=;
	b=VNP3TTnEZHeSHlecCD8YpaKQTSN++/HqCOz2ggJNDjk8Z+9h3MouoBMFxHGrvA+1HbdZvJ
	n8+e6qKcf0j/39jhi4bbyKen5374fWQEnW0QyyT2T/QsHuthd3w5WUxorNNyGHClX1aAff
	48lGnGsQkfk5mTh13uuGlYEeG6nDMYo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-kvFa5hADN1O0RsC4-Mwovg-1; Fri, 24 Mar 2023 15:46:22 -0400
X-MC-Unique: kvFa5hADN1O0RsC4-Mwovg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FDB885C069;
	Fri, 24 Mar 2023 19:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CA09C15BA0;
	Fri, 24 Mar 2023 19:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65A571946A5E;
	Fri, 24 Mar 2023 19:46:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC80F1946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 19:46:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ADA3F492B0B; Fri, 24 Mar 2023 19:46:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5696492B0A
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:46:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 872D83C0F245
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:46:19 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-nLo-2ACeM_KPdA13IByF8g-1; Fri, 24 Mar 2023 15:46:17 -0400
X-MC-Unique: nLo-2ACeM_KPdA13IByF8g-1
Received: by mail-pl1-f169.google.com with SMTP id kq3so2784229plb.13
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 12:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679687177;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=J7dxhXOhPm1rjnBhX708y4lq+UW0mc9qQ6mqHHtCoG4=;
 b=t8ID9X4uqD/5+STmRIWJRf38TB/oWpHxNpjqbm3BKEKVvWl+Tj2EO6YC1HPH/pswLN
 xkHav5lAr54gsREowFhZ6VLY/jj6Cg/vlUkN0dcQHvBvaoVhE6v+nT3TSVjJ3AAC5DEa
 vv1DPv4HNeYNmjWBY1Oo/eUqcSguIU5FQzDP+XMOd0PmobL1ywVUGGJs+5OMao5hVZMQ
 JMIaROSTl2F3DpY5sM/ti6Ps5LyYUtHkcxKGmqBM4mrgszI+xJXGThEJ5cJB2f2QHBUD
 vl/ZXJPy1X8VNEFeKjVLnNjwthnRQqr4DVVnqVI14xyWfZGjq/QAhGqVzsUet03yKVlJ
 VX4A==
X-Gm-Message-State: AAQBX9d6KX2dq1bXFf4qlJyptPziPkEoKfR4kKYeJ0m4821kMurp3Vvb
 avYHWf3PDG1FKiJNYHcelHc=
X-Google-Smtp-Source: AKy350YIsFGcV01ac5EKq37TJfDpDKKDtii9V8hYor/rYLrdjT6fks/kkJW+tmPAJbXZUh9YIxzmkQ==
X-Received: by 2002:a17:902:fb4e:b0:1a1:cd76:7880 with SMTP id
 lf14-20020a170902fb4e00b001a1cd767880mr3549674plb.15.1679687176657; 
 Fri, 24 Mar 2023 12:46:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:386d:2249:7df8:ecf?
 ([2620:15c:211:201:386d:2249:7df8:ecf])
 by smtp.gmail.com with ESMTPSA id
 d9-20020a170902854900b0019c61616f82sm14572264plo.230.2023.03.24.12.46.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Mar 2023 12:46:16 -0700 (PDT)
Message-ID: <901b8d9d-dc20-f409-7dd4-000db8b03259@acm.org>
Date: Fri, 24 Mar 2023 12:46:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
To: Mike Christie <michael.christie@oracle.com>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-3-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-3-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v5 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: Stefan Haberland <sth@linux.ibm.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/24/23 11:17, Mike Christie wrote:
> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts and DASD's
> locking feature which works similar to NVMe/SCSI reservations where a
> host can get a lock on a device and when the lock is taken it will get
> failures.
> 
> This patch renames BLK_STS_NEXUS so it better reflects this type of
> use.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

