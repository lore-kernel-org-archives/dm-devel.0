Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA61C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669913463;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z8QuImFWinFprmjUQ7HSyOnxNEnaIAEsSICapbCcUiI=;
	b=hc8KFm6QVc9chEV3dvHdBXsotFY1Pkqbmzx9nrGcAudHJSGcGH7hLy7n9GYeRdeXHTjbng
	WyRGiCSomZ4fwQPW+bWnYS5a18TppunjucDJc2nH6tqYYxJfTSrgVvmUhTM5iBfNmOGI3y
	vG+/Zl5v8UFHCFmLCjU2lUil7Xv60qI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-CRIUcBsMN2qV9zw7sHzqig-1; Thu, 01 Dec 2022 11:51:00 -0500
X-MC-Unique: CRIUcBsMN2qV9zw7sHzqig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B50151C08791;
	Thu,  1 Dec 2022 16:50:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69B9F111E3EA;
	Thu,  1 Dec 2022 16:50:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 418BD19465A8;
	Thu,  1 Dec 2022 16:50:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4CF6719465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 16:50:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 192784EA52; Thu,  1 Dec 2022 16:50:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11B407AE5
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 16:50:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEEA01C08793
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 16:50:56 +0000 (UTC)
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net
 [217.70.178.240]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-lF3Ry5lKNfebirzpyHZ-xQ-1; Thu, 01 Dec 2022 11:50:53 -0500
X-MC-Unique: lF3Ry5lKNfebirzpyHZ-xQ-1
Received: from relay4-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::224])
 by mslow1.mail.gandi.net (Postfix) with ESMTP id E088ACF3B0;
 Thu,  1 Dec 2022 16:38:42 +0000 (UTC)
Received: (Authenticated sender: peter@korsgaard.com)
 by mail.gandi.net (Postfix) with ESMTPSA id E46F6E0002;
 Thu,  1 Dec 2022 16:38:36 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.94.2)
 (envelope-from <peter@korsgaard.com>)
 id 1p0ma3-006iwA-Mk; Thu, 01 Dec 2022 17:38:35 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: Mike Snitzer <snitzer@redhat.com>
References: <20221116061656.2345538-1-peter@korsgaard.com>
 <877czkhc7u.fsf@dell.be.48ers.dk> <Y4fiQvg9OOATD5Cv@redhat.com>
 <87bkond1mi.fsf@dell.be.48ers.dk> <Y4jSkNJzTtRZSbrg@redhat.com>
Date: Thu, 01 Dec 2022 17:38:35 +0100
In-Reply-To: <Y4jSkNJzTtRZSbrg@redhat.com> (Mike Snitzer's message of "Thu, 1
 Dec 2022 11:13:04 -0500")
Message-ID: <871qpjcc50.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2] dm init: add dm-mod.waitfor to wait for
 asynchronously probed block devices
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
Cc: Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@kernel.org>,
 Helen Koike <helen.koike@collabora.com>, fabio.aiuto@amarulasolutions.com,
 dm-devel@redhat.com, michael@amarulasolutions.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Hi,

 >> As mentioned,
 >> https://lore.kernel.org/all/20220406154631.277107-1-fabio.aiuto@amarulasolutions.com/
 >> is an alternatively (less nice) approach to solve the same issue, so yes
 >> - It is useful and needed.

 > OK, so it should be easy for others to say so, right?

Yes. Fabio, you pointed me to the earlier patch, so you presumably need
something like this as well, right?


 > My hesitation is that it feels like something that could be papering
 > over device specific issues with their async initialization?  Even if
 > that is the case, it'd be nice to know _why_ this change is needed.
 > IMHO, the patch header stops short of offering compelling and informed
 > justification.

Well, it is exactly like the rootwait option we have for normal (non-dm)
root= handling, so it is for the same use cases / issues.

A lot of embedded / non-initramfs setups use rootwait today because of
the async initialization logic. If those setups want to use root-on-dm
(E.G. for dm-verity) then they need to use this dm_mod.waitfor= instead
of rootwait.

rootwait was added by:

commit cc1ed7542c8c26af0f501da8006b9fce03e9aaca
Author: Pierre Ossman <drzeus-list@drzeus.cx>
Date:   Sun Jul 15 23:40:35 2007 -0700

    init: wait for asynchronously scanned block devices

    Some buses (e.g.  USB and MMC) do their scanning of devices in the
    background, causing a race between them and prepare_namespace().  In order
    to be able to use these buses without an initrd, we now wait for the device
    specified in root= to actually show up.

    If the device never shows up than we will hang in an infinite loop.  In
    order to not mess with setups that reboot on panic, the feature must be
    turned on via the command line option "rootwait".

    [bunk@stusta.de: root_wait can become static]
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

-- 
Bye, Peter Korsgaard

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

