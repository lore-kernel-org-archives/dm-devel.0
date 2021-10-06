Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10BDC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 14:48:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62D05610C9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 14:48:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 62D05610C9
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633531722;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hzN+0U2+A4asE+wkW8K+LFqO1nqx1wzKblHV4L1+3bg=;
	b=ekj8PWCJckm5kTVlTVYJvrMafORo9V9j7sVDsozHOkhEpxmcnUSXqs6XhXBIpHLF6s1Wce
	4o9W4IOGwJdpy0xaUyW5SwWtv73ppXVNSmcQ1DpIYmdP7Zm8f2JXVqfBk0YjeJrf3JoN0x
	7qoGjuQz+ncwILUlfiF9uO/PiTTEYm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-cIAD_z4nNGe6Xns6TcRv4w-1; Wed, 06 Oct 2021 10:48:41 -0400
X-MC-Unique: cIAD_z4nNGe6Xns6TcRv4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D24A9802C91;
	Wed,  6 Oct 2021 14:48:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90D5010016FF;
	Wed,  6 Oct 2021 14:48:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 120A4180BAD1;
	Wed,  6 Oct 2021 14:48:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196EhvTN025583 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 10:43:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E5AE12166B40; Wed,  6 Oct 2021 14:43:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E07FB2166B2F
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 14:43:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E5D811E97
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 14:43:45 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-401-qDX7t5klN3eSEeUeQi796w-1; Wed, 06 Oct 2021 10:43:43 -0400
X-MC-Unique: qDX7t5klN3eSEeUeQi796w-1
Received: by mail-qv1-f69.google.com with SMTP id
	c13-20020a056214224d00b00382f21b95fcso2888377qvc.5
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 07:43:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=cZTENCuvw0rDt5LX9xZwoqEqbbTllu7PrFNLcPSq/zo=;
	b=1TbTrHquApfhdfCfNQSIDFqR9oIV7WPWsJD50DPXNv8nbQaLz8wSwumH5DoaNh/RHV
	PYbBcKcy4AFC0MRU9RUIpBzJC6N1t9sEp9/TYBQX1lm4xZsqYM+zJdNfgubLK16vcpgG
	ozm7PYPZCGlYysXsgUkG9LtjjQQayRGABaJjFhAkq/BvnPLembD+K234Y9upnwEF982G
	HjDgBwOFeZr2C7L8oJRNKgtkxAsUEn3A17WSdALjdZiRQWWGls5HXeh78aD+PeTb5u/t
	Guo/+p/ZbLIDdIl8atCLRf3AFmpWy8C/7u74dw2yziadb4CnZAKHP8zS3OaTOnCuhEmZ
	cjMw==
X-Gm-Message-State: AOAM5336ie5yNXMX4CxkL9ip1Xud1YRlBJONTreaXav4X/woqv0Tzgps
	9+2OMAdSVTB9bZZF8AhWDieiaftRncuocUWSjUp4UQwrpxyzl1k/vkpjTIIWLTUY8Pydd84WOnb
	Je/7awDh6pOUicg==
X-Received: by 2002:a05:622a:549:: with SMTP id
	m9mr26432406qtx.131.1633531422315; 
	Wed, 06 Oct 2021 07:43:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/diaLClqgqyB+WtonYxpEP3/4qWBwzXjSBjvMy6cwUguD3O6zs8+jGx492oMa5QlUkqza6A==
X-Received: by 2002:a05:622a:549:: with SMTP id
	m9mr26432387qtx.131.1633531422130; 
	Wed, 06 Oct 2021 07:43:42 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	f5sm12705618qtp.44.2021.10.06.07.43.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 07:43:41 -0700 (PDT)
Date: Wed, 6 Oct 2021 10:43:40 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jiazi Li <jqqlijiazi@gmail.com>
Message-ID: <YV22HGeK867BHKNP@redhat.com>
References: <1632916768-22379-1-git-send-email-lijiazi@xiaomi.com>
MIME-Version: 1.0
In-Reply-To: <1632916768-22379-1-git-send-email-lijiazi@xiaomi.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jiazi Li <lijiazi@xiaomi.com>, dm-devel@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: fix NULL pointer issue when free bio
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 29 2021 at  7:59P -0400,
Jiazi Li <jqqlijiazi@gmail.com> wrote:

