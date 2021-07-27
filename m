Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C90C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 10:35:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5866C60FA0
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 10:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5866C60FA0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=thson.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-6GL4b9FKPJKkajldVLwN8g-1; Tue, 27 Jul 2021 06:35:33 -0400
X-MC-Unique: 6GL4b9FKPJKkajldVLwN8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A756D107ACF5;
	Tue, 27 Jul 2021 10:35:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1C3510074E5;
	Tue, 27 Jul 2021 10:35:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 680624BB7C;
	Tue, 27 Jul 2021 10:35:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16RAIOLH003592 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 06:18:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1E9A121417EB; Tue, 27 Jul 2021 10:18:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1928C21417F4
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 10:18:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06C9C802A64
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 10:18:21 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de
	[85.215.255.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-389-S81FBqhWN7WHCegF-37RYA-1; Tue, 27 Jul 2021 06:18:16 -0400
X-MC-Unique: S81FBqhWN7WHCegF-37RYA-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
	with ESMTPSA id t06ddcx6RAIAo5V
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Tue, 27 Jul 2021 12:18:10 +0200 (CEST)
From: Thore Sommer <public@thson.de>
To: tusharsu@linux.microsoft.com
Date: Tue, 27 Jul 2021 12:18:02 +0200
Message-Id: <20210727101802.779067-1-public@thson.de>
In-Reply-To: <c833339e-c4bf-6e78-5719-cd902fa8426f@linux.microsoft.com>
References: <c833339e-c4bf-6e78-5719-cd902fa8426f@linux.microsoft.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	dm-devel@redhat.com, public@thson.de,
	linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
	IMA
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Tushar,

I've now tested your patches more in depth. I've used the latest changes from
the dm-5.15 branch. Here are some things that I noticed during testing with
dm-verity. I'm relative new to IMA and device mapper, so there are also some
more general questions.

No new IMA measurement is generated if dm-verity verification fails. This is
unfortunate because to make the dm-verity measurements useful we need to be
notified when hash_failed is set to true. We will need something like
"device_update" where we remeasure the device state if it has changed.

Creating a dm-verity device with mount then removing it and now if you create it
again no measurement is generated. Is that the expected behavior?  
I would expect that new measurements for "table_load" and "device_resume" are
created even if the entries are identical the other ones before.

There is no way to verify if the root hash was verified against a signature. We
have "root_hash_sig_key_desc SIGNATURE_DESCRIPTION" in the dm table.
"SIGNATURE_DESCRIPTION" itself is not really useful because it seems that we
cannot map it back to the certificate that was used for verification but the
presence of "root_hash_sig_key_desc" might be enough in combination with
measuring the keyring.

Is there a reason that suspend is not measured?

How is the measured uuid created? The format seems to be
"CRYPT-VERITY-UUID-NAME" where UUID is uuid from the verity device and NAME is
the device mapper name. Does this naming come from the kernel or libcryptsetup?

What can happen in between a "table_load" and "device_resume" that is security
relevant?

For remote attestation services it would be nice if we have clear indicator from
what component the "ima-buf" entry was generated. Prefixing all "n-ng" field
entries with something like "dm_" would make it easier for us to add different
validators for different measurements that use the "ima-buf" template. The
keyring measurements already use "ima-buf" and using some kind of naming scheme
to easily differentiate the entries would be nice.

Not directly device mapper related, but it would be nice to also measure the
mount points and a mapping to the device IDs. The reasoning is that we can
measure if the target is correct but not if it was mounted correctly.  
In our case we can verify the trust of our initramfs that creates the dm-verity
device and then mounts it and if this fails refuses to boot, but that might not
always be the case.

Regards, 
Thore

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

