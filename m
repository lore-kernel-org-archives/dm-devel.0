Return-Path: <SRS0=PNFx=H5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CE7C433E0
	for <dm-devel@archiver.kernel.org>; Sat, 27 Feb 2021 06:03:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA7A864EB3
	for <dm-devel@archiver.kernel.org>; Sat, 27 Feb 2021 06:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA7A864EB3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614405806;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aNsVH7U5ButboJvc7/wwZDX4xdkmkFsrUeBcYU63Uz4=;
	b=BcJixHVSM2cbBd6uW3yLu8w3JHw9zebH74x6AjO7gZGkba05ciCP1/IzVLzFkS8iGV+DYa
	aubp2gd4K9MaqS8uKVC01ay+oEZkfoWg3yrENwHG1uoxkGO/SqYw4ML1S3l8WtJ7r6TtsN
	u3zMdLVMv+7sKg5C5q/5bsp3lnzkn6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-3qPmpOTgOzWAiQQpGElYPA-1; Sat, 27 Feb 2021 01:03:25 -0500
X-MC-Unique: 3qPmpOTgOzWAiQQpGElYPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16F4CC280;
	Sat, 27 Feb 2021 06:03:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 560BF709B3;
	Sat, 27 Feb 2021 06:03:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89BF74E58E;
	Sat, 27 Feb 2021 06:03:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11R62oWE011149 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Feb 2021 01:02:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5C0015C257; Sat, 27 Feb 2021 06:02:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A9785C5E0;
	Sat, 27 Feb 2021 06:02:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11R62iT7018328; 
	Sat, 27 Feb 2021 00:02:44 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11R62gY6018327;
	Sat, 27 Feb 2021 00:02:42 -0600
Date: Sat, 27 Feb 2021 00:02:41 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210227060241.GP15006@octiron.msp.redhat.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 10:19:45PM +0000, Martin Wilck wrote:
> On Mon, 2021-02-08 at 23:19 -0600, Benjamin Marzinski wrote:
> >  If
> > multipathd notices that a path's wwid has changed it will remove and
> > re-add the path, just like the existing wwid checking code for change
> > events does.=A0 In cases where the no uevent occurs, both the udev
> > database entry and sysfs will have the old wwid, so the only way to
> > get
> > a current wwid is to ask the device directly.=A0
>=20
> sysfs is wrong too, really? In that case I fear triggering an uevent
> won't fix the situation. You need to force the kernel to rescan the
> device, otherwise udev will fetch the WWID from sysfs again, which
> still has the wrong ID... or what am I missing here?

I just figured out the confusion here.  Redhat has not always included
55-scsi-sg3_id.rules in sg3_utils. It does now, but installs it as
61-scsi-sg3_id.rules instead (This is why we install multipath.rules as
62-multipath.rules). The result of this is that ID_SERIAL is set by
"scsi_id --export --whitelisted -d $devnode" from
60-persistent-storage.rules. This means that when a uevent comes in,
ID_SERIAL is repopulated by ioctling the device, unlike the case where
55-scsi-sg3_id.rules sets ID_SERIAL, which gets the information from
sysfs if possible.

Clearly, for distributions that set ID_SERIAL from 55-scsi-sg3_id.rules,
multipathd needs to take more drastic measures if the sysfs vpd_page83
file is wrong.

Looking at this made me notice another issue. scsi_id and the rules in
55-scsi-sg3_id.rules don't agree on the priority of the different id
types for choosing the wwid from the various ids in vpd page 83. And
mulitpath's parse_vpd_pg83() doesn't agree with either of them.

Here are the different priority orderings for the ID types

=09=09sg_inq +
scsi_id=09=0955-scsi-sg3_id.rules=09parse_vpd_pg83
-------------------------------------------------------
36=09=0936=09=09=0936
35=09=0935=09=09=0935
3[^56]=09=0932=09=09=0932
2=09=092=09=09=098
=09=098=09=09=092
1=09=091=09=09=091
=09=093[^652]=09=09=093[^652]
0=09=090=09=09=090

Since Redhat is changing the default ordering of the
55-scsi-sg3_id.rules, it seems reasonable that we make parse_vpd_pg83()
match the 55-scsi-sg3_id.rules ordering, and I'll add a redhat specific
patch to match it to the scsi_id ordering. However, the fact that
differences which udev rules are installed or their ordering can changed
the WWID does lend some weight to the code that I originally had for
recheck_wwid, where we would only enable it after verifying that at one
point, the parse_vpd_pg83() wwid agreed with the uid_attribute wwid. On
the other hand, assuming that distributions make sure that
parse_vpd_pg83() matches their udev setup, then not requiring them to be
equal at some point allows recheck_wwid to catch problems that happened
before multipath started using the device, for whatever that's worth.

-Ben

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

