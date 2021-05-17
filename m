Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CA3C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 20:09:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE13361002
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 20:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE13361002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-c-8Q6ZzMPEujadi8gemDZg-1; Mon, 17 May 2021 16:09:01 -0400
X-MC-Unique: c-8Q6ZzMPEujadi8gemDZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B3EB1854E24;
	Mon, 17 May 2021 20:08:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD4B19C9B;
	Mon, 17 May 2021 20:08:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6391355347;
	Mon, 17 May 2021 20:08:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HK8rrs024327 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 16:08:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9B39C1009136; Mon, 17 May 2021 20:08:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 972941112854
	for <dm-devel@redhat.com>; Mon, 17 May 2021 20:08:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A20780122D
	for <dm-devel@redhat.com>; Mon, 17 May 2021 20:08:50 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
	[209.85.221.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-18-L763D6HTM-aW6hXM5k9KxA-1; Mon, 17 May 2021 16:08:48 -0400
X-MC-Unique: L763D6HTM-aW6hXM5k9KxA-1
Received: by mail-wr1-f47.google.com with SMTP id i17so7693404wrq.11;
	Mon, 17 May 2021 13:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=Duwm/iFd8KECQNMNKx0/aJXwd2ybVVPG5qFnPmj1aGk=;
	b=AFEth4/URt3JYgYkEZh0y18Oyt9M0R1MBsZUXmRYKE6df6k5bqmntaxYxvMMmF+cal
	jciE4Ke+nFpEs6L+/pdBZtmnaIN1UTHUQcuQja+WMoYcdKLf2YPx+Ab/+p4rhvBr0TWh
	d4tpKiwuDuQt1V7FjSenq1rg7woKIgmSUT+iPQ/EPJExGHUwTZyiXXXIdNc5FGoF3ZAU
	BSfBrQJbP0AHy64SRS51vyR7VDxDYpQ+iDCyJZzfeyRR0oyTo+geH3P/Pg5QQd1SqkPi
	5ca3v/vOx2ESHQPsDER4gvfrtuMGDvmm/irWDBlQ4I8Ay7NE8QYkt37aS3mvUSpCLnkR
	04Ng==
X-Gm-Message-State: AOAM5314tg6SliDjWPy3wJREM2rBPtrp9GILDaZvpdyavJjAWO0NZ4h6
	xyZdNF7pH2Jllta4Bv2eW1VjFuklwA==
X-Google-Smtp-Source: ABdhPJw4XlO3F0l4HIqvyAQIESfmVYzZkeZ9yM+kPkf2aG3Rnwiz9VLTZ6LiZU8NTE8YWPcMf/s6Fg==
X-Received: by 2002:a05:6000:1541:: with SMTP id
	1mr1721331wry.364.1621282126776; 
	Mon, 17 May 2021 13:08:46 -0700 (PDT)
Received: from localhost ([90.160.137.52]) by smtp.gmail.com with ESMTPSA id
	f188sm464862wmf.24.2021.05.17.13.08.46
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 17 May 2021 13:08:46 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-5-mwilck@suse.com>
	<cb7300e3-9b91-df75-9343-06ae2c88d6ce@gmail.com>
	<addaed4d0bbb82f0a786eeb1d3066262a340ceaa.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <db3fb4b8-8179-661e-00b1-8fa8dd574b3c@gmail.com>
Date: Mon, 17 May 2021 22:08:45 +0200
MIME-Version: 1.0
In-Reply-To: <addaed4d0bbb82f0a786eeb1d3066262a340ceaa.camel@suse.com>
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
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/7] libdmmp: allow building without perl
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
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 5/17/21 10:04 PM, Martin Wilck wrote:

> On Mon, 2021-05-17 at 21:47 +0200, Xose Vazquez Perez wrote:
>> On 3/26/21 10:29 PM, mwilck@suse.com=A0wrote:
>>
>>> Add the kernel-doc generated manpages of libdmmp to git, and
>>> change the libdmmp Makefile to regenerate them (only) when
>>> necessary.
>>
>> Every month, nice try :-)
>=20
> Hm, doesn't happen here. What are you doing differently?
>=20
> $ make -C libdmmp docs/man/dmmp_strerror.3
> make: Entering directory '/mnt/git/mpath-tools/libdmmp'
> make: 'docs/man/dmmp_strerror.3' is up to date.
> make: Leaving directory '/mnt/git/mpath-tools/libdmmp'
>=20
> Likewise, "make install" won't rebuild any man pages.

Just:
$ git clone -b queue  https://github.com/openSUSE/multipath-tools
$ make
$ git diff

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

