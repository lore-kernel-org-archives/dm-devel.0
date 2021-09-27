Return-Path: <SRS0=coXp=OR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA1EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:29:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 307E360FC0
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 307E360FC0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-IHnrv8ggOCaDe7DbKL_D3g-1; Mon, 27 Sep 2021 18:29:11 -0400
X-MC-Unique: IHnrv8ggOCaDe7DbKL_D3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 711F8801E72;
	Mon, 27 Sep 2021 22:29:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 510EE109B6E1;
	Mon, 27 Sep 2021 22:29:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C3AE4E58F;
	Mon, 27 Sep 2021 22:29:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18RMT5QZ028492 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 27 Sep 2021 18:29:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 95BC2B3007; Mon, 27 Sep 2021 22:29:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9047CB27BD
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 22:29:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C71898007B1
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 22:29:02 +0000 (UTC)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
	[209.85.166.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-I8M8kHcwOGGTdc9XqVjDzg-1; Mon, 27 Sep 2021 18:29:01 -0400
X-MC-Unique: I8M8kHcwOGGTdc9XqVjDzg-1
Received: by mail-il1-f175.google.com with SMTP id a11so9731348ilk.9
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 15:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=w9ezsQ1UkQZeC53NkFhy7B+1aNQW9TNDf1kl1c4M4R4=;
	b=BqdvZc92YR4Yvr0Cr+ZwG9SWFo6F9CH4NAEHl8+vlmU7cmP2+Q2p7anO1K9WduGOZi
	l4s8zbV9r1ZZL7nE/VcmMEv55tWLkXC2zFDlLyxnAMG+5PiBFDUn98jkq7uJzGy7ZGHa
	xi0K6SmFkfotL2zkICb2lsaWYxKE6uzX5v8+xxkx6yXhtb5bIndCJ1WTaJfs0wsiFh/Z
	UXC1mpd8fR9xijXQHl/agCNjveCp2gs49ruPH4df1DHEKe1NjRB/Yn8obEOhoIz7jPOO
	HJk8foRNamovh84HaFSa30z855sEAlcZK1diu8NMk/SP8/64rGc2SARz51plvJjFTFVV
	NY0Q==
X-Gm-Message-State: AOAM5327k70n5gEzislexopqncCpnSNpd7oB8qF150sjYgoi1ZO9WCY2
	h49xumhXtV35yLqiJZQ5v6g1Aw==
X-Google-Smtp-Source: ABdhPJz2QpC01URNtiA6TI68tVS50xc5AHbinQF2wOnvWrWvzOWk+mcoidVwrUAWxR5vBmrTJemKng==
X-Received: by 2002:a05:6e02:661:: with SMTP id
	l1mr1855976ilt.122.1632781740297; 
	Mon, 27 Sep 2021 15:29:00 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id
	z25sm7614559iow.20.2021.09.27.15.28.58
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 27 Sep 2021 15:28:59 -0700 (PDT)
To: Luis Chamberlain <mcgrof@kernel.org>, martin.petersen@oracle.com,
	jejb@linux.ibm.com, kbusch@kernel.org, sagi@grimberg.me,
	adrian.hunter@intel.com, beanhuo@micron.com, ulf.hansson@linaro.org,
	avri.altman@wdc.com, swboyd@chromium.org, agk@redhat.com,
	snitzer@redhat.com, josef@toxicpanda.com
References: <20210927215958.1062466-1-mcgrof@kernel.org>
	<20210927215958.1062466-7-mcgrof@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dc945e14-498b-2cc1-8ef3-8dcaacfb948c@kernel.dk>
Date: Mon, 27 Sep 2021 16:28:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210927215958.1062466-7-mcgrof@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v4 6/6] nbd: add error handling support for
	add_disk()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/27/21 3:59 PM, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

