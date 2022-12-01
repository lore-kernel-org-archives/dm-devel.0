Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9F0C43217
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 07:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669879701;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZQ1z9NlvyLI391QmDqVoBK3bFwK6PF/GLYHhIspe48c=;
	b=RNnQhlwb74W8RvXG69EVivzk7S7Rgk0Pi4YgnU0jmlueYBkd4Vd9ByRoNA6zCOZ96zNaR3
	lvlu4mQPDmdiXesKXJPHbLzsWe0iBsaKc5Kkj250hKDj+uFcMlUgKkKv1HnOVfWKF3MxAu
	7ZSqy18DTQSlqAFwwpRwgKNCmTjYZSo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-U5-WZETuODWIWenKhu2rBA-1; Thu, 01 Dec 2022 02:28:17 -0500
X-MC-Unique: U5-WZETuODWIWenKhu2rBA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DFC8800186;
	Thu,  1 Dec 2022 07:28:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1771A2166B47;
	Thu,  1 Dec 2022 07:28:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF7D919465A8;
	Thu,  1 Dec 2022 07:28:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90D9D19465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 07:28:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 75DEA111F3B6; Thu,  1 Dec 2022 07:28:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F45C1121314
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 07:28:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B4AD1C05157
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 07:28:12 +0000 (UTC)
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net
 [217.70.178.231]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-2pZxXgSKOk6YYk8fEc0eZw-1; Thu, 01 Dec 2022 02:28:10 -0500
X-MC-Unique: 2pZxXgSKOk6YYk8fEc0eZw-1
Received: (Authenticated sender: peter@korsgaard.com)
 by mail.gandi.net (Postfix) with ESMTPSA id BBC14100004;
 Thu,  1 Dec 2022 07:28:06 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.94.2)
 (envelope-from <peter@korsgaard.com>)
 id 1p0dzJ-006Ism-Jn; Thu, 01 Dec 2022 08:28:05 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: Mike Snitzer <snitzer@redhat.com>
References: <20221116061656.2345538-1-peter@korsgaard.com>
 <877czkhc7u.fsf@dell.be.48ers.dk> <Y4fiQvg9OOATD5Cv@redhat.com>
Date: Thu, 01 Dec 2022 08:28:05 +0100
In-Reply-To: <Y4fiQvg9OOATD5Cv@redhat.com> (Mike Snitzer's message of "Wed, 30
 Nov 2022 18:07:46 -0500")
Message-ID: <87bkond1mi.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 dm-devel@redhat.com, fabio.aiuto@amarulasolutions.com,
 Helen Koike <helen.koike@collabora.com>, michael@amarulasolutions.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Hi,

 > On Thu, Nov 24 2022 at  5:35P -0500,
 > Peter Korsgaard <peter@korsgaard.com> wrote:

 >> > +	if (waitfor[0])
 >> > +		DMINFO("all devices available");
 >> > +

 > Why 20?  Also, why is waiting indefinitely OK?  Would really like to
 > hear from other consumers of dm-init that this module param is useful
 > and needed.

Mainly because of checkpatch.pl ;) prepare_namespace() uses msleep(5)
but checkpatch complains about it, so I made it 20 instead. It doesn't
really matter much, as long as it is small enough to not delay boots too
much (E.G. this is typically used for embedded system where boot time is
critical).

I would say that it DOES make sense to wait forever, similar to how it
is done in prepare_namespace() when rootwait is passed. This waitfor
bootargs is used for root-on-dm, so we cannot continue until the
underlying devices are available.

As mentioned,
https://lore.kernel.org/all/20220406154631.277107-1-fabio.aiuto@amarulasolutions.com/
is an alternatively (less nice) approach to solve the same issue, so yes
- It is useful and needed.

-- 
Bye, Peter Korsgaard

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

