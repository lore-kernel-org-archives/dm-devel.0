Return-Path: <SRS0=rkDd=LI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3E5C2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 14 Jun 2021 15:15:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5A486128B
	for <dm-devel@archiver.kernel.org>; Mon, 14 Jun 2021 15:15:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5A486128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623683746;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/mBnCR4dddLcZPa5lbmZfNgsj8hKWw5LR3n98DHLXtI=;
	b=bRbFnZX2f1t1Wp9LNG4Ui3kqyP4xZuYcirzKPdlnhdFc+Wpd8IVlUF8+Duj3RGCC94tqnc
	ojLRIhlgamNExbcUjxFrJMXvjdqsWW67et2KoHdmrHS2QbhZH7NJE4/Ys8tPLEnEQwoHIu
	6fSQr0Hl+KogLDGK789tBtLSVwXdRe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-AfHyMQkxM-O5wkS6s07Djw-1; Mon, 14 Jun 2021 11:15:45 -0400
X-MC-Unique: AfHyMQkxM-O5wkS6s07Djw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 600051922037;
	Mon, 14 Jun 2021 15:15:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91BC219C46;
	Mon, 14 Jun 2021 15:15:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E9DA1809CAC;
	Mon, 14 Jun 2021 15:15:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15EFFWO8009474 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Jun 2021 11:15:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C7111112C076; Mon, 14 Jun 2021 15:15:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1A8D112C071
	for <dm-devel@redhat.com>; Mon, 14 Jun 2021 15:15:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E33F518E0920
	for <dm-devel@redhat.com>; Mon, 14 Jun 2021 15:15:25 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
	[209.85.219.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-157-_pndczo-MSGrpA-UmnxEkg-1; Mon, 14 Jun 2021 11:15:21 -0400
X-MC-Unique: _pndczo-MSGrpA-UmnxEkg-1
Received: by mail-qv1-f44.google.com with SMTP id if15so9761990qvb.2;
	Mon, 14 Jun 2021 08:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=ZGk/FA6XxJotBQ1URjiWbasLNGa5cJUSnfXjO2+742k=;
	b=CdXKmqdMKyQds8v2q56AmpqL51BWgFADdk9n+66aYXOBfyI0nLsaTEDu6GFbxuTRtY
	bJF0O1z7cw9y4rPm8wc/MSfoL7SGLXdtPcqDcN0HQtXTPsKMhLJihsW0Jqmop2mu838V
	mxzhOXve3KdOGqsC4H+kHV+iXlcvL7YbQu8nY/OGUIROjntBmUaO6BYmsUgYAZO/D77n
	rrh3oj/gCaCIKVc5DbsDUTbe94Zm1QN6SyE0kFUQvJAx2SQlsPqE6oSBJ8tCCUu2JcO0
	2zE8jK/UJRDK4SZOrIItXDP7RJlpxaO7CM6UdkhWoc+uJ3FIdP6JGy1VjKwdMyqmjTOX
	wMyA==
X-Gm-Message-State: AOAM532KHSdLIHDidTheuwO2/hHzdNTD/2Uoy1ZzqxLg3PAdtwPP+Pvo
	fd0yp5KkO3R58+n6rByd9WfaKfbALPyP9w==
X-Google-Smtp-Source: ABdhPJyAqNDr60raHRfjT+q3Sts7H3aWjsFFkX73RBcG/iIK+h5Cc6F9UIoka2tDB7DvrS5FNqdIhg==
X-Received: by 2002:ad4:4146:: with SMTP id z6mr16633948qvp.36.1623683721047; 
	Mon, 14 Jun 2021 08:15:21 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	h5sm10542086qkg.122.2021.06.14.08.15.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 14 Jun 2021 08:15:20 -0700 (PDT)
Date: Mon, 14 Jun 2021 11:15:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: mwilck@suse.com
Message-ID: <YMdyh62mR/lEifMR@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210611202509.5426-1-mwilck@suse.com>
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
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/2] dm: dm_blk_ioctl(): implement
 failover for SG_IO on dm-multipath
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 11 2021 at  4:25P -0400,
mwilck@suse.com <mwilck@suse.com> wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> Hello Mike,
> 
> here is v3 of my attempt to add retry logic to SG_IO on dm-multipath devices.
> Sorry that it took such a long time.
> 
> Regards
> Martin
> 
> Changes v2->v3:
> 
>  - un-inlined scsi_result_to_blk_status again, and move the helper
>    __scsi_result_to_blk_status to block/scsi_ioctl.c instead
>    (Bart v. Assche)
>  - open-coded the status/msg/host/driver-byte -> result conversion
>    where the standard SCSI helpers aren't usable (Bart v. Assche)

This work offers a proof-of-concept but it needs further refinement
for sure.

The proposed open-coded SCSI code (in patch 2's drivers/md/dm-scsi_ioctl.c) 
is well beyond what I'm willing to take in DM.  If this type of
functionality is still needed (for kvm's SCSI passthru snafu) then
more work is needed to negotiate proper interfaces with the SCSI
subsystem (added linux-scsi to cc, odd they weren't engaged on this).

Does it make sense to extend the SCSI device handler interface to add
the required enablement? (I think it'd have to if this line of work is
to ultimately get upstream).

Mike

  
> Changes v1->v2:
> 
>  - applied modifications from Mike Snitzer
>  - moved SG_IO dependent code to a separate file, no scsi includes in
>    dm.c any more
>  - made the new code depend on a configuration option 
>  - separated out scsi changes, made scsi_result_to_blk_status()
>    inline to avoid dependency of dm_mod from scsi_mod (Paolo Bonzini)
> 
> Martin Wilck (2):
>   scsi: export __scsi_result_to_blk_status() in scsi_ioctl.c
>   dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO on dm-multipath
> 
>  block/scsi_ioctl.c         |  52 ++++++++++++++-
>  drivers/md/Kconfig         |  11 ++++
>  drivers/md/Makefile        |   4 ++
>  drivers/md/dm-core.h       |   5 ++
>  drivers/md/dm-rq.h         |  11 ++++
>  drivers/md/dm-scsi_ioctl.c | 127 +++++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c            |  20 +++++-
>  drivers/scsi/scsi_lib.c    |  29 +--------
>  include/linux/blkdev.h     |   3 +
>  9 files changed, 229 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/md/dm-scsi_ioctl.c
> 
> -- 
> 2.31.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

