Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E41EC4361B
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 14:10:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AA3E920798
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 14:10:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA3E920798
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-VAq1FEBlPnGBf6AM6LtIIw-1; Mon, 14 Dec 2020 09:10:19 -0500
X-MC-Unique: VAq1FEBlPnGBf6AM6LtIIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1CCD192CC41;
	Mon, 14 Dec 2020 14:10:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B34210021AA;
	Mon, 14 Dec 2020 14:10:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 094774BB7B;
	Mon, 14 Dec 2020 14:10:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEEA8Rb018168 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 09:10:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BAD635F262; Mon, 14 Dec 2020 14:10:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5BFA5F253
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 14:10:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35B4F8007DF
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 14:10:06 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-183-NgxTqtbwNLWx2Ljzv3bgdA-1;
	Mon, 14 Dec 2020 09:10:04 -0500
X-MC-Unique: NgxTqtbwNLWx2Ljzv3bgdA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 94445AC10;
	Mon, 14 Dec 2020 14:10:01 +0000 (UTC)
Message-ID: <c60f83ab769989c400554ed98c89a8c8bb51d8c3.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 14 Dec 2020 15:10:00 +0100
In-Reply-To: <CABr-GnfpHZ97dqD_XrgggjDVzK+_1g-sU-SHic_2jA2S=TDK0Q@mail.gmail.com>
References: <CABr-GnfTqde6t2LFTHbrRkp1qMVbsRUEFBqU6tW1M_uR1svHFg@mail.gmail.com>
	<d40f6d93d398a3bbb6b9a42d67f47521d35c4d65.camel@suse.com>
	<CABr-GnfpHZ97dqD_XrgggjDVzK+_1g-sU-SHic_2jA2S=TDK0Q@mail.gmail.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] uxsock_timeout default value in man page
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, 2020-12-14 at 11:19 +0100, Christophe Varoqui wrote:
> Thank you for the review, the commit is in.
> 
> the user reporting this, seems to face exactly the problem mentioned
> in 7db0c44 :
> 
> commit 7db0c4466c0e5ed2179710f93d1d14a0bf92922a
> ...
>     And the default timeout should be increased to 4 seconds to
> ensure
>     multipath runs correctly on large installations.
> 
> He clearly qualifies as "large installation", and reach that timeout
> when submitting a large number of mpathpersist registers in parallel
> on boot.
> Regardless, needing a uxsock_timeout greater than 4 seconds hints we
> do something non-optimal there.
> Have you already had a chance to investigate possible enhancements on
> this ?

Not yet. To solve this for good, I think we'd eventually need to tackle
the BML (Big Multipathd Lock). Nobody has attempted to do this yet. Wrt
to the special mpathpersist case, it would perhaps be possible to
figure out some other optimization (first idea: rather than running
dozens of mpathpersist processes during boot time, why not set the
correct keys in the prkeys file right away?). We'd need to understand
how they are using mpathpersist. That sounds like a case for the user's
support team in the first place.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

