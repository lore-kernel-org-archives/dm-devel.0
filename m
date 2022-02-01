Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBBC4C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 10:16:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-hAYgf5FfP1WFePCLV-R7iQ-1; Tue, 01 Feb 2022 05:16:04 -0500
X-MC-Unique: hAYgf5FfP1WFePCLV-R7iQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C6671091DAF;
	Tue,  1 Feb 2022 10:15:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3E035F91C;
	Tue,  1 Feb 2022 10:15:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7251518095C9;
	Tue,  1 Feb 2022 10:15:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211AFrFe026125 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 05:15:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0DEE52026D60; Tue,  1 Feb 2022 10:15:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0892D2026980
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 10:15:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B71D1044565
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 10:15:49 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
	[209.85.218.46]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-501-ybL9Yf4nNjKUi-kwJc3gIg-1; Tue, 01 Feb 2022 05:11:48 -0500
X-MC-Unique: ybL9Yf4nNjKUi-kwJc3gIg-1
Received: by mail-ej1-f46.google.com with SMTP id h7so52612806ejf.1;
	Tue, 01 Feb 2022 02:11:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=Tp1QirIUKeyFSAa6K51ywcQsn5I7k5ys1z7XMAiBW1M=;
	b=I2DzaMojutq9wJvfdVHUooyS9TbI7QRKHtdZpk5ykvyZDi4HA6AhliehifxLpOebN1
	iyEltQPuiuHZ/oMUpGt6Z2C73uR+UHOsFJOiZNbSVyI2BsGZKMli9wHZIXk6npb31Lmu
	EyAVsaVu+xIl02cvszvSB9QmIrB+yY9ME2O546UWt3aT0KMiX4C8O/ZU/LcOGsEYAKVc
	SR+PdJPQESEwOO4WoXgbGzCAVqklyWcAImfbjrdTjQqvzU5yt2ZsKKfNfLQtWcJQoVGY
	5g/9yp283t0m0Ck7UbvTLnM/8p5S+xGOrrl8dq57TB3t+zRdfSNVbj/f/WGqDS90rlE9
	+9eg==
X-Gm-Message-State: AOAM530kzeWSvFZA0lhoNewKQGP10ZOZOKTMUXaN9KkQU8yk3BpdTVfi
	pcSR+5LvUrG5NchcZnvXJlA=
X-Google-Smtp-Source: ABdhPJydMu2oYXYCFSp9SvQD7rMsmZNiuN3Tl0gQX9h8yz6JU0PDgPFQPTGXP23dqn0XAktoQRSlWg==
X-Received: by 2002:a17:907:7388:: with SMTP id
	er8mr20040817ejc.269.1643710306141; 
	Tue, 01 Feb 2022 02:11:46 -0800 (PST)
Received: from [192.168.0.99] ([83.148.32.207])
	by smtp.gmail.com with ESMTPSA id
	f19sm14334729edu.22.2022.02.01.02.11.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 01 Feb 2022 02:11:45 -0800 (PST)
Message-ID: <cc5c503a-c94f-d32f-9f91-e388f36c647c@gmail.com>
Date: Tue, 1 Feb 2022 11:11:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Firefox/91.0 Thunderbird/91.4.0
To: Martin Wilck <mwilck@suse.com>, Peter Rajnoha <prajnoha@redhat.com>
References: <20220128134229.1783-1-mwilck@suse.com>
	<10ad6fc0-6c24-c98b-4a02-2140883af72d@gmail.com>
	<a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
	<712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
	<20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
	<3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
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
Cc: Franck Bui <fbui@suse.de>, lvm-devel@redhat.com, dm-devel@redhat.com,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Heming Zhao <heming.zhao@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 01. 02. 22 v 9:40 Martin Wilck napsal(a):
> On Mon, 2022-01-31 at 14:33 +0100, Peter Rajnoha wrote:
>> (just discussed this with Zdenek too)
>>
>> The patch makes sense to me!
>>
>> We added all the DM_UDEV_PRIMARY_SOURCE_FLAG and related for exactly
>> such cases where we need to take the existing values already scanned
>> in previous event, main use-case being the trigger at boot. We just
>> didn't cover the 13-dm-disk.rules with the same logic regarding the
>> suspended state to keep the symlinks - I didn't think it would cause
>> issues (because, usually, after suspend, we anticipate incoming
>> resume where the device is scanned again).
>>
>> But yes, if temporarily losing the symlink causes issues, your patch
>> solves that (Zdenek will push that upstream).
> 
> Thank you very much! It occured to me that if we want to solve my use
> case with minimal risk, we could make the the case in which the
> symlinks are preserved conditional on ACTION=="add" (i.e. true coldplug
> events). Tell me if you'd prefer that, I can re-submit.

The problem is handling of 'suspended' state in udev rules - as I've mentioned 
original no userland tool should mostly care about this.

However since there are those things like udev 'trigger' and it would be kind 
of ugly if the 'left-over' suspended device would stop whole system operation
it's most likely better ATM to have some kind of support for this.

It's should be noted there is still 'race' risk of system freezing in the case 
the suspend happens just after sysfs test and before actual i.e. 'blkid' use.
But let's assume the chance of having this to happen is pretty minimal, and 
usually tools doing suspend & resume will work correctly and the 'crash' will 
not likely happen in this particular moment - and suspended device just 
hanging there already for longer time.

The missed issue to be solve is - that ALL rules have to rely on a single 
suspend check - otherwise we risk 'partial' processing  which is the last 
thing we want to see (aka all or nothing).

Your real problem was not the suspend on its own - which still may happen 
anytime (so i.e. just after the test whether device is suspended),
but the bug was related to bad exit path cleaning udev db content in this case 
- which is clear bug.  Next bug is that other rules have to be consistent and 
properly skip its processing if the 1st. rules decides its meant to be skipped.

ATM your patch is already upstream and great thanks for pointing this out.

Regards

Zdenek


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

