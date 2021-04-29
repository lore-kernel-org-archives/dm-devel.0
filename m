Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEA4C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 20:34:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F171961423
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 20:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F171961423
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-z0ZEBnSFMeSdY9BrXpOyAQ-1; Thu, 29 Apr 2021 16:34:29 -0400
X-MC-Unique: z0ZEBnSFMeSdY9BrXpOyAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31CCB10066EB;
	Thu, 29 Apr 2021 20:34:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BA545C559;
	Thu, 29 Apr 2021 20:34:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 930461806D35;
	Thu, 29 Apr 2021 20:34:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TKXZBs009273 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 16:33:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AC42420B6640; Thu, 29 Apr 2021 20:33:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5A0020B6651
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 20:33:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D20FCA2880C
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 20:33:32 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-595-d58kVbvTObqLGMY9ah-9_A-1;
	Thu, 29 Apr 2021 16:33:30 -0400
X-MC-Unique: d58kVbvTObqLGMY9ah-9_A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7AA47ADD7;
	Thu, 29 Apr 2021 20:33:28 +0000 (UTC)
Message-ID: <bb30875e11913a33bcaf491d0f752132ebb9ce5e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, Hannes Reinecke
	<hare@suse.de>
Date: Thu, 29 Apr 2021 22:33:27 +0200
In-Reply-To: <08440651-6e8f-734a-ef43-561d9c2596a6@acm.org>
References: <20210429155024.4947-1-mwilck@suse.com>
	<20210429155024.4947-2-mwilck@suse.com>
	<08440651-6e8f-734a-ef43-561d9c2596a6@acm.org>
User-Agent: Evolution 3.38.4
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13TKXZBs009273
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Bonzini <pbonzini@redhat.com>, Paolo,
	Christoph Hellwig <hch@lst.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] scsi: convert
 scsi_result_to_blk_status() to inline
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Bart,

thanks for looking at this.

On Thu, 2021-04-29 at 09:20 -0700, Bart Van Assche wrote:
> On 4/29/21 8:50 AM, mwilck@suse.com=A0wrote:
> > This makes it possible to use scsi_result_to_blk_status() from
> > code that shouldn't depend on scsi_mod (e.g. device mapper).
>=20
> I think that's the wrong reason to make a function inline. Please
> consider moving scsi_result_to_blk_status() into one of the block
> layer
> source code files that already deals with SG I/O, e.g.
> block/scsi_ioctl.c.

scsi_ioctl.c, are you certain? scsi_result_to_blk_status() is an
important part of the block/scsi interface... You're right that that
this function is not a prime candidate for inlining, but I'm still
wondering where it belongs if we don't.

Looking forward to see what others think.

>=20
> > diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> > index 83f7e520be48..ba1e69d3bed9 100644
> > --- a/include/scsi/scsi_cmnd.h
> > +++ b/include/scsi/scsi_cmnd.h
> > @@ -311,24 +311,44 @@ static inline struct scsi_data_buffer
> > *scsi_prot(struct scsi_cmnd *cmd)
> > =A0#define scsi_for_each_prot_sg(cmd, sg, nseg, __i)=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __=
i)
> > =A0
> > +static inline void __set_status_byte(int *result, char status)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0*result =3D (*result & 0xffffff00) | status;
> > +}
> > +
> > =A0static inline void set_status_byte(struct scsi_cmnd *cmd, char
> > status)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0cmd->result =3D (cmd->result & 0xffffff00) | stat=
us;
> > +=A0=A0=A0=A0=A0=A0=A0__set_status_byte(&cmd->result, status);
> > +}
> > +
> > +static inline void __set_msg_byte(int *result, char status)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0*result =3D (*result & 0xffff00ff) | (status << 8=
);
> > =A0}
> > =A0
> > =A0static inline void set_msg_byte(struct scsi_cmnd *cmd, char
> > status)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0cmd->result =3D (cmd->result & 0xffff00ff) | (sta=
tus << 8);
> > +=A0=A0=A0=A0=A0=A0=A0__set_msg_byte(&cmd->result, status);
> > +}
> > +
> > +static inline void __set_host_byte(int *result, char status)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0*result =3D (*result & 0xff00ffff) | (status << 1=
6);
> > =A0}
> > =A0
> > =A0static inline void set_host_byte(struct scsi_cmnd *cmd, char
> > status)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0cmd->result =3D (cmd->result & 0xff00ffff) | (sta=
tus << 16);
> > +=A0=A0=A0=A0=A0=A0=A0__set_host_byte(&cmd->result, status);
> > +}
> > +
> > +static inline void __set_driver_byte(int *result, char status)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0*result =3D (*result & 0x00ffffff) | (status << 2=
4);
> > =A0}
> > =A0
> > =A0static inline void set_driver_byte(struct scsi_cmnd *cmd, char
> > status)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0cmd->result =3D (cmd->result & 0x00ffffff) | (sta=
tus << 24);
> > +=A0=A0=A0=A0=A0=A0=A0__set_driver_byte(&cmd->result, status);
> > =A0}
>=20
> The layout of the SCSI result won't change since it is used in
> multiple
> UAPI data structures. I'd prefer to open-code host_byte() in
> scsi_result_to_blk_status() instead of making the above changes.

OK. I'm generally no fan of hard-coding but I guess you're right
in this case.

Thanks,
Martin





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

