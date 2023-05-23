Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B8AC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 22:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684880000;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RzJOPYenVHfg2zqmBNjTbGmYkQtvXICL4ELcPvTbV6I=;
	b=OvrPBSUYYODDwB/m19ydVCt60CnQPAvqQpX+nsRH551lII7vSxz+2mmJuzp62Tq1p4uF2c
	bMyKx2mIJRIwmC+wfnP8IFi/7Nue78XiiF4HdJzPCx2VigPA2Ls7XNkA1YFK1QgkNWJTMd
	OERlKH2BtoQHqUi0W/JUSy7UCOAZe2U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-UzLmAckxNsCU0eCYr2NnYA-1; Tue, 23 May 2023 18:13:16 -0400
X-MC-Unique: UzLmAckxNsCU0eCYr2NnYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D35BE280AA7E;
	Tue, 23 May 2023 22:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 769E9140E95D;
	Tue, 23 May 2023 22:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E66919465A8;
	Tue, 23 May 2023 22:13:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64E2D19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 22:13:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F0AE40CFD46; Tue, 23 May 2023 22:13:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36E0640CFD45
 for <dm-devel@redhat.com>; Tue, 23 May 2023 22:13:12 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19B3F811E7F
 for <dm-devel@redhat.com>; Tue, 23 May 2023 22:13:12 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-ROpkG_Y4Pg6OIGcm-wITGA-1; Tue, 23 May 2023 18:13:10 -0400
X-MC-Unique: ROpkG_Y4Pg6OIGcm-wITGA-1
Received: by mail-qt1-f199.google.com with SMTP id
 d75a77b69052e-3f697a64cc2so1492981cf.3
 for <dm-devel@redhat.com>; Tue, 23 May 2023 15:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684879990; x=1687471990;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=TPM01XPJotlxXQm9x8UW+H+xbOwXmHBJ79622BZ9Cv8=;
 b=e96KvG4yCGFzutGQzW/jv10rhfEkgjVRFzaMEORmzbsN0KHXJVbICT3joFJLGdk0Cp
 jK5TIg7+ZIeiIxYmYoCc/sNqu1W1usoTFIP41iL7XsiHw3+LvV8fJfCdZCD+GEUYIN0W
 04d41UbJzJysNTFC3xdMVDI25ya0P/pwe8JbkTw+QXT3OnoSNU/Aa2YBpmINVo2tQErO
 VgN7JlsdBptXukyunY1sRyqjlE99lfvW9B8sZ7Fi4fRqiA6B6Dyh9VJJltM5DXlcRsXg
 IbCo9hIQnaqXDFj0Yq1TgGMzVS3slzHWN9nqBYAqsghjF+4XQctXYC6Ql3+nH/x2hX2T
 h6RA==
X-Gm-Message-State: AC+VfDwuvj/gH8GBd0GW8d7Z14ruV+mPeqBUjy0jXcE0PBSJ5Dcc199F
 1ZQkmgMp7G/r6mdi9KAqxnGTEyZC3BVDcTm16VOWCy+0FA+PVqhVAvxbHCnuCUUM8gGWpsK/lnb
 SGSAbDST5AWoYh9M=
X-Received: by 2002:a05:622a:48d:b0:3f5:ef49:722c with SMTP id
 p13-20020a05622a048d00b003f5ef49722cmr24849849qtx.2.1684879990124; 
 Tue, 23 May 2023 15:13:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7/3mFuM4Sg5KPzLpANVm5ZJP+Nbjijgyek8H2PKX/k1qAPcrIS64/OcNJwMjLRAN+W/l1YLA==
X-Received: by 2002:a05:622a:48d:b0:3f5:ef49:722c with SMTP id
 p13-20020a05622a048d00b003f5ef49722cmr24849824qtx.2.1684879989743; 
 Tue, 23 May 2023 15:13:09 -0700 (PDT)
Received: from [172.16.2.39]
 (173-166-2-198-newengland.hfc.comcastbusiness.net. [173.166.2.198])
 by smtp.gmail.com with ESMTPSA id
 n12-20020ac85a0c000000b003e302c1f498sm1289329qta.37.2023.05.23.15.13.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 23 May 2023 15:13:09 -0700 (PDT)
Message-ID: <0d3d1835-d945-9fa2-f3b7-6a60aae3d1df@redhat.com>
Date: Tue, 23 May 2023 18:13:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
To: Eric Biggers <ebiggers@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <20230523214539.226387-3-corwin@redhat.com>
 <20230523220618.GA888341@google.com>
From: corwin <corwin@redhat.com>
In-Reply-To: <20230523220618.GA888341@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 02/39] Add the MurmurHash3 fast hashing
 algorithm.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/23/23 6:06 PM, Eric Biggers wrote:
> On Tue, May 23, 2023 at 05:45:02PM -0400, J. corwin Coburn wrote:
>> MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was originally
>> written by Austin Appleby and placed in the public domain. This version has
>> been modified to produce the same result on both big endian and little
>> endian processors, making it suitable for use in portable persistent data.
>>
>> Signed-off-by: J. corwin Coburn <corwin@redhat.com>
>> ---
>>   drivers/md/dm-vdo/murmurhash3.c | 175 ++++++++++++++++++++++++++++++++
>>   drivers/md/dm-vdo/murmurhash3.h |  15 +++
>>   2 files changed, 190 insertions(+)
>>   create mode 100644 drivers/md/dm-vdo/murmurhash3.c
>>   create mode 100644 drivers/md/dm-vdo/murmurhash3.h
> 
> Do we really need yet another hash algorithm?
> 
> xxHash is another very fast non-cryptographic hash algorithm that is already
> available in the kernel (lib/xxhash.c).
> 
> - Eric

The main reason why vdo uses Murmur3 and not xxHash is that vdo has been 
in deployment since 2013, and, if I am reading correctly, xxHash did not 
have a 128 bit variant until 2019.

It would certainly be possible to switch vdo to xxHash, but it would be 
problematic for existing users.

corwin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