> dm_io_dec_pending call end_io_acct first, will dec md in-flight
> pending count. If a task is swapping table at same time.
> task1                             task2
> do_resume
>  ->do_suspend
>   ->dm_wait_for_completion
>                                   bio_endio
> 				   ->clone_endio
> 				    ->dm_io_dec_pending
> 				     ->end_io_acct
> 				      ->wakeup task1
>  ->dm_swap_table
>   ->__bind
>    ->__bind_mempools
>     ->bioset_exit
>      ->mempool_exit
>                                      ->free_io
> mempool->elements is NULL, and lead to following crash:
> [ 67.330330] Unable to handle kernel NULL pointer dereference at virtual
> address 0000000000000000
> ......
> [ 67.330494] pstate: 80400085 (Nzcv daIf +PAN -UAO)
> [ 67.330510] pc : mempool_free+0x70/0xa0
> [ 67.330515] lr : mempool_free+0x4c/0xa0
> [ 67.330520] sp : ffffff8008013b20
> [ 67.330524] x29: ffffff8008013b20 x28: 0000000000000004
> [ 67.330530] x27: ffffffa8c2ff40a0 x26: 00000000ffff1cc8
> [ 67.330535] x25: 0000000000000000 x24: ffffffdada34c800
> [ 67.330541] x23: 0000000000000000 x22: ffffffdada34c800
> [ 67.330547] x21: 00000000ffff1cc8 x20: ffffffd9a1304d80
> [ 67.330552] x19: ffffffdada34c970 x18: 000000b312625d9c
> [ 67.330558] x17: 00000000002dcfbf x16: 00000000000006dd
> [ 67.330563] x15: 000000000093b41e x14: 0000000000000010
> [ 67.330569] x13: 0000000000007f7a x12: 0000000034155555
> [ 67.330574] x11: 0000000000000001 x10: 0000000000000001
> [ 67.330579] x9 : 0000000000000000 x8 : 0000000000000000
> [ 67.330585] x7 : 0000000000000000 x6 : ffffff80148b5c1a
> [ 67.330590] x5 : ffffff8008013ae0 x4 : 0000000000000001
> [ 67.330596] x3 : ffffff80080139c8 x2 : ffffff801083bab8
> [ 67.330601] x1 : 0000000000000000 x0 : ffffffdada34c970
> [ 67.330609] Call trace:
> [ 67.330616] mempool_free+0x70/0xa0
> [ 67.330627] bio_put+0xf8/0x110
> [ 67.330638] dec_pending+0x13c/0x230
> [ 67.330644] clone_endio+0x90/0x180
> [ 67.330649] bio_endio+0x198/0x1b8
> [ 67.330655] dec_pending+0x190/0x230
> [ 67.330660] clone_endio+0x90/0x180
> [ 67.330665] bio_endio+0x198/0x1b8
> [ 67.330673] blk_update_request+0x214/0x428
> [ 67.330683] scsi_end_request+0x2c/0x300
> [ 67.330688] scsi_io_completion+0xa0/0x710
> [ 67.330695] scsi_finish_command+0xd8/0x110
> [ 67.330700] scsi_softirq_done+0x114/0x148
> [ 67.330708] blk_done_softirq+0x74/0xd0
> [ 67.330716] __do_softirq+0x18c/0x374
> [ 67.330724] irq_exit+0xb4/0xb8
> [ 67.330732] __handle_domain_irq+0x84/0xc0
> [ 67.330737] gic_handle_irq+0x148/0x1b0
> [ 67.330744] el1_irq+0xe8/0x190
> [ 67.330753] lpm_cpuidle_enter+0x4f8/0x538
> [ 67.330759] cpuidle_enter_state+0x1fc/0x398
> [ 67.330764] cpuidle_enter+0x18/0x20
> [ 67.330772] do_idle+0x1b4/0x290
> [ 67.330778] cpu_startup_entry+0x20/0x28
> [ 67.330786] secondary_start_kernel+0x160/0x170
> 
> Move end_io_acct after free_io to fix this issue.
> 
> Signed-off-by: Jiazi Li <lijiazi@xiaomi.com>

Thanks very much for this.  You did a wonderful job analyzing and
fixing this race.

I've tweaked the header slightly to improve clarity and made one
whitespace indentation adjustment.  I've now marked this for stable@
and queued this up.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

