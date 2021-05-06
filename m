Return-Path: <SRS0=LgXV=KB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F08C433ED
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 09:34:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0CD5C61132
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 09:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CD5C61132
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-H08PbhuPPSCiFRTgdAuc-Q-1; Thu, 06 May 2021 05:34:02 -0400
X-MC-Unique: H08PbhuPPSCiFRTgdAuc-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C52FC1008061;
	Thu,  6 May 2021 09:33:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8E721002388;
	Thu,  6 May 2021 09:33:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 922A21800B8A;
	Thu,  6 May 2021 09:33:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1469XpKx023946 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 May 2021 05:33:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8DD8E2ED97; Thu,  6 May 2021 09:33:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8958711FC8C
	for <dm-devel@redhat.com>; Thu,  6 May 2021 09:33:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFED585828E
	for <dm-devel@redhat.com>; Thu,  6 May 2021 09:33:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-166-ErJE6vHGOs2c49h7MwvE3w-1;
	Thu, 06 May 2021 05:33:44 -0400
X-MC-Unique: ErJE6vHGOs2c49h7MwvE3w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4A334B17E;
	Thu,  6 May 2021 09:14:57 +0000 (UTC)
Date: Thu, 6 May 2021 11:14:55 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, zohar@linux.ibm.com,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Message-ID: <YJOzjw0k+ZgWaQO3@pevik>
References: <20200928035605.22701-1-tusharsu@linux.microsoft.com>
	<20200928035605.22701-3-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20200928035605.22701-3-tusharsu@linux.microsoft.com>
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
Cc: snitzer@redhat.com, dm-devel@redhat.com, agk@redhat.com,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, ltp@lists.linux.it
Subject: Re: [dm-devel] [PATCH v2 2/2] IMA: Add test for dm-crypt measurement
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

Hi Tushar, Mimi, Lakshmi,

> New functionality is being added to IMA to measure data provided by
> kernel components. With this feature, IMA policy can be set to enable
> measuring data provided by device-mapper targets. Currently one such
> device-mapper target - dm-crypt, is being updated to use this
> functionality. This new functionality needs test automation in LTP.

> Add a testcase which verifies that the IMA subsystem correctly measures
> the data coming from a device-mapper target - dm-crypt.

I noticed v10 patchset [1] has been merged, including SELinux commit
fdd1ffe8a812 ("selinux: include a consumer of the new IMA critical data hook"),
thus I merge this patchset.

I suppose fdd1ffe8a812 is the commit which should be mentioned in
ima_dm_crypt.sh, right? (the only change to v3 [2])

Kind regards,
Petr

[1] https://lore.kernel.org/linux-integrity/20210108040708.8389-1-tusharsu@linux.microsoft.com/
[2] https://patchwork.ozlabs.org/project/ltp/list/?series=230766&state=*

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

