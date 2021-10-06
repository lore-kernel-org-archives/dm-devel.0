Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FA5C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:18:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26C6B610C8
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26C6B610C8
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633526290;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gAWqEMIq8B6bx/AE8D3dtS+E827RMM2TSNFLnDdHFpM=;
	b=XN4LAYgs/cjqWBE7iiEXAvFVL+89eCORRC4XwgsDMUd1r09WDfD8tm2i5JuLRLV9r+jpJ2
	I/T0G70W14uWg0N5BjolB43gl1scYUjxGlEW6HSwNzQEACO8z/+uPa1FFGavkqfnT49XcA
	l8z4PHWJZzvTr54e+QKOAqyu+mwU76w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-npU1wC75MWWfmeqoMY8ZNg-1; Wed, 06 Oct 2021 09:18:06 -0400
X-MC-Unique: npU1wC75MWWfmeqoMY8ZNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 141B6835DE0;
	Wed,  6 Oct 2021 13:18:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D76219723;
	Wed,  6 Oct 2021 13:18:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E7FEA180598A;
	Wed,  6 Oct 2021 13:17:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196DHsBj014164 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 09:17:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 299A32157F3D; Wed,  6 Oct 2021 13:17:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23D252157F3B
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:17:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A32F811E76
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:17:54 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-InbcGAvKMS21Q38DpME9cA-1; Wed, 06 Oct 2021 09:17:52 -0400
X-MC-Unique: InbcGAvKMS21Q38DpME9cA-1
Received: by mail-qv1-f72.google.com with SMTP id
	4-20020a05621420a400b003831d93e2b5so655184qvd.12
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 06:17:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=+zbCfVnHe3hEOXNTzkBOuBqFXs5HnnXgmi37Lbo5cf0=;
	b=gQrQdd4gPFOk+dosaXeLoj9dxefFUbxrbEJw/m0iNEWbr02E6GkMPfzCn7exWP2et/
	CtiTUPsUwKH4jy3HlkYiGuWuOEV+WGT6hbG85LIXLvHSDRSmD8DtwU+tlPRNbgQ8y7oI
	LSlNSoY82QRQUS3z+Z00zh2SYJY54hElp5tbGvRQokl32LXNcSmd3Y3oeXaNUyYNp/7z
	YK6ZfFCG/gnBm4YIlxOah5hEFYgwEaF4cKEcomMtaJ1YXdiWU2eI50j7LkAfFFBozjp+
	/AY0NtTAe6flsQIoJutkG108MCHQNYqt/vWxepHV+sPZaXVlcDJH/+fVGCBBTRHMw6gs
	yM9A==
X-Gm-Message-State: AOAM531mz5cJALdiJq/7xysUujkg9SSbY+Jr00Eg4rb/F06XJvNAbJbH
	TeMikaw8SMUbMdjCWw6ujBcwmv589cbMjU6Tb1sdZA5lj7VCwlyW0wp8QikT7SUK/7wfPgwDwly
	7scHGFIF4r19u7Q==
X-Received: by 2002:a05:622a:180f:: with SMTP id
	t15mr25944901qtc.314.1633526271473; 
	Wed, 06 Oct 2021 06:17:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJ/dfz8opFCb2v5qUfLE0aMcIttTRFyUR16Rj5nDfAcBalXCGeyEeOx/El3NjgM1QYp0hnaw==
X-Received: by 2002:a05:622a:180f:: with SMTP id
	t15mr25944862qtc.314.1633526271274; 
	Wed, 06 Oct 2021 06:17:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	r17sm12574405qtx.17.2021.10.06.06.17.50
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 06:17:50 -0700 (PDT)
Date: Wed, 6 Oct 2021 09:17:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
	sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
	ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
	agk@redhat.com, josef@toxicpanda.com
Message-ID: <YV2h/iA79JhMJt07@redhat.com>
References: <20210927215958.1062466-1-mcgrof@kernel.org>
	<20210927215958.1062466-5-mcgrof@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210927215958.1062466-5-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org
Subject: Re: [dm-devel] [PATCH v4 4/6] dm: add add_disk() error handling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 27 2021 at  5:59P -0400,
Luis Chamberlain <mcgrof@kernel.org> wrote:

> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> There are two calls to dm_setup_md_queue() which can fail then,
> one on dm_early_create() and we can easily see that the error path
> there calls dm_destroy in the error path. The other use case is on
> the ioctl table_load case. If that fails userspace needs to call
> the DM_DEV_REMOVE_CMD to cleanup the state - similar to any other
> failure.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

