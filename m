Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A313EC43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 20:18:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-uTb4aPAqMS2yNQk_6pYljw-1; Wed, 15 Jun 2022 16:18:43 -0400
X-MC-Unique: uTb4aPAqMS2yNQk_6pYljw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 542273C1022C;
	Wed, 15 Jun 2022 20:18:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F5A34011A3E;
	Wed, 15 Jun 2022 20:18:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E31E1947040;
	Wed, 15 Jun 2022 20:18:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A79791947040
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 20:18:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 898A8492CA6; Wed, 15 Jun 2022 20:18:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85DD3492CA5
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:18:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E59485A582
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:18:37 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-pNSA_KKgPCmEQiTd3HvY4Q-1; Wed, 15 Jun 2022 16:18:35 -0400
X-MC-Unique: pNSA_KKgPCmEQiTd3HvY4Q-1
Received: by mail-pj1-f52.google.com with SMTP id
 k5-20020a17090a404500b001e8875e6242so3040763pjg.5; 
 Wed, 15 Jun 2022 13:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=SNU2ULTl0ChHoBmMMoN7qtu5qLqYyEFI2kUe8MWmWMo=;
 b=3HClbDyNzRJoKlDTGI501yxJly0rMXC1fUxoe55V5keHQwzNXaNOWdT3MP/5/mt3SA
 IcKbHOSJzK50IIPnfQgqb/AzrHa8lw7eZgHMKS7nch3s9KZO71xiuA4LW8VcmWQ4wnq8
 DeQ8r23kExAzlVSjWeoicUqDJrbCN9BPhK265+64w4KBbJ2AAgaistk9QIJdiiy3vmKt
 K5FMmJk2W6BDqhE/Q0VtDK7MutKX+abAHpZ8+XbTDAr1coZROE5gNZo6TCI+K5tnK/Bz
 Pmc5BA1tjjecmopoNGFjROr0bwynAZPe9xJvAf4FfVEWVM9sFN+2yFyGUNK4PN2OjZqz
 o2RQ==
X-Gm-Message-State: AJIora91jZ0d2NBCUu8ZUL2zZjz7Rq4DYK2uMstq0oMqL2xY+j7vB3FN
 9JQSDIH272Ua1lesnljRXpU=
X-Google-Smtp-Source: AGRyM1s3xzzOdnqeKw+fkjDbJVScgIu0tZCo++/2yYCKrn2XJapgnfJfEXIAyvKCytnUw+BXN2cYHQ==
X-Received: by 2002:a17:902:9a97:b0:168:a97e:2457 with SMTP id
 w23-20020a1709029a9700b00168a97e2457mr1297905plp.33.1655324314284; 
 Wed, 15 Jun 2022 13:18:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:36ac:cabd:84b2:80f6?
 ([2620:15c:211:201:36ac:cabd:84b2:80f6])
 by smtp.gmail.com with ESMTPSA id
 b9-20020a170902d88900b001663185e654sm8464plz.280.2022.06.15.13.18.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Jun 2022 13:18:33 -0700 (PDT)
Message-ID: <c2269e99-b832-1c00-a08b-14af3be4d76b@acm.org>
Date: Wed, 15 Jun 2022 13:18:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101927eucas1p17220c7a36f69f59ff8ddd560b42967ec@eucas1p1.samsung.com>
 <20220615101920.329421-2-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220615101920.329421-2-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 01/13] block: make blkdev_nr_zones and
 blk_queue_zone_no generic for npo2 zsze
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
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

On 6/15/22 03:19, Pankaj Raghav wrote:
> Adapt blkdev_nr_zones and blk_queue_zone_no function so that it can
> also work for non-power-of-2 zone sizes.
> 
> As the existing deployments of zoned devices had power-of-2
> assumption, power-of-2 optimized calculation is kept for those devices.
> 
> There are no direct hot paths modified and the changes just
> introduce one new branch per call.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

