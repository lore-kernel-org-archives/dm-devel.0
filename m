Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D31C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:24:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D24626128E
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D24626128E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-amjkKJT1MqSo7Dk2QWGSqQ-1; Tue, 08 Jun 2021 12:24:20 -0400
X-MC-Unique: amjkKJT1MqSo7Dk2QWGSqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16944818400;
	Tue,  8 Jun 2021 16:24:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1043D179E6;
	Tue,  8 Jun 2021 16:24:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4D5E344A59;
	Tue,  8 Jun 2021 16:24:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158GO9fl020820 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 12:24:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4275D101B892; Tue,  8 Jun 2021 16:24:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D6401033C65
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:24:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B710919822
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:24:07 +0000 (UTC)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
	[209.85.215.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-542--kaR42gNPaigMxOZzqs3gw-1; Tue, 08 Jun 2021 12:24:04 -0400
X-MC-Unique: -kaR42gNPaigMxOZzqs3gw-1
Received: by mail-pg1-f172.google.com with SMTP id y11so8785854pgp.11;
	Tue, 08 Jun 2021 09:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=tWUOLd7SDy3G4uRPATKyTli1+VRXa+Ne7jXYUe6DYzU=;
	b=V42haPygkmyGF5kVRyZd+7TRPYyx9zTc8rglsNFXiCbD/IWPrMkUhWcyj4okHOjUfh
	ezmn7F3uajB2EFTG4X0aMvnEMYZ4iYQaGJIyeZoWLnmHihwSg/xUir1vYpl39wAi67hB
	uD22/EXOigBUhHOZtQPd7y1pTG0+JH7+dAS1KpT82GaRaZT7fvwr/F73u7QFUEI5ALRR
	0Y5hBNZSqyJNwKAoKt8jgN07YHjfbGud9u06h/wsq+XD+xR6TTxIJ9eP4mLbcXwkrHqw
	kC2fcCHkmosEgdOhfK2vdkYOeMPwJx8hwW09/g5UhVxTZIUWVEJ0FmEMz75QXuUnpxSv
	4s+w==
X-Gm-Message-State: AOAM5306uerqF/5PismzgE6VKKFv/cJjL3dpATCEOIkuaEzzuHb8Sgpw
	mRo+pk23l95ZYmjihmdWpW4=
X-Google-Smtp-Source: ABdhPJw8yHF55mrEwh6e92tzycqNf1F5E5W7MS3iqsvoqL7+Q6ralpXCJFS3XAL+JOxp8CFbvFr8pQ==
X-Received: by 2002:a05:6a00:170c:b029:2dc:dd8f:e083 with SMTP id
	h12-20020a056a00170cb02902dcdd8fe083mr663455pfc.77.1623169441463;
	Tue, 08 Jun 2021 09:24:01 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	p11sm11877708pgn.65.2021.06.08.09.23.59
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 08 Jun 2021 09:24:00 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-4-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <c5e460da-1401-30c3-df87-0a033f40e563@acm.org>
Date: Tue, 8 Jun 2021 09:23:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608160603.1535935-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 03/16] bvec: fix the include guards for bvec.h
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 9:05 AM, Christoph Hellwig wrote:
> Fix the include guards to match the file naming.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

