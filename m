Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5673DC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:53:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A820664E79
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A820664E79
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-RTfMDegQOfWjD62xWJ24sQ-1; Tue, 23 Feb 2021 17:53:55 -0500
X-MC-Unique: RTfMDegQOfWjD62xWJ24sQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF6641087D6E;
	Tue, 23 Feb 2021 22:53:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A180A10372C1;
	Tue, 23 Feb 2021 22:53:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27C1F58077;
	Tue, 23 Feb 2021 22:53:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NMrh7e015262 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 17:53:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6DC40200BFFD; Tue, 23 Feb 2021 22:53:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64E73200F444
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 22:53:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38620186E121
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 22:53:41 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-26-cw4vpwxRPTSLFBy0kUI0ug-1;
	Tue, 23 Feb 2021 17:53:36 -0500
X-MC-Unique: cw4vpwxRPTSLFBy0kUI0ug-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 22E00ACE5;
	Tue, 23 Feb 2021 22:38:53 +0000 (UTC)
Date: Tue, 23 Feb 2021 23:38:51 +0100
From: Petr Vorel <pvorel@suse.cz>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <YDWD+9dB8kx0ZPYR@pevik>
References: <20200928035605.22701-1-tusharsu@linux.microsoft.com>
	<20200928035605.22701-2-tusharsu@linux.microsoft.com>
	<20201221230531.GD4453@pevik>
	<28c14c80-660a-0f36-64ca-ae5230992032@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <28c14c80-660a-0f36-64ca-ae5230992032@linux.microsoft.com>
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
	dm-devel@redhat.com, ltp@lists.linux.it,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/2] IMA: generalize key measurement tests
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: Petr Vorel <pvorel@suse.cz>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

> Thanks for your review.
> My sincere apologies for missing this email and not responding in time.

> The device mapper measurement work is being revisited - to cover aspects
> like more DM targets (not just dm-crypt), better memory management,
> more relevant attributes from the DM targets, other corner cases etc.

> Therefore, even though this patch, "1/2: generalize key measurement
> tests", would be useful for other tests; I will have to revisit the
> second patch, "2/2: dm-crypt measurements", to address the DM side changes I
> mentioned above.

> I will revisit this series, esp. testing the DM target measurements
> part, once the kernel work I mentioned above is close to completion.

> I will also address your feedback on patch #1 and #2 from v2 iteration
> at that time.

> Thanks again for your review and feedback.

I updated your patchset a bit and going to send it to ML.

Kind regards,
Petr

> Thanks,
> Tushar

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

