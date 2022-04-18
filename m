Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652A6C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 01:33:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-qUhsMa9BPpy04Y1tleNMKw-1; Sun, 17 Apr 2022 21:32:57 -0400
X-MC-Unique: qUhsMa9BPpy04Y1tleNMKw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA83080B710;
	Mon, 18 Apr 2022 01:32:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81DD7400F24;
	Mon, 18 Apr 2022 01:32:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DBD019451F1;
	Mon, 18 Apr 2022 01:32:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9570A19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 01:32:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7FD7D401E9C; Mon, 18 Apr 2022 01:32:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BFF0400F24
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 01:32:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61B9680159B
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 01:32:51 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-uFrLqqcpOeWWvbfq27y8ZA-1; Sun, 17 Apr 2022 21:32:49 -0400
X-MC-Unique: uFrLqqcpOeWWvbfq27y8ZA-1
Received: by mail-pj1-f47.google.com with SMTP id
 z6-20020a17090a398600b001cb9fca3210so12794350pjb.1
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 18:32:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=KJfLbwgngO3OiGtIZhQTnGZUpV/6KTf4a6VxaVn0jHA=;
 b=EepCAWy6fBD/doFkatbsHNf4aY8qLEym9OA9FoCJdRtK7CYbVjpMcEIkQsIoA6ixOz
 6jEyDQb2mMhQR2v6CKU5oXhizRkHiQSXCJSBfgXBL3JqF3/UaijQjW9z2aAN9WNumu8r
 4/hjTmH5LxAfUPZWMc0c8s3yZ6wHoWeKxEtJIX3KVhiZuZLXtJdnvdge08FwWU4Edi30
 ZUzXsYNedyI+xQpAyYbgX5TvhUBvyfETZwcUd+xhpYc2sXlFRDcE5VssmHzfmZMCmUeT
 nmWQP1CMPnPTH55FYRVPgHgZvX5eOfwMzXG2zqlOIpVinBd66YeEePIx+mUF7zxBs9Bq
 0AvQ==
X-Gm-Message-State: AOAM533g00HoZ5/bbPqja3vDbraQWi/QDumL8XqCJNmTjzHx1cPVWkP0
 f6ZyliedrXbz2Wyjni3S1nwuCA==
X-Google-Smtp-Source: ABdhPJxH3Tcv8urG8TWDL99aaKBrMqsxLK1RCMCg75RZRVpxh7Td568gOGSDadX3DzyNp9aRqA2iCg==
X-Received: by 2002:a17:903:2406:b0:158:f6f0:6c44 with SMTP id
 e6-20020a170903240600b00158f6f06c44mr4676524plo.88.1650245568439; 
 Sun, 17 Apr 2022 18:32:48 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 g15-20020a63be4f000000b0039934531e95sm10726611pgo.18.2022.04.17.18.32.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 18:32:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220406061228.410163-1-hch@lst.de>
References: <20220406061228.410163-1-hch@lst.de>
Message-Id: <165024556441.258485.6980891929042026868.b4-ty@kernel.dk>
Date: Sun, 17 Apr 2022 19:32:44 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] cleanup bio_kmalloc v3
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 snitzer@redhat.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 josef@toxicpanda.com, colyli@suse.de, linux-block@vger.kernel.org,
 song@kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org,
 dsterba@suse.com, phillip@squashfs.org.uk, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 6 Apr 2022 08:12:23 +0200, Christoph Hellwig wrote:
> this series finishes off the bio allocation interface cleanups by dealing
> with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
> for the bio and bio_vecs with a hidden bio_init call and magic cleanup
> semantics.
> 
> This series moves a few callers away from bio_kmalloc and then turns
> bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
> inline biovecs.  The callers need to manually call bio_init instead with
> all that entails and the magic that turns bio_put into a kfree goes away
> as well, allowing for a proper debug check in bio_put that catches
> accidental use on a bio_init()ed bio.
> 
> [...]

Applied, thanks!

[1/5] btrfs: simplify ->flush_bio handling
      commit: f9e69aa9ccd7e51c47b147e45e03987ea0ef9aa3
[2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
      commit: 46a2d4ccc49903923506685a8368ca88312bbdc9
[3/5] target/pscsi: remove pscsi_get_bio
      commit: 7655db80932d95f501a0811544d9520ec720e38d
[4/5] block: turn bio_kmalloc into a simple kmalloc wrapper
      commit: 066ff571011d8416e903d3d4f1f41e0b5eb91e1d
[5/5] pktcdvd: stop using bio_reset
      commit: 852ad96cb03621f7995764b4b31cbff9801d8bcd

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

