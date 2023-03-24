Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AEAAC6FD20
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679687121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8pK2ZejypAA+x+jqVpl4HeW9TFVw3fQEy1A/vugrfxU=;
	b=BX18gaXHG2wojzR2/tTLKNCja4slWWnsFzUTKYBK1B29/ev5+4jPR0OV/SBpqBHp07dD4B
	RaVC0JZOdBQdZzfB7wqo9jo5fTfxnUEA0yv73aGfnUi8Rx2BI++X80SXwEQGOq1hrrVboJ
	0XeoJbSgHYKdMJ4dZi8m7RBwsj/EeBI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-bnpqJAxeMVO4OoKXT-_RBw-1; Fri, 24 Mar 2023 15:45:17 -0400
X-MC-Unique: bnpqJAxeMVO4OoKXT-_RBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECDFF3C0F248;
	Fri, 24 Mar 2023 19:45:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 428B740C83AC;
	Fri, 24 Mar 2023 19:45:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 112751946A5E;
	Fri, 24 Mar 2023 19:45:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9CDC61946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 19:45:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80B6F40CF916; Fri, 24 Mar 2023 19:45:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7893B40CE2D4
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:45:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DE803C0F245
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:45:13 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-n12XTqJEMwivYTy4_xCHkQ-1; Fri, 24 Mar 2023 15:45:11 -0400
X-MC-Unique: n12XTqJEMwivYTy4_xCHkQ-1
Received: by mail-pj1-f44.google.com with SMTP id
 fy10-20020a17090b020a00b0023b4bcf0727so2686264pjb.0
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 12:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679687110;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=mzEyCZHLH4Zfj5DYk4naroNB2YGbHeAPk3MJAB81cn0=;
 b=VkwhwiRYHsVL6GuXUJsuKp1r9sXM/8gFQYYBde/dAYYnqkVc+YWsxj2Px81CKkdfAu
 iRg/QTNj1NWZWKgOsCxeQTyz2dgoPRo5VW9W1ya1i6W/ciqwzu+SHtQL3JNlEIM4giH2
 C1RwXkhk7smfjqZ2nYKTj7DkS1Hkmv2BN/B/z1gx0ZueiE9fuOG62VL/EJZb4T0tE03v
 IG8xWWwCLUoQMOZtReJFrtsS3hmJeKX2fR8DXaJ3cAG81yutkGNvWh2a+6AGdwY8gOVb
 f764u0JiPx59xIl72cNEsRZ8JGYN0vqnHw4gm1FftPrd+VuL2fM9gjkLDM2iKXE4LJRx
 NlAg==
X-Gm-Message-State: AO0yUKXvErDYoWCAJmbYMj3VJOmdOZEzzsno6R3xQc6mEQu1HiLikxQx
 E2XTqU/ELd0Spgw5VhL5Z/k=
X-Google-Smtp-Source: AK7set+WBcQsEOXCQ/txqOh9eErFNTaYEWF2xegD7KrWmJzmFiNv92WvD5FLTUar7NcICYJm6jYnKg==
X-Received: by 2002:a05:6a20:7a98:b0:cc:868f:37b3 with SMTP id
 u24-20020a056a207a9800b000cc868f37b3mr3618846pzh.58.1679687110519; 
 Fri, 24 Mar 2023 12:45:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:386d:2249:7df8:ecf?
 ([2620:15c:211:201:386d:2249:7df8:ecf])
 by smtp.gmail.com with ESMTPSA id
 a14-20020a62e20e000000b00625d84a0194sm14306035pfi.107.2023.03.24.12.45.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Mar 2023 12:45:09 -0700 (PDT)
Message-ID: <0dfa3352-cdca-90c1-a6c9-ea4a4c85dfa1@acm.org>
Date: Fri, 24 Mar 2023 12:45:07 -0700
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
 <20230324181741.13908-2-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-2-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v5 01/18] block: Add PR callouts for read
 keys and reservation
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/24/23 11:17, Mike Christie wrote:
> Add callouts for reading keys and reservations. This allows LIO to support
> the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
> to optimize it's error handling so it can check if it's getting an error
> because there's an existing reservation or if we need to retry different
> paths.
> 
> Note: This only initially adds the struct definitions in the kernel as I'm
> not sure if we wanted to export the interface to userspace yet. read_keys
> and read_reservation are exactly what dm-multipath and LIO need, but for a
> userspace interface we may want something like SCSI's READ_FULL_STATUS and
> NVMe's report reservation commands. Those are overkill for dm/LIO and
> READ_FULL_STATUS is sometimes broken for SCSI devices.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

