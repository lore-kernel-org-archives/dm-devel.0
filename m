Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F52CC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 04:51:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FAC364E8A
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 04:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FAC364E8A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612846277;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SlnW6Dh0Ox9K7QwGBQd5CvSnSTQWnXtIdsn0R/Oczpw=;
	b=hsb1mKZhavf9T2jGA+eY/V0pWLp7ULW5AP341P7g/s/2T+onfcr3yrUdbQNbjsHpDQTOHa
	ipnU3ubq7AALG/7YS+K5hOBVjfQjUUHrEzXA+chu3y0yAB29saBsBwF84MKvNbX00aUmYK
	AR+Fzp4pV+i3jj6ys0Vf7VjYwdngMm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-7zhubHxwNJibA4-3b5mXOQ-1; Mon, 08 Feb 2021 23:51:14 -0500
X-MC-Unique: 7zhubHxwNJibA4-3b5mXOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2673380196C;
	Tue,  9 Feb 2021 04:51:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D1E60C04;
	Tue,  9 Feb 2021 04:51:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EB4B718095CB;
	Tue,  9 Feb 2021 04:51:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1194oxZp025565 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 23:50:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 32A7E60C5B; Tue,  9 Feb 2021 04:50:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CE535F7D0;
	Tue,  9 Feb 2021 04:50:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1194opZP008525; 
	Mon, 8 Feb 2021 22:50:51 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1194omPI008524;
	Mon, 8 Feb 2021 22:50:48 -0600
Date: Mon, 8 Feb 2021 22:50:47 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Chongyun Wu <wucy11@chinatelecom.cn>
Message-ID: <20210209045047.GD15006@octiron.msp.redhat.com>
References: <4ca7da32-5777-9089-1e96-a5dbb46c585a@chinatelecom.cn>
	<4c7286abbdd79fc0c726fd119fdda3b7a140e056.camel@suse.com>
	<ffb39ebe-ab7e-f82a-f4cb-5b8353bfda2a@chinatelecom.cn>
	<bdeb04efcac09880451505ca2970c6d322c48da5.camel@suse.com>
	<13b96493-5e48-8c56-9e56-b5d42f4a3b07@chinatelecom.cn>
MIME-Version: 1.0
In-Reply-To: <13b96493-5e48-8c56-9e56-b5d42f4a3b07@chinatelecom.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: yubin1@chinatelecom.cn, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>, zhangzijian@chinatelecom.cn
Subject: Re: [dm-devel] [PATCH] multipathd: LUN protection by checking
 path's wwid change status
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I've actually managed to reproduce this issue with the latest code.  All
it takes is two machines in the same FC zone, with one of them having a
FC driver that supports target mode and LIO.

To do it:
You can grab TGT_WWPN and INIT_WWPN from
/sys/class/fc_host/host<n>/port_name

On the target machine (assuming you're using the ql2xxx module)
load the FC driver in target mode
# modprobe qla2xxx qlini_mode=3Ddisabled

start up the LIO target.service
# service target start

configure the setup in targetcli
# targetcli
/> qla2xxx/ create <TGT_WWPN>
/> backstores/fileio create file1 <FILE_1> 100M
/> backstores/fileio create file2 <FILE_2> 100M
/> qla2xxx/<TGT_WWPN>/luns create /backstores/fileio/file1 1
/> qla2xxx/<TGT_WWPN>/luns create /backstores/fileio/file2 2
/> qla2xxx/<TGT_WWPN>/acls create <INIT_WWPN>

On the host machine:
discover the LIO devices on each FC host
# echo 1 > /sys/class/fc_host/host<N>/issue_lip

You should have two multipath devices now

On the target machine:
switch the LUNs
/> qla2xxx/<TGT_WWPN>/acls/<INIT_WWPN> delete 1
/> qla2xxx/<TGT_WWPN>/acls/<INIT_WWPN> delete 2
/> qla2xxx/<TGT_WWPN>/acls/<INIT_WWPN> create 2 /backstores/fileio/file1
/> qla2xxx/<TGT_WWPN>/acls/<INIT_WWPN> create 1 /backstores/fileio/file2

This will often generate a change event, but not on every path,
leaving some paths as part of the wrong multipath device.

I'll post a patchset based on Chongyun's patch shortly to deal with
this.

-Ben

On Fri, Jan 08, 2021 at 11:13:01AM +0800, Chongyun Wu wrote:
> Thanks Martin, I will try to reproduce this issue with the latest version
> when the enviroments ready, if reproduce it again I will let you know,
> thanks again~
>=20
> On 2021/1/7 19:27, Martin Wilck wrote:
> >On Thu, 2021-01-07 at 10:23 +0800, Chongyun Wu wrote:
> >>Hello Martin,
> >>Thanks for view this patch.
> >>
> >>On 2021/1/7 5:10, Martin Wilck wrote:
> >>>Hello Chongyun,
> >>>
> >>>On Mon, 2020-12-28 at 11:34 +0800, Chongyun Wu wrote:
> >>>> =A0=A0From 37c74873acfc1587e79a6504ca3d42b8fa00d49e Mon Sep 17
> >>>>00:00:00
> >>>>2001
> >>>>
> >>>>From: Chongyun Wu <wucy11@chinatelecom.cn>
> >>>>Date: Mon, 21 Dec 2020 09:51:20 +0800
> >>>>Subject: [PATCH] multipathd: LUN data protection by checking
> >>>>path's
> >>>>wwid
> >>>> =A0=A0=A0change status
> >>>>
> >>>>Issue description:
> >>>>A) Device sda and sdb correspend to LUN1 and LUN2 in storage
> >>>>backend
> >>>>and
> >>>>the upper layer application uses those two devices.
> >>>>B) Doing illegal operation: unmapping LUN1 and LUN2 in storage
> >>>>backend,
> >>>>and export LUN2 and LUN1 to host with exchanged assignment
> >>>>relation
> >>>>between sda and sdb.
> >>>>C) The upper layer application run for a while and found that the
> >>>>data
> >>>>in both LUN1 and LUN2 has been corrupted.
> >>>
> >>>Can you please be explicit about which multipath-tools version you
> >>>have
> >>>tested? I thought we had the wwid change issues covered. Ben and I
> >>>have
> >>>been putting quite some effort into this recently. Of course we can
> >>>be
> >>>wrong, but I'd like to understand the issue fully.
> >>>
> >>The test version is 0.8.3.
> >
> >A test with 0.8.5 would be in necessary, then. The INIT_REMOVED logic
> >has been added after 0.8.4.
> >>>
> >>>Please confirm that you've been using the latest version from
> >>>Christophe's repo (or better even, from my upstream-queue), and
> >>>provide
> >>>-v3 logs showing what goes wrong.
> >>Sorry Martin, I haven't save the logs and the enviroment is
> >>unavailable now.
> >
> >Well, please report back if you can reproduce the issue with current
> >upstream.
> >
> >Regards,
> >Martin
> >
> >
>=20
> --=20
> Best Regard,
> Chongyun Wu

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

