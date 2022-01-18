Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D6BC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 20:27:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-2STeXfe1MEWlwYuz8zcrlA-1; Tue, 18 Jan 2022 15:27:49 -0500
X-MC-Unique: 2STeXfe1MEWlwYuz8zcrlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AF57100B3AE;
	Tue, 18 Jan 2022 20:27:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F36444D70D;
	Tue, 18 Jan 2022 20:27:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 408624BB7C;
	Tue, 18 Jan 2022 20:27:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20IKRfbT024446 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 15:27:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2310E1402408; Tue, 18 Jan 2022 20:27:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F2911402404
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 20:27:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04D23108C0E2
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 20:27:41 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-673-2RZo2-xZPkKvZil9k-jlCA-1; Tue, 18 Jan 2022 15:27:38 -0500
X-MC-Unique: 2RZo2-xZPkKvZil9k-jlCA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id AE3AEB81772;
	Tue, 18 Jan 2022 20:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42309C340E0;
	Tue, 18 Jan 2022 20:27:35 +0000 (UTC)
Date: Tue, 18 Jan 2022 12:27:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <Yecitbf4lJtQA69O@sol.localdomain>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeUgNpFeg9LmW4Um@infradead.org>
	<0461b15e-8ace-5a84-cf9d-504e555b8cab@gmail.com>
	<2d937f09-e18c-6a95-bc6c-45bf5d1b1a11@nvidia.com>
	<YebupSYksz2gV8vn@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YebupSYksz2gV8vn@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20IKRfbT024446
X-loop: dm-devel@redhat.com
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	dm-devel <dm-devel@redhat.com>, Nitzan Carmi <nitzanc@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 18, 2022 at 08:45:25AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 17, 2022 at 04:00:59PM +0200, Israel Rukshin wrote:
> > DM extension gives us several capabilities:
> >=20
> > 1. Use the Linux keyring and other key management tools.
> >=20
> > =A0=A0=A0 - I used "keyctl padd user test-key @u < /tmp/wrapped_dek" at=
 my tests
>=20
> Well, and kernel consumer can do that.
>=20
> > 2. Split a single block device into several DMs. Allow us to use a diff=
erent
> > encryption key and encryption mode per DM.
>=20
> If we allow setting a default key for every block device you can still
> do that using normal dm-linear.
>=20
> >=20
> > 3. Replace a key during I/O by using "dmsetup suspend /dev/dm-0" and
> > "dmsetup=A0 resume /dev/dm-0".
>=20
> With a block layer ioctl that also works easily.
>=20

A while ago, I had looked into adding an ioctl to set a default key for a b=
lock
device.  There were a few things that led me to choose a dm target instead.=
  I'm
not sure how many of these are still relevant, but these are what I conside=
red:

* The block device for a partition doesn't have its own request_queue or
  queue_limits; those are properties of the disk, not the partition.  But,
  setting an encryption key may require changes to the queue_limits.  For
  example, discard_zeroes_data will no longer work, and the logical_block_s=
ize
  will need to become the crypto data unit size which may be larger than th=
e
  original logical_block_size.

* The block_device for a given partition didn't stay around while no one ha=
s it
  opened or mounted.  This may have been addressed by Christoph's changes l=
ast
  year that merged block_device and hd_struct, but this used to be an issue=
.

* There was some issue caused by the way the block layer maps partitions to
  disks; the knowledge of the original block device (and thus the key) was =
lost
  at this point.  I'm not sure whether this is still an issue or not.

* A block device ioctl to set a key would need to handle cases where the bl=
ock
  device is already open (fail with EBUSY?), or already has pages cached in=
 the
  pagecache (invalidate them?).  A dm target avoids these concerns since a =
key
  would only be set up when the disk and block device are originally create=
d.

Finally, there's also the fact that this would really be more than "setting=
 a
default key".  To precisely specify the encryption format, you also have to
specify the algorithm, the key type, and the data unit size.  (Also potenti=
ally
more details about IV generation, if blk-crypto ever starts to support more=
 IV
generation methods, which I'd like to avoid but it might eventually happen.=
)

These could all be passed in an ioctl, but dm-crypt already has a syntax de=
fined
for specifying encryption formats.  So it could make sense to reuse it.

Also as Israel indicated, people will want support for Linux keyring keys a=
s an
alternative to raw keys.  A new ioctl could support this, though dm-crypt
already has a defined way to specify such keys.

If all these issues can be solved, then I'd be fine with the block device i=
octl.

- Eric


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

