Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B39C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 06:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670912639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wE7j2hSAd27npbSL5BLSNMPKKb+s62/wWoUm0/FRTjg=;
	b=AY6Fmimh0BFC3zOCfq0xX101HXEWzxshOXtSAlLS0E+jfA/OEGZLlkGUz09WiSne5yXcwc
	JSo0/etsDpvfOdi9WOSGPcL7rGM5wNU/eSy8dda7olH277yubBakfIV3fDYvCSwYzd+xq/
	gonmfMiexKfdC7n7Ka2AjN1zSCCI31s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-pnPSR_wVNfmTRu1SmhTVow-1; Tue, 13 Dec 2022 01:23:55 -0500
X-MC-Unique: pnPSR_wVNfmTRu1SmhTVow-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABFDB86865C;
	Tue, 13 Dec 2022 06:23:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3B43492B00;
	Tue, 13 Dec 2022 06:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C325E1946588;
	Tue, 13 Dec 2022 06:23:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 365E61946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 06:23:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFEEE40ED785; Tue, 13 Dec 2022 06:23:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8D0540ED784
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 06:23:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCE0C1C05156
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 06:23:49 +0000 (UTC)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-470-77UimHuEPG2qRHfoH6JUeA-1; Tue, 13 Dec 2022 01:23:48 -0500
X-MC-Unique: 77UimHuEPG2qRHfoH6JUeA-1
Received: by mail-wm1-f72.google.com with SMTP id
 m38-20020a05600c3b2600b003d1fc5f1f80so5191516wms.1
 for <dm-devel@redhat.com>; Mon, 12 Dec 2022 22:23:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zdosc0+4UprGU1f9HW8VSDzkH/4Gm3wZqjmhjmwHaoc=;
 b=QV3/27rzYpklBIsaEEgDtnbgZqUdMQRZBrN2775U2KPGy8Qs4ubW98O7nvH9iiVSfT
 QQ1owUAU0XuRI3umDsJ7ffvMzTnjq+YOdouWM1/0Iu1DLOv4dPVjDEgWwdE4pBhmccRD
 6Z0+z9W/4i/pp1QbLITz5/fgA8daxfwhJmPykXKi4RbeYSFIWGHcH6c7BlNzsX7Tdi5s
 tYMea6PzkyVq7oSi86P6iMQJYOhVRVCNRDUibIJMt4mnu9rYkUKiZgXfbuGtNsgw6ZoX
 hTjkzRX8BmyK8BccCOPwTBPnNv5uOJBZrYNCYJ8vHwzcWJTLnitXOGxgWiykfGQIUYfs
 diPw==
X-Gm-Message-State: ANoB5pmIfHCj0mqMtQO8Y1MxAcCvaSJBb1TO5/IOf3qDBsszkOKz+tkH
 cEhFOM4K0UwJYaU0p9O8I40DE34qTwzBcek4M8gapQKIPSwv1gGRfHPVCQvHmEgkA/bASmO3bnn
 twgV+qoKop0wpQ4A=
X-Received: by 2002:a5d:4b0b:0:b0:241:f8b6:9693 with SMTP id
 v11-20020a5d4b0b000000b00241f8b69693mr10657858wrq.37.1670912627218; 
 Mon, 12 Dec 2022 22:23:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4I9L5F8Y2mNHOKhXS0GG3uRTSVP0X4b9ULK97I3031/HbGTKYGoQr9e4elbaLdVkvuI9TpMQ==
X-Received: by 2002:a5d:4b0b:0:b0:241:f8b6:9693 with SMTP id
 v11-20020a5d4b0b000000b00241f8b69693mr10657848wrq.37.1670912626982; 
 Mon, 12 Dec 2022 22:23:46 -0800 (PST)
Received: from redhat.com ([2.52.138.183]) by smtp.gmail.com with ESMTPSA id
 q4-20020adffec4000000b00241c6729c2bsm10574835wrs.26.2022.12.12.22.23.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 22:23:46 -0800 (PST)
Date: Tue, 13 Dec 2022 01:23:42 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20221213001034-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
 <ccb5388d-4976-31a3-0559-e94c14c90573@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <ccb5388d-4976-31a3-0559-e94c14c90573@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 13, 2022 at 04:58:47AM +0000, Chaitanya Kulkarni wrote:
> Michael,
> 
> On 12/7/22 12:28, Michael S. Tsirkin wrote:
> > On Wed, Dec 07, 2022 at 08:31:28AM -0800, Christoph Hellwig wrote:
> >> On Wed, Dec 07, 2022 at 05:21:48AM -0500, Michael S. Tsirkin wrote:
> >>> Christoph you acked the spec patch adding this to virtio blk:
> >>>
> >>> 	Still not a fan of the encoding, but at least it is properly documented
> >>> 	now:
> >>>
> >>> 	Acked-by: Christoph Hellwig <hch@lst.de>
> >>>
> >>> Did you change your mind then? Or do you prefer a different encoding for
> >>> the ioctl then? could you help sugesting what kind?
> >>
> >> Well, it is good enough documented for a spec.  I don't think it is
> >> a useful feature for Linux where virtio-blk is our minimum viable
> >> paravirtualized block driver.
> > 
> > No idea what this means, sorry.  Now that's in the spec I expect (some)
> > devices to implement it and if they do I see no reason not to expose the
> > data to userspace.
> > 
> 
> Even if any device implements is it can always use passthru commands.
> See below for more info...
> 
> > Alvaro could you pls explain the use-case? Christoph has doubts that
> > it's useful. Do you have a device implementing this?
> > 
> 
>  From what I know, virtio-blk should be kept minimal and should not
> add any storage specific IOCTLs or features that will end up loosing
> its generic nature.
> 
> The IOCTL we are trying to add is Flash storage specific which
> goes against the nature of generic storage and makes it non-generic.
> In case we approve this it will open the door for non-generic
> code/IOCTL in the virtio-blk and that needs to be avoided.

Wrt these fields that horse has bolted, it's in the spec.

> For any storage specific features or IOCTL (flash/HDD) it should
> be using it's own frontend such as virtio-scsi or e.g. nvme and
> not virtio-blk.
> 
> Hope this helps.
> 
> -ck

I don't understand what you are suggesting, sorry. It's a hardware
device. It can't just "switch to a different frontend".

-- 
MST

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

