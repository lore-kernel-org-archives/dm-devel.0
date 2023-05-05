Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D0DC77B7C
	for <dm-devel@archiver.kernel.org>; Fri,  5 May 2023 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683295934;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=98OiXz8RgP7LwLIdUXBxEA7QGDSdOs5ruJjTKBUgO7A=;
	b=a/GhKWGfsTmA9thtPhAiOXKxM06AEYK3RDdxJ4rcu9JcjkzlB3+9/CIazt2CyiprzLMC+f
	5QFRqp0psB5qZejIcj3ZjOZAbzBh7I4U1yUXDxwD/CAp2zDaOWTIUaeR4SlPq6If799nFQ
	Mr7sRnMiZjHBIn5pjEGVY4ahv1RtT5g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-NiHxnwCeM_a1mziEhuZRRw-1; Fri, 05 May 2023 10:12:13 -0400
X-MC-Unique: NiHxnwCeM_a1mziEhuZRRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B19038173D1;
	Fri,  5 May 2023 14:12:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4113614171B6;
	Fri,  5 May 2023 14:12:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 023961946A48;
	Fri,  5 May 2023 14:12:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C3CF1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 May 2023 14:12:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DFD4C084BB; Fri,  5 May 2023 14:12:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1762DC15BA0
 for <dm-devel@redhat.com>; Fri,  5 May 2023 14:12:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9CAE1078504
 for <dm-devel@redhat.com>; Fri,  5 May 2023 14:12:02 +0000 (UTC)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com
 [209.85.128.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-MJg6Vx1WPDq-NOhc7p-efA-1; Fri, 05 May 2023 10:11:55 -0400
X-MC-Unique: MJg6Vx1WPDq-NOhc7p-efA-1
Received: by mail-yw1-f173.google.com with SMTP id
 00721157ae682-55a202d44e6so2122257b3.0
 for <dm-devel@redhat.com>; Fri, 05 May 2023 07:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683295915; x=1685887915;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=lYPB3stPQmWSExnYMshDYbYhsfa2W+OlQjJxEpndWnM=;
 b=LbU04/yzPCnZXYiTvgAySIKAKHi1nrUIBUK/0dL1YEo3hqgGAw1XN9DWTKPD3p7HOf
 03NxoxJxUd+Sy3ljGekmntjVtEJC6IaCo26X6llCvLsopxOTFqAjrnnuPxlqJQXlVTBl
 d6MX0bTlB7CZSTB/srL4Rne31q3KaegMuPdtwLb5SXNAVBRc5phJc+Y+zn5F84peZjCR
 vE5mmmmhsoSYwQtQT8gikIjEYkOPn3+QFUOdBYCbHrIaT4dAp0pxIY3yVszNM2K7pKFR
 JdOWySdyb8nNAKFkg07inrmcu09RfsY+uTR30LoDwxgJueTguCIaIFxa2inrOXocjqfY
 zTsQ==
X-Gm-Message-State: AC+VfDx2fGZCUJiglZrsNhlT7zHsLpn8pvoXoUWBh6rHf7SW7HU+z6b2
 00i9Dah13Ub8KfEQ4TMvK86vPQ==
X-Google-Smtp-Source: ACHHUZ6qoOI/+PGpkkPitfDFrwnR+RSgPJAmgOvbSJFeS3wnUhPPJunQJdt8ejTtUoT1u+x3g04+yQ==
X-Received: by 2002:a81:5d6:0:b0:55a:9e2f:933d with SMTP id
 205-20020a8105d6000000b0055a9e2f933dmr1748012ywf.1.1683295914848; 
 Fri, 05 May 2023 07:11:54 -0700 (PDT)
Received: from [172.20.2.186] ([12.153.103.3])
 by smtp.gmail.com with ESMTPSA id
 x8-20020a814a08000000b0054f56baf3f2sm264788ywa.122.2023.05.05.07.11.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 05 May 2023 07:11:53 -0700 (PDT)
Message-ID: <e56b4f96-a379-f97b-168f-d03f170744b2@kernel.dk>
Date: Fri, 5 May 2023 08:11:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
 <1ac1fc5e-3c32-9d62-65bf-5ccbb82c37cc@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1ac1fc5e-3c32-9d62-65bf-5ccbb82c37cc@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v5 00/20] bio: check return values of
 bio_add_page
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Damien Le Moal <Damien.LeMoal@wdc.com>, "kch@nvidia.com" <kch@nvidia.com>,
 "agruenba@redhat.com" <agruenba@redhat.com>,
 "shaggy@kernel.org" <shaggy@kernel.org>, "song@kernel.org" <song@kernel.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>,
 "willy@infradead.org" <willy@infradead.org>,
 "ming.lei@redhat.com" <ming.lei@redhat.com>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>, "rpeterso@redhat.com" <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/5/23 2:09?AM, Johannes Thumshirn wrote:
> On 02.05.23 12:20, Johannes Thumshirn wrote:
>> We have two functions for adding a page to a bio, __bio_add_page() which is
>> used to add a single page to a freshly created bio and bio_add_page() which is
>> used to add a page to an existing bio.
>>
>> While __bio_add_page() is expected to succeed, bio_add_page() can fail.
>>
>> This series converts the callers of bio_add_page() which can easily use
>> __bio_add_page() to using it and checks the return of bio_add_page() for
>> callers that don't work on a freshly created bio.
>>
>> Lastly it marks bio_add_page() as __must_check so we don't have to go again
>> and audit all callers.
>>
>> Changes to v4:
>> - Rebased onto latest Linus' master
>> - Dropped already merged patches
>> - Added Sergey's Reviewed-by
>>
>> Changes to v3:
>> - Added __bio_add_folio and use it in iomap (Willy)
>> - Mark bio_add_folio must check (Willy)
>> - s/GFS/GFS2/ (Andreas)
>>
>> Changes to v2:
>> - Removed 'wont fail' comments pointed out by Song
>>
>> Changes to v1:
>> - Removed pointless comment pointed out by Willy
>> - Changed commit messages pointed out by Damien
>> - Colledted Damien's Reviews and Acks
> 
> Jens any comments on this?

I'll take a look post -rc1.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

