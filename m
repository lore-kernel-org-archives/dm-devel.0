Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23539C43470
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:43:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6DEF613FB
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6DEF613FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619556233;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I5R+AIvTxNMUm9y5uKWdAtxIfha2VTz1ofxGFDzx5TQ=;
	b=R5M0DC5Fl1/02d6G4U6xB2xAgCHzH0saXoYX/9RvutE0NUHNf2n58aVyL/1oqjbtDzDPil
	FvON6y39R3Zct1JhuDBIFFd+VUosaGFVOWeI0DGgYnkfnjNnh6S5EOCluQyDGTOF4qAvAL
	Iw2tM9sFrnm8yIv+7xkZNvtOPKPGMX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-EmnCEBO3NsSvu99J2CcIIg-1; Tue, 27 Apr 2021 16:43:51 -0400
X-MC-Unique: EmnCEBO3NsSvu99J2CcIIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52F93107ACC7;
	Tue, 27 Apr 2021 20:43:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB4815C23E;
	Tue, 27 Apr 2021 20:43:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F11E18095C9;
	Tue, 27 Apr 2021 20:43:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13RKfod7031571 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 16:41:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ACAAC1037E8A; Tue, 27 Apr 2021 20:41:50 +0000 (UTC)
Received: from ovpn-112-203.phx2.redhat.com (ovpn-112-203.phx2.redhat.com
	[10.3.112.203])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C65C100763B;
	Tue, 27 Apr 2021 20:41:46 +0000 (UTC)
Message-ID: <c8ede601244e1710dbf320c33c0f7853e249bbee.camel@redhat.com>
From: "Ewan D. Milne" <emilne@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Date: Tue, 27 Apr 2021 16:41:45 -0400
In-Reply-To: <488ef3e7fa0cca4f0a0cb2e9307ddaa08385d3f7.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
	<65f66a5e03081dd3b470fa9aeff9a77dbc41743c.camel@redhat.com>
	<488ef3e7fa0cca4f0a0cb2e9307ddaa08385d3f7.camel@suse.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-04-27 at 20:33 +0000, Martin Wilck wrote:
> On Tue, 2021-04-27 at 16:14 -0400, Ewan D. Milne wrote:
> > 
> > There's no way to do that, in principle.  Because there could be
> > other I/Os in flight.  You might (somehow) avoid retrying an I/O
> > that got a UA until you figured out if something changed, but other
> > I/Os can already have been sent to the target, or issued before you
> > get to look at the status.
> 
> Right. But in practice, a WWID change will hardly happen under full
> IO
> load. The storage side will probably have to block IO while this
> happens, at least for a short time period. So blocking and quiescing
> the queue upon an UA might still work, most of the time. Even if we
> were too late already, the sooner we stop the queue, the better.
> 
> The current algorithm in multipath-tools needs to detect a path going
> down and being reinstated. The time interval during which a WWID
> change
> will go unnoticed is one or more path checker intervals, typically on
> the order of 5-30 seconds. If we could decrease this interval to a
> sub-
> second or even millisecond range by blocking the queue in the kernel
> quickly, we'd have made a big step forward.

Yes, and in many situations this may help.  But in the general case
we can't protect against a storage array misconfiguration,
where something like this can happen.  So I worry about people
believing the host software will protect them against a mistake,
when we can't really do that.

All it takes is one I/O (a discard) to make a thorough mess of the LUN.

-Ewan

> 
> Regards
> Martin
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

