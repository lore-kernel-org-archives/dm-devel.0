Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D478C46467
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 09:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673343811;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/PETqyXCklPemwxBolbbaHMsmFpycyh0YgNeCU2GYRw=;
	b=PLaHI5so0Fz9sHHGpl71ad9kV2M2kx9zEfihWexh66ZpY0K5oUlT8SbFgGRXfkjk6uE+/j
	EAHN5S9XF10kv/SbNWwRGzfNXfPhZtjfrQx37OY9l0lvIuoySDaav+Pv+Po1d38TkU1HMC
	DQncv6rqfiQdC1ljUT0PzfqrhaRZG30=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-H6yBhk6sOS6bfut-GCxZWQ-1; Tue, 10 Jan 2023 04:43:28 -0500
X-MC-Unique: H6yBhk6sOS6bfut-GCxZWQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 601FA811E9C;
	Tue, 10 Jan 2023 09:43:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A96B140EBF4;
	Tue, 10 Jan 2023 09:43:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EA1D193F504;
	Tue, 10 Jan 2023 09:43:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 651741946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 09:43:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FF952026D76; Tue, 10 Jan 2023 09:43:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4895F2026D68
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:43:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D88E85CBE1
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:43:23 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-EpmrSPfqO_KizzYUrWpOpw-1; Tue, 10 Jan 2023 04:43:21 -0500
X-MC-Unique: EpmrSPfqO_KizzYUrWpOpw-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id D623968BEB; Tue, 10 Jan 2023 10:43:16 +0100 (CET)
Date: Tue, 10 Jan 2023 10:43:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20230110094316.GA14143@lst.de>
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e@eucas1p2.samsung.com>
 <20230106083317.93938-8-p.raghav@samsung.com> <20230110065822.GF10289@lst.de>
 <35293c0c-2d72-c4ee-2296-079d56df7d5b@samsung.com>
MIME-Version: 1.0
In-Reply-To: <35293c0c-2d72-c4ee-2296-079d56df7d5b@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 7/7] dm: call dm_zone_endio after the target
 endio callback for zoned devices
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
Cc: axboe@kernel.dk, bvanassche@acm.org, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 10, 2023 at 10:07:39AM +0100, Pankaj Raghav wrote:
> I just extracted the cleanup from my old series. Do you think it is better
> to send it as a separate patch instead of adding it along in this series?

dm and block have different maintainers.  So unless there is a
dependency it's better to split the patches out.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

