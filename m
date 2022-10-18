Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189F4C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 22:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666131123;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HX8s1JN/29WZ+LyCmJmOFXWGDhvFLKizY51ErstCax8=;
	b=bsLH5uL/4cuNa+bM9nHaCy62R8r7noH/zOt7EU5VQfRKaXOwx6oBUeZOfcci/4CkgAkm9C
	iVynh6zIdDzg9ISNnBQ4Y3bFXUHFbvumS973GF+b0V078z1P8kPjnGP8FaCwYOf9iWpbD2
	45h8NKxLDBmHJsJx6uSKuk/nVcRRlT0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-ZRDUoYPLOZeN58Rr00tTFA-1; Tue, 18 Oct 2022 18:11:59 -0400
X-MC-Unique: ZRDUoYPLOZeN58Rr00tTFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 561F6857D17;
	Tue, 18 Oct 2022 22:11:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3F6E111DCE0;
	Tue, 18 Oct 2022 22:11:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDF4B1946594;
	Tue, 18 Oct 2022 22:11:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C92B5194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 22:11:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D59D9111DCE1; Tue, 18 Oct 2022 22:11:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE099111DCE0
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 22:11:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78172811732
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 22:11:53 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-qJfIMDwlM9adsKAPo_Hq-g-1; Tue, 18 Oct 2022 18:11:43 -0400
X-MC-Unique: qJfIMDwlM9adsKAPo_Hq-g-1
Received: by mail-wr1-f42.google.com with SMTP id f11so26079068wrm.6;
 Tue, 18 Oct 2022 15:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0Q1Bo1NOfImcyyTBS4cIDNC7uZFtunDU2SA9Z06ciYg=;
 b=cnuoEII6b53l3v5sGKR1a+Y3z3v0e7qgihog/jwrIMwZojsVCU0OkADNmSScoar28T
 khbzE8GxXokQNr7Oc8uRfUPNy2Dy0o/1GyPH3q95gfmXrDT9kiJkmoikl+GDzF94V5u+
 B3KdargHIS/zLN06h38Xv8KCFuM16x7gQVEZBAYYaU9CGh4n+ONLv4Di2q5t3sa1H5tt
 2qbu3yrMfciX7TkNAmI+BubSnkRLgh1taM2lNsJVqcf8UldfUQCFeLD0MwfDJI9sXphA
 MTYRJbR9AZgLhXapyUCJK6/Pmvz+MFyME8JwzrMsz/oSwFlXVoM6CHRFnHlDZbavPMye
 GOjA==
X-Gm-Message-State: ACrzQf1rcIxQJXKFPmAAPCPmpwyWtg56bbsDhAiq7AdftCIpOmeKOhIj
 fmNpD5ZBvwf817Yl/sPSsNNDQ8K1zJM=
X-Google-Smtp-Source: AMsMyM6zlPhfj9UPXGe2hQ73kVErzhC0ypl8flD0nntIbW8asoQpRbn4rPIbfkqnfdOor8C6R+RSfA==
X-Received: by 2002:a17:907:2701:b0:78d:cb12:6d94 with SMTP id
 w1-20020a170907270100b0078dcb126d94mr4321132ejk.344.1666131091468; 
 Tue, 18 Oct 2022 15:11:31 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 r1-20020a1709061ba100b0072a881b21d8sm8060745ejg.119.2022.10.18.15.11.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Oct 2022 15:11:15 -0700 (PDT)
Message-ID: <b9608b92-fab8-93a0-2821-80a49c3328eb@gmail.com>
Date: Wed, 19 Oct 2022 00:11:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Mike Snitzer <snitzer@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
 <CAHk-=wiE_p66JtpfsM2GMk0ctuLcP+HBuNOEnpZRY0Ees8oFXw@mail.gmail.com>
 <Y08W5Tj1YC8/BZDM@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <Y08W5Tj1YC8/BZDM@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: linux-block@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@kernel.org>,
 Nathan Huckleberry <nhuck@google.com>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Genjian Zhang <zhanggenjian@kylinos.cn>, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Alasdair G Kergon <agk@redhat.com>, Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/18/22 23:13, Mike Snitzer wrote:
...
>> In the absence of that kind of unification, just use 'errno'.
> 
> Mikulas touches on why why using errno isn't useful for DM. And for
> DM's device stacking it is hard to know which error spewed to dmesg
> (via DMERR, DMCRIT, DMINFO, etc) is relevant to a particular admin
> interface issuing the DM ioctl.
> 
> So the idea to send the (hopefully useful) error string back up to the
> relevant userspace consumer was one task that seemed needed (based on
> Milan Broz's various complaints against DM.. which sprang from your
> regular remainder that DM's version numbers are broken and need to be
> removed/replaced).

Well, when you mention my complaints, I think we are moving from one extreme
to another.

For the error reporting - we use errno values in libcryptsetup everywhere,
so if DM ioctls (through libdevmapper we use) returns proper errno, this is
the minimal solution that helps here.
The problem is that ioctl() are often just translated to -EINVAL.
(Or lost in libdevmapper compatibility layers.)

 From the dm-crypt/verity/integrity perspective, ENOMEM, ENODEV (bad block device),
ENOTSUP/ENOENT (for crypto algs not available), EIO for IO error,
EILSEQ for data integrity failure is the basic what we need.
(I perhaps forgot some, I can go through the code if you need it.)

As a bonus, if DM ioctl() returns fixed string that describes user-friendly error
(like: "keysize not compatible" or so) that's all we need
(ti->error strings are already in DM targets).

I have never asked for dynamically allocated error strings in kernel
and I do not know Mikulas' motivation to implement it.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

