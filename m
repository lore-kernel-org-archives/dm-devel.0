Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3879BC00A89
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 07:03:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 544482080D
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 07:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 544482080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-nyGVT8caMz2lSGygFQdlKg-1; Thu, 05 Nov 2020 02:03:29 -0500
X-MC-Unique: nyGVT8caMz2lSGygFQdlKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18FE564149;
	Thu,  5 Nov 2020 07:03:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12B9C5D9D5;
	Thu,  5 Nov 2020 07:03:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 679DF18005A3;
	Thu,  5 Nov 2020 07:03:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A573Ck1003007 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 02:03:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6D79FCF635; Thu,  5 Nov 2020 07:03:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68A67D0171
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 07:03:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18098185A7A1
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 07:03:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-71-D7OfRHIxMzik30nbdbJ8eg-1;
	Thu, 05 Nov 2020 02:03:05 -0500
X-MC-Unique: D7OfRHIxMzik30nbdbJ8eg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id F11F3AB4C;
	Thu,  5 Nov 2020 07:03:03 +0000 (UTC)
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <e77c4409175db94f97543991632c323a78ab3ef9.camel@suse.com>
	<20201102224048.GV3384@octiron.msp.redhat.com>
	<b0c9073c-1c1e-04d0-7edf-e2d66c0094be@suse.de>
	<20201104161207.GD3384@octiron.msp.redhat.com>
	<4a490654f966e54e6540fcfc97bf6b32a37bee5b.camel@suse.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <82c032dc-a7ba-e03e-67d1-1d1f8e240269@suse.de>
Date: Thu, 5 Nov 2020 08:03:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4a490654f966e54e6540fcfc97bf6b32a37bee5b.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A573Ck1003007
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 11/4/20 10:01 PM, Martin Wilck wrote:
> On Wed, 2020-11-04 at 10:12 -0600, Benjamin Marzinski wrote:
>> On Wed, Nov 04, 2020 at 03:11:04PM +0100, Hannes Reinecke wrote:
>>>
>>> Well ... isn't that what the option '-d' is for?
>>> Namely _not_ starting the log thread when running under systemd?
>>
>> Martin is arguing that syslogd is at least as likely not to block as
>> journald, so if we don't need the log thread when writing to journald
>> (though stderr), we also don't need the log thread when writing to
>> syslogd. Correct me, if I'm wrong Martin.
>=20
> Exactly. The log thread has some race issues that we've been discussing
> in another thread ("[PATCH v2 29/29] libmultipath: fix race between
> log_safe and log_thread_stop()"). I had been digging into the code a
> bit, and found some more things that I'd like to see improved. But I
> realized fixing this for good might be hairy and take a lot of time
> which would be better spent elsewhere, and started wondering if we
> still need it at all.

Well, seeing that most distributions (or all I care about :-) have=20
switched to systemd I don't have any issues with removing it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
HRB 36809 (AG N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

