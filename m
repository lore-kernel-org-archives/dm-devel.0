Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2582C636D6
	for <dm-devel@archiver.kernel.org>; Thu, 23 Feb 2023 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677156028;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4yHjWctq9uNky111uAYd0rrQHbpF3OEK4/haKoATN/g=;
	b=L2Glmavgd+QSFUehheRptWAyE0n1lwGughSIO7aqB0KBDNQbJJKJ11ugPtmKatkhXiwyMm
	fqRDglsXbrtjkF05i+QXpE3xNObrNPpLaDtV6vRHFFfuHc6q4PfdOXwxeuMJ5m81OOaL5o
	qcHY9ROMz+iTK/ITbb9cv7Ds/dR3Kx0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-a8CqZq5cNVygn0PnkVCXKA-1; Thu, 23 Feb 2023 07:40:25 -0500
X-MC-Unique: a8CqZq5cNVygn0PnkVCXKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6E143C0F22C;
	Thu, 23 Feb 2023 12:40:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8A852026D38;
	Thu, 23 Feb 2023 12:40:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C62D319465B1;
	Thu, 23 Feb 2023 12:40:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 92F5819465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Feb 2023 12:40:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F9EC2166B2B; Thu, 23 Feb 2023 12:40:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 389112166B29
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 12:40:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AF45101A521
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 12:40:08 +0000 (UTC)
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-502-jZUdELYUN2iMGgNaHviwGQ-1; Thu,
 23 Feb 2023 07:40:06 -0500
X-MC-Unique: jZUdELYUN2iMGgNaHviwGQ-1
Received: from authenticated user by stravinsky.debian.org with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2) (envelope-from <zeha@debian.org>)
 id 1pVAYt-009Uiv-21; Thu, 23 Feb 2023 12:18:59 +0000
Date: Thu, 23 Feb 2023 13:18:57 +0100
From: Chris Hofstaedtler <zeha@debian.org>
To: Thomas Glanzmann <thomas@glanzmann.de>
Message-ID: <20230223121857.kadue7dwoynayqni@zeha.at>
References: <Y/YVZ61NB4aP0lHM@glanzmann.de>
MIME-Version: 1.0
In-Reply-To: <Y/YVZ61NB4aP0lHM@glanzmann.de>
X-Debian-User: zeha
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] NetAPP AFF A220 - Debian - multipathing setup
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, team+linux-blocks@tracker.debian.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

* Thomas Glanzmann <thomas@glanzmann.de> [230222 14:15]:
> Hello,
> I have Debian bullseye connected to an AFF A220 NetApp iSCSI target with
> ALUA enabled. I see two paths, however multipathd doesn't seem to
> configure a multipath device for the two paths. Find the output of the
> following commands here:

> multipath -T

>   find_multipaths "strict"

Per multipath.conf(5):

| strict    Both multipath and multipathd treat only such devices as multipath devices which have been
|           part of a multipath map previously, and which are  therefore  listed  in  the  wwids_file.
|           Users can manually set up multipath maps using the multipathd add map command. Once set up
|           manually, the map is remembered in the wwids file and will be set up automatically in  the
|           future.

I would guess your wwids/bindings files are empty, and thus you need to
follow the advice in the manpage: use multipathd add map, or maybe
multipath -a.

If you decide to change find_multipaths, I would suggest verifying
that your resulting setup works across reboots, etc.

By the way, I think the current recommendation for modern NetApp
platforms is `prio "alua"`, not `ontap`. Would be good if NetApp
would confirm this somehow/somewhere.

Best,
Chris

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

