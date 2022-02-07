Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AEFC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:37:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-Sr3S3DeyPuCESBhktyn9DQ-1; Tue, 08 Feb 2022 17:37:30 -0500
X-MC-Unique: Sr3S3DeyPuCESBhktyn9DQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2116612ED;
	Tue,  8 Feb 2022 22:37:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3FD55DB90;
	Tue,  8 Feb 2022 22:37:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E2CE4BB7B;
	Tue,  8 Feb 2022 22:37:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217KBcTT004543 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 15:11:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 26BF5C15E6F; Mon,  7 Feb 2022 20:11:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22E39C0809E
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 20:11:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 076478027FC
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 20:11:38 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
	[209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-608-YhB3LMiXMHO7bae1sXyh2Q-1; Mon, 07 Feb 2022 15:11:34 -0500
X-MC-Unique: YhB3LMiXMHO7bae1sXyh2Q-1
Received: by mail-qt1-f174.google.com with SMTP id s1so12945588qtw.9
	for <dm-devel@redhat.com>; Mon, 07 Feb 2022 12:11:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=gNN8FSbqW/28ZmsRURCN6lI2eFXOmMZXjim5krXiZyo=;
	b=fNrwZckBVRwSCIWaint89oO9xOc7ol4JLFEzX8RY4Yt7sPvQer8IDXJLdrxjwa0xP4
	cgTDSSl8W4Pz58oSWiKeSMFDVNwkwIRwZoW87i4dr+ePuIfS4QIT1XP7msaHY4MDqraI
	rzdRlMIuDDQSJRn5Y5eG3AdPiBjf1u4pdB6sL6rv4wbjJSJFz6RygzGBgF6MYLRHy49O
	+gxWHM65OsTaw7YZvPf+dHrpkfwOg6rudCSe7rlWejZKl5JuIcZzufCU95nN1X998BEe
	HkE8FZpGdZtcdDzVHWPRpsd4huJW06CHOzSIjpanv2SN3f94MmVPLWnrOqcR1xPUGCVX
	WxcA==
X-Gm-Message-State: AOAM533xgNdbjMngvEFjpuaCmB1ixcprZLtJ8JDakuQBRh4TmYcn89O8
	hpH9yuIXC/rHpH3+tkuCDpPciitHolaZEIalngznnxP6
X-Google-Smtp-Source: ABdhPJydcWRD0WqbtlLlpSuD0y0GE3E32XBC/b3rksX2Tq2+SwTY0/AhAwObTaUNb37w0y322V+HT1iwebT4QmR3FVI=
X-Received: by 2002:a05:622a:1448:: with SMTP id
	v8mr863731qtx.412.1644264694367; 
	Mon, 07 Feb 2022 12:11:34 -0800 (PST)
MIME-Version: 1.0
References: <CAPx-8MP6zbPACu-HaYeBO8AqBwqxt4YQarSm6vaZHSApiQWX7Q@mail.gmail.com>
In-Reply-To: <CAPx-8MP6zbPACu-HaYeBO8AqBwqxt4YQarSm6vaZHSApiQWX7Q@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Mon, 7 Feb 2022 14:14:27 -0600
Message-ID: <CAAMCDee5y=JKkd+=7SbmS=hE=z4JJfU9st+0Fv2Jwfs=7HR+gg@mail.gmail.com>
To: Aidan Walton <aidan.walton@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] Can not remove device. No files open,
 no processes attached. Forced to reboot server.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 7, 2022 at 3:35 AM Aidan Walton <aidan.walton@gmail.com> wrote:
>
> Hi,
> I've been chasing a problem now for a few weeks. I have a flaky SATA
> controller that fails unpredictably and upon doing so all drives
> attached are disconnected by the kernel. I have 2 discs on this
> controller which are the components of a RAID1 array. mdraid fails the
> disc (in its strange way) stating that one device is removed and the
> other is active. Apparently this is the default mdraid approach. Even
> though both devices are in fact failed. Regardless, the devmapper
> device which is supporting an LVM logical volume on top of this raid
> array, remains active. The logical volume is no longer listed by
> lvdisplay, but dmsetup -c info shows:
> Name                                Maj Min Stat Open Targ Event  UUID
> storage.mx.vg2-shared_sun_NAS.lv1   253   2 L--w    1    1      0
> LVM-Ud9pj6QE4hK1K3xiAFMVCnno3SrXaRyTXJLtTGDOPjBUppJgzr4t0jJowixEOtx7
> storage.mx.vg1-shared_sun_users.lv1 253   1 L--w    1    1      0
> LVM-ypcHlbNXu36FLRgU0EcUiXBSIvcOlHEP3MHkBKsBeHf6Q68TIuGA9hd5UfCpvOeo
> ubuntu_server--vg-ubuntu_server--lv 253   0 L--w    1    1      0
> LVM-eGBUJxP1vlW3MfNNeC2r5JfQUiKKWZ73t3U3Jji3lggXe8LPrUf0xRE0YyPzSorO
>
> The device in question is 'storage.mx.vg2-shared_sun_NAS.lv1'
>
> As can be seen is displays 'open'
>
> however lsof /dev/mapper/storage.mx.vg2-shared_sun_NAS.lv1
> <blank>
>
> fuser -m /dev/storage.mx.vg1/shared_sun_users.lv1
> <blank>
>
> dmsetup status storage.mx.vg2-shared_sun_NAS.lv1
> 0 976502784 error
>
> dmsetup remove storage.mx.vg2-shared_sun_NAS.lv1
> device-mapper: remove ioctl on storage.mx.vg2-shared_sun_NAS.lv1
> failed: Device or resource busy
>
> dmsetup wipe_table storage.mx.vg2-shared_sun_NAS.lv1
> device-mapper: resume ioctl on storage.mx.vg2-shared_sun_NAS.lv1
> failed: Invalid argument
>
>
> and so on. Nothing appears to be attached to this device but it
> refuses to be removed. As a consequence I can not disable the mdraid
> array and can not recover the controller. Which is possible by
> resetting the pci slot.
>
> Currently the only possible way I have to recover this problem is to
> reboot the server.
>
> Please see.
> https://marc.info/?l=linux-raid&m=164159457011525&w=2
>
> for the discussion regarding the same problem on the linux-raid mailing list.
> No progress so far, help appreciated
> Aidan
>


Was the filesystem mounted when this happened and if so how did you
get it unmounted?  If the filesystem is mounted and has any dirty
cache, that cache won't flush with the device missing and won't allow
the device to be umounted.

The in-kernel opens will not show for lsof (mounts, nfs exports on the
fs, and probably other direct users in the kernel of the lv), so
likely one of those is still there.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

