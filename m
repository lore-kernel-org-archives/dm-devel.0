Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8006C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FDA861985
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FDA861985
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-L9fCTheoNzickXU6OCHsOQ-1; Wed, 31 Mar 2021 09:33:07 -0400
X-MC-Unique: L9fCTheoNzickXU6OCHsOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91CFB83DD25;
	Wed, 31 Mar 2021 13:32:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 672E81B5C1;
	Wed, 31 Mar 2021 13:32:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A49F180B452;
	Wed, 31 Mar 2021 13:32:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12VBrEpm016928 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 07:53:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8A8F42026D64; Wed, 31 Mar 2021 11:53:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85D602026D6B
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 11:53:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB634101A52C
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 11:53:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-524-_Pw8oXiaNmWd08vuPPJONQ-1;
	Wed, 31 Mar 2021 07:53:06 -0400
X-MC-Unique: _Pw8oXiaNmWd08vuPPJONQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D0329B1DE;
	Wed, 31 Mar 2021 11:53:04 +0000 (UTC)
To: Martin Wilck <martin.wilck@suse.com>,
	"erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"bblock@linux.ibm.com" <bblock@linux.ibm.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
	<7b7663da1edf9fcb3e2515e41602ab68de02d2a9.camel@suse.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <0419387c-071c-2c5e-79f4-8873553e5da3@suse.de>
Date: Wed, 31 Mar 2021 13:53:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <7b7663da1edf9fcb3e2515e41602ab68de02d2a9.camel@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12VBrEpm016928
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:19 -0400
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On 3/31/21 1:45 PM, Martin Wilck wrote:
> On Wed, 2021-03-31 at 16:18 +0530, Muneendra Kumar M wrote:
>>
>>> Talking about FPIN, is it planned to notify user space about such
>>> fabric
>> events, and if yes, how?
>>
>> [Muneendra]Yes. FC drivers, when receiving FC FPIN ELS's are calling
>> a
>> scsi transport routine with the FPIN payload.=A0 The transport
>> is pushing this as an "event" via netlink.=A0 An app bound to the local
>> address used by the scsi transport can receive the event and parse
>> it.
>>
>> Benjamin has added a marginal_path group(multipath marginal
>> pathgroups) in
>> the dm-multipath.
>> https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-g=
it
>> -send-email-bmarzins@redhat.com/
>>
>> One of the intention of the Benjamin's patch (support for maginal
>> path) is
>> to support for the FPIN events we receive from fabric.
>> On receiving the fpin-li our intention was to=A0 place all the paths
>> that
>> are affected into the marginal path group.
>>
>=20
> I'm aware of Ben's work, but I hadn't realized it had anything to do
> with FPIN. As of today, multipathd doesn't listen on the
> NETLINK_SCSITRANSPORT socket. Does any user space tool do this?
> Google didn't show me anything.
>=20
I did, once, but that was years ago.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke=09=09           Kernel Storage Architect
hare@suse.de=09=09=09                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
HRB 36809 (AG N=FCrnberg), GF: Felix Imend=F6rffer


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

