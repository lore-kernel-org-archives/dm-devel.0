Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86AAC352A1
	for <dm-devel@archiver.kernel.org>; Tue,  6 Dec 2022 18:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670352253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SbSEwpWFbyS6Jxg3Dg32Zn7COwTl4ZelDDQ6uZeqoW4=;
	b=QfTMv1fabFvtILTTeanDmwbrStSkz1ICptfz9HcphprpB4Hqo8jsMXoHq2xkQ7pvWZaUyh
	B4B/Yk/BnIJIDwoquEetrVG6WRDTWugyBvp9rXc7R++9Ypt5IYKI/A6L8CTMMBUAQ64vN+
	H1PFiB0sFnu6movQlUSegM3xnGVFLt4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-w5lbN990OZajFnbC1WBaGg-1; Tue, 06 Dec 2022 13:44:12 -0500
X-MC-Unique: w5lbN990OZajFnbC1WBaGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E36786C143;
	Tue,  6 Dec 2022 18:44:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7009740C6EC2;
	Tue,  6 Dec 2022 18:44:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E23E19465A0;
	Tue,  6 Dec 2022 18:44:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 868291946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 18:43:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A3421492B05; Tue,  6 Dec 2022 18:43:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B112492B04
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:43:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FA9D811E67
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:43:58 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-72BF-RLoOG2zw2yeq86Xfw-1; Tue, 06 Dec 2022 13:43:56 -0500
X-MC-Unique: 72BF-RLoOG2zw2yeq86Xfw-1
Received: by mail-pl1-f175.google.com with SMTP id s7so14801289plk.5;
 Tue, 06 Dec 2022 10:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=kkdpynN3ZZxXXoC+/B2qsqOUkzGgxT1EtXnN9c8yuhc=;
 b=3kU5EiyVwDcE6q/CJN6bRQlQfi62II+YQGs2Bp70I4PAxlkPGn34Q5EddZhCpAWxWR
 RP14+3BE7VYEdLUEEaxiQFHplC0jPW4xthO+Zgpz2fPlZwCthlL/I/MiOnzXAYj4V7rV
 6unEvil9VuRhqiTpurhGud7Di1YlGgGMY3Fa82XDqkRNWoB5h6IvqwU74KL0wbh5tZ9m
 r0svnTKHQ5sjzjSak4AzSn5Ce2akQ8Ik6NETe3EbkqAt1b26WLAtc19DMFxV205C2lWq
 GgbBRcHtxpGt52ZYYnS7/ULbA/+bjDJLd0WBp/fVJIyBBe9+2pAnWulFrUwKcqmMeOBa
 P/Uw==
X-Gm-Message-State: ANoB5plewfb1M2htb4nYQWYQJv8geg5FCHDQBl3stnSEMDWypDqolT9T
 nTNpLcpRBLdEQ76Z53HHItI=
X-Google-Smtp-Source: AA0mqf7j+ouvNKByY6CjriE3yqeB9gzC2l06X8kaUAU+HcxR8ONUrkX2oxkDdJixvxaJgsfMp5zJAA==
X-Received: by 2002:a17:90a:bd96:b0:219:3553:4ff5 with SMTP id
 z22-20020a17090abd9600b0021935534ff5mr45767962pjr.22.1670352235149; 
 Tue, 06 Dec 2022 10:43:55 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6220:45e1:53d2:e1cb?
 ([2620:15c:211:201:6220:45e1:53d2:e1cb])
 by smtp.gmail.com with ESMTPSA id
 a1-20020a63cd41000000b0045dc85c4a5fsm10068334pgj.44.2022.12.06.10.43.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 06 Dec 2022 10:43:54 -0800 (PST)
Message-ID: <1d1c946d-2739-6347-f453-8ccf92c6a0cc@acm.org>
Date: Tue, 6 Dec 2022 10:43:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
To: Alvaro Karsz <alvaro.karsz@solid-run.com>,
 virtualization@lists.linux-foundation.org
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/5/22 08:20, Alvaro Karsz wrote:
> +/* Get lifetime information struct for each request */
> +struct virtio_blk_lifetime {
> +	/*
> +	 * specifies the percentage of reserved blocks that are consumed.
> +	 * optional values following virtio spec:
> +	 * 0 - undefined
> +	 * 1 - normal, < 80% of reserved blocks are consumed
> +	 * 2 - warning, 80% of reserved blocks are consumed
> +	 * 3 - urgent, 90% of reserved blocks are consumed
> +	 */
> +	__le16 pre_eol_info;
> +	/*
> +	 * this field refers to wear of SLC cells and is provided in increments of 10used,
> +	 * and so on, thru to 11 meaning estimated lifetime exceeded. All values above 11
> +	 * are reserved
> +	 */
> +	__le16 device_lifetime_est_typ_a;
> +	/*
> +	 * this field refers to wear of MLC cells and is provided with the same semantics as
> +	 * device_lifetime_est_typ_a
> +	 */
> +	__le16 device_lifetime_est_typ_b;
> +};

Why does the above data structure only refer to SLC and MLC but not to
TLC or QLC?

How will this data structure be extended without having to introduce a
new ioctl?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

