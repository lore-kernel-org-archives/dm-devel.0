Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A7BC48BDF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 17:12:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3064B61420
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 17:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3064B61420
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623777134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UlLWv2AbV9QnlGlBjANRZmubLs0sJBZNQkoC1zs3tNo=;
	b=exwena6hBn5RfjNVVmQQ3tvyiU3EttZxGGRMoTsK3NBT1X8XJScu2TBPrdAh/y05x0BpbA
	WlrZtaTDQxV+mIOqPiXAPyio2bL4arpzYy34AGQcKX+bW0+Qa2elCRf6De8HuBf65i3UQg
	BU1WiFWR8QH9h8LVD5sBrEB52eEWl0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-Q_4dAj8kMo6UPia0gmj6IQ-1; Tue, 15 Jun 2021 13:11:52 -0400
X-MC-Unique: Q_4dAj8kMo6UPia0gmj6IQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAD099F92C;
	Tue, 15 Jun 2021 17:11:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 455975C1C2;
	Tue, 15 Jun 2021 17:11:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0ED671809CAD;
	Tue, 15 Jun 2021 17:11:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FHBjvh028671 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 13:11:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E8F6721EC5CD; Tue, 15 Jun 2021 17:11:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3DC121EC5CC
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:11:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BE24800140
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:11:41 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
	[209.85.160.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-306-UM9i-ddfPPqWOLH--TdcFg-1; Tue, 15 Jun 2021 13:11:39 -0400
X-MC-Unique: UM9i-ddfPPqWOLH--TdcFg-1
Received: by mail-qt1-f175.google.com with SMTP id g12so11808487qtb.2;
	Tue, 15 Jun 2021 10:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition
	:content-transfer-encoding:in-reply-to;
	bh=CL0lPV57QQHAIoWqPYdz9D7HX33G5wLB3yUQQff9WgA=;
	b=RA3z0IvEu0Zj0Pu3PnzkUu6wGR56qTeN9D357G/bXwSB+LhVJX/VyemRZRkRsBQOly
	KMzOmZecUfGejyhS+7ARKalOd2s/hZ+vyV52HHFJfp0LwotvmrrqjpUU/hK7krBJN0fx
	dMeVGvbwznLzEHHdLyiVqovrUOH895aabiacQkrs3V6XfrhokCZxbqAUiq2ctB+NnF0o
	bybennIwVymHIGiZO3DgwHdEyJSIFR5z9bmZ/S7SmOBbR2OCNCX0v3RP6gKYr0iqd2bp
	4jlD+Ii4N67kLCafahGMXww4EblVrWPoxKZ8WB3Cq3JxzH9c0tO0zbbGgy9CNVRbstyv
	Rnww==
X-Gm-Message-State: AOAM531IPvABuI6Nr27BRYPi1QoyGDshp42l8NEkhVGBGYLowqdp02Hr
	0kOOW7lE/gKeAmQqlOvPNo8RS1W058mEGA==
X-Google-Smtp-Source: ABdhPJxayfWzxz+qB4dToDDc+nMn15PJJw+LBedHSGIvCcEQmO+DY2E1QRIgLKljXIPFOl3lTC9Lag==
X-Received: by 2002:ac8:7950:: with SMTP id r16mr609893qtt.137.1623777098552; 
	Tue, 15 Jun 2021 10:11:38 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	s69sm10922199qke.115.2021.06.15.10.11.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 15 Jun 2021 10:11:37 -0700 (PDT)
Date: Tue, 15 Jun 2021 13:11:37 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <YMjfSVASeTE0Sy9H@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
	<YMdyh62mR/lEifMR@redhat.com>
	<44fc94278e0c4b15a611a6887c668f41c262e001.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <44fc94278e0c4b15a611a6887c668f41c262e001.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 15 2021 at  6:54P -0400,
Martin Wilck <mwilck@suse.com> wrote:

> Hi Mike,
>=20
> On Mo, 2021-06-14 at 11:15 -0400, Mike Snitzer wrote:
> >=20
> > This work offers a proof-of-concept but it needs further refinement
> > for sure.
>=20
> Thanks for looking into it again. I need some more guidance from your
> part in order to be able to resubmit the set in a form that you
> consider ready for merging.
>=20
> > The proposed open-coded SCSI code (in patch 2's drivers/md/dm-
> > scsi_ioctl.c)=20
> > is well beyond what I'm willing to take in DM.
>=20
> I'm not sure what code you're referring to. Is it the processing of the
> bytes of the SCSI result code? If yes, please note that I had changed
> that to open-coded form in response to Bart's review of my v2
> submission. If it's something else, please point it out to me.
>=20
> To minimize the special-casing for this code path, Hannes suggested to
> use a target-specific unprepare_ioctl() callback to to tell the generic
> dm code whether a given ioctl could be retried.=A0The logic that I've put
> into=A0dm-scsi_ioctl.c could then be moved into the unprepare_ioctl()
> callback of dm-mpath.=A0dm_blk_ioctl() would need to check the callback's
> return value and possibly retry the ioctl. Would hat appeal to you?
>=20
> > =A0 If this type of
> > functionality is still needed (for kvm's SCSI passthru snafu) then
> > more work is needed to negotiate proper interfaces with the SCSI
> > subsystem (added linux-scsi to cc, odd they weren't engaged on this).
>=20
> Not cc'ing linux-scsi was my oversight, sorry about that.=A0
>=20
> But I don't quite understand what interfaces you have in mind. SCSI
> needs to expose the SG_IO interface to dm, which it does; I just needed
> to export sg_io() to get access to the sg_io_hdr fields. The question
> whether a given IO can be retried is decided on the dm (-mpath) layer,
> based on blk_status_t; no additional interface on the SCSI side is
> necessary for that.
>=20
> > Does it make sense to extend the SCSI device handler interface to add
> > the required enablement? (I think it'd have to if this line of work
> > is
> > to ultimately get upstream).
>=20
> My current code uses the device handler indirectly for activating paths
> during priority group switching, via the dm-mpath prepare_ioctl()
> method and __pg_init_all_paths(). This is what I intended - to use
> exactly the same logic for SG_IO which is used for regular read/write
> IO on the block device.=A0What additional functionality for the device
> handler do you have in mind?
>=20
> Regards and thanks,
> Martin

I just replied to patch 2 with detailed suggestions.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

