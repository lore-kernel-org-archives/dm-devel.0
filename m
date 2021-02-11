Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF62C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 14:45:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECF6464E92
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 14:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECF6464E92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613054747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hp724HGX7DrvcxYHySFumcQt9EHInT2jO0OCH6E67cA=;
	b=Ui7Ec4BGKd9zPHKMLSnvQ+GegS9J7Q74uHs515IwFWhETaWJCnr64kseD1ZwvusGASe6a4
	ixLEgSANStW1GaecMfCqnr0EfZDygpUq1gJNDlwqgAC41HLAp5VZ1j5u51aFoFrUL4sfmd
	yw9Ch0IJat38qOwVIZFjR0OhP2THj2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-GH5rkxijOna9EUDs4SUiaA-1; Thu, 11 Feb 2021 09:45:42 -0500
X-MC-Unique: GH5rkxijOna9EUDs4SUiaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FD8100CCC7;
	Thu, 11 Feb 2021 14:45:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D949A60936;
	Thu, 11 Feb 2021 14:45:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A1C2818095CB;
	Thu, 11 Feb 2021 14:45:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BEjah7010497 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 09:45:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6F2A110016F6; Thu, 11 Feb 2021 14:45:36 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 587A910016F8;
	Thu, 11 Feb 2021 14:45:33 +0000 (UTC)
Date: Thu, 11 Feb 2021 09:45:32 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <20210211144532.GB13067@redhat.com>
References: <20210211142243.31062-1-ntsironis@arrikto.com>
MIME-Version: 1.0
In-Reply-To: <20210211142243.31062-1-ntsironis@arrikto.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v2] dm era: only resize metadata in preresume
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 11 2021 at  9:22am -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Metadata resize shouldn't happen in the ctr. The ctr loads a temporary
> (inactive) table that will only become active upon resume. That is why
> resize should always be done in terms of resume. Otherwise a load (ctr)
> whose inactive table never becomes active will incorrectly resize the
> metadata.
> 
> Also, perform the resize directly in preresume, instead of using the
> worker to do it.
> 
> The worker might run other metadata operations, e.g., it could start
> digestion, before resizing the metadata. These operations will end up
> using the old size.
> 
> This could lead to errors, like:
> 
>   device-mapper: era: metadata_digest_transcribe_writeset: dm_array_set_value failed
>   device-mapper: era: process_old_eras: digest step failed, stopping digestion
> 
> The reason of the above error is that the worker started the digestion
> of the archived writeset using the old, larger size.
> 
> As a result, metadata_digest_transcribe_writeset tried to write beyond
> the end of the era array.
> 
> Fixes: eec40579d84873 ("dm: add era target")
> Cc: stable@vger.kernel.org # v3.15+
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> ---
>  drivers/md/dm-era-target.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)

Thanks, I replaced the patch I created (that used a worker to resize
from preresume) with this.

Now staged for 5.12.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

