Return-Path: <SRS0=K1eQ=L6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33323C07E96
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jul 2021 10:13:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B524B619A2
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jul 2021 10:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B524B619A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1625566408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jGwUclIbT3xOmoDWkX40quDbUyYdmMKsWX1D6ZPJGdQ=;
	b=FBKXFyzbwyw77KZwONn1gFJU7yaca3OPPrsYOMKdPPRXa/KQDxFMptPTnRJHYa2sO+OzW2
	iodYLXIhxe1C9axNGehsRwww9Pcb16+Wl6rZaDoXUhCvYFcS1MDUNeH1Oru63FvQZb4T+/
	c9YmpDz0IgZanlxtjGYjfRMW63CMcKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-xDGocmfGNr-WVa2rAsJPAA-1; Tue, 06 Jul 2021 06:13:27 -0400
X-MC-Unique: xDGocmfGNr-WVa2rAsJPAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CAC418D6A2C;
	Tue,  6 Jul 2021 10:13:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6769960583;
	Tue,  6 Jul 2021 10:13:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E5B24EA2A;
	Tue,  6 Jul 2021 10:13:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 166ADGWu019835 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 6 Jul 2021 06:13:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E55A202F2F5; Tue,  6 Jul 2021 10:13:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A1BE202F2F4
	for <dm-devel@redhat.com>; Tue,  6 Jul 2021 10:13:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6F001064FAE
	for <dm-devel@redhat.com>; Tue,  6 Jul 2021 10:13:12 +0000 (UTC)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
	[209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-116-fvNH2IugM06yc1npNhhKgw-1; Tue, 06 Jul 2021 06:13:11 -0400
X-MC-Unique: fvNH2IugM06yc1npNhhKgw-1
Received: by mail-wm1-f71.google.com with SMTP id
	l3-20020a05600c1d03b029021076e2b2f6so599922wms.4
	for <dm-devel@redhat.com>; Tue, 06 Jul 2021 03:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:to:cc:references:from:subject:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=UdbP9WvOMnnXkMiAx8SSh/Xyar5eu75VziOeoXPg7vQ=;
	b=maTMTnP21+c97ePwPvPcRTMzHbvkNKRX/SL1ClpC8CxPCq6WOI2zqUDk6YyIOZppyx
	jQYbIQM+oyh/VJ5IhLbHka8H1z541f0ebYgX5qyHyW5RFI4Q0BQHfmswBlPFQtJmI3EH
	CiGCTW33PI04IOZCsjbZ2vAP1RdO4yvCGjHtrLEYFKA5Zpq1zhDwsedo8Z9jz8D7L2be
	mcib3qMCSmGyEs8q5evbxSnX2hbJ8sds7i4MCooN4JjarKaaTwlKJdpogRWwnDX5uNm7
	fnhI+c7OdFYO9QzhbuLnChWmYrXP5abfbykDlcOwz/4VNoQOEJMP5mdydAcSdRullTqm
	o05A==
X-Gm-Message-State: AOAM530vhJe5VAhd736Z0ipnD+zUmEqgaPj0qp8V4QqMiFEWD4LWRoXy
	8mdaQwlIsBIy4SZa+veulMfUmn+uz0DsghVxh3ZmlBGI4xUVfn0MLJGlf4v9srs4jeCeAzdTUlE
	A3n6jacKe06cazKM=
X-Received: by 2002:adf:f54e:: with SMTP id j14mr20648364wrp.373.1625566390312;
	Tue, 06 Jul 2021 03:13:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4V2nazX3V0PXum+kvfO29LxwBUB/ZWyTGJPIPsll6HWmlVpOewleeKpK4mLBKQCrXh9hJEQ==
X-Received: by 2002:adf:f54e:: with SMTP id j14mr20648301wrp.373.1625566389908;
	Tue, 06 Jul 2021 03:13:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
	([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
	by smtp.gmail.com with ESMTPSA id w22sm2345342wmc.4.2021.07.06.03.13.08
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 06 Jul 2021 03:13:09 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
	<de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
	<20210701113442.GA10793@lst.de>
	<003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
	<e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
	<5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
	<a088aa5c8459c001403bda9384b38213f8232fc6.camel@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e5fc1d54-8443-49f4-078e-1453c6a97ba7@redhat.com>
Date: Tue, 6 Jul 2021 12:13:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a088aa5c8459c001403bda9384b38213f8232fc6.camel@suse.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, Mike Snitzer <snitzer@redhat.com>,
	emilne@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, nkoenig@redhat.com,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 05/07/21 15:48, Martin Wilck wrote:
> On Mo, 2021-07-05 at 15:11 +0200, Hannes Reinecke wrote:
>> On 7/5/21 3:02 PM, Paolo Bonzini wrote:
>>> On 02/07/21 16:21, Martin Wilck wrote:
>>>>> SG_IO gives you raw access to the SCSI logic unit, and you get
>>>>> to
>>>>> keep the pieces if anything goes wrong.
>>>>
>>>> That's a very fragile user space API, on the fringe of being
>>>> useless
>>>> IMO.
>>>
>>> Indeed.=A0 If SG_IO is for raw access to an ITL nexus, it shouldn't
>>> be supported at all by mpath devices.=A0 If on the other hand SG_IO is
>>> for raw access to a LUN, there is no reason for it to not support
>>> failover.
>>
>> Or we look at IO_URING_OP_URING_CMD, to send raw cdbs via io_uring.
>> And delegate SG_IO to raw access to an ITL nexus.
>> Doesn't help with existing issues, but should get a clean way
>> forward.
>=20
> I still have to understand how this would help with the retrying
> semantics. Wouldn't we get the exact same problem if a path error
> occurs?

Also, how would the URING_CMD API differ from SG_IO modulo one being a=20
ioctl and one being io_uring-based?  In the end what you have to do is=20
1) send a CDB and optionally some data 2) get back a status and=20
optionally some data and sense.  Whether the intended use of the API is=20
for an ITL nexus or a LUN doesn't really matter.  So, what is the=20
rationale for "SG_IO is for a nexus" in the first place, if you think=20
that "raw CDBs for a LUN" is a useful operation?  You can still use=20
DM_TABLE_STATUS (iirc) to address a specific ITL nexus if desired.

Besides the virtualization case, think of udev rules that use SG_IO to=20
retrieve the device identification page for an mpath device and create=20
corresponding symlinks in /dev.  They would fail if the first path is=20
not responding, which is not desirable.

Paolo

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

