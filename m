Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659CEC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 16:16:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D4E83610E8
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 16:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D4E83610E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-ZOxvnY20NfWuhEqEX-jYmQ-1; Fri, 29 Oct 2021 12:15:57 -0400
X-MC-Unique: ZOxvnY20NfWuhEqEX-jYmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40D9C806688;
	Fri, 29 Oct 2021 16:15:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CBFD1B472;
	Fri, 29 Oct 2021 16:15:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D93921806D03;
	Fri, 29 Oct 2021 16:15:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TGFmN8025551 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 12:15:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9E54D40CFD10; Fri, 29 Oct 2021 16:15:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 996E540CFD0B
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 16:15:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80EE4106655B
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 16:15:48 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
	[209.85.214.179]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-122-WuviQ-2DONeid8-Noxb1WA-1; Fri, 29 Oct 2021 12:15:46 -0400
X-MC-Unique: WuviQ-2DONeid8-Noxb1WA-1
Received: by mail-pl1-f179.google.com with SMTP id t11so7135556plq.11
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 09:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=jKXUH2KRwO4V5xMJ+T8M1TeZFj9xrcQY7R7PFnzsrsY=;
	b=g1HFePcobQbpcpIOaPSaMMLsmCDQiMBB8WlHQbjzDhf+4en0ngLddkaJ1Xlq8ybK78
	/rAxwrA3Gv/RHHgHVDIlBE5iUvnENLmxlT2kqbVvD2hHONM42N//wVnopK9OTI8v94xK
	ICMzvlXO9GKuwJ8pl2VUj4juNfsEPaCc2ZDqKtaOSJEKbh0muA89GWsnQ4qB+vBtU0yR
	uRczgdGJBZrTXD1PT+Fz1cqkKVg5V9EKDeduRM6IoYBlVTA5NWEY3pe1pv9Da9yqfjcu
	ADxALOUsB/wktht7SwurIYm1i39FWfZJG+iGF6saEayhlfzflGsY99lo3dIhUoQ6qtPa
	io7g==
X-Gm-Message-State: AOAM533S9pUOOlszVm/3M3xFqwZVzayaU6M4jWyFu3BQigVKuN+p9vqd
	rHESA3BJb8EgiFh+DK3gCzW+BXVJcsOnDw==
X-Google-Smtp-Source: ABdhPJwmiz+YImWEBzmpCqKfSuiQbDI0Gd4nWkdhrFsTjLBkZ9Q+upPQOIKIxvtxSPGosOf0hyw62g==
X-Received: by 2002:a17:903:248f:b0:141:5a79:ae48 with SMTP id
	p15-20020a170903248f00b001415a79ae48mr10311651plw.12.1635524145387;
	Fri, 29 Oct 2021 09:15:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:201:7346:8d3b:12d0:7278])
	by smtp.gmail.com with ESMTPSA id a7sm7087948pfo.32.2021.10.29.09.15.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 29 Oct 2021 09:15:44 -0700 (PDT)
To: Hannes Reinecke <hare@suse.de>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
	<ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <5edcab45-afc6-3766-cede-f859da2934d1@acm.org>
Date: Fri, 29 Oct 2021 09:15:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/28/21 10:51 PM, Hannes Reinecke wrote:
> Also Keith presented his work on a simple zone-based remapping block device, which included an in-kernel copy offload facility.
> Idea is to lift that as a standalone patch such that we can use it a fallback (ie software) implementation if no other copy offload mechanism is available.

Is a link to the presentation available?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

