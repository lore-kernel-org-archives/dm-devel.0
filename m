Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F75C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 21:02:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D7D6207BB
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 21:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D7D6207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-wrq86jnVMDmyaKUM0bca1A-1; Wed, 04 Nov 2020 16:02:17 -0500
X-MC-Unique: wrq86jnVMDmyaKUM0bca1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60D288C88F9;
	Wed,  4 Nov 2020 21:02:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 065C170C3F;
	Wed,  4 Nov 2020 21:02:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B5B558122;
	Wed,  4 Nov 2020 21:02:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4L1H5o000758 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 16:01:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1FCD11112860; Wed,  4 Nov 2020 21:01:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C36C1112861
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 21:01:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEB158582BA
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 21:01:13 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-593-60Ke5Un9NIeBEHwgVB5Y4Q-1;
	Wed, 04 Nov 2020 16:01:10 -0500
X-MC-Unique: 60Ke5Un9NIeBEHwgVB5Y4Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3D477AB95;
	Wed,  4 Nov 2020 21:01:09 +0000 (UTC)
Message-ID: <4a490654f966e54e6540fcfc97bf6b32a37bee5b.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Date: Wed, 04 Nov 2020 22:01:08 +0100
In-Reply-To: <20201104161207.GD3384@octiron.msp.redhat.com>
References: <e77c4409175db94f97543991632c323a78ab3ef9.camel@suse.com>
	<20201102224048.GV3384@octiron.msp.redhat.com>
	<b0c9073c-1c1e-04d0-7edf-e2d66c0094be@suse.de>
	<20201104161207.GD3384@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] Thoughts about multipathd's log thread
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2020-11-04 at 10:12 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 04, 2020 at 03:11:04PM +0100, Hannes Reinecke wrote:
> > 
> > Well ... isn't that what the option '-d' is for?
> > Namely _not_ starting the log thread when running under systemd?
> 
> Martin is arguing that syslogd is at least as likely not to block as
> journald, so if we don't need the log thread when writing to journald
> (though stderr), we also don't need the log thread when writing to
> syslogd. Correct me, if I'm wrong Martin.

Exactly. The log thread has some race issues that we've been discussing
in another thread ("[PATCH v2 29/29] libmultipath: fix race between
log_safe and log_thread_stop()"). I had been digging into the code a
bit, and found some more things that I'd like to see improved. But I
realized fixing this for good might be hairy and take a lot of time
which would be better spent elsewhere, and started wondering if we
still need it at all.

Thanks,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

