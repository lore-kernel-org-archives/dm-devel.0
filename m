Return-Path: <SRS0=qllc=KC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70117C433B4
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 14:11:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6AB7E6142D
	for <dm-devel@archiver.kernel.org>; Fri,  7 May 2021 14:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AB7E6142D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tls.msk.ru
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-ba_TX5PNOlSlPOhhdmgvdQ-1; Fri, 07 May 2021 10:11:06 -0400
X-MC-Unique: ba_TX5PNOlSlPOhhdmgvdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F99218B62AE;
	Fri,  7 May 2021 14:11:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0B4869112;
	Fri,  7 May 2021 14:10:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9401B1800BB4;
	Fri,  7 May 2021 14:10:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 147EArSs021928 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 7 May 2021 10:10:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6094A16F729; Fri,  7 May 2021 14:10:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AF5D16F73F
	for <dm-devel@redhat.com>; Fri,  7 May 2021 14:10:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05148868A26
	for <dm-devel@redhat.com>; Fri,  7 May 2021 14:10:51 +0000 (UTC)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-464-LLUyv3WkPQefMjGQyYS3GQ-1;
	Fri, 07 May 2021 10:10:48 -0400
X-MC-Unique: LLUyv3WkPQefMjGQyYS3GQ-1
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
	by isrv.corpit.ru (Postfix) with ESMTP id B68A640010;
	Fri,  7 May 2021 17:10:45 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
	by tsrv.corpit.ru (Postfix) with ESMTP id 016CE70;
	Fri,  7 May 2021 17:10:45 +0300 (MSK)
To: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com
References: <7104c94c-7408-0d58-ddd9-384102e820bc@msgid.tls.msk.ru>
	<6a71df25-d1fb-db02-ff55-384ba0828647@redhat.com>
From: Michael Tokarev <mjt@tls.msk.ru>
Message-ID: <84eaa68f-3ea3-8313-2953-46375dce9f86@msgid.tls.msk.ru>
Date: Fri, 7 May 2021 17:10:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <6a71df25-d1fb-db02-ff55-384ba0828647@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 147EArSs021928
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] can we fix some dm snapshot crashes please? :)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-2"; Format="flowed"

07.05.2021 15:31, Zdenek Kabelac wrote:
> Dne 07. 05. 21 v 12:31 Michael Tokarev napsal(a):
...
>> =A0=A0sz=3D$(blockdev --getsize /dev/loop0)
>> =A0=A0dmsetup create base --table "0 $sz snapshot-origin /dev/loop0"
>> =A0=A0# and now the crash
>> =A0=A0mkfs.ext4 /dev/mapper/base

> Yes reproducible - can you please open BZ report here:
>=20
> https://bugzilla.redhat.com/enter_bug.cgi?product=3DLVM%20and%20device-ma=
pper

Ok, will do, thanks!

> I assume you are aware you are trying to using snapshot target in wrong w=
ay,
> but it should not be crashing kernel.

Actually I'm not aware about the wrong way. The documentation is a bit lack=
ing
in this area. There are a few (maybe 2 or 3) guides describing the steps to=
 do,
most involves first using an 1:1 linear table, next replacing it on-the-fly=
 with
snapshot-origin table, but nowhere it is told that I can't create snapshot-=
origin
directly, or that I need at least one snapshot device, or that the origin o=
f the
snapshot-origin table should be a dm device, or many many other variations.

I just tried to create a snapshot to be able to revert changes if something=
 goes
wrong, and since I don't use lvm I thought that plain dmsetup should do, bu=
t
discovered that it doesn't quite work and it actually is a dangerous thing =
to use.. :)

Thanks!

/mjt


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

