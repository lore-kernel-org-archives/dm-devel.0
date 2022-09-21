Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54573C6FA8E
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 08:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663749247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1MFXgwudqJM3FlIHSXM6xb/vhMARz6qFFjz/5fJ0lgo=;
	b=ZWCk98uvCN1gUyBQv0SjI1PZ0EeNBOoN/xUYqoibI+8WqUsbPTjGZZT7yUjPyUhY40FpW5
	2/2f22A4pVUYvaOKq9T+3g1dNayezVPn1sN3P/qSjUcJFpeSo/KydWPkgPWv16nZjK6n68
	9elgvJH/pEcfzuieDEgSlxZSCpT9O6I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-QO5-sRC_PiCgD9bHb1bOGw-1; Wed, 21 Sep 2022 04:34:03 -0400
X-MC-Unique: QO5-sRC_PiCgD9bHb1bOGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C27C857FAC;
	Wed, 21 Sep 2022 08:34:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CE6E111E3E8;
	Wed, 21 Sep 2022 08:33:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB7E919465B7;
	Wed, 21 Sep 2022 08:33:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 940E11946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 05:54:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77A8440C206B; Wed, 21 Sep 2022 05:54:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7086F40C2064
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 05:54:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54417101245E
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 05:54:56 +0000 (UTC)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com
 [209.85.218.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-2CNxhhkbOvattLDyCEPgFA-1; Wed, 21 Sep 2022 01:54:44 -0400
X-MC-Unique: 2CNxhhkbOvattLDyCEPgFA-1
Received: by mail-ej1-f50.google.com with SMTP id r18so11106998eja.11
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 22:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=O+/FFDzqjGUa/uvDMSfAuiQjEkg5o9+lgPvGbc+n8wE=;
 b=fGlEzyA7rCAYu4GiDzH1UKvTJuqhxOFXnTFMKN527gLYPAlSV7Bt4fxbCsIF8/qqQu
 Hk6AnSOpa0v8vH+dlHeU0waeEUazAhnX6emeAZBmtt+9rRVwVMGymxU0StgH53FUhrJw
 bk+LAMXM11nU7XUfTZOZFDEoT3AHZRpyN8Y6uJQJAWOTZrh/7VLN4peK9SvOpozrnu5W
 cU0k5o0nFucXKoQbQxGbpZmuBko+i+8jPeB1TO8C08B9KWvkCzcgshHf77qNn5TFCc1X
 s32br2SXfn0wT9NL7U/xGChwhrJF1zMRannRgNRUgLz0BZm6NacGKCliFLhPS/E3QJKX
 ub2Q==
X-Gm-Message-State: ACrzQf1Pzi8YBzvzxhjZN8IKJzQLF7e9mZDCYuGf3s7qLm35EYZJLl18
 +SwIbpdX4JgThRXkIyOjwzVgV+Ngqwv3Xfh37L1j6Q==
X-Google-Smtp-Source: AMsMyM7DwZfJgUBj+Jcm+ahguQtT7+RYi7n81t2AfUSbJlFqnH/D7ZLc78O5AtvKtve14UtIE21JWlJbn+K5xTQxSGs=
X-Received: by 2002:a17:907:7289:b0:780:2017:3898 with SMTP id
 dt9-20020a170907728900b0078020173898mr19775359ejc.276.1663739683574; Tue, 20
 Sep 2022 22:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YylweQAZkIdb5ixo@infradead.org>
In-Reply-To: <YylweQAZkIdb5ixo@infradead.org>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Tue, 20 Sep 2022 22:54:32 -0700
Message-ID: <CAG9=OMNoG01UUStNs_Zhsv6mXZw0M0q2v54ZriJvHZ4aspvjEQ@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 21 Sep 2022 08:33:55 +0000
Subject: Re: [dm-devel] [PATCH RFC 4/8] fs: Introduce FALLOC_FL_PROVISION
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org,
 Evan Green <evgreen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 20, 2022 at 12:49 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> >
> > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > sends a hint to (supported) thinly provisioned block devices to
> > allocate space for the given range of sectors via REQ_OP_PROVISION.
>
> So, how does that "provisioning" actually work in todays world where
> storage is usually doing out of place writes in one or more layers,
> including the flash storage everyone is using.  Does it give you one
> write?  And unlimited number?  Some undecided number inbetween?

Apologies, the patchset was a bit short on describing the semantics so
I'll expand more in the next revision; I'd say that it's the minimum
of regular mode fallocate() guarantees at each allocation layer. For
example, the guarantees from a contrived storage stack like (left to
right is bottom to top):

[ mmc0blkp1 | ext4(1) | sparse file | loop | dm-thinp | dm-thin | ext4(2) ]

would be predicated on the guarantees of fallocate() per allocation
layer; if ext4(1) was replaced by a filesystem that did not support
fallocate(), then there would be no guarantee that a write to a file
on ext4(2) succeeds.

For dm-thinp, in the current implementation, the provision request
allocates blocks for the range specified and adds the mapping to the
thinpool metadata. All subsequent writes are to the same block, so
you'll be able to write to the same block inifinitely. Brian mentioned
this above, one case it doesn't cover is if provision is called on a
shared block, but the natural extension would be to allocate and
assign a new block and copy the contents of the shared block (kind of
like copy-on-provision).

[reflowed]
> How is it affected by write zeroes to that range or a discard?

The current semantics of discards for dm-thinp/ext4/sparse files will
apply as they do today; discards will unmap the dm-thin block/free the
file extent. Write zeroes is more interesting; dm-thinp will treat the
command as usual. ext4_zero_range will mark the extents as unwritten,
so essentially if a user did provision + write to a block, write zeros
to the block would essentially leave it in the original provisioned
state, but ext4 would now show the contents of the block as zero on
the next read. I think, similar to above, the semantics of a request
will depend on each layer that it passes through.

Best
Sarthak

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

