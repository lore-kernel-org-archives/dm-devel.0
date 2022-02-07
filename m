Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69056C3527B
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:34:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-neRAp2D0O5W1m8dPnPfOEw-1; Tue, 08 Feb 2022 17:34:09 -0500
X-MC-Unique: neRAp2D0O5W1m8dPnPfOEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96C1C1054FA2;
	Tue,  8 Feb 2022 22:34:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7461976E3C;
	Tue,  8 Feb 2022 22:34:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4693C59CAE;
	Tue,  8 Feb 2022 22:34:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217F77Tg014746 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 10:07:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5CCFC2166B4C; Mon,  7 Feb 2022 15:07:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53F5F2166B5D
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 15:07:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D03E185A79C
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 15:07:04 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
	[209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-150-OjhLsFRFNqStiCcaynqxRw-1; Mon, 07 Feb 2022 10:07:02 -0500
X-MC-Unique: OjhLsFRFNqStiCcaynqxRw-1
Received: by mail-ej1-f52.google.com with SMTP id og43so18937943ejc.0
	for <dm-devel@redhat.com>; Mon, 07 Feb 2022 07:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:references:from:in-reply-to
	:content-transfer-encoding;
	bh=F3cqhKo/LUB7lGd0QDU+7FObPag4yKIRgYNcM4OrB2Q=;
	b=JdShME2CYCwAvhfmlXpbPpPIiJ8cJtZH5+Rabl9SlNL6PA/Wq8haNqNenKkm906yJ/
	PEHV7cUvKRfjPG/hzC+EHi7go269/zVRQhSPOMWdDXNZE7S1CGMQ1U8FQObdhPDmj9bI
	xEjHbjHb8qT5G8BqDhpU6/7ToJ5Vd7RHXjr2PT2ANJTK6+VqSJ6Xd43sEuzf9M66QJ9N
	4k0hoB4Aq5LQCPeLRVcyDEEpLmJixh5iP0zVhe5AXe9aKpKTPxb5sACEzDeYFu3Fe3SZ
	BdWtTpeaPvWQ40maVWg0DyOzaPH7LAlfTjGYo7JQ8vij3lYlmIbN3Sv2i/OSwFFRzGqU
	N0aQ==
X-Gm-Message-State: AOAM533IzO1KEXsdgSIefaTC3mNSrzEiSWG2FAjs/DnScO79nENy2bVP
	kigxSn/21ZiXkkXy7FcxkbZb4yDEB8xkDQ==
X-Google-Smtp-Source: ABdhPJwuNJNabMe2MZDkjuUvvmf88WMVCS+Q/WS5WxIhcqXkUKIPSKOy8JNTMpdNd7rE91eyxuyZbg==
X-Received: by 2002:a17:907:9804:: with SMTP id
	ji4mr124118ejc.716.1644246420695; 
	Mon, 07 Feb 2022 07:07:00 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id
	ek21sm3144572edb.27.2022.02.07.07.06.59
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 07 Feb 2022 07:07:00 -0800 (PST)
Message-ID: <bf9817e2-32ed-f278-42c6-044c061f59f1@gmail.com>
Date: Mon, 7 Feb 2022 16:06:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: Aidan Walton <aidan.walton@gmail.com>, dm-devel@redhat.com
References: <CAPx-8MP6zbPACu-HaYeBO8AqBwqxt4YQarSm6vaZHSApiQWX7Q@mail.gmail.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <CAPx-8MP6zbPACu-HaYeBO8AqBwqxt4YQarSm6vaZHSApiQWX7Q@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 06. 02. 22 v 16:16 Aidan Walton napsal(a):
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

You can't remove device with open count >0.
You've already replaced device target type with error - so whoever keeps this 
device open gets error on all read & writes (and you would probably see it on 
kernel log)

Your remaining problem is to figure out who holds devices open in kernel.

fusers shows only user-land apps - but not in-kernel users - so you should 
probably try to see how you are usinf your devices - who is mounting/using them ?

If your kernel is working correctly - tools like  'lsblk' are typically quite 
good at exposing your device tree..

But you would need to expose way more details to give more qualified advice...

Regards

Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

