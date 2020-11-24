Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A29C63777
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D6AFD206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6AFD206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-jJIX_p9mMbyR3icbifZbYg-1; Tue, 24 Nov 2020 12:39:06 -0500
X-MC-Unique: jJIX_p9mMbyR3icbifZbYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85FFC19251A3;
	Tue, 24 Nov 2020 17:38:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6734760C43;
	Tue, 24 Nov 2020 17:38:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EDF25002E;
	Tue, 24 Nov 2020 17:38:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHcsCA022028 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:38:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A2159112D177; Tue, 24 Nov 2020 17:38:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D6F3112C093
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:38:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 657298015A3
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:38:52 +0000 (UTC)
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com
	[209.85.222.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-47-qPkTvbmDNFe4jBomLLby-w-1; Tue, 24 Nov 2020 12:38:39 -0500
X-MC-Unique: qPkTvbmDNFe4jBomLLby-w-1
Received: by mail-qk1-f196.google.com with SMTP id u184so6904763qkf.3;
	Tue, 24 Nov 2020 09:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=g4LY6zleEye3uEtWn8BHkQWiPOUg2vGvLOmcGW0MhEo=;
	b=eT8sLWG2TR/S8gEl5pRlNdzSqalg0F4d2D+ov3PdiBaGs4Vr7UIObUjbGwsag+ue5y
	ixpABgh7GXXRcJyuT3KTw+UE+sYOp3vhsLU608aZakSMpB0V5X/Y0VfixCmOMV5wD104
	Ltb2v5GS2e3E2cfbIoEK65v5ezLl7GA8HvaXfAhVYzFWczFeOjMXIaMZwdUBcp6Csr61
	SHYPObysF9GhmdJbq9wXMI5I4ZQvd9RDYLIbnL6m6AhDZfbkol8g0cs0X6aSGRFKmt+n
	KhR5yNvhbb8a+MvmGoU/VD9GQg+pQiyErw/CJK+MA2Fz5PUq2mRQyHtUBwLsogqablmf
	TFzw==
X-Gm-Message-State: AOAM533wvEkcU/p9moQWrlv0/lN+4QxvtN3wyuoBtauOhuEjckoZJ8xV
	sYu8veOVuaC4nVVyvDi5j34=
X-Google-Smtp-Source: ABdhPJw43+aOSAPykQeYdeX4DmgWRqK+CIO4uPy4u98lyqJL8LkKiYWD+c6leseDOSmCa64pRPr2xg==
X-Received: by 2002:a37:e40b:: with SMTP id y11mr5925723qkf.29.1606239519064; 
	Tue, 24 Nov 2020 09:38:39 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	s7sm13183950qkm.124.2020.11.24.09.38.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:38:38 -0800 (PST)
Date: Tue, 24 Nov 2020 12:38:16 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71FCKpLZLywTTT8@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-17-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-17-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 16/45] block: change the hash used for
 looking up block devices
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:22PM +0100, Christoph Hellwig wrote:
> Adding the minor to the major creates tons of pointless conflicts. Just
> use the dev_t itself, which is 32-bits and thus is guaranteed to fit
> into ino_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

