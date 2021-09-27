Return-Path: <SRS0=coXp=OR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A540EC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:29:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E16F560FED
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:29:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E16F560FED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-A0LvhiQLMOecF8I51PPjgw-1; Mon, 27 Sep 2021 18:29:00 -0400
X-MC-Unique: A0LvhiQLMOecF8I51PPjgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A04BB1006AA4;
	Mon, 27 Sep 2021 22:28:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E6BD5D9D5;
	Mon, 27 Sep 2021 22:28:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5ADE1809C84;
	Mon, 27 Sep 2021 22:28:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18RMSqYe028468 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 27 Sep 2021 18:28:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1937A202F328; Mon, 27 Sep 2021 22:28:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 149EA2026D2F
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 22:28:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6297D1066680
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 22:28:49 +0000 (UTC)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
	[209.85.166.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-502-4Zp-l4l-NZ6O15T1iLc9Gw-1; Mon, 27 Sep 2021 18:28:47 -0400
X-MC-Unique: 4Zp-l4l-NZ6O15T1iLc9Gw-1
Received: by mail-io1-f53.google.com with SMTP id i62so8816979ioa.6
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 15:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=w9ezsQ1UkQZeC53NkFhy7B+1aNQW9TNDf1kl1c4M4R4=;
	b=bWJpf6oIkC3/rE/+OMjZNSHtxhio5Ad1tfSUKwCc8y1wTNxv2nh+cxSuHuB6YX2UXA
	PPQJqGySPvciB5AsFa1xjeg69HtVgyR9q/+Ug0AF5/cMQ3VYAlQGr4wvPtHTZQz3/4Dc
	xFG0ZsaJ4wTRPxc4DjeUNxn2B7enixp2xNq9bLFdsCCDFUuyg7mu3sWOpJp71HGISkQM
	53l3uoAiLaDtEO7nQNXr5Rs2tf6A4jGRJZy/1+6b3DrtYl9SQRC8dXzJ4H0AVRqV4Knh
	ZeB+aclvxvC1aayq2ahtjeL1B26atEeqLLPCQ9Q8Q4izlW86cEij9UtuMUzGZiFTAFLz
	qZRA==
X-Gm-Message-State: AOAM5334iacyb2RA3FfWzHqG265O8cu9nOoIsfWjwpJG6fdA+MiQ9dLf
	zerBf9gSXDEHI5YOPMThuXRIcg==
X-Google-Smtp-Source: ABdhPJztY3mK3ksoDQMf3OrQ8dUSONHNyLP4EfHo/dO6kIiAhPp9t/W2Pe9f9RD+PJfpbL6A6UQe4w==
X-Received: by 2002:a02:22cf:: with SMTP id o198mr1814887jao.37.1632781726231; 
	Mon, 27 Sep 2021 15:28:46 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id
	e13sm9446741iod.36.2021.09.27.15.28.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 27 Sep 2021 15:28:45 -0700 (PDT)
To: Luis Chamberlain <mcgrof@kernel.org>, martin.petersen@oracle.com,
	jejb@linux.ibm.com, kbusch@kernel.org, sagi@grimberg.me,
	adrian.hunter@intel.com, beanhuo@micron.com, ulf.hansson@linaro.org,
	avri.altman@wdc.com, swboyd@chromium.org, agk@redhat.com,
	snitzer@redhat.com, josef@toxicpanda.com
References: <20210927215958.1062466-1-mcgrof@kernel.org>
	<20210927215958.1062466-6-mcgrof@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1cd6103b-1251-cc22-93ad-da7f207147b4@kernel.dk>
Date: Mon, 27 Sep 2021 16:28:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210927215958.1062466-6-mcgrof@kernel.org>
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
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v4 5/6] loop: add error handling support for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

