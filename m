Return-Path: <SRS0=jm7j=OZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98F4C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Oct 2021 17:26:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E48C61215
	for <dm-devel@archiver.kernel.org>; Tue,  5 Oct 2021 17:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3E48C61215
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-r5vUrN7xPEa7-7ZdtfHBNw-1; Tue, 05 Oct 2021 13:26:38 -0400
X-MC-Unique: r5vUrN7xPEa7-7ZdtfHBNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56DF59126F;
	Tue,  5 Oct 2021 17:26:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD68360C05;
	Tue,  5 Oct 2021 17:26:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9EB7A4E58F;
	Tue,  5 Oct 2021 17:26:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 195HQR8V027697 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Oct 2021 13:26:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 81D4B2028107; Tue,  5 Oct 2021 17:26:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 794212026D65
	for <dm-devel@redhat.com>; Tue,  5 Oct 2021 17:26:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E78CA811E76
	for <dm-devel@redhat.com>; Tue,  5 Oct 2021 17:26:21 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-495-Pvu39tnjNieT1NLRgA-Bvw-1;
	Tue, 05 Oct 2021 13:26:19 -0400
X-MC-Unique: Pvu39tnjNieT1NLRgA-Bvw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE6A61350;
	Tue,  5 Oct 2021 17:26:18 +0000 (UTC)
Date: Tue, 5 Oct 2021 10:26:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <YVyKuXgDjNgNdSHS@gmail.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210929163600.52141-1-ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 0/4] blk-crypto cleanups
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 29, 2021 at 09:35:56AM -0700, Eric Biggers wrote:
> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the
> "blk-crypto profile" of a device, similar to blk_integrity_profile.
> 
> This series also improves the inline-encryption.rst documentation file,
> and cleans up blk-crypto-fallback a bit.
> 
> This series applies to block/for-next.
> 
> Changed v3 => v4:
>   - Rebased onto block/for-next to resolve a conflict due to
>     'struct request' being moved.
> 

Ping?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

