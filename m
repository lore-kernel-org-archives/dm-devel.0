Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D4E6C63797
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673044628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zyO/WNgUSye+3bZHFDJanjclOW1JemObXEmzEDZ00hk=;
	b=QWLPZm9z8oWmJs34aUkY6q2AQYmKOTk8AU/FLjhhV2/WSAExgPdjAwRKDdt7gEQtV7BcW2
	FWDoJSDVUeDXONSZ/g+PsFCS8b78zptsa+69rToy2FYtBmX1lteIq2UW7X1lBEeVhUDk9p
	IVO2A9JNk7OIg4Fqb8QkO1oJl+1SRhQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-rMa3noGWNfeJ9P-bN_15cw-1; Fri, 06 Jan 2023 17:37:05 -0500
X-MC-Unique: rMa3noGWNfeJ9P-bN_15cw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D46E3C38FF5;
	Fri,  6 Jan 2023 22:37:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B266492B06;
	Fri,  6 Jan 2023 22:37:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1674C194707F;
	Fri,  6 Jan 2023 22:37:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E77281946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 22:37:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B225F7AE5; Fri,  6 Jan 2023 22:37:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA2F151FF
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 22:37:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89ED33C38FF6
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 22:37:00 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-343-ymwS9tW7MGed6rk4qrfORg-1; Fri, 06 Jan 2023 17:36:58 -0500
X-MC-Unique: ymwS9tW7MGed6rk4qrfORg-1
Received: by mail-pj1-f54.google.com with SMTP id
 m7-20020a17090a730700b00225ebb9cd01so6680694pjk.3
 for <dm-devel@redhat.com>; Fri, 06 Jan 2023 14:36:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=2ta2lEkN5kGxTKM6DO1j7OMg4sGm8eJ8eSltnioRMtI=;
 b=niLfT68XR4SmKpORj4XlzZHxB6P/+9YA03sUtdKvdGxhhQ0PAXejeIuxlci7UvsNWa
 Whalo+RyflNSCPGmz+c1HGTlc6ZaY6tSGOv4Ijevd9UGnzmM6s30Em/6ypU6mz6SHn6v
 v97k1f1EN3KRnW+nZV3vOv2niU4onPeAjaFifLE8kw5KLleIs5Nglp5zyMiWbCWd7Ysi
 y4QLc8RD7X0pf3zvzEsXBmqceyOimeeRp/4oljPapDRzaCeDBVa0bCh/quqxJvApz17S
 +OT0Th5mfLVoS5BG0B7gC+QNFIRaTVJ5VHfFh8tfOPKxZFQJC+xUWbjW8k0Ay7wbmU7k
 zQaA==
X-Gm-Message-State: AFqh2kqMkT4v96U697+cIb83INqaKJ/a3s5Hxe1JFBsUMT3SQoufVDAe
 ID/ihZOME9kck+cwMuDVPkw=
X-Google-Smtp-Source: AMrXdXvx9hEsKsGVd1MGjXgFFib0cGo/BvdB3EmgdQG2Q+U3IMxgohrZP/fJyOzM+mjRgn5vTXWY8g==
X-Received: by 2002:a17:902:ab8d:b0:192:f45d:92b9 with SMTP id
 f13-20020a170902ab8d00b00192f45d92b9mr8998981plr.29.1673044617680; 
 Fri, 06 Jan 2023 14:36:57 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:23c3:f25b:a19d:c75a?
 ([2620:15c:211:201:23c3:f25b:a19d:c75a])
 by smtp.gmail.com with ESMTPSA id
 q18-20020a170902bd9200b00186b7443082sm1384960pls.195.2023.01.06.14.36.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Jan 2023 14:36:57 -0800 (PST)
Message-ID: <271c3316-e464-9dc6-f703-26a5986a00de@acm.org>
Date: Fri, 6 Jan 2023 14:36:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f@eucas1p1.samsung.com>
 <20230106083317.93938-3-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230106083317.93938-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 2/7] block: add a new helper
 bdev_{is_zone_start, offset_from_zone_start}
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
Cc: gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/6/23 00:33, Pankaj Raghav wrote:
> +static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
> +						   sector_t sec)
> +{
> +	if (!bdev_is_zoned(bdev))
> +		return 0;
> +
> +	return sec & (bdev_zone_sectors(bdev) - 1);
> +}
> +
> +static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
> +{
> +	if (!bdev_is_zoned(bdev))
> +		return false;
> +
> +	return bdev_offset_from_zone_start(bdev, sec) == 0;
> +}

A nit: 'sector_t sector' is much more common in the block layer than 
'sector_t sec'. Please consider changing 'sec' into 'sector'.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

