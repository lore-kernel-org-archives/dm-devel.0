Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE43C77B72
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973846;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rvaEgBNd950lJpTjYgTI/pETMhxtPJeX34EiJzYvF3c=;
	b=Su8GcB3vgEbbQZ1Q5+O0drqXVY/GchMS1xiM4Xkt8WiE9Mbq3+6uOCW/zzuCYA7gHc7Kaw
	ZyM6HbgAApiABUzlTve0HKtCobdU3KxK7bjlNsmcfuvi7eBI/fv1q+Zg6efwolJfV51bfO
	/sZb8+EYnOhjFhQywpBIqWDMs8mbHfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-JSEsPWSiN0mDmUlxUeOXXw-1; Thu, 20 Apr 2023 02:57:22 -0400
X-MC-Unique: JSEsPWSiN0mDmUlxUeOXXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EF6A857A8E;
	Thu, 20 Apr 2023 06:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 087FEC164ED;
	Thu, 20 Apr 2023 06:57:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE12F19472C9;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EEDF119465B2
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 15:49:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CF5A52166B34; Wed, 19 Apr 2023 15:49:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7FB82166B33
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 15:49:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB2542823817
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 15:49:36 +0000 (UTC)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-_38M6DXIMOKqRhqBZmRxkQ-1; Wed, 19 Apr 2023 11:49:33 -0400
X-MC-Unique: _38M6DXIMOKqRhqBZmRxkQ-1
Received: by mail-ej1-f43.google.com with SMTP id a5so26396558ejb.6;
 Wed, 19 Apr 2023 08:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681919371; x=1684511371;
 h=content-transfer-encoding:in-reply-to:subject:from:content-language
 :references:cc:to:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=eOUql/Ro9WMFOAkCEiG4JHxRup0JACmg1t6/598D9Co=;
 b=ci1fYGm522l9rRpOCQdjmdmXztdFzzXZO3VRx9u/aBBBtrRxbMcyQt6Df9ADLeqfaR
 mD/nUKmTkoaG4D+U0WiO0CUodoFqWeyZ8d7sqNXJcq+RcqYZJNZL4chyUgUg0fELMjsl
 FR6fB94G4u9HtKrWP2c59yrrMGGiwNlcTFMvO4EUGnAxT2urS0eyAt6AU3v11881tx6J
 6BMEx4F7QzbRSDl69GWqa6ppiKZ2PGhFfQt59LnSlrufghzcC+5qZ8h2j3sfejgTkwfl
 XbfJiUy2AMiYaKuT2xnUuck1UG13Kfh5mBIDhnuXvkBGW1UsUrXEzECVaTfC5lJvMDvr
 v2qQ==
X-Gm-Message-State: AAQBX9e+aTu2U7AEwy2m8P2JdSLgYE9oBmnb+GCLf70REX1FsEM7r7TE
 z/dQX6UR6fCCdpH+Hw41cFg=
X-Google-Smtp-Source: AKy350aGL2zkmqe4oR+uMj3AvMO3DzPKJ+2nYfKvNg29gbfKfCGrXHIDbSOpWzqvwSwoi/4pOYVBdg==
X-Received: by 2002:a17:907:98ef:b0:92c:8e4a:1a42 with SMTP id
 ke15-20020a17090798ef00b0092c8e4a1a42mr15999637ejc.32.1681919370719; 
 Wed, 19 Apr 2023 08:49:30 -0700 (PDT)
Received: from [192.168.32.129] (aftr-62-216-205-204.dynamic.mnet-online.de.
 [62.216.205.204]) by smtp.gmail.com with ESMTPSA id
 o26-20020a1709061d5a00b0094e44899367sm9373601ejh.101.2023.04.19.08.49.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 19 Apr 2023 08:49:30 -0700 (PDT)
Message-ID: <0388e267-6a5f-85b8-83eb-62ea5aae06e1@kernel.org>
Date: Wed, 19 Apr 2023 17:49:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Matthew Wilcox <willy@infradead.org>
References: <20230419140929.5924-1-jth@kernel.org>
 <20230419140929.5924-20-jth@kernel.org>
 <ZD/4b9ZQ1YZRTgHL@casper.infradead.org>
From: Johannes Thumshirn <jth@kernel.org>
In-Reply-To: <ZD/4b9ZQ1YZRTgHL@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: Re: [dm-devel] [PATCH v3 19/19] block: mark bio_add_page as
 __must_check
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, cluster-devel@redhat.com,
 kch@nvidia.com, snitzer@kernel.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, rpeterso@redhat.com, dsterba@suse.com,
 axboe@kernel.dk, linux-raid@vger.kernel.org, damien.lemoal@wdc.com,
 song@kernel.org, johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 19/04/2023 16:19, Matthew Wilcox wrote:
> On Wed, Apr 19, 2023 at 04:09:29PM +0200, Johannes Thumshirn wrote:
>> Now that all users of bio_add_page check for the return value, mark
>> bio_add_page as __must_check.
> 
> Should probably add __must_check to bio_add_folio too?  If this is
> really the way you want to go ... means we also need a
> __bio_add_folio().

I admit I haven't thought of folios, mea culpa.

3 of the callers of bio_add_folio() don't check the return value:
$ git grep -E '\sbio_add_folio\b'
fs/iomap/buffered-io.c:         bio_add_folio(ctx->bio, folio, plen, poff);
fs/iomap/buffered-io.c: bio_add_folio(&bio, folio, plen, poff);
fs/iomap/buffered-io.c:         bio_add_folio(wpc->ioend->io_bio, folio, 
len, poff);

But from a quick look they look OK to me.

Does that look reasonable to you:

diff --git a/block/bio.c b/block/bio.c
index fd11614bba4d..f3a3524b53e4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1138,6 +1138,14 @@ int bio_add_page(struct bio *bio, struct page *page,
  }
  EXPORT_SYMBOL(bio_add_page);

+void __bio_add_folio(struct bio *bio, struct folio *folio, size_t len,
+                    size_t off)
+{
+       WARN_ON_ONCE(len > UINT_MAX);
+       WARN_ON_ONCE(off > UINT_MAX);
+       __bio_add_page(bio, &folio->page, len, off);
+}
+
  /**
   * bio_add_folio - Attempt to add part of a folio to a bio.
   * @bio: BIO to add to.


Byte,
	Johannes

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

