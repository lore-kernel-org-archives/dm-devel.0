Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2413C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 19:18:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-14xNzSwfPiinwsFLhjKkUA-1; Tue, 01 Feb 2022 14:18:32 -0500
X-MC-Unique: 14xNzSwfPiinwsFLhjKkUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C34F08143F2;
	Tue,  1 Feb 2022 19:18:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 798465F4EE;
	Tue,  1 Feb 2022 19:18:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4C7A4CA93;
	Tue,  1 Feb 2022 19:18:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211JIOo4007540 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 14:18:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B951492CA4; Tue,  1 Feb 2022 19:18:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68077492D1F
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 19:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FC8F1044563
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 19:18:24 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
	[209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-218-DlT2bRXbP2qu2KkfZNfw-w-1; Tue, 01 Feb 2022 14:18:22 -0500
X-MC-Unique: DlT2bRXbP2qu2KkfZNfw-w-1
Received: by mail-pj1-f52.google.com with SMTP id
	s2-20020a17090ad48200b001b501977b23so4233454pju.2; 
	Tue, 01 Feb 2022 11:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=hp34bVqoar/e3InZNjkVm77xuFkZxmxfiyCdI22uRdU=;
	b=HtqFJ42hcUbldcNPTeJw5uB2w42t66PoMbJUwcYwtaJewwNIFOG4omDwRrV4Er32VF
	dLhASMM2orfW+2GqCXaRsFZdPtqdqsL3zH6jo4suPGoqxTKn41mqOUkjSexJdtKFYPfY
	t6PXWjpKW417uP7kownXcm4BoKJ8pjI6/Tp+CW9gHr3pwkbWnF4kgFyiZUWUPCFl+91E
	Yhq+fkwuOFFz4ptQ9Pzt9BShNZ/+12TrNLhDfiQ3CgrJwR24WiPb6iAS5GI5Q2uzv1La
	Y4a1oWBS/My693ZPnHTspS/Ubl3daOwtOP4dBiNRzIIzhCc9E4vsZPT62AiikuODcmWO
	Eljw==
X-Gm-Message-State: AOAM531KsyCN5Il0nlZQsPyTIl1321/qIlnHe0bjne2+trT1lMkxEP1a
	9Qhm4Z6kUx+yauiizmgoXA+//QbIsRU=
X-Google-Smtp-Source: ABdhPJwVjQ8XwIE/Pdopyd4xqNbc3uXzt+CS6ObdWGWjnTBypf2k1gl84D5YDxPWH3xnxlch5HtAXg==
X-Received: by 2002:a17:90b:4d12:: with SMTP id
	mw18mr4005365pjb.104.1643743100937; 
	Tue, 01 Feb 2022 11:18:20 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	ns21sm3381040pjb.43.2022.02.01.11.18.18
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 01 Feb 2022 11:18:19 -0800 (PST)
Message-ID: <1380d0e4-032d-133b-4ebb-f10d85e39800@acm.org>
Date: Tue, 1 Feb 2022 11:18:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Mikulas Patocka <mpatocka@redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011332330.22481@file01.intranet.prod.int.rdu2.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <alpine.LRH.2.02.2202011332330.22481@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 2/3] nvme: add copy offload support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2/1/22 10:33, Mikulas Patocka wrote:
> +static inline blk_status_t nvme_setup_read_token(struct nvme_ns *ns, struct request *req)
> +{
> +	struct bio *bio = req->bio;
> +	struct nvme_copy_token *token = page_to_virt(bio->bi_io_vec[0].bv_page) + bio->bi_io_vec[0].bv_offset;

Hmm ... shouldn't this function use bvec_kmap_local() instead of 
page_to_virt()?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

