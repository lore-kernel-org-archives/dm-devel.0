Return-Path: <SRS0=a4Wy=L5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB57C07E99
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:02:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05DCB6144E
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05DCB6144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1625490156;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l6HYUmoUG9RTn7HHSgyoOyJlFBwpENOvtYwWhmcEYYA=;
	b=jV+bmQsqusFhzE0Wo03LvEzFT1pvsx61i3WWvATvsPtkJUP3a5Kt48N/G6VxVdDn1JCqUP
	qWLeSV1XGe+OobBgzQVuAt92weMv5Ewu3C4jV73RbDb0u32mpZknUbkwPesAbb6SPhJpUp
	M4ZpDXeJ2Zo9ghUAiMrz+MMF7yLc260=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-LRlRAvWpMK2zZDIeFxm0Uw-1; Mon, 05 Jul 2021 09:02:35 -0400
X-MC-Unique: LRlRAvWpMK2zZDIeFxm0Uw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 903D956B2C;
	Mon,  5 Jul 2021 13:02:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7259860C0F;
	Mon,  5 Jul 2021 13:02:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46C121809C99;
	Mon,  5 Jul 2021 13:02:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 165D2Hxv018626 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 5 Jul 2021 09:02:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 31A2F2023437; Mon,  5 Jul 2021 13:02:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C63C2023434
	for <dm-devel@redhat.com>; Mon,  5 Jul 2021 13:02:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D87AD89C7DC
	for <dm-devel@redhat.com>; Mon,  5 Jul 2021 13:02:13 +0000 (UTC)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
	[209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-251-6T2nDMfuMsqoQfxaLF3NCg-1; Mon, 05 Jul 2021 09:02:12 -0400
X-MC-Unique: 6T2nDMfuMsqoQfxaLF3NCg-1
Received: by mail-wm1-f69.google.com with SMTP id
	z4-20020a1ce2040000b02901ee8d8e151eso9873644wmg.1
	for <dm-devel@redhat.com>; Mon, 05 Jul 2021 06:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=EQiaDZSDRoWhnvLd0y+F7CVOe8BAX1HmtgpDqCLODno=;
	b=r/510Z33qIwb5WabACn+funvWrSg8QwM5TjbFYS/A2ffs/3rj6rnVYy95TJDijlpB4
	8eIEtDhY+s9ZO2Z2MkNIJRuSLxKQW3a2B5Qt+SzgYZzDWuX2+x44vMwAnXe6Y5v6Cjsh
	Zbcwblf4V6DSaVCGNJWqEJGVFpLR8W6KCBIW0zmPUisiDM7Q0mSETR/Kbh3Aci1z8CVl
	wEYQq5HiM6baAdthfWQVbQz0ntX3yLup9OXtZizvzCVO0jzmoPY4UVAwiUyc4Akr6unt
	hNn/VBB7KyMp2DQqN2HLFzvM+plUgFHRGwbc9zR/nijgvaLxwc0z5IPf4yRfmC+u/Y75
	Dn0w==
X-Gm-Message-State: AOAM533munhsU9i68nXnSrYcrKrjZIB/jmznP2OmBn5eXNpuTv9OZfV9
	msMuzALXMflHK8ZhAjzo8o2t3MdAWSZ0juh7+IJwQkqKzFL10UwuEbEwFTDerxWJVwuXgPdSGdR
	HBoFdd8pIDexpq8Y=
X-Received: by 2002:a7b:ca43:: with SMTP id m3mr14772428wml.74.1625490131334; 
	Mon, 05 Jul 2021 06:02:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzS6R45eQdBafjJCfhd1vm8LmWsahyCdE9gLBl2N2UbSQMBfrvMPQtX8pBLO/KLwWonQWqk0g==
X-Received: by 2002:a7b:ca43:: with SMTP id m3mr14772386wml.74.1625490130998; 
	Mon, 05 Jul 2021 06:02:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
	([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
	by smtp.gmail.com with ESMTPSA id
	16sm12186756wmk.18.2021.07.05.06.02.09
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 05 Jul 2021 06:02:09 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
	<de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
	<20210701113442.GA10793@lst.de>
	<003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
Date: Mon, 5 Jul 2021 15:02:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, emilne@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 02/07/21 16:21, Martin Wilck wrote:
>> SG_IO gives you raw access to the SCSI logic unit, and you get to
>> keep the pieces if anything goes wrong.
> 
> That's a very fragile user space API, on the fringe of being useless
> IMO.

Indeed.  If SG_IO is for raw access to an ITL nexus, it shouldn't be
supported at all by mpath devices.  If on the other hand SG_IO is for
raw access to a LUN, there is no reason for it to not support failover.

Paolo

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

