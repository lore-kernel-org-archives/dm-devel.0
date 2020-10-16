Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43EEC433E7
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 07:18:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7E2522240
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 07:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7E2522240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-iitClkH2MoSi6XitHXhdqQ-1; Mon, 19 Oct 2020 03:18:09 -0400
X-MC-Unique: iitClkH2MoSi6XitHXhdqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9B7618A0737;
	Mon, 19 Oct 2020 07:18:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 246F35C225;
	Mon, 19 Oct 2020 07:18:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CEFA61800B72;
	Mon, 19 Oct 2020 07:18:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GCJKme032457 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 08:19:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B35621160DFF; Fri, 16 Oct 2020 12:19:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF9061160DFE
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 12:19:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71AD4811E79
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 12:19:18 +0000 (UTC)
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch
	[83.166.143.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-309-icmd76BROR2BCJ4Bc_3YgA-1; Fri, 16 Oct 2020 08:19:15 -0400
X-MC-Unique: icmd76BROR2BCJ4Bc_3YgA-1
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id
	4CCQDy0WxlzlhX9r; Fri, 16 Oct 2020 14:19:14 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [94.23.54.103])
	by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id
	4CCQDx0z2wzlh8TJ; Fri, 16 Oct 2020 14:19:13 +0200 (CEST)
To: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>
References: <20201015150504.1319098-1-mic@digikod.net>
	<20201015165229.GA5513@redhat.com>
	<022e949e-00c4-d98a-b536-1c5f9e05c09c@digikod.net>
	<b7ba2ff9-5f5f-8c1e-dfaa-33da56d3d8de@digikod.net>
	<b7ccaa01-0398-f108-a70d-c67753d9fa6d@gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <55389f91-60a5-05db-b3e1-8f24aa356893@digikod.net>
Date: Fri, 16 Oct 2020 14:19:12 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <b7ccaa01-0398-f108-a70d-c67753d9fa6d@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GCJKme032457
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 19 Oct 2020 03:17:59 -0400
Cc: Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	=?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alasdair Kergon <agk@redhat.com>,
	Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [dm-devel] [PATCH v2] dm verity: Add support for signature
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


On 16/10/2020 13:08, Milan Broz wrote:
> On 16/10/2020 10:49, Micka=EBl Sala=FCn wrote:
>> On 16/10/2020 10:29, Micka=EBl Sala=FCn wrote:
>>>
>>> On 15/10/2020 18:52, Mike Snitzer wrote:
>>>> Can you please explain why you've decided to make this a Kconfig CONFI=
G
>>>> knob?=A0 Why not either add: a dm-verity table argument? A dm-verity
>>>> kernel module parameter? or both (to allow a particular default but
>>>> then
>>>> per-device override)?
>>>
>>> The purpose of signed dm-verity images is to authenticate files, or sai=
d
>>> in another way, to enable the kernel to trust disk images in a flexible
>>> way (i.e. thanks to certificate's chain of trust). Being able to update
>>> such chain at run time requires to use the second trusted keyring. This
>>> keyring automatically includes the certificate authorities from the
>>> builtin trusted keyring, which are required to dynamically populate the
>>> secondary trusted keyring with certificates signed by an already truste=
d
>>> authority. The roots of trust must then be included at build time in th=
e
>>> builtin trusted keyring.
>>>
>>> To be meaningful, using dm-verity signatures implies to have a
>>> restricted user space, i.e. even the root user has limited power over
>>> the kernel and the rest of the system. Blindly trusting data provided b=
y
>>> user space (e.g. dm-verity table argument, kernel module parameter)
>>> defeat the purpose of (mandatory) authenticated images.
>>>
>>>>
>>>> Otherwise, _all_ DM verity devices will be configured to use secondary
>>>> keyring fallback.=A0 Is that really desirable?
>>>
>>> That is already the current state (on purpose).
>>
>> I meant that when DM_VERITY_VERIFY_ROOTHASH_SIG is set, dm-verity
>> signature becomes mandatory. This new configuration
>> DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING extend this trust to the
>> secondary trusted keyring, which contains certificates signed (directly
>> or indirectly) by CA from the builtin trusted keyring.
>>
>> So yes, this new (optional) configuration *extends* the source of trust
>> for all dm-verity devices, and yes, it is desirable. I think it should
>> have been this way from the beginning (as for other authentication
>> mechanisms) but it wasn't necessary at that time.
>=20
> Well, I understand why you need a config option here.
> And using the secondary keyring actually makes much more sense to me than
> the original approach.
>=20
> But please do not forget that dm-verity is sometimes used in different
> contexts where such strict in-kernel certificate trust is unnecessary.
> With your configure options set, you deliberately remove the possibility
> to configure such devices.
It doesn't make sense to set DM_VERITY_VERIFY_ROOTHASH_SIG in generic
distro because such policy is configured at build time in the kernel
with hardcoded CAs. If the new option is not set then nothing change. I
don't see why it could be an issue for use cases we previously defined
(with DM_VERITY_VERIFY_ROOTHASH_SIG).

> I understand that it is needed for "trusted" systems, but we should be
> clear
> in the documentation.
> Maybe also add note to
> /Documentation/admin-guide/device-mapper/verity.rst ?
> We already mention DM_VERITY_VERIFY_ROOTHASH_SIG there.

The current documentation remains true.
DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING depends on
DM_VERITY_VERIFY_ROOTHASH_SIG.

>=20
> The current userspace configuration through veritysetup does not need
> any patches for your patch, correct?

Right, it's only different from the kernel point of view.

>=20
> Thanks,
> Milan
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

