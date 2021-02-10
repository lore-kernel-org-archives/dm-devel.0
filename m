Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BA0C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 19:56:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB91964EE8
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 19:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB91964EE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-idHozrSENc-b-mtYHg-juw-1; Wed, 10 Feb 2021 14:56:52 -0500
X-MC-Unique: idHozrSENc-b-mtYHg-juw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E6B780196E;
	Wed, 10 Feb 2021 19:56:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3CE1100164C;
	Wed, 10 Feb 2021 19:56:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 071A318095C9;
	Wed, 10 Feb 2021 19:56:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AJtmET008109 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 14:55:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 242B02026D14; Wed, 10 Feb 2021 19:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F44B2026D11
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 19:55:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2505D185A793
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 19:55:45 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-37-wLwj53x4MqyFHpbqWZPGZg-1; 
	Wed, 10 Feb 2021 14:55:41 -0500
X-MC-Unique: wLwj53x4MqyFHpbqWZPGZg-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6720364EE6;
	Wed, 10 Feb 2021 19:55:38 +0000 (UTC)
Date: Wed, 10 Feb 2021 11:55:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Satya Tangirala <satyat@google.com>
Message-ID: <YCQ6OBExblohlnfO@gmail.com>
References: <20210201051019.1174983-1-satyat@google.com>
	<20210201051019.1174983-3-satyat@google.com>
MIME-Version: 1.0
In-Reply-To: <20210201051019.1174983-3-satyat@google.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 2/5] block: keyslot-manager: Introduce
 functions for device mapper support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 01, 2021 at 05:10:16AM +0000, Satya Tangirala wrote:
> Introduce blk_ksm_update_capabilities() to update the capabilities of
> a keyslot manager (ksm) in-place. The pointer to a ksm in a device's
> request queue may not be easily replaced, because upper layers like
> the filesystem might access it (e.g. for programming keys/checking
> capabilities) at the same time the device wants to replace that
> request queue's ksm (and free the old ksm's memory). This function
> allows the device to update the capabilities of the ksm in its request
> queue directly. Devices can safely update the ksm this way without any
> synchronization with upper layers *only* if the updated (new) ksm
> continues to support all the crypto capabilities that the old ksm did
> (see description below for blk_ksm_is_superset() for why this is so).
> 
> Also introduce blk_ksm_is_superset() which checks whether one ksm's
> capabilities are a (not necessarily strict) superset of another ksm's.
> The blk-crypto framework requires that crypto capabilities that were
> advertised when a bio was created continue to be supported by the
> device until that bio is ended - in practice this probably means that
> a device's advertised crypto capabilities can *never* "shrink" (since
> there's no synchronization between bio creation and when a device may
> want to change its advertised capabilities) - so a previously
> advertised crypto capability must always continue to be supported.
> This function can be used to check that a new ksm is a valid
> replacement for an old ksm.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Looks good, you can add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

