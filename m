Return-Path: <SRS0=L0Bp=GY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA23C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 17:42:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7FD7D21973
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 17:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FD7D21973
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-B-C5rSW5P_6qSRrl66h3wQ-1; Thu, 21 Jan 2021 12:42:15 -0500
X-MC-Unique: B-C5rSW5P_6qSRrl66h3wQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C298E107ACF9;
	Thu, 21 Jan 2021 17:42:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 813CD61F55;
	Thu, 21 Jan 2021 17:42:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB7FD180954D;
	Thu, 21 Jan 2021 17:42:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10LHg5df007022 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Jan 2021 12:42:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 55B8A2026D3B; Thu, 21 Jan 2021 17:42:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5127B2026D35
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 17:42:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C0DF1875049
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 17:42:03 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-306-IV2TCc9sOGykHMdx4peSLg-1;
	Thu, 21 Jan 2021 12:42:00 -0500
X-MC-Unique: IV2TCc9sOGykHMdx4peSLg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C0182AB7F;
	Thu, 21 Jan 2021 17:41:57 +0000 (UTC)
Message-ID: <c842e69c9aa788506ac86c615d0ed4761aed5e29.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Date: Thu, 21 Jan 2021 18:41:57 +0100
In-Reply-To: <20210121170347.GA29511@lst.de>
References: <20201210092459.81939-1-hare@suse.de>
	<29294c6553c7ec3d31e1bc3b9de524e9c7060f07.camel@suse.com>
	<e8d2e33fd4cb6ecb8c727b3c3c4c5e4c9e260c33.camel@suse.com>
	<20210121160933.GA4104@redhat.com> <20210121170347.GA29511@lst.de>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10LHg5df007022
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] dm: avoid filesystem lookup in dm_get_dev_t()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-21 at 18:03 +0100, Christoph Hellwig wrote:
> On Thu, Jan 21, 2021 at 11:09:33AM -0500, Mike Snitzer wrote:
> > > Mike, do you need anything more to apply this one? Do you want a
> > > cleaned-up resend?
> >=20
> > It got hung up with Christoph correctly requesting more discussion,
> > last
> > linux-block/lkml mail on the associated thread I kicked off is
> > here:
> > https://lkml.org/lkml/2020/12/23/76
> >=20
> > Basically if Hannes or yourself would like to review that thread
> > and
> > send a relevant v2 it'd really help move this forward.=A0 I'm bogged
> > down
> > with too many competing tasks.=A0 You guys may be able to act on this
> > line
> > of development/fixing quicker than I'll get to it.
>=20
> I'll get back to this ASAP, sorry.

AFAICS reverting 644bda6f3460, which is basically what Hannes did,
is consensus. Christoph suggested also to revert the export of
name_to_dev_t(), but that is used in a couple of other places too,
unexporting it will require a bit more work.

I'd like to move forward with the issue of blocking dm ioctls, so
I'll submit a v2. Feel free to use or discard it as you please.

Thanks,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

