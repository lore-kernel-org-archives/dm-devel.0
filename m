Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D84BC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 07:12:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D8FB61999
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 07:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D8FB61999
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617088332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Bd8mqldCMBMOb8q8QhUhTpMc+kyT7WO5SGbBUGGyjLY=;
	b=LLQYHCZ2CLLRuK4C4tv5SX1b+xulahu0r74eZ1L0MJ1mh3sO4RUmJ51WT4Y6V4SuVN2vDN
	sEOWbJQids+eiNrM9z3FCGd4BOpF0l2Sw/A14JilAUEurhax4OOgYo9/f08sSChWq4Imn0
	+EJw2xv3Wwl7EtpLIfo9yX8BvuJoZwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-pr0kmcQOOCyIlFoPpRVCwg-1; Tue, 30 Mar 2021 03:12:10 -0400
X-MC-Unique: pr0kmcQOOCyIlFoPpRVCwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2F298030DD;
	Tue, 30 Mar 2021 07:12:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7CB219706;
	Tue, 30 Mar 2021 07:12:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6AF9D1809C83;
	Tue, 30 Mar 2021 07:12:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U76Kro009750 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 03:06:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ECA363AC0; Tue, 30 Mar 2021 07:06:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 828D6669F3;
	Tue, 30 Mar 2021 07:06:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12U76Gf4007610; 
	Tue, 30 Mar 2021 02:06:16 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12U76Fpw007609;
	Tue, 30 Mar 2021 02:06:15 -0500
Date: Tue, 30 Mar 2021 02:06:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210330070615.GQ15006@octiron.msp.redhat.com>
References: <20210329203935.19691-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210329203935.19691-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: give up "add missing path" after
 multiple failures
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

On Mon, Mar 29, 2021 at 10:39:35PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> After b7aae60 ("multipathd: improve "add missing path" handling"),
> a path that failed to initialize after multiple udev retriggers
> would still be checked in check_path(). However, if a path is up,
> has been checked more than once, the failback WWID methods have
> been tried, and still there is no usable WWID, we may conclude
> that something is fishy and we shouldn't keep trying.
> 
> Without this patch, totally WWID-less devices (seen e.g. on ESXi)
> will cause a "add missing path" message in every checker iteration.
> 
> Fixes: b7aae60 ("multipathd: improve "add missing path" handling")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 16 ++++++++++++++++
>  multipathd/main.c        |  6 ++++--
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index f804414..ec99a7a 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -2370,6 +2370,22 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  			if (pp->initialized != INIT_FAILED) {
>  				pp->initialized = INIT_MISSING_UDEV;
>  				pp->tick = conf->retrigger_delay;
> +			} else if (pp->retriggers >= conf->retrigger_tries &&
> +				   (pp->state == PATH_UP || pp->state == PATH_GHOST)) {
> +				/*
> +				 * We have failed to read udev info for this path
> +				 * repeatedly. We used the fallback in get_uid()
> +				 * if there was any, and still got no WWID,
> +				 * although the path is allegedly up.
> +				 * It's likely that this path is not fit for
> +				 * multipath use.
> +				 */
> +				char buf[16];
> +
> +				snprint_path(buf, sizeof(buf), "%T", pp, 0);
> +				condlog(1, "%s: no WWID in state \"%s\", giving up",
> +					pp->dev, buf);
> +				return PATHINFO_SKIPPED;
>  			}
>  			return PATHINFO_OK;
>  		}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 3579bad..102946b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2218,13 +2218,13 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  				ev_add_path(pp, vecs, 1);
>  				pp->tick = 1;
>  			} else {
> +				if (ret == PATHINFO_SKIPPED)
> +					return -1;
>  				/*
>  				 * We failed multiple times to initialize this
>  				 * path properly. Don't re-check too often.
>  				 */
>  				pp->checkint = max_checkint;
> -				if (ret == PATHINFO_SKIPPED)
> -					return -1;
>  			}
>  		}
>  		return 0;
> @@ -2504,6 +2504,8 @@ checkerloop (void *ap)
>  		vector_foreach_slot (vecs->pathvec, pp, i) {
>  			rc = check_path(vecs, pp, ticks);
>  			if (rc < 0) {
> +				condlog(1, "%s: check_path() failed, removing",
> +					pp->dev);
>  				vector_del_slot(vecs->pathvec, i);
>  				free_path(pp);
>  				i--;
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

