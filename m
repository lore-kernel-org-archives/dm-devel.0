Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322BFC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 17:31:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6171764DF2
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 17:31:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6171764DF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-gL6MAwA5NPCLXVRQeMY4cw-1; Tue, 09 Feb 2021 12:31:07 -0500
X-MC-Unique: gL6MAwA5NPCLXVRQeMY4cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE5AE107ACC7;
	Tue,  9 Feb 2021 17:31:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE37171F4;
	Tue,  9 Feb 2021 17:31:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF3B418095CB;
	Tue,  9 Feb 2021 17:30:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119HUsMn023664 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 12:30:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 51C5CA37DF; Tue,  9 Feb 2021 17:30:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C68D9D51
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 17:30:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03BF3101A58E
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 17:30:52 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-142-jaP58cNGNwe27d8jAgVFvQ-1;
	Tue, 09 Feb 2021 12:30:49 -0500
X-MC-Unique: jaP58cNGNwe27d8jAgVFvQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7594CACB7;
	Tue,  9 Feb 2021 17:30:48 +0000 (UTC)
Message-ID: <11c072c152937004e5f08ecff8dd9ded7d915af6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 09 Feb 2021 18:30:47 +0100
In-Reply-To: <3c8f215a-75d5-0f7b-1008-c8c565bb0cf3@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
	<05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
	<6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
	<7b2c571eb7ff9d54c51037a4fae87796ead1144e.camel@suse.com>
	<3c8f215a-75d5-0f7b-1008-c8c565bb0cf3@huawei.com>
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
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 119HUsMn023664
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-09 at 09:36 +0800, lixiaokeng wrote:
>=20
> >=20
> > I still don't fully understand. Above you said "this coredump
> > doesn't
> > seem to appear any more". Am I understanding correctly that you
> > observed *other* core dumps instead?

> >=20
>=20
> No, it is not "instead".
> As shown in https://www.spinics.net/lists/dm-devel/msg45293.html,
> there are some different crashes in multipathd with no code change.
> When blocking of thread cancellation during
> udev_monitor_receive_device(),
> no crash in udev_monitor_receive_device happens but others still
> exist.

Now I got it, eventually :-) Thanks for the clarification. Would it be
ossible for you to categorize the different=A0issues and provide core
dumps?

You mentioned in the systemd issue that you were playing around with
the gcc -fexceptions flag. As I remarked there - how did it get set in
the first place? What distro are you using?
> >=20
> > The "best" solution would probably be to generally disallow
> > cancellation, and only run pthread_testcancel() at certain points
> > in
> > the code where we might block (and know that being cancelled would
> > be
> > safe). That would not only make multipathd safer from crashing, it
> > would also enable us to remove hundreds of ugly
> > pthread_cleanup_push()/pop() calls from our code.
> >=20
> > Finding all these points would be a challenge though, and if we
> > don't
> > find them, we risk hanging on exit again, which is bad too, and was
> > just recently improved.
>=20
> Do you mean some patches have been made to solve these problem?

No. I could hack up some, but it will take some time.

Regards,
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

