Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B8AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 17:58:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-Ak6fzrPQOGyWMKoFgHJrvQ-1; Tue, 18 Jan 2022 12:58:23 -0500
X-MC-Unique: Ak6fzrPQOGyWMKoFgHJrvQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B160146890;
	Tue, 18 Jan 2022 17:58:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 213A010A48CE;
	Tue, 18 Jan 2022 17:58:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50D444BB7C;
	Tue, 18 Jan 2022 17:57:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20IGjUuI003238 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 11:45:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A0C0840CFD32; Tue, 18 Jan 2022 16:45:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D11040CFD22
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 16:45:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 843303C29341
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 16:45:30 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-595-EKICKCWnN5qpSCAyzjMoSg-1; Tue, 18 Jan 2022 11:45:28 -0500
X-MC-Unique: EKICKCWnN5qpSCAyzjMoSg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1n9rbp-002HY4-2S; Tue, 18 Jan 2022 16:45:25 +0000
Date: Tue, 18 Jan 2022 08:45:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Israel Rukshin <israelr@nvidia.com>
Message-ID: <YebupSYksz2gV8vn@infradead.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeUgNpFeg9LmW4Um@infradead.org>
	<0461b15e-8ace-5a84-cf9d-504e555b8cab@gmail.com>
	<2d937f09-e18c-6a95-bc6c-45bf5d1b1a11@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <2d937f09-e18c-6a95-bc6c-45bf5d1b1a11@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Eric Biggers <ebiggers@google.com>,
	Christoph Hellwig <hch@infradead.org>, dm-devel <dm-devel@redhat.com>,
	Nitzan Carmi <nitzanc@nvidia.com>, Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2022 at 04:00:59PM +0200, Israel Rukshin wrote:
> DM extension gives us several capabilities:
>=20
> 1. Use the Linux keyring and other key management tools.
>=20
> =A0=A0=A0 - I used "keyctl padd user test-key @u < /tmp/wrapped_dek" at m=
y tests

Well, and kernel consumer can do that.

> 2. Split a single block device into several DMs. Allow us to use a differ=
ent
> encryption key and encryption mode per DM.

If we allow setting a default key for every block device you can still
do that using normal dm-linear.

>=20
> 3. Replace a key during I/O by using "dmsetup suspend /dev/dm-0" and
> "dmsetup=A0 resume /dev/dm-0".

With a block layer ioctl that also works easily.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

