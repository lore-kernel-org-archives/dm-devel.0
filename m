Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF48C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 08:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658478068;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ahLPuRtGhRq/m/j/vAtC+jobmeo9c4PRhRd9qWuotTw=;
	b=ZbZRM0SP3K/X8PZyVL2xdsvtATK04/i7YCsW7q3qnxDjLdTo9c+U5Zp/orKnyKyEUBEbdj
	5nVxhA1FOJCoeR+At757e9dvkFJljajp9JUPLrhqiFNfTFE/T4G8bo6ihusmLmR1GNAGiH
	9DqMZZDKVihfYWA5w8t0lYymtE78IoI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-tuxTvoT1OeSfl6EjCAFi1g-1; Fri, 22 Jul 2022 04:21:04 -0400
X-MC-Unique: tuxTvoT1OeSfl6EjCAFi1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEAEE801755;
	Fri, 22 Jul 2022 08:21:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB0252166B26;
	Fri, 22 Jul 2022 08:20:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 714E6194704D;
	Fri, 22 Jul 2022 08:20:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D99D31947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 08:20:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5F332166B2A; Fri, 22 Jul 2022 08:20:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1C932166B26
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 08:20:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9705F85A581
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 08:20:57 +0000 (UTC)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-uFY_rQyfPr-9cb2lcK7IYg-1; Fri, 22 Jul 2022 04:20:55 -0400
X-MC-Unique: uFY_rQyfPr-9cb2lcK7IYg-1
Received: by mail-ej1-f42.google.com with SMTP id os14so7351493ejb.4
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 01:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=CGzPRcx2BHVSrFEMXPI3kWcYnIUX7tUCN7uqV/cjft0=;
 b=UNKLzRlXgqn/KMYm0EDLPuvbh/JuXHwo//qZdBLfDq/+x9eMQPaGBMixVbSijJXCAh
 /QHYBGjIg1XoIKXNOdiNzA38UR7uOnMeA5oCPMpfDLsVA5IrBuyCbJCxGYio3WkL9w6u
 57AGpf8h8KbjZowNAWH54o4W2JJsbgNJbRIbq7qmsinBhdujdPiuiw7l4TiYadtvvyX2
 3jAiDQbRqn6tFo5Tfa9pAPeZKpXrUflgLt5m0RU/rQesWVX7/6Ag2qBtfzr3FR5DHJS9
 exzRIp8c11VhY+1/RK4Byex4J9YT4ST1Id5YhopQwa/yxdBb1/aTZ/G6fQN2IQN3NNOp
 beiw==
X-Gm-Message-State: AJIora8vgFyEdiff8bTa4VNySp4Ny7mUyWiDCHISWTkbPPz+kcJUWb5q
 TIegcYdcsBaBkVS3itZPMIY=
X-Google-Smtp-Source: AGRyM1v7wdyeXoa61yzyvQ2gbQ4dc1ENgHDkcFpbRhqkxJ0WE62ubw/EiOn8lbUjjhD0Y8eerLXzCQ==
X-Received: by 2002:a17:907:9810:b0:72f:36e5:266c with SMTP id
 ji16-20020a170907981000b0072f36e5266cmr2178933ejc.105.1658478053899; 
 Fri, 22 Jul 2022 01:20:53 -0700 (PDT)
Received: from [192.168.8.101] (78-80-26-209.customers.tmcz.cz. [78.80.26.209])
 by smtp.gmail.com with ESMTPSA id
 dk20-20020a0564021d9400b0043a71775903sm2153198edb.39.2022.07.22.01.20.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 22 Jul 2022 01:20:53 -0700 (PDT)
Message-ID: <a8c3cff3-15f8-abaa-61b1-9347841e984a@gmail.com>
Date: Fri, 22 Jul 2022 10:20:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>
References: <1658316391-13472-1-git-send-email-israelr@nvidia.com>
 <1658316391-13472-2-git-send-email-israelr@nvidia.com>
 <Ytj249InQTKdFshA@sol.localdomain> <20220721125459.GC20555@lst.de>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20220721125459.GC20555@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 1/1] block: Add support for setting inline
 encryption key per block device
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
Cc: Jens Axboe <axboe@kernel.dk>, Max Gurtovoy <mgurtovoy@nvidia.com>,
 Israel Rukshin <israelr@nvidia.com>, dm-devel@redhat.com,
 Linux-block <linux-block@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
 Nitzan Carmi <nitzanc@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 21/07/2022 14:54, Christoph Hellwig wrote:
> On Wed, Jul 20, 2022 at 11:49:07PM -0700, Eric Biggers wrote:
>> On the other hand, I'd personally be fine with saying that this isn't actually
>> needed, i.e. that allowing arbitrary overriding of the default key is fine,
>> since userspace should just set up the keys properly.  For example, Android
>> doesn't need this at all, as it sets up all its keys properly.  But I want to
>> make sure that everyone is generally okay with this now, as I personally don't
>> see a fundamental difference between this and what the dm-crypt developers had
>> rejected *very* forcefully before.  Perhaps it's acceptable now simply because
>> it wouldn't be part of dm-crypt; it's a new thing, so it can have new semantics.
> 
> I agree with both the dm-crypt maintainer and you on this.  dm-crypt is
> a full disk encryption solution and has to provide guarantees, so it
> can't let upper layers degrade the cypher.  The block layer support on
> the other hand is just a building block an can as long as it is carefully
> documented.

Yes, that is what I meant when complaining about the last dm-crypt patch.

I think inline encryption for block devices is a good idea; my complaint was
integration with dm-crypt - as it can dilute expectations and create a new
threat model here.

But I also think that implementing this directly in the block layer makes sense.
Perhaps it should be generic enough.
(I can imagine dynamic inline encryption integrated into LVM ... :-)

>> I'm wondering if anyone any thoughts about how to allow data_unit_size >
>> logical_block_size with this patch's approach.  I suppose that the ioctl could
>> just allow setting it, and the block layer could fail any I/O that isn't
>> properly aligned to the data_unit_size.
> 
> We could do that, but we'd need to comunicate the limit to the upper
> layers both in the kernel an user space.  Effectively this changes the
> logical block size for all practical purposes.

I think you should support setting logical encryption size from the beginning,
at least prepare API for that. It has a big impact on performance.
The dm-crypt also requires aligned IO here. We propagate new logical size
to upper layers (and also to loop device below, if used).
(Also this revealed hacks in USB enclosures mapping unaligned devices...)

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

