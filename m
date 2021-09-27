Return-Path: <SRS0=coXp=OR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E920FC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 18:09:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6D67760F12
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 18:09:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6D67760F12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-bcrwlNUSORS7e7NRn4ghog-1; Mon, 27 Sep 2021 14:09:23 -0400
X-MC-Unique: bcrwlNUSORS7e7NRn4ghog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAE25362FA;
	Mon, 27 Sep 2021 18:09:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CFD76CA29;
	Mon, 27 Sep 2021 18:09:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 19ECD1806D02;
	Mon, 27 Sep 2021 18:09:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18RI9EFu007258 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 27 Sep 2021 14:09:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E43A4C83C; Mon, 27 Sep 2021 18:09:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04DB64E3C5
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 18:09:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C82E2800B29
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 18:09:09 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-206-Su2b-OLIPuWOaAjU8NGnyQ-1;
	Mon, 27 Sep 2021 14:09:07 -0400
X-MC-Unique: Su2b-OLIPuWOaAjU8NGnyQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A31960F12;
	Mon, 27 Sep 2021 18:09:06 +0000 (UTC)
Date: Mon, 27 Sep 2021 11:09:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <YVIIwUv9Vwd2dFt8@gmail.com>
References: <20210923185629.54823-1-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210923185629.54823-1-ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v3 0/4] blk-crypto cleanups
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 23, 2021 at 11:56:25AM -0700, Eric Biggers wrote:
> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the
> "blk-crypto profile" of a device, similar to blk_integrity_profile.
> 
> This series also improves the inline-encryption.rst documentation file,
> and cleans up blk-crypto-fallback a bit.
> 
> This series applies to v5.15-rc2.
> 
> Changed v2 => v3:
>   - Made some minor tweaks to patches 3 and 4, mostly comments and
>     documentation.
>   - Clarified a commit message to mention no change in behavior.
>   - Added a Reviewed-by tag.
> 
> Changed v1 => v2:
>   - Fixed a build error in blk-integrity.c.
>   - Removed a mention of "ksm" from a comment.
>   - Dropped the patch "blk-crypto-fallback: consolidate static variables".
>   - Added Acked-by and Reviewed-by tags.
> 
> Eric Biggers (4):
>   blk-crypto-fallback: properly prefix function and struct names
>   blk-crypto: rename keyslot-manager files to blk-crypto-profile
>   blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
>   blk-crypto: update inline encryption documentation

Any more feedback on this?  If there are any objections to the renaming of
blk_keyslot_manager to blk_crypto_profile, now is the time to speak up.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

