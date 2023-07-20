Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277DAC0015E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jul 2023 06:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689921504;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EfIfnjaxtI5M/LHDFeq0pYuTNQNtH4YOqvyg1qrJoys=;
	b=eC+8GQuf9q/jTxU3i6Y5Kk26pHLTZx3oWv9L6fWtsiF9gd75g0Gx1rZcy9tfs+k+NG/YTh
	j2+ZqFXAIiZkUIGvtXlerWBdTXCsrCTelr+t6jCOr2DGvV8+3NqJLPk+begCZhKV0USfIn
	ZX3APbDDOG5TXNwDOQJbjicDp6V0fpI=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-O3-PAcUwPu-V3vRAgAxtEg-1; Fri, 21 Jul 2023 02:38:20 -0400
X-MC-Unique: O3-PAcUwPu-V3vRAgAxtEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD2921C060D7;
	Fri, 21 Jul 2023 06:38:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E26A1401C2E;
	Fri, 21 Jul 2023 06:38:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F30291946A43;
	Fri, 21 Jul 2023 06:38:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 334861946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 07:55:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CFA201454143; Thu, 20 Jul 2023 07:55:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B031454142
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 07:55:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A95048F1841
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 07:55:30 +0000 (UTC)
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-fcHqTvf6Nn6qjXNhby7rBw-1; Thu,
 20 Jul 2023 03:55:25 -0400
X-MC-Unique: fcHqTvf6Nn6qjXNhby7rBw-1
Received: from 127.0.0.1 (localhost [127.0.0.1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
 (No client certificate requested)
 by mail.lichtvoll.de (Postfix) with ESMTPSA id 225317497FD;
 Thu, 20 Jul 2023 09:55:23 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 20 Jul 2023 09:55:22 +0200
Message-ID: <38426448.10thIPus4b@lichtvoll.de>
In-Reply-To: <20230720042034.GA5764@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <4835096.GXAFRqVoOG@lichtvoll.de> <20230720042034.GA5764@mit.edu>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Fri, 21 Jul 2023 06:38:07 +0000
Subject: [dm-devel] Nobarrier mount option (was: Re: File system robustness)
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
Cc: linux-embedded@vger.kernel.org, dm-devel@redhat.com,
 Kai Tomerius <kai@tomerius.de>,
 =?ISO-8859-1?Q?Bj=F8rn?= Forsman <bjorn.forsman@gmail.com>,
 Ext4 Developers List <linux-ext4@vger.kernel.org>,
 "Alan C. Assis" <acassis@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lichtvoll.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Theodore Ts'o - 20.07.23, 06:20:34 CEST:
> On Wed, Jul 19, 2023 at 08:22:43AM +0200, Martin Steigerwald wrote:
> > Is "nobarrier" mount option still a thing? I thought those mount
> > options have been deprecated or even removed with the introduction
> > of cache flush handling in kernel 2.6.37?
> 
> Yes, it's a thing, and if your server has a UPS with a reliable power
> failure / low battery feedback, it's *possible* to engineer a reliable
> system.  Or, for example, if you have a phone with an integrated
> battery, so when you drop it the battery compartment won't open and
> the battery won't go flying out, *and* the baseboard management
> controller (BMC) will halt the CPU before the battery complete dies,
> and gives a chance for the flash storage device to commit everything
> before shutdown, *and* the BMC arranges to make sure the same thing
> happens when the user pushes and holds the power button for 30
> seconds, then it could be safe.

Thanks for clarification. I am aware that something like this can be 
done. But I did not think that is would be necessary to explicitly 
disable barriers, or should I more accurately write cache flushes, in 
such a case:

I thought that nowadays a cache flush would be (almost) a no-op in the 
case the storage receiving it is backed by such reliability measures. 
I.e. that the hardware just says "I am ready" when having the I/O 
request in stable storage whatever that would be, even in case that 
would be battery backed NVRAM and/or temporary flash.

At least that is what I thought was the background for not doing the 
"nobarrier" thing anymore: Let the storage below decide whether it is 
safe to basically ignore cache flushes by answering them (almost) 
immediately.

However, not sending the cache flushes in the first place would likely 
still be more efficient although as far as I am aware block layer does not 
return back a success / failure information to the upper layers anymore 
since kernel 2.6.37.

Seems I got to update my Linux Performance tuning slides about this once 
again.

> We also use nobarrier for a scratch file systems which by definition
> go away when the borg/kubernetes job dies, and which will *never*
> survive a reboot, let alone a power failure.  In such a situation,
> there's no point sending the cache flush, because the partition will
> be mkfs'ed on reboot.  Or, in if the iSCSI or Cloud Persistent Disk
> will *always* go away when the VM dies, because any persistent state
> is saved to some cluster or distributed file store (e.g., to the MySQL
> server, or Big Table, or Spanner, etc.  In these cases, you don't
> *want* the Cache Flush operation, since skipping it reduce I/O
> overhead.

Hmm, right.

> So if you know what you are doing, in certain specialized use cases,
> nobarrier can make sense, and it is used today at my $WORK's data
> center for production jobs *all* the time.  So we won't be making
> ext4's nobarrier mount option go away; it has users.  :-)

I now wonder why XFS people deprecated and even removed those mount 
options. But maybe I better ask them separately instead of adding their 
list in CC. Probably by forwarding this mail to the XFS mailing list 
later on.

Best,
-- 
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

