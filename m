Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495D2EB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 06:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689834838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NG7cSKTDGHMjuzf2IGmkzbqoFAf6ePtMoi/vrxaS158=;
	b=Z4yilFz+8iih8g6arGeOydAr47cNLOxnbUccFIXxFSAStZmhjN/SJPVdSopjjkj4zI/25u
	cjoKCkXYd0B/732l/Ap2j7l0XGuWHR9HoZQkBvXgv3RgPif1vItMtWz7DztCNRfut+F9ev
	cXLU0nlr0Bbg3XYanLTUzTHTki7ZhoI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-0d5rcEv6NOmUm-Jwe61Jbg-1; Thu, 20 Jul 2023 02:33:55 -0400
X-MC-Unique: 0d5rcEv6NOmUm-Jwe61Jbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BA12185A793;
	Thu, 20 Jul 2023 06:33:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59CA4200B41D;
	Thu, 20 Jul 2023 06:33:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 28D1519465B9;
	Thu, 20 Jul 2023 06:33:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 442821946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Jul 2023 10:54:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14B321454143; Wed, 19 Jul 2023 10:54:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C3BE1454142
 for <dm-devel@redhat.com>; Wed, 19 Jul 2023 10:54:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B855029AB448
 for <dm-devel@redhat.com>; Wed, 19 Jul 2023 10:54:46 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
 [81.169.146.160]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-_b0AszP3NReVLZ84wYZh4A-1; Wed, 19 Jul 2023 06:54:44 -0400
X-MC-Unique: _b0AszP3NReVLZ84wYZh4A-1
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: ":J20NVVSndvp4466vFhCXUxk5AzpkHwfKmUFBoZWB6MoGGjIYlcL1veuiArSdmAK/Sg=="
Received: from jukebox.tomerius.de by smtp.strato.de (RZmta 49.6.4 DYNA|AUTH)
 with ESMTPSA id Y0a99ez6JApf0CC
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
 (Client did not present a certificate);
 Wed, 19 Jul 2023 12:51:41 +0200 (CEST)
Received: from [192.168.3.20] (helo=tomerius.de)
 by jukebox.tomerius.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
 (Exim 4.92) (envelope-from <kai@tomerius.de>)
 id 1qM4mS-0005X8-JQ; Wed, 19 Jul 2023 12:51:40 +0200
Date: Wed, 19 Jul 2023 12:51:39 +0200
From: Kai Tomerius <kai@tomerius.de>
To: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20230719105138.GA19936@tomerius.de>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTU=WsTaSowjkKT-snuvZwqWqnH3cdgGoCkToH02qEkgg@mail.gmail.com>
 <20230718053017.GB6042@tomerius.de>
 <CAEYzJUGC8Yj1dQGsLADT+pB-mkac0TAC-typAORtX7SQ1kVt+g@mail.gmail.com>
 <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
 <20230718213212.GE3842864@mit.edu>
MIME-Version: 1.0
In-Reply-To: <20230718213212.GE3842864@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 20 Jul 2023 06:33:33 +0000
Subject: Re: [dm-devel] File system robustness
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
Cc: =?iso-8859-1?Q?Bj=F8rn?= Forsman <bjorn.forsman@gmail.com>,
 dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 "Alan C. Assis" <acassis@gmail.com>, linux-embedded@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: tomerius.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> In answer to Kai's original question, the setup that was described
> should be fine --- assuming high quality hardware.

I wonder how to judge that ... it's an eMMC supposedly complying to
some JEDEC standard, so it *should* be ok.

> ... if power is cut suddenly, the data used by the Flash
> Translation Layer can be corrupted, in which case data written months
> or years ago (not just recent data) could be lost.

At least I haven't observed anything like that up to now.

But on another aspect: how about the interaction between dm-integrity
and ext4? Sure, they each have their own journal, and they're
independent layers. Is there anything that could go wrong, say a block
that can't be recovered in the dm-integrity layer, causing ext4 to run
into trouble, e.g., an I/O error that prevents ext4 from mounting?

I assume tne answer is "No", but can I be sure?

Thx
regards
Kai

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

