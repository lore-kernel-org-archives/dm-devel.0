Return-Path: <SRS0=9700=DW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012FAC433DF
	for <dm-devel@archiver.kernel.org>; Thu, 15 Oct 2020 08:08:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B412E22243
	for <dm-devel@archiver.kernel.org>; Thu, 15 Oct 2020 08:08:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B412E22243
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-IAB8pwJ6Nb-c-pjkX8-WmQ-1; Thu, 15 Oct 2020 04:08:05 -0400
X-MC-Unique: IAB8pwJ6Nb-c-pjkX8-WmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B468030C6;
	Thu, 15 Oct 2020 08:08:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B21A5C1BD;
	Thu, 15 Oct 2020 08:07:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 082861826D35;
	Thu, 15 Oct 2020 08:07:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09D8pgvc004773 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 13 Oct 2020 04:51:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3F3BD6FA40; Tue, 13 Oct 2020 08:51:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 397D49E76
	for <dm-devel@redhat.com>; Tue, 13 Oct 2020 08:51:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C811F102F1E0
	for <dm-devel@redhat.com>; Tue, 13 Oct 2020 08:51:39 +0000 (UTC)
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch
	[83.166.143.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-582-nj9pRu0uNe-fkgw4ghcptA-1; Tue, 13 Oct 2020 04:51:37 -0400
X-MC-Unique: nj9pRu0uNe-fkgw4ghcptA-1
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id
	4C9Tml6Zp0zlkxyN; Tue, 13 Oct 2020 10:51:35 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [94.23.54.103])
	by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id
	4C9Tmk5Vd6zlh8WW; Tue, 13 Oct 2020 10:51:34 +0200 (CEST)
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20201002071802.535023-1-mic@digikod.net>
	<bda2ffd7-3b7c-33a4-667f-a3435e112fc1@digikod.net>
	<20201012235502.GA36149@linux.intel.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <1b344a3c-2671-3b1a-3c6b-f3b28e819bc5@digikod.net>
Date: Tue, 13 Oct 2020 10:51:34 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <20201012235502.GA36149@linux.intel.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09D8pgvc004773
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 15 Oct 2020 04:07:55 -0400
Cc: Mike Snitzer <snitzer@redhat.com>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	=?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
	Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [dm-devel] [PATCH v1] dm verity: Add support for signature
 verification with 2nd keyring
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
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Message-ID: <20201013085134.eZeKtCgPk-eTbuRbGQzys5Vf-AS0AvLW5xRMZ9cDJWM@z>


On 13/10/2020 01:55, Jarkko Sakkinen wrote:
> On Fri, Oct 09, 2020 at 11:50:03AM +0200, Micka=EBl Sala=FCn wrote:
>> Hi,
>>
>> What do you think about this patch?
>>
>> Regards,
>>  Micka=EBl
>>
>> On 02/10/2020 09:18, Micka=EBl Sala=FCn wrote:
>>> From: Micka=EBl Sala=FCn <mic@linux.microsoft.com>
>>>
>>> Add a new DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING configuration
>>> to enable dm-verity signatures to be verified against the secondary
>>> trusted keyring.  This allows certificate updates without kernel update
>>> and reboot, aligning with module and kernel (kexec) signature
>>> verifications.
>=20
> I'd prefer a bit more verbose phrasing, not least because I have never
> really even peeked at dm-verity, but it is also a good practice.
>=20
> You have the middle part of the story missing - explaining the semantics
> of how the feature leads to the aimed solution.

OK, what about:

Add a new configuration DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
to enable dm-verity signatures to be verified against the secondary
trusted keyring. Instead of relying on the builtin trusted keyring (with
hard-coded certificates), the second trusted keyring can include
certificate authorities from the builtin trusted keyring and child
certificates loaded at run time. Using the secondary trusted keyring
enables to use dm-verity disks (e.g. loop devices) signed by keys which
did not exist at kernel build time, leveraging the certificate chain of
trust model. In practice, this allows to update certificates without
kernel update and reboot, aligning with module and kernel (kexec)
signature verification which already use the secondary trusted keyring.


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

