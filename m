Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24171C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 16:17:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 817842064C
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 16:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GTxScQbF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 817842064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604506624;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4y6/WKkdx+Ca/OtZp6psQqsDYNfj1aQz8oTosDDkFj4=;
	b=GTxScQbFPMQLhrhZ7TZqpFVY462PGhREFHky6bSw7VLYgqN/m1IME397dRbIBRYrZqCQHR
	ipBzI3UIOz5PiPQmeO4gYcz6Vqj4xGk6MM2ztgPY/OjDuLbGBuzEdZw9dxhDLm4qRdDt54
	cmvvvEuqzPfbc5a0RteQeCWUPRKSV6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-WhYwDb1VMnC3XF81CBu2Vw-1; Wed, 04 Nov 2020 11:17:01 -0500
X-MC-Unique: WhYwDb1VMnC3XF81CBu2Vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FE161016CE3;
	Wed,  4 Nov 2020 16:16:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E07205B4BB;
	Wed,  4 Nov 2020 16:16:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 87165181A050;
	Wed,  4 Nov 2020 16:16:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4GCD5d028207 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 11:12:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B175A75131; Wed,  4 Nov 2020 16:12:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 994367513B;
	Wed,  4 Nov 2020 16:12:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A4GC8bl026138; 
	Wed, 4 Nov 2020 10:12:08 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A4GC750026137;
	Wed, 4 Nov 2020 10:12:07 -0600
Date: Wed, 4 Nov 2020 10:12:07 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20201104161207.GD3384@octiron.msp.redhat.com>
References: <e77c4409175db94f97543991632c323a78ab3ef9.camel@suse.com>
	<20201102224048.GV3384@octiron.msp.redhat.com>
	<b0c9073c-1c1e-04d0-7edf-e2d66c0094be@suse.de>
MIME-Version: 1.0
In-Reply-To: <b0c9073c-1c1e-04d0-7edf-e2d66c0094be@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>, Martin Wilck <mwilck@suse.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 04, 2020 at 03:11:04PM +0100, Hannes Reinecke wrote:
> On 11/2/20 11:40 PM, Benjamin Marzinski wrote:
> >On Mon, Nov 02, 2020 at 01:17:28PM +0100, Martin Wilck wrote:
> >>(sending again, with dm-devel on cc. Sorry!)
> >>
> >>Hi Ben, hi Christophe,
> >>
> >>AFAIU, the purpose of the log thread is to avoid blocking while writing
> >>log messages to the syslog socket. The thread has been in place for a
> >>long time. However, the large majority of multipath installations today
> >>runs on systemd-enabled systems, where we don't use the log thread.
> >>Rather, we write to stderr (which is actually a journald socket)
> >>directly.
> >>
> >>That makes me wonder: if the problem of blocking while writing to the
> >>log socket is real, it should happen with journald as well (possibly
> >>more so than with syslogd; journald doesn't exactly have the reputation
> >>of being highly efficient). Thus, we should be using the log thread
> >>also for the systemd case
> >
> >It does seem sort of wasteful to me to have a thread buffering writes to
> >a daemon that itself buffers writes. If journald is blocking logging
> >processes from continuing, that's a big problem, and not just for
> >multipath. Obviously multipathd, or at the very least, path checking, is
> >supposed to continue working when there is no access to the root
> >filesystem, which is a stricter requirement than other programs have.
> >But IO delays happen, and journald better be decoupling them from the
> >logging process. I have seen journald drop log messages, presumably
> >because it isn't just blocking everything that wants to log to it.
> >
> >>  OTOH, I'm not aware of any bug reports
> >>saying that multipathd wasn't able to handle events because of blocking
> >>log calls. So perhaps the issue is rather theoretical? In that case, we
> >>could do away with all the complexity the log thread involves.
> >>
> >>What do you think?
> >
> >I do believe that syslog is allowed to block the caller, but I agree
> >that we've mostly moved on to a systemd world where multipathd is
> >writing to stderr. Removing this will make multipathd run a real risk of
> >hanging on logging when not run through systemd. I just don't know how
> >likely that scenario is anymore.
> >
> Well ... isn't that what the option '-d' is for?
> Namely _not_ starting the log thread when running under systemd?

Martin is arguing that syslogd is at least as likely not to block as
journald, so if we don't need the log thread when writing to journald
(though stderr), we also don't need the log thread when writing to
syslogd. Correct me, if I'm wrong Martin.

-Ben

>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> HRB 36809 (AG N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

