Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E44DC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 08:40:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69E6C613CC
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 08:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69E6C613CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619685603;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c+a4aet3M0OAx5ga+jCfAXWdBIWMBsVA9/QJ9U20Ep4=;
	b=KBwxDIjnVWfqwR3gDpZ/CyROCd13rd0/8X4aMNWO1sZ/4jTD8IcOqNj8hdWZV9bLshcVaO
	3fkk0eGAaK/OWocukaGmZMBMRHrr6m06on1ppGbsAo4pVIedbkYvAUPjDS2JVaSYZVL1LG
	87JHnE2sdMbPpnHPisSpcgsj7eLU5S0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-NH2KKvf7Nf-dPee9kLYRaA-1; Thu, 29 Apr 2021 04:40:00 -0400
X-MC-Unique: NH2KKvf7Nf-dPee9kLYRaA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 246E080EDAF;
	Thu, 29 Apr 2021 08:39:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E8B15D9C6;
	Thu, 29 Apr 2021 08:39:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0A97944A5E;
	Thu, 29 Apr 2021 08:39:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13T8drmb001070 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 04:39:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 775A420BDB2B; Thu, 29 Apr 2021 08:39:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 726D920BDB2A
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 08:39:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 091CA109DCFF
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 08:39:51 +0000 (UTC)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
	[209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-272-gMersTBQMtm8W9gTdnENag-1; Thu, 29 Apr 2021 04:39:49 -0400
X-MC-Unique: gMersTBQMtm8W9gTdnENag-1
Received: by mail-ed1-f70.google.com with SMTP id
	w15-20020a056402268fb02903828f878ec5so28362625edd.5
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 01:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=YziHZFF8ZYjt6d2ezm44ghu0dLtw0EhgTLZDtPz5/rc=;
	b=A0OFS/pGGzdGKHmBwGjXI9T3yTlIDZJlyBMem1L/R0Diumvv2nhHijkZzzHiszSVUe
	ha6q2tiZFhm/HEYCaju2CiXBkxKn21I3WgcvEC8jZ8Ba+Jbx4p4jWfg5I90u2fznnqpo
	FnZha4RF2JwnRLUqILHRl1v6z2/JSx1gaTI45Qtx8Ew3brutBxQ4oxWzv071RppsW1HM
	L4NvMIODw0NgJMy4XqAmNxaQosxwgGvxHnXQ5yWaNmUUrBwDfxjk35faf377b5ZFjYZb
	Vnjm0uMn1sv2xl5XCsoJB7gufHcUyHY/wAJzpUMYbVulpm8w4RrUnlUUy94Ki/B4dyN1
	wJOw==
X-Gm-Message-State: AOAM5316NcqU4o7Qhhx6z93VjEJ66Aqo1OQ1aj2uBfw/OR6/B11vbF+e
	eNBK7P0LdL9D8aMVYft20ktRl6fnD6sQ2xmAyT1ZEv0F915sdV+fErzVlNkbhPpXABJKSnhPLZN
	seiN3q4nHcR5UX2U=
X-Received: by 2002:aa7:cc03:: with SMTP id q3mr17091511edt.366.1619685587965; 
	Thu, 29 Apr 2021 01:39:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwd2TXhakCnmeWFFLQi2DCo7bfYX6fBe4+mzuRAM9OilcI3eUClhNV3iEkoklK6AA8G03NA3Q==
X-Received: by 2002:aa7:cc03:: with SMTP id q3mr17091498edt.366.1619685587829; 
	Thu, 29 Apr 2021 01:39:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
	([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
	by smtp.gmail.com with ESMTPSA id e4sm1388137ejh.98.2021.04.29.01.39.46
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 29 Apr 2021 01:39:47 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@redhat.com>
References: <20210422202130.30906-1-mwilck@suse.com>
	<20210428195457.GA46518@lobo>
	<26ac367a5a09ff5de628717721425fbc03018f44.camel@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <395bdc56-137d-5f1d-ac0a-0ac5b76c02b3@redhat.com>
Date: Thu, 29 Apr 2021 10:39:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <26ac367a5a09ff5de628717721425fbc03018f44.camel@suse.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: dm_blk_ioctl(): implement failover for SG_IO on
	dm-multipath
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 29/04/21 10:33, Martin Wilck wrote:
> On Wed, 2021-04-28 at 15:54 -0400, Mike Snitzer wrote:
>>
>> @@ -626,32 +626,16 @@ static int dm_sg_io_ioctl(struct block_device
>> *bdev, fmode_t mode,
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
>>  =20
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rhdr.info & SG_INFO=
_CHECK) {
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
 See if this is a target or path error.
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
 Compare blk_path_error(),
>> scsi_result_to_blk_status(),
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
 blk_errors[].
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
/
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sw=
itch (rhdr.host_status) {
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ca=
se DID_OK:
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (scsi_status_is_good(rhdr.status))
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 0;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0break;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ca=
se DID_TARGET_FAILURE:
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -EREMOTEIO;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ca=
se DID_NEXUS_FAILURE:
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -EBADE;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ca=
se DID_ALLOC_FAILURE:
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -ENOSPC;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ca=
se DID_MEDIUM_ERROR:
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -ENODATA;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0de=
fault:
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* Everything else is a path error */
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bl=
k_status_t sts =3D
>> scsi_result_to_blk_status(rhdr.host_status, NULL);
>=20
> This change makes dm_mod depend on scsi_mod.
> Would you seriously prefer that over a re-implementation of the logic?

You could just make it an inline function too.

Paolo

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

