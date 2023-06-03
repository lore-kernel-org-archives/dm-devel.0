Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E943EC77B7A
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 09:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685784191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=edM2Ov0r65X1e+4IITQJCyWuPcw02kEXXOPCR44CpAU=;
	b=fbfLUPphZbWwv7HyNiO260dwe+wOJ4dwpLzWkBXld3BKdrzPjA3+mYilcqw02Svi8Qyr6l
	WLCaPCbZCH+QD3chR02IG3q4hNt3floXnMq1dehvVIH+JMgroXF/PlgeR4baKPozd/1Vle
	EHECdYEuAeehQl1B8C/3qt4L6iOEijs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-1hn0gXxFOkesGi8CdmF0yA-1; Sat, 03 Jun 2023 05:23:08 -0400
X-MC-Unique: 1hn0gXxFOkesGi8CdmF0yA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBB4185A795;
	Sat,  3 Jun 2023 09:23:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B6A92026D49;
	Sat,  3 Jun 2023 09:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DD5719465A3;
	Sat,  3 Jun 2023 09:23:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5365D19465A2
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 09:23:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 43B5B40C6CCC; Sat,  3 Jun 2023 09:23:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C24440C6EC4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 09:23:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C960811E78
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 09:23:02 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-Fxm-4eMlMlOM7z6i5BjsbA-1; Sat, 03 Jun 2023 05:22:56 -0400
X-MC-Unique: Fxm-4eMlMlOM7z6i5BjsbA-1
Received: by mail-wm1-f50.google.com with SMTP id
 5b1f17b1804b1-3f6d38a140bso21915915e9.1; 
 Sat, 03 Jun 2023 02:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685784174; x=1688376174;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=O5ZZccEjOJDauUyUc86UqVR1EPzXqg2YfD93ZA1ljqc=;
 b=TplwNe7jmqOnB0/AL35lGb13mGjwcaW0eNn/ijl/E3yl9Z7iF3ulWtF7p44u9EE64T
 6sLYNhU2yxF8TyIbPFhcIgId42yiLGTI+IinxhJ/0X2up+x+aHdFQPx1c39A9utAflO4
 bizmK7P5JWFB/ua+t4jhmG6kjR+VRmcPSbx+Qqq24Pibk2ujUkSkL+00UEzua0TnOQsX
 UZiejE7+p7XPGWYr/F+9tymbZxz/AsXSpix47+gBiFq7YyQ5SoQ32esHUhyda8gU9Jz3
 m8HrR6Hu8MhKOygMOyth2Lr8HnAbWOMKRzQdO+VZirfCWvqKCEjaB8mx167jqUOhxXy2
 22XQ==
X-Gm-Message-State: AC+VfDyyEViy7sU+C/oxMo7hcRO70i0iIPprAO1eGw8xVn37vRw/iX8t
 ktKWJtHs1ZxnIThZFsj8btE=
X-Google-Smtp-Source: ACHHUZ7HrvGXynuCfe2Du1bVfjOvawLJSng9RyiQMVVgL2YM1NZ+L20ZQXh+OzK3OYRVGFQ/PlzrPQ==
X-Received: by 2002:a1c:4c0d:0:b0:3f7:5e1:f3fd with SMTP id
 z13-20020a1c4c0d000000b003f705e1f3fdmr4008232wmf.5.1685784174328; 
 Sat, 03 Jun 2023 02:22:54 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 l5-20020a7bc445000000b003f6042d6da0sm4431638wmi.16.2023.06.03.02.22.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 03 Jun 2023 02:22:53 -0700 (PDT)
Message-ID: <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
Date: Sat, 3 Jun 2023 11:22:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
To: Eric Biggers <ebiggers@kernel.org>, Coiby Xu <coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20230602213452.GC628@quark.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 0/5] Support kdump with LUKS encryption by
 reusing LUKS volume key
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
Cc: Baoquan He <bhe@redhat.com>, Kairui Song <ryncsn@gmail.com>, x86@kernel.org,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 Pingfan Liu <kernelfans@gmail.com>, Dave Hansen <dave.hansen@intel.com>,
 dm-devel@redhat.com, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/2/23 23:34, Eric Biggers wrote:
> On Thu, Jun 01, 2023 at 03:24:39PM +0800, Coiby Xu wrote:
>> [PATCH 0/5] Support kdump with LUKS encryption by reusing LUKS volume key
> 
> The kernel has no concept of LUKS at all.  It provides dm-crypt, which LUKS
> happens to use.  But LUKS is a userspace concept.
> 
> This is a kernel patchset, so why does it make sense for it to be talking about
> LUKS at all?  Perhaps you mean dm-crypt?

Exactly.

I had the same comment almost a year ago... and it still applies:
https://lore.kernel.org/all/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/

  Anyway, please fix the naming before this patchset can be read or reviewed!

  LUKS is user-space key management only (on-disk metadata); the kernel has
  no idea how the key is derived or what LUKS is - dm-crypt only knows the key
  (either through keyring or directly in the mapping table).

  Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
  is used in many other mappings (plain, bitlocker, veracrypt, ...)
  Just use the dm-crypt key, do not reference LUKS at all.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

