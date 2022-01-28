Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9515AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 15:33:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-Vfb3Pjl2OwWQ88xoYrVNhQ-1; Fri, 28 Jan 2022 10:33:55 -0500
X-MC-Unique: Vfb3Pjl2OwWQ88xoYrVNhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B67B48144E0;
	Fri, 28 Jan 2022 15:33:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 324DF1059A7C;
	Fri, 28 Jan 2022 15:33:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DD6561809CB8;
	Fri, 28 Jan 2022 15:33:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SFXlKC023705 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 10:33:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 03E40C07F46; Fri, 28 Jan 2022 15:33:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00303C1914A
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:33:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6AD28EE131
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:33:46 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
	[209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-164-9PSF4IahPzCdCrEdj-UqRw-1; Fri, 28 Jan 2022 10:33:44 -0500
X-MC-Unique: 9PSF4IahPzCdCrEdj-UqRw-1
Received: by mail-ed1-f45.google.com with SMTP id b13so10668769edn.0;
	Fri, 28 Jan 2022 07:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=J39o/+NL7vj1OYePdSg9ysegY5Zf1FWB8lvbxMTqsdc=;
	b=UxpTn7P4+ve+G+Wu6Ik3hhtSSYxyvfOqNXYHuSbCbkiR3d0D4T67rkYTungY7qLzQa
	Byq1tEEdonaNv1vluqlfjBND2FAVrqqrLPqRy59R7WYHspL+feNXYjZAKlXc0WzJNqbY
	KRUDQqngD+n46mrmSJrb5xZABlIp5Yd67M1Zu9V4hC0t8xKZ7VhZmlN6ibximCrMS/N+
	qtMRbMaYF+Nj+uLgpnJPfvxx5/joF3EcmmtIt7aGyZukm7v748t/Rzrw7J5O/9Gdlo4r
	Uu8dZKbtqKZzhZc/EanSgnYTc0be5kG2AkzIetNmPKF7FqOQqIMoqOHczuWN2A/sTbEl
	L+DQ==
X-Gm-Message-State: AOAM532qKlWGP/FkXRCNdWL99Se3/5cSgVZGDZ8kdEd31+TB994M0+Ot
	ofFqwU6Q4onEsWrts+57PJI=
X-Google-Smtp-Source: ABdhPJyhX66MXDHvwYRLscWdOM6K+xZ+bQvfSsS1S8VFgzHB47z6K6AgH3qY49Dq73924hwNXukVRQ==
X-Received: by 2002:a05:6402:424a:: with SMTP id
	g10mr8733044edb.309.1643384022556; 
	Fri, 28 Jan 2022 07:33:42 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id
	gg14sm10144598ejb.62.2022.01.28.07.33.41
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 28 Jan 2022 07:33:41 -0800 (PST)
Message-ID: <10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
Date: Fri, 28 Jan 2022 16:33:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: mwilck@suse.com, Zdenek Kabelac <zkabelac@redhat.com>,
	David Teigland <teigland@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
References: <20220128134229.1783-1-mwilck@suse.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <20220128134229.1783-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Franck Bui <fbui@suse.de>, lvm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 28. 01. 22 v 14:42 mwilck@suse.com napsal(a):
> From: Martin Wilck <mwilck@suse.com>
> 
> If a dm device is suspended, we can't run blkid on it. But earlier
> rules (e.g. 11-dm-parts.rules) might have imported previously scanned
> properties from the udev db, in particular if the device had been correctly
> set up beforehand (DM_UDEV_PRIMARY_SOURCE_FLAG==1). Symlinks for existing
> ID_FS_xyz properties must be preserved in this case. Otherwise lower-priority
> devices (such as multipath components) might take over the symlink
> temporarily.
> 
> Likewise, we should't stop watching a temporarily suspended, but previously
> correctly configured dm device.


I'm a bit confused here what is the purpose of this patch.

blkid is supposed to scan 'every' disk it's told to scan -  if device is 
suspend - blkid shall fait till it's resumed.

Suspend operation itself is meant to be quick - and process suspending any 
device should be doing it rather 'quickly'  (aka reload DM table)

So now - how do you get 'suspended' devices that are blocking blkid ?

lvm2 has implemented some sort of 'optional' hack to avoid scanning suspended 
devices - but this shouldn't be normally needed - unless your system is flawed 
with some set of suspended devices (maybe from some crashed lvm command).

Regards

Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

