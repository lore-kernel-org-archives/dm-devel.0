Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E854C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 13:18:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F313B60238
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 13:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F313B60238
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-wbmFOsejN9--YIHlR1TFcw-1; Tue, 17 Aug 2021 09:18:29 -0400
X-MC-Unique: wbmFOsejN9--YIHlR1TFcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFA208030B7;
	Tue, 17 Aug 2021 13:18:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71AB75C1D5;
	Tue, 17 Aug 2021 13:18:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E431D181A2A6;
	Tue, 17 Aug 2021 13:18:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HDG0hP025900 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 09:16:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 63CAF200D8EC; Tue, 17 Aug 2021 13:16:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F69A200D8F9
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 13:15:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D54208D1386
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 13:15:57 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-126-F1gdcOpANT-_ysUxEePDlQ-1;
	Tue, 17 Aug 2021 09:15:56 -0400
X-MC-Unique: F1gdcOpANT-_ysUxEePDlQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id C925E6054F;
	Tue, 17 Aug 2021 13:08:45 +0000 (UTC)
Date: Tue, 17 Aug 2021 15:08:43 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: SelvaKumar S <selvakuma.s1@samsung.com>
Message-ID: <YRu02+RgnZekKSqi@kroah.com>
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101753epcas5p4f4257f8edda27e184ecbb273b700ccbc@epcas5p4.samsung.com>
	<20210817101423.12367-3-selvakuma.s1@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20210817101423.12367-3-selvakuma.s1@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, hch@lst.de, agk@redhat.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org, selvajove@gmail.com,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	javier.gonz@samsung.com, kbusch@kernel.org, axboe@kernel.dk,
	damien.lemoal@wdc.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-api@vger.kernel.org,
	johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
	joshiiitr@gmail.com, asml.silence@gmail.com
Subject: Re: [dm-devel] [PATCH 2/7] block: Introduce queue limits for
 copy-offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 17, 2021 at 03:44:18PM +0530, SelvaKumar S wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Add device limits as sysfs entries,
>         - copy_offload (READ_WRITE)
>         - max_copy_sectors (READ_ONLY)
>         - max_copy_ranges_sectors (READ_ONLY)
>         - max_copy_nr_ranges (READ_ONLY)

You forgot to add Documentation/ABI/ entries for your new sysfs files,
so we can't properly review them :(

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

