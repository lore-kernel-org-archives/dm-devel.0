Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A20C64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:53:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC88D20639
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC88D20639
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-4oZRrhhfMI2kqND1c5_fvg-1; Tue, 01 Dec 2020 12:53:39 -0500
X-MC-Unique: 4oZRrhhfMI2kqND1c5_fvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92197858184;
	Tue,  1 Dec 2020 17:53:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63D0760BFA;
	Tue,  1 Dec 2020 17:53:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ECBF6180954D;
	Tue,  1 Dec 2020 17:53:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1HrWDE004782 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:53:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EF45A1004035; Tue,  1 Dec 2020 17:53:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB409112D19D
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:53:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C76D2101A565
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:53:29 +0000 (UTC)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
	[209.85.210.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-532-HtcOw9WOM5qeQ1o0hvpFsg-1; Tue, 01 Dec 2020 12:53:27 -0500
X-MC-Unique: HtcOw9WOM5qeQ1o0hvpFsg-1
Received: by mail-pf1-f195.google.com with SMTP id q22so1329449pfk.12
	for <dm-devel@redhat.com>; Tue, 01 Dec 2020 09:53:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=GGvr/361QsS/rtGakPueyLl+Ud9hPyc2KZoLpr4f4aA=;
	b=S5EjZUorMK0PcOO5QcLR7FwYLNzIWBoBkmebFPg09DoBpiW4diN3BxwYfqkCTl8A2j
	XH5iDSvJGy1UgrR4eMNbzjqD7j+IMWE/OsVL2DwJo7/oL/dXgTSq3VNcTbLtAzhJ69Y6
	Ix75BdVvzk4eT+TmUOTuvpYsYMTXIDKp9GZiJSFZufIcLAc3lu/Q0VT0q++nkHMPxYQ5
	RlyEtz4aNQNKgm7TfBhPRX3B422Kq9MoXSYWbxXf/R/sDE2RzccUAKsyXuE7YjZj7lUx
	WnvmeR/6XRvYj8B34g54T7XxgKKMXarMlxBf1mDUOoTLWnl6npbbYn3ldx6kVGdqYcm/
	INxQ==
X-Gm-Message-State: AOAM531RCVRsHaI1gaXVoFmDmOJlDE8XczNgIah7QYH+di2/IafxUfx4
	4lNFqUlkmzHredHbijF+oXZ0CQ==
X-Google-Smtp-Source: ABdhPJxh5z2v04fO7TlUW/jBlS4B25SihFMf4nMDomCGzRTrIUqxQxpNuCmqXImwL2paKnurwV9pKQ==
X-Received: by 2002:aa7:97a2:0:b029:19a:e055:1d53 with SMTP id
	d2-20020aa797a20000b029019ae0551d53mr3756146pfq.12.1606845206386;
	Tue, 01 Dec 2020 09:53:26 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::12f3? ([2620:10d:c090:400::5:b3dd])
	by smtp.gmail.com with ESMTPSA id
	v196sm431732pfc.34.2020.12.01.09.53.25
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 01 Dec 2020 09:53:25 -0800 (PST)
To: Mike Snitzer <snitzer@redhat.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8c878c13-2112-32cd-6ff0-bb54fd6b8382@kernel.dk>
Date: Tue, 1 Dec 2020 10:53:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201201160709.31748-1-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, bjohnsto@redhat.com,
	jdorminy@redhat.com, martin.petersen@oracle.com
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/1/20 9:07 AM, Mike Snitzer wrote:
> commit 22ada802ede8 ("block: use lcm_not_zero() when stacking
> chunk_sectors") broke chunk_sectors limit stacking. chunk_sectors must
> reflect the most limited of all devices in the IO stack.
> 
> Otherwise malformed IO may result. E.g.: prior to this fix,
> ->chunk_sectors = lcm_not_zero(8, 128) would result in
> blk_max_size_offset() splitting IO at 128 sectors rather than the
> required more restrictive 8 sectors.
> 
> And since commit 07d098e6bbad ("block: allow 'chunk_sectors' to be
> non-power-of-2") care must be taken to properly stack chunk_sectors to
> be compatible with the possibility that a non-power-of-2 chunk_sectors
> may be stacked. This is why gcd() is used instead of reverting back
> to using min_not_zero().

Applied for 5.10, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

