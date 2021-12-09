Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2AC6C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  9 Dec 2021 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639063701;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oCdvAyxfLsQ6JIQGKzjhSeC+DA8FfJSZMpbyhJAPMHw=;
	b=RHaY+kTgaGMMNvckvAMCtCmyaFJgXIYNCiaj6IxHEphKxos54SsJz8ND8Ht4KknXndOCym
	RBRzydFzFQeQZlh+Lqb2Fi3ULXqh16Ln/bAE8UmThc8p8qKmTF7CwbF0STlPXbo8Uf1QEX
	lYQQyMb+P+vEdbuaTCFOx8at5SYwb+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-105-8wCtoNz_O0ydm7t_kxrByg-1; Thu, 09 Dec 2021 10:28:18 -0500
X-MC-Unique: 8wCtoNz_O0ydm7t_kxrByg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FE5181EE63;
	Thu,  9 Dec 2021 15:28:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 753B178C30;
	Thu,  9 Dec 2021 15:28:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 413301809CB8;
	Thu,  9 Dec 2021 15:28:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B9FS33Z010183 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 10:28:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBDA245D75; Thu,  9 Dec 2021 15:28:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CE0045D82;
	Thu,  9 Dec 2021 15:27:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1B9FRfWt028197; 
	Thu, 9 Dec 2021 09:27:41 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1B9FRetc028196;
	Thu, 9 Dec 2021 09:27:40 -0600
Date: Thu, 9 Dec 2021 09:27:40 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211209152740.GZ19591@octiron.msp.redhat.com>
References: <20211207200402.14157-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211207200402.14157-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/4] multipathd: service unit fixes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 07, 2021 at 09:03:58PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Hi Christophe, hi Ben,
> 
> this set drops some directives from multipathd's service unit which
> are to the best of my knowledge obsolete or redundant. It is part of an
> effort to eliminate the differences between the service unit we ship and the
> one which is shipped by dracut. The ultimate goal is to drop the
> multipathd.service file in dracut and use ours, which will make it
> easier to apply changes in the future.
> 
> I'll create a dracut pull request that goes with this set.
> 
> Regards
> Martin
> 
> Martin Wilck (4):
>   multipathd.service: remove LimitCORE=infinity directive
>   multipathd.service: don't load SCSI device handler modules
>   multipathd.service: add dependency on initrd-cleanup.service
>   multipathd.service: drop dependencies on iscsi and iscsid
> 
>  multipathd/multipathd.service | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> -- 
> 2.34.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

