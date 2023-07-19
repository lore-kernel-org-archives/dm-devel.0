Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DDCC0015E
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jul 2023 07:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689750200;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fj3QONLmWpUGXhsTn8cBK/VfxfFXLv/vZ7LG89dBjg0=;
	b=Osnw9BMxdj7/sn6sKBRVm1dcUahtgixrTK4lsvCG4AP26BMIl6t2KM88sj7+2ezlOgxkji
	OLgZNWzpPX+RCO3QALH96bLeoPNd8b7R93Hwc8pzo10hB9dzdnqwpP4uxTMu+XEYTRNX6+
	M6DWBe0cUk5vIrhShSzrtgV8KNFRrB8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-439gGKZkN8-XtF-u-Ho2oQ-1; Wed, 19 Jul 2023 03:03:16 -0400
X-MC-Unique: 439gGKZkN8-XtF-u-Ho2oQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFAE988D704;
	Wed, 19 Jul 2023 07:03:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E153B10E56;
	Wed, 19 Jul 2023 07:03:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD89219465A0;
	Wed, 19 Jul 2023 07:03:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0C46F1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Jul 2023 06:32:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD3AA200B41D; Wed, 19 Jul 2023 06:32:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A585A200AD6E
 for <dm-devel@redhat.com>; Wed, 19 Jul 2023 06:32:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A17E3C0BE29
 for <dm-devel@redhat.com>; Wed, 19 Jul 2023 06:32:54 +0000 (UTC)
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-PCwehmqzP_6FlXi5ITBlHg-1; Wed,
 19 Jul 2023 02:32:52 -0400
X-MC-Unique: PCwehmqzP_6FlXi5ITBlHg-1
Received: from 127.0.0.1 (localhost [127.0.0.1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
 (No client certificate requested)
 by mail.lichtvoll.de (Postfix) with ESMTPSA id 4FB5F747857;
 Wed, 19 Jul 2023 08:22:44 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Alan C. Assis" <acassis@gmail.com>, Theodore Ts'o <tytso@mit.edu>
Date: Wed, 19 Jul 2023 08:22:43 +0200
Message-ID: <4835096.GXAFRqVoOG@lichtvoll.de>
In-Reply-To: <20230718213212.GE3842864@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
 <20230718213212.GE3842864@mit.edu>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 19 Jul 2023 07:03:10 +0000
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
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Forsman <bjorn.forsman@gmail.com>,
 dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 linux-embedded@vger.kernel.org, Kai Tomerius <kai@tomerius.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lichtvoll.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Theodore Ts'o - 18.07.23, 23:32:12 CEST:
> If you get it all right, you'll be fine.  On the other hand, if you
> have crappy hardware (such as might be found for cheap in the checkout
> counter of the local Micro Center, or in a back alley vendor in
> Shenzhen, China), or if you do something like misconfigure the file
> system such as using the "nobarrier" mount option "to speed things
> up", or if you have applications that update files in an unsafe
> manner, then you will have problems.

Is "nobarrier" mount option still a thing? I thought those mount options 
have been deprecated or even removed with the introduction of cache flush 
handling in kernel 2.6.37?

Hmm, the mount option has been removed from XFS in in kernel 4.19 
according to manpage, however no mention of any deprecation or removal 
in ext4 manpage. It also does not seem to be removed in BTRFS at least 
according to manpage btrfs(5).

-- 
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

