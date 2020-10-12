Return-Path: <SRS0=9700=DW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379B7C433E7
	for <dm-devel@archiver.kernel.org>; Thu, 15 Oct 2020 08:08:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7AB982224A
	for <dm-devel@archiver.kernel.org>; Thu, 15 Oct 2020 08:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AB982224A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-rXS06SG5Pf6X_Rnq6EFDtg-1; Thu, 15 Oct 2020 04:08:06 -0400
X-MC-Unique: rXS06SG5Pf6X_Rnq6EFDtg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BFE2803620;
	Thu, 15 Oct 2020 08:08:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A3FF60CD0;
	Thu, 15 Oct 2020 08:07:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A433C44A66;
	Thu, 15 Oct 2020 08:07:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09CNuKFU010216 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Oct 2020 19:56:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9414E2166BDB; Mon, 12 Oct 2020 23:56:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EA912166BA4
	for <dm-devel@redhat.com>; Mon, 12 Oct 2020 23:56:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75A1280018B
	for <dm-devel@redhat.com>; Mon, 12 Oct 2020 23:56:17 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-172-T4omkkyQMX-HUPhyY3V2ng-1; Mon, 12 Oct 2020 19:56:14 -0400
X-MC-Unique: T4omkkyQMX-HUPhyY3V2ng-1
IronPort-SDR: PRoCyUkx6E5gFMD91z6UY4lqWs8Y16ScBq2mtEOSMN6XSeUOhvWuQpXLDRYo6MjnNU1WUT9BSQ
	PMt7aW8ksXlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="153650692"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; d="scan'208";a="153650692"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
	by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	12 Oct 2020 16:55:07 -0700
IronPort-SDR: SV0qYb63niNV9GMArm2g502LOO41WCibREwQLWEdJpDSZOVJp3Wfeu2Ylls0Vzbg/P9gkErI/D
	AupL5AM/4/Zw==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; d="scan'208";a="530165565"
Received: from lusin-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.81])
	by orsmga005-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:55:04 -0700
Date: Tue, 13 Oct 2020 02:55:02 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Message-ID: <20201012235502.GA36149@linux.intel.com>
References: <20201002071802.535023-1-mic@digikod.net>
	<bda2ffd7-3b7c-33a4-667f-a3435e112fc1@digikod.net>
MIME-Version: 1.0
In-Reply-To: <bda2ffd7-3b7c-33a4-667f-a3435e112fc1@digikod.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 15 Oct 2020 04:07:55 -0400
Cc: Mike Snitzer <snitzer@redhat.com>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-ID: <20201012235502.gE6wi5e5wP3uYNrY3JCW1uJ4FcoHj-g9Q2cSUr9FmU0@z>

On Fri, Oct 09, 2020 at 11:50:03AM +0200, Micka=C3=ABl Sala=C3=BCn wrote:
> Hi,
>=20
> What do you think about this patch?
>=20
> Regards,
>  Micka=C3=ABl
>=20
> On 02/10/2020 09:18, Micka=C3=ABl Sala=C3=BCn wrote:
> > From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> >=20
> > Add a new DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING configuration
> > to enable dm-verity signatures to be verified against the secondary
> > trusted keyring.  This allows certificate updates without kernel update
> > and reboot, aligning with module and kernel (kexec) signature
> > verifications.

I'd prefer a bit more verbose phrasing, not least because I have never
really even peeked at dm-verity, but it is also a good practice.

You have the middle part of the story missing - explaining the semantics
of how the feature leads to the aimed solution.

/Jarkko

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

