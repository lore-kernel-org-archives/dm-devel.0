Return-Path: <SRS0=GX9t=JW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46373C433ED
	for <dm-devel@archiver.kernel.org>; Sun, 25 Apr 2021 16:01:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB67E611BD
	for <dm-devel@archiver.kernel.org>; Sun, 25 Apr 2021 16:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB67E611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-nMUB5k5EN4CBdHF0LBcZgg-1; Sun, 25 Apr 2021 12:01:11 -0400
X-MC-Unique: nMUB5k5EN4CBdHF0LBcZgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D503318397A3;
	Sun, 25 Apr 2021 16:01:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A5E15C255;
	Sun, 25 Apr 2021 16:01:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89C2189DC;
	Sun, 25 Apr 2021 16:01:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13PG0v38003458 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 25 Apr 2021 12:00:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4A4E01111A6F; Sun, 25 Apr 2021 16:00:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45F051111A6E
	for <dm-devel@redhat.com>; Sun, 25 Apr 2021 16:00:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81D33A28805
	for <dm-devel@redhat.com>; Sun, 25 Apr 2021 16:00:54 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
	[209.85.128.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-143-rYxhxvRXOcG3gHpukKPwfg-1; Sun, 25 Apr 2021 12:00:49 -0400
X-MC-Unique: rYxhxvRXOcG3gHpukKPwfg-1
Received: by mail-wm1-f47.google.com with SMTP id
	n4-20020a05600c4f84b029013151278decso3749091wmq.4; 
	Sun, 25 Apr 2021 09:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:subject:to:cc:references:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=H4bXcaSBTatv1HygDEgBVmbBypncwaDQjT73iMDYjNU=;
	b=AA1G3o0/MaW7nT3peageutkQsUHp+EM4NsrDoDlcV53RgSny4DkhoBeJh/viusyD4Z
	gAmhM9R4PkKRE4qopZIf1Zdv+0dT3o7ANDc3PPctd3MQgjFcAQz5lZv7beHuNgzF7RSn
	EQ+ptY8NKovwSji/M9ljsRsYo5PZp3OsbhhxOrqM4Dp5hdCenQBcIzHwohoo0q1IlyF1
	4EnhJZzQ5B3/a+e3GGTf2qU75i4r+kYY85Gh0YGcAlmxWpVEK1TRZLln+ADyxfsEX9Pg
	L9Pmy3cHp15huTbr04vFHtJmjBzkaACm8P4r5nKsBTGwVvNSjOuQstBfCL06lCxsYvwD
	0PyA==
X-Gm-Message-State: AOAM532ELaKLyHxyV9rQkXeM8hGHzSH6v2n/ZVv/52WV43IxEODuKvZQ
	RdIL9FTegmGCZ2LV1/QXng==
X-Google-Smtp-Source: ABdhPJyYv7Ost9JA+T9r4bJ3/k6LVlml4w0A/cD1Xi0T3SrNflFm7roIXmrxGkLy1f9BaWYMduFcsA==
X-Received: by 2002:a05:600c:414d:: with SMTP id
	h13mr927608wmm.62.1619366448423; 
	Sun, 25 Apr 2021 09:00:48 -0700 (PDT)
Received: from localhost (215.red-95-127-152.staticip.rima-tde.net.
	[95.127.152.215]) by smtp.gmail.com with ESMTPSA id
	k11sm16670767wmj.1.2021.04.25.09.00.47
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 25 Apr 2021 09:00:47 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Martin Wilck <mwilck@suse.com>
References: <20210325223414.5185-1-xose.vazquez@gmail.com>
	<f8a43dd00248218c96bd2cc06fb31c5aa41223f1.camel@suse.com>
Message-ID: <38fc1d23-4636-5b43-1f39-f5d6eebdd901@gmail.com>
Date: Sun, 25 Apr 2021 18:00:45 +0200
MIME-Version: 1.0
In-Reply-To: <f8a43dd00248218c96bd2cc06fb31c5aa41223f1.camel@suse.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/2] multipath-tools: add more ALUA info to
	docs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 3/26/21 5:36 PM, Martin Wilck wrote:

> On Thu, 2021-03-25 at 23:34 +0100, Xose Vazquez Perez wrote:
>> Xose Vazquez Perez (2):
>>  =A0 multipath-tools: add info about how to enable ALUA in Huawei
>> OceanStor arrays
>>  =A0 multipath-tools: add more info about ALUA for CLARiiON arrays
>>
>>  =A0README.alua | 5 ++++-
>>  =A01 file changed, 4 insertions(+), 1 deletion(-)
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
>> ---
>> BTW, some "new" generations of fully symmetrical Active-Active arrays
>> support ALUA
>> (by default ???), but in the multipath-tools hwtable they are defined
>> as "multibus":

[moved]

> Almost every (SCSI) array I've seen lately supports ALUA (even though
> some seem to interpret the standard quite freely).

Hitachi VSP is an exception.

> In general, we rely on the vendors for these matters. But if you have
> reliable information, I support changing this to "group_by_prio".

>> - IBM DS8000, since ???

For DS8000 there are no official docs. However
IBM/2107900 was added to the kernel with the alua handler in 2008:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D057ea7c9683c3d684128cced796f03c179ecf1c2
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/device_handler/scsi_dh_alua.c?id=3D057ea7c9683c3d684128cced796f03=
c179ecf1c2#n683

And a pair of recent logs:
https://marc.info/?l=3Dlinux-scsi&m=3D156407413807511
https://marc.info/?l=3Dlinux-scsi&m=3D155074069424506&q=3Dmbox

>> - IBM XIV, since Gen2 with microcode 10.2.1

https://www.ibm.com/support/pages/ibm-flashsystem%C2%AE-a9000-and-a9000r-hy=
perswap-solution-deployment-linux%C2%AE-ibm-z-systems%C2%AE
https://www.redbooks.ibm.com/redbooks/pdfs/sg248368.pdf (page 186 [172])

>> - EMC SYMMETRIX, since VMAX 3 with HYPERMAX OS 5977.811.784

https://www.delltechnologies.com/zh-tw/collaterals/unauth/technical-guides-=
support-information/products/storage-2/docu5128.pdf (page 164),
but no official config.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

