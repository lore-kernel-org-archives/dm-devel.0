Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BAAC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 18:11:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-mop34XLRMrCyu_DFSEj-pw-1; Mon, 23 May 2022 14:11:40 -0400
X-MC-Unique: mop34XLRMrCyu_DFSEj-pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E37CF19705A7;
	Mon, 23 May 2022 18:11:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB3841410DD5;
	Mon, 23 May 2022 18:11:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 92742194705A;
	Mon, 23 May 2022 18:11:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0A131947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 18:11:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A66640E6A58; Mon, 23 May 2022 18:11:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8645E40E6A47
 for <dm-devel@redhat.com>; Mon, 23 May 2022 18:11:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB77185A7A4
 for <dm-devel@redhat.com>; Mon, 23 May 2022 18:11:30 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-Tc4huk2HNc20dGqkhVIdkw-1; Mon, 23 May 2022 14:11:26 -0400
X-MC-Unique: Tc4huk2HNc20dGqkhVIdkw-1
Received: by mail-pl1-f180.google.com with SMTP id c2so13823634plh.2;
 Mon, 23 May 2022 11:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YcM2V9lJrQoILVWR8hE1O3AxcExnhJbF35MwvFVRNF0=;
 b=1gm/wM/GX6pz9uArQdXgdfva4gjKgID2G7xkW7DAh0HGllf4SSWIzFUHS89fpObutb
 uQpGU/TouVk/L6CRBR9QuHszmnmQpKpIsieduLXYCWVDq3d4HN9gmCXNIwe5PLfNBa4s
 SObgouxmAQtRnWqWNqFgVcVxJQS18r1M/hJZU5NUCnIO4k7WeouPwqHNpX6xiyqK27xJ
 Sid6dkdSnJlV2Uizzt2kogaGcPHTq3c8Izov8qKPtjyabhM2SghLNJDB7PFct8qsVEWp
 gr439gd0UEm8ptqVREdrIyyaGZ4e+LqJoUZz6ae7zPtpeJCJlvFQFnXDbfWxaJK64EgD
 ypHg==
X-Gm-Message-State: AOAM532BF3XnedtTJYJAuwHduASLoymkg59M4md18J/UnMUoIPimQnbO
 u7c/MxVI9tE416Q48lYDLWg=
X-Google-Smtp-Source: ABdhPJyM/CwxpvBVN9kqgJt3dUJYAsl5xQQzoLnJApp0k9u48+L0bdeBCHhzQQ+qLqqg/d0Knkk4fQ==
X-Received: by 2002:a17:90a:8807:b0:1df:78c7:c215 with SMTP id
 s7-20020a17090a880700b001df78c7c215mr247975pjn.234.1653329485047; 
 Mon, 23 May 2022 11:11:25 -0700 (PDT)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
 by smtp.gmail.com with ESMTPSA id
 x3-20020a654143000000b003c14af50610sm5025690pgp.40.2022.05.23.11.11.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 May 2022 11:11:24 -0700 (PDT)
Date: Mon, 23 May 2022 11:11:22 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20220523181122.3vjizmsx7a2mpf6z@garbanzo>
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161612eucas1p102a76ba431c934230309042521018915@eucas1p1.samsung.com>
 <20220523161601.58078-7-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220523161601.58078-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v5 6/7] null_blk: use zone_size_sects_shift
 for power of 2 zoned devices
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, damien.lemoal@opensource.wdc.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 gost.dev@samsung.com, dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de
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

On Mon, May 23, 2022 at 06:16:00PM +0200, Pankaj Raghav wrote:
> Instead of doing is_power_of_2 and ilog2 operation for every IO, cache
> the zone_size_sects_shift variable and use it for power of 2 zoned
> devices.
> 
> This variable will be set to zero for non power of 2 zoned devices.
> 
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

