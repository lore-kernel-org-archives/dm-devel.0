Return-Path: <SRS0=Ylab=J3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5C6C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 21:13:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 236A261466
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 21:13:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 236A261466
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-iP8qnxkGNpCGZCvPefivxg-1; Fri, 30 Apr 2021 17:13:03 -0400
X-MC-Unique: iP8qnxkGNpCGZCvPefivxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34EC8107ACC7;
	Fri, 30 Apr 2021 21:12:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 347FB19C66;
	Fri, 30 Apr 2021 21:12:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 656F855341;
	Fri, 30 Apr 2021 21:12:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13ULCtdl030671 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Apr 2021 17:12:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 04DEA209A818; Fri, 30 Apr 2021 21:12:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00287209A817
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 21:12:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E6788CDDEE
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 21:12:51 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
	[209.85.210.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-31-bUyW8Ae1OP2tBmhxr-lorQ-1; Fri, 30 Apr 2021 17:12:49 -0400
X-MC-Unique: bUyW8Ae1OP2tBmhxr-lorQ-1
Received: by mail-pf1-f170.google.com with SMTP id b27so972192pfp.9;
	Fri, 30 Apr 2021 14:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=IJVRbjgMjkBqhc3MOP/kRS9kVrpbjy+Gj7VZlV7M4Sw=;
	b=fjDR12lvf/Wg0wFcaYILiHRXJFjQaLd3022IdJ/Ufluy0xjEpNC+/GLkwoUcIvMBEl
	oF09yRgKaHxOeYK//Fi5qbXa6H1cq89Y/zTc95G4IG4RkOD3XQqjpXx9I2oifIACHhsW
	GuwDzo4u8SkngU6TYEu1RDXWwyMTXQzlMKvw2tRUAnutqFuf9FMLRtJMnnt64tYISGk0
	++aB0KNdipwQ+VUUsF9vAdQ4KB2uA6Qlz2UkUILz1oVI6FU6HmpN2uMvO4JB/7lxoAHD
	WWB7oLRWTp+8rfXuBq6BUMvg0fiNHnV12wSu+Pha3syFF+DmTkTB1uPVNJmVhCNjUuK1
	fcag==
X-Gm-Message-State: AOAM533I9d+jYLdOn21V1nJymfCNKlf8ZEuP1vimtlk6jhz3WAJ32oXd
	nWYrJ55JgCbX8entmhsjXn0=
X-Google-Smtp-Source: ABdhPJz3eL+t6Dg1nqOMtbXH8G3Q/sOwzwjQbJpqJixOkSvPC4i/h6TqfkrtvQUScR89exTuAoOjyA==
X-Received: by 2002:a63:205d:: with SMTP id r29mr6472707pgm.340.1619817167797; 
	Fri, 30 Apr 2021 14:12:47 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a75c:e2e0:cb86:23e0?
	([2601:647:4000:d7:a75c:e2e0:cb86:23e0])
	by smtp.gmail.com with ESMTPSA id
	m188sm2821390pfm.167.2021.04.30.14.12.46
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 30 Apr 2021 14:12:46 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
References: <20210429155024.4947-1-mwilck@suse.com>
	<20210429155024.4947-2-mwilck@suse.com>
	<08440651-6e8f-734a-ef43-561d9c2596a6@acm.org>
	<bb30875e11913a33bcaf491d0f752132ebb9ce5e.camel@suse.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <39a59df5-9fdb-a1f1-39a2-c41b62e8076c@acm.org>
Date: Fri, 30 Apr 2021 14:12:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <bb30875e11913a33bcaf491d0f752132ebb9ce5e.camel@suse.com>
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
Cc: linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] scsi: convert
 scsi_result_to_blk_status() to inline
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
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On 4/29/21 1:33 PM, Martin Wilck wrote:
> On Thu, 2021-04-29 at 09:20 -0700, Bart Van Assche wrote:
>> On 4/29/21 8:50 AM, mwilck@suse.com=A0wrote:
>>> This makes it possible to use scsi_result_to_blk_status() from
>>> code that shouldn't depend on scsi_mod (e.g. device mapper).
>>
>> I think that's the wrong reason to make a function inline. Please
>> consider moving scsi_result_to_blk_status() into one of the block
>> layer
>> source code files that already deals with SG I/O, e.g.
>> block/scsi_ioctl.c.
>=20
> scsi_ioctl.c, are you certain? scsi_result_to_blk_status() is an
> important part of the block/scsi interface... You're right that that
> this function is not a prime candidate for inlining, but I'm still
> wondering where it belongs if we don't.

The block/scsi_ioctl.c file is included in the kernel if and only if
BLK_SCSI_REQUEST is enabled. And that Kconfig symbol only selects the
block/scsi_ioctl.c file. Additionally, the following occurs in the SCSI
Kconfig file:

config SCSI
=09tristate "SCSI device support"
=09[ ... ]
=09select BLK_SCSI_REQUEST

In other words, block/scsi_ioctl.c is built unconditionally if SCSI is
enabled. Adding the scsi_result_to_blk_status() function to the
block/scsi_ioctl.c file would increase the size of kernels that enable
bsg, ide, the SCSI target code or nfsd but not the SCSI initiator code.
If the latter is a concern, how about moving scsi_result_to_blk_status()
into a new file in the block directory?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

