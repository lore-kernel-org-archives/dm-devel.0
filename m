Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3586EC0015E
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jul 2023 06:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690180459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LlgTVAvlVdRsmttCNRaPfu+XQHDIgRzv4uR8ILmL9Hw=;
	b=SDhCItIz8dC/la3zs5+/4Mt2QvadXE3+6NdJXEGFNs1L+GsXxczh2rRSPlEfra6A8YnBch
	IzbLCvFZVq5Cur3PA9/o9U4BWyYTEpjNnQ72aMo9y9VLhGmo2Ww6IRQEshyFpaGroHm1HL
	D5a/8jrckMnQqQNNE+nYPzAN57vrnJc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-KY7IVA5xMnWltFNdzhBPIQ-1; Mon, 24 Jul 2023 02:34:17 -0400
X-MC-Unique: KY7IVA5xMnWltFNdzhBPIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88B313C01E11;
	Mon, 24 Jul 2023 06:34:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03532C2C856;
	Mon, 24 Jul 2023 06:34:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 100A719451F0;
	Mon, 24 Jul 2023 06:34:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9B1EF1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Jul 2023 14:51:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85D344CD0E6; Fri, 21 Jul 2023 14:51:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E215492C13
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 14:51:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67960936D25
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 14:51:37 +0000 (UTC)
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-4lkw_eFePRGuh-4aLbea6A-1; Fri,
 21 Jul 2023 10:51:34 -0400
X-MC-Unique: 4lkw_eFePRGuh-4aLbea6A-1
Received: from 127.0.0.1 (localhost [127.0.0.1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
 (No client certificate requested)
 by mail.lichtvoll.de (Postfix) with ESMTPSA id E2FE274C065;
 Fri, 21 Jul 2023 16:51:31 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 21 Jul 2023 16:51:31 +0200
Message-ID: <4918028.0VBMTVartN@lichtvoll.de>
In-Reply-To: <20230721133526.GF5764@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <38426448.10thIPus4b@lichtvoll.de> <20230721133526.GF5764@mit.edu>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 24 Jul 2023 06:34:11 +0000
Subject: Re: [dm-devel] Nobarrier mount option (was: Re: File system
 robustness)
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lichtvoll.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Theodore Ts'o - 21.07.23, 15:35:26 CEST:
> > At least that is what I thought was the background for not doing the
> > "nobarrier" thing anymore: Let the storage below decide whether it
> > is safe to basically ignore cache flushes by answering them (almost)
> > immediately.
> 
> The problem is that the storage below (e.g., the HDD) has no idea that
> all of this redundancy exists.  Only the system adminsitrator who is
> configuring the file sysetm will know.  And if you are runninig a
> hyper-scale cloud system, this kind of custom made system will be
> much, MUCH, cheaper than buying a huge number of $$$ EMC storage
> arrays.

Okay, that is reasonable.

Thanks for explaining.

-- 
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

