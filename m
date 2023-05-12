Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8043AC77B75
	for <dm-devel@archiver.kernel.org>; Fri, 12 May 2023 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683913984;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CLg0E3C8cvzU+yO5UHAsnoZFRqBMSpqy9KhX9bqm62M=;
	b=XSpva7v8Kve1cHXkRN1PCMcMBQ6rp86v46Iq0WQVtdeq7/dIE6Wi0sb2G+50myaelPNoZj
	+6V5E2vGvYKSZwprnCQuRTNm3R3/FYbaE7wHl9vzPM7fcsd+Wbwi4P5MrTKBGa/+gu3Sv6
	yoe5/Me6IWKx2eS6Pii8JZwKaw/gnDc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-0ivX6DPvO0qL9h289KHm9A-1; Fri, 12 May 2023 13:53:00 -0400
X-MC-Unique: 0ivX6DPvO0qL9h289KHm9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 908743802B87;
	Fri, 12 May 2023 17:52:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A1CB63F8A;
	Fri, 12 May 2023 17:52:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DBC0419451E4;
	Fri, 12 May 2023 17:52:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B0AB419451E3
 for <dm-devel@listman.corp.redhat.com>; Fri, 12 May 2023 17:52:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 993C5492B07; Fri, 12 May 2023 17:52:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9171E492C13
 for <dm-devel@redhat.com>; Fri, 12 May 2023 17:52:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74B0A868901
 for <dm-devel@redhat.com>; Fri, 12 May 2023 17:52:55 +0000 (UTC)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
 [209.85.208.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-jcihdVywN3SaLLAKDXD3Yw-1; Fri, 12 May 2023 13:52:53 -0400
X-MC-Unique: jcihdVywN3SaLLAKDXD3Yw-1
Received: by mail-ed1-f52.google.com with SMTP id
 4fb4d7f45d1cf-50bc456cc39so15226032a12.1; 
 Fri, 12 May 2023 10:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683913972; x=1686505972;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+z5HbnsTK18J0+qXZRdJVRc1SE6gpbbfgXJ/tjWlB7U=;
 b=V8iIS/Hw4h4wnISAGfjV79+ovtVp0KeRQB5A+zW4YdFFU4FW29uHgtDrIXoVIxmQZ6
 nafF06GVIimpL+cH+YXUrqFk2m4gfZ34Jc9hCNVONtWc2znDnm4xwgtliHfdg7KPsJqO
 n0aJ04rt5XphZBvK0llMjs2SfBEHIqyh+KuTfLkado7zHJzeW1bHhYS1pDk2X6HbWmzb
 uNszR84Tjv0TV9LAb2ubMS3vy9zAbmBH0VxuCyHbU8Y5JxZuohkXHeyL7/scYmX28sza
 aDx+zBgECOow1OprCTKu3GLnAD0rpAV36GwDBjQAnZyQvEkTQvCn7bPxxQuYSWRbzes5
 d/9Q==
X-Gm-Message-State: AC+VfDyn92D1w6lbSXL9fdKIc11+n9YihM2T8fRZlf0d0A3SD4/o38+V
 g8TTYvH3wS/0yh2DG+TOGWZf3TrOE40NeQ==
X-Google-Smtp-Source: ACHHUZ56Nh7GwRsgEU7BrtcKNxP6mA30n2Lp1bDbFoN+fPJbMW2/FQ70ahtIiWVgDXjjaIwqqpCnZQ==
X-Received: by 2002:a17:907:1b17:b0:94f:432f:243e with SMTP id
 mp23-20020a1709071b1700b0094f432f243emr22067959ejc.14.1683913971874; 
 Fri, 12 May 2023 10:52:51 -0700 (PDT)
Received: from [192.168.8.101] (37-48-17-149.nat.epc.tmcz.cz. [37.48.17.149])
 by smtp.gmail.com with ESMTPSA id
 n25-20020a170906379900b00965c529f103sm5575504ejc.86.2023.05.12.10.52.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 12 May 2023 10:52:51 -0700 (PDT)
Message-ID: <8c7dcc39-d7c9-d81e-a7af-5cbf055082c7@gmail.com>
Date: Fri, 12 May 2023 19:52:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
To: Eric Biggers <ebiggers@kernel.org>,
 "Chang S. Bae" <chang.seok.bae@intel.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
 <ZFWY6/VelArVYy1F@gmail.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <ZFWY6/VelArVYy1F@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 11/12] crypto: x86/aes-kl - Support AES
 algorithm using Key Locker instructions
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
Cc: Tom Rix <trix@redhat.com>, dave.hansen@linux.intel.com,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 "H. Peter Anvin" <hpa@zytor.com>, ardb@kernel.org, herbert@gondor.apana.org.au,
 x86@kernel.org, mingo@kernel.org, Ingo Molnar <mingo@redhat.com>, bp@suse.de,
 Nathan Chancellor <nathan@kernel.org>, Borislav Petkov <bp@alien8.de>,
 luto@kernel.org, dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, linux-crypto@vger.kernel.org, bernie.keany@intel.com,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/6/23 02:01, Eric Biggers wrote:
...
> This does not correctly describe what is going on.  Actually, this patchset
> registers the AES-KL XTS algorithm with the usual name "xts(aes)".  So, it can
> potentially be used by any AES-XTS user.  It seems that you're actually relying
> on the algorithm priorities to prioritize AES-NI, as you've assigned priority
> 200 to AES-KL, whereas AES-NI has priority 401.  Is that what you intend, and if
> so can you please update your explanation to properly explain this?
> 
> The alternative would be to use a unique algorithm name, such as
> "keylocker-xts(aes)".  I'm not sure that would be better, given that the
> algorithms are compatible.  However, that actually would seem to match the
> explanation you gave more closely, so perhaps that's what you actually intended?

Sorry to be late in-game, but as this is intended for LUKS/dm-crypt use,
I have a comment here:

LUKS2 will no longer support algorithms with the dash in the name for dm-crypt
(iow "aes-generic" or something like that will no longer work, and I am afraid
you will need aes-kl/keylocker-xts here to force to use AES-KL for dm-crypt).

One reason is described in https://gitlab.com/cryptsetup/cryptsetup/-/issues/809,
but the major problem is that cryptsetup used CIPHER-MODE-IV syntax (that mixes
badly with the dash in algorithm names). And we still rely on internal conversions
of common modes to that syntax (currently it worked only by a luck).

When I added the "capi" format for dm-crypt for algorithms specification,
I made a mistake in that it allows everything, including crypto driver
platform-specific names.
The intention was to keep the kernel to decide which crypto driver will be used.
So, this is perhaps fine for dm-crypt now but LUKS is a portable format, and a generic
algorithm (like AES) should not depend on a specific driver or CPU feature.

IOW, implement xts(aes) and let the user prioritize the driver (no changes
needed for LUKS header then, AES-KL is loaded automatically) or/and create a wrapper
(similar to paes, that we already support) that will force to use AES-KL
(...but without the dash in the name, please :)

If there is a problem with it, please create an issue for cryptsetup upstream
to discuss it there (before the kernel part is merged!), so we can find some
solution - I would like to avoid incompatibilities later.

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

