Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6CFC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 15 Dec 2022 12:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671107732;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YrFundgctuwIOLRoRekR9Ip4XQXo3Z+e7gEFJQBRFng=;
	b=be3m2cR9sANf01MYi6Cw798TdNHwajJVrS6yCtGC5VgdoAiSweVKTVRSa5+C3EWdeIo+I7
	w2bj3FHcFSXTiK80B4TVfCpKkwWq/MgFOhdKn3eKoXIkHAuARxwVevsCg9j2MvFjdcGnPx
	RX6DLDZOi6YE+ULbjdozTyaBZbyinsY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-9_ZXNj12P221ha44Wv_Wsg-1; Thu, 15 Dec 2022 07:35:29 -0500
X-MC-Unique: 9_ZXNj12P221ha44Wv_Wsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B47D1C0A587;
	Thu, 15 Dec 2022 12:35:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49A121121314;
	Thu, 15 Dec 2022 12:35:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B2EE1946A72;
	Thu, 15 Dec 2022 12:35:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B5261946588
 for <dm-devel@listman.corp.redhat.com>; Sun, 11 Dec 2022 09:50:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AB271415100; Sun, 11 Dec 2022 09:50:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62EDB140E93D
 for <dm-devel@redhat.com>; Sun, 11 Dec 2022 09:50:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4492C1C08780
 for <dm-devel@redhat.com>; Sun, 11 Dec 2022 09:50:24 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-x6J0bFKBNvGOFGIICg2nZQ-1; Sun, 11 Dec 2022 04:50:22 -0500
X-MC-Unique: x6J0bFKBNvGOFGIICg2nZQ-1
Received: by mail-pf1-f175.google.com with SMTP id t18so6597922pfq.13
 for <dm-devel@redhat.com>; Sun, 11 Dec 2022 01:50:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Rh5QAklyd4AeYLHpArFINipp6iRCr8KKOQb7s6HGEMI=;
 b=NXxl4gcSYOL+rXX2eMfX9sX6tvD4q+2jI8BYPz4eT06BKcw8bH7UPj277gV0E0PxdY
 Fn4ehtDBm4u+QqN1NBn/aMyCltEnPtidu8Le/OyMpHXEY6WJVMH+m9Wm43kgELZdV8yC
 ii608/VMMF3rd7GcJ44Nj2qVlQMflbyioCcNmQl6Kecwt+ZGpf3tCAKWZPD8sWrnbuGk
 rajGQZoSWo2SobmhIZgyf0Al93aQNJdXZpXzSNE5WYrvOI1pXwCX9S9nx7zMFXir/LUC
 YJekdaktolgWW4mBO14WsDoU8XNZLcKEhVjY81i6SRE//qBojBfo+Hz50WnSDUh4n767
 PTLA==
X-Gm-Message-State: ANoB5pm6OJsFYWNqVEKHG0jhhTMAWKmEmxcbF/eLeqlQnf78uoKBLNIZ
 Y2BHRtZWeeILAgoWT0ImfJDceKBJRNlEyoASvttKeA==
X-Google-Smtp-Source: AA0mqf6sTgZzExROP+3AcD990q4QofPnx+7w4Ve/p3V7twkuqcE/V+srS9ihCucVMYKxVIFQ4amS8gQqv9Gu8amMX4A=
X-Received: by 2002:a63:2226:0:b0:478:54e2:ecb1 with SMTP id
 i38-20020a632226000000b0047854e2ecb1mr37001807pgi.550.1670752221276; Sun, 11
 Dec 2022 01:50:21 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221207152116-mutt-send-email-mst@kernel.org>
From: Alvaro Karsz <alvaro.karsz@solid-run.com>
Date: Sun, 11 Dec 2022 11:49:44 +0200
Message-ID: <CAJs=3_Bu+tZqQk3JDzP0JfNbPZ8FG7mRNnPE9RrWUs8VOF=FzQ@mail.gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 15 Dec 2022 12:35:07 +0000
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Alvaro could you pls explain the use-case? Christoph has doubts that
> it's useful. Do you have a device implementing this?

Our HW exposes virtio devices, virtio block included.
The block device backend can be a eMMC/uSD card.

The HW can report health values (power, temp, current, voltage) and I
thought that it would be nice to be able to report lifetime values as
well.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

