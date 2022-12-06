Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A33C63709
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V4yQVfs2Ob5hEfN51FhR3EIZInkiZvspfkm7X1N0vVg=;
	b=JKUOShuvGxUvhOSAjFgKcfETRFLSt8BMGWwp/7I0lvTmHFWxWGAIAqx8AwI6u8p0bHCB0l
	bgFiGa5jI/GQKhwd4d2R4ML1yATxLdWmZ1Ipb/1eJCMTao5dHGs8MmbmS7pg8/PW+32Is9
	Nm9EykuFPYA9cM4Nd7+7fE8WZH7zTqE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-TLddSDUIOFap0mfIuQXo2g-1; Wed, 07 Dec 2022 08:37:23 -0500
X-MC-Unique: TLddSDUIOFap0mfIuQXo2g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66EDB802C17;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56112492B04;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECEA31946A67;
	Wed,  7 Dec 2022 13:37:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 562041946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 16:40:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BDE22166B29; Tue,  6 Dec 2022 16:40:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 450032166B26
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 16:40:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26263800186
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 16:40:16 +0000 (UTC)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-V1QE45flN4u-E51dZWZ-Rw-1; Tue, 06 Dec 2022 11:40:14 -0500
X-MC-Unique: V1QE45flN4u-E51dZWZ-Rw-1
Received: by mail-wr1-f70.google.com with SMTP id
 p2-20020adfaa02000000b00241d7fb17d7so3375846wrd.5
 for <dm-devel@redhat.com>; Tue, 06 Dec 2022 08:40:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6ge3pwq/JlMlTkSjEGqqkwIK42+btCPQr7/pr8xaxyc=;
 b=SFYlqbo4douqjlVNjU+acKyd5Dxeem/6RK9iWIdH6ycFwkuURQJQAWB7MsjkKnlhCb
 BBm3HawIRLRzCqhRba3+75yWOx0IooYP8ipuPUZlbSIgTpnboEY7z1hw2J4rQ2v8USPk
 JLX65n1puuYIWKA5PjFrqDb8/PJ8AVA99sdcHKdLJIz8Isp5zgQX6P+pJU91KJN88PRv
 /P0APiFQfT84pq81qegztZT77nhjtckY6xzTLZPfgo5YbqB9ozIYtd/D+5ULvDEheBpe
 MvsNxrFuj4CW4K2xCxp259gb+p2LvF4epTEgxwEkIlxYPPTxu2RqthsRTd6LW4altFja
 IxcA==
X-Gm-Message-State: ANoB5pnu/yDJSMIEUbEfDKfXUS0x3e+JiaIVC6dJ6Qma1SmA1J1hZYZn
 npNTgn3OzPJMIgD5LYgNBdbP+KOxFdjbuSMuq7HDCJnA6ryaRyleR7sjtZg3RxixqK1PMO60bD4
 KrZj6nlNxU95pSN0=
X-Received: by 2002:a05:600c:43d6:b0:3cf:a856:ba2f with SMTP id
 f22-20020a05600c43d600b003cfa856ba2fmr54374395wmn.37.1670344813012; 
 Tue, 06 Dec 2022 08:40:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4NVS4Nr5mwzewnBswh2mp5LN3uIb1H6IjnbaF2zAiGYSd8n0GAdY9XUcgUa+xExhq9zeGgKw==
X-Received: by 2002:a05:600c:43d6:b0:3cf:a856:ba2f with SMTP id
 f22-20020a05600c43d600b003cfa856ba2fmr54374381wmn.37.1670344812837; 
 Tue, 06 Dec 2022 08:40:12 -0800 (PST)
Received: from redhat.com ([109.253.207.7]) by smtp.gmail.com with ESMTPSA id
 h20-20020a05600c351400b003c6cd82596esm29427965wmq.43.2022.12.06.08.40.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Dec 2022 08:40:12 -0800 (PST)
Date: Tue, 6 Dec 2022 11:40:06 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20221206113744-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y49ucLGtCOtnbM0K@fedora>
MIME-Version: 1.0
In-Reply-To: <Y49ucLGtCOtnbM0K@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 Alvaro Karsz <alvaro.karsz@solid-run.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 06, 2022 at 11:31:44AM -0500, Stefan Hajnoczi wrote:
> On Mon, Dec 05, 2022 at 06:20:34PM +0200, Alvaro Karsz wrote:
> 
> I don't like that the ioctl lifetime struct is passed through
> little-endian from the device to userspace. The point of this new ioctl
> is not to be a passthrough interface. The kernel should define a proper
> UABI struct for the ioctl and handle endianness conversion. But I think
> Michael is happy with this approach, so nevermind.
> 
> > @@ -219,4 +247,8 @@ struct virtio_scsi_inhdr {
> >  #define VIRTIO_BLK_S_OK		0
> >  #define VIRTIO_BLK_S_IOERR	1
> >  #define VIRTIO_BLK_S_UNSUPP	2
> > +
> > +/* Virtblk ioctl commands */
> > +#define VBLK_GET_LIFETIME	_IOR('r', 0, struct virtio_blk_lifetime)
> 
> Does something include <linux/ioctl.h> for _IOR()? Failure to include
> the necessary header file could break userspace applications that
> include <linux/virtio_blk.h>.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Good point. I think it's preferable to add a new header
for this stuff. virtio_blk_ioctl.h ? Have that pull in linux/ioctl.h
Also VIRTIO_BLK_IOCTL_GET_LIFETIME
might be a better name to avoid confusion and collisions.
And s/Virtblk/virtio-blk/

-- 
MST

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

