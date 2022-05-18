Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CD8C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 07:57:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-tdfjjqDDOJGS2wiGvuHANA-1; Wed, 18 May 2022 03:57:51 -0400
X-MC-Unique: tdfjjqDDOJGS2wiGvuHANA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C13F1C06ED6;
	Wed, 18 May 2022 07:57:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF70540CF8EE;
	Wed, 18 May 2022 07:57:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 884701947B8E;
	Wed, 18 May 2022 07:57:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC8F91947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 07:57:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D7601415101; Wed, 18 May 2022 07:57:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9926A1415100
 for <dm-devel@redhat.com>; Wed, 18 May 2022 07:57:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81144185A7B2
 for <dm-devel@redhat.com>; Wed, 18 May 2022 07:57:48 +0000 (UTC)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com
 [209.85.218.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-sbmmOI_2OxO4L_dsDbjW3w-1; Wed, 18 May 2022 03:57:46 -0400
X-MC-Unique: sbmmOI_2OxO4L_dsDbjW3w-1
Received: by mail-ej1-f50.google.com with SMTP id kq17so2185662ejb.4;
 Wed, 18 May 2022 00:57:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=7ktjmA9lbYY+r3k7Xl4dUBOmRn/WA+0dOC0w53gvyVI=;
 b=a2vYKyznZ9xHhc16XtHBmkOlL/ZhjtkBBNs7fifbjcHFhdTuv3nBnBDh03FaIIo3dM
 nc3sg1Ds7K5VyAK2KX84lpDG3cbb5xAob8Hx25b+rECQKGRNpVnP7KRCjyKj+zZeqYaA
 JmkooHUd1mAkYSZNexUCbtmCQcFP/kw0P9BVC+sh8tz/oy7fnYA5D6u5QVi3NcQb1Q+K
 2O3fkphdsxE5rbsfQLzb3tdfDKYqUyb9uNMswYpH8Pvznop5fdgDyEW8ZHdfzFefTqdP
 JsWofFB58M114kFNOzOyeZBNEuSVHvIqxojsdFIQH7+bPcaR7W0+Lb4OPIggk74Q/MBt
 VPEg==
X-Gm-Message-State: AOAM530maLc4G1l4RPUL/vdgLmUF/BaQ8diVshveVcvgnw2qlJo5boP7
 uF3cmeFGcEVW56i4LTh6LR34yo8WNqU=
X-Google-Smtp-Source: ABdhPJztZ+He6oZQpf5QYU8EpE4w74uBqb8gCz5K0anlddF2ScBUceeYay5gmr2N6k7sTt2XgAqIxw==
X-Received: by 2002:a17:907:7216:b0:6f4:70d4:a3c4 with SMTP id
 dr22-20020a170907721600b006f470d4a3c4mr22754545ejc.529.1652860665411; 
 Wed, 18 May 2022 00:57:45 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 ee46-20020a056402292e00b0042617ba63aesm928060edb.56.2022.05.18.00.57.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 18 May 2022 00:57:44 -0700 (PDT)
Message-ID: <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
Date: Wed, 18 May 2022 09:57:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Kees Cook <keescook@chromium.org>,
 James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 1/3] dm: Add verity helpers for LoadPin
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
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 18/05/2022 01:34, Matthias Kaehlcke wrote:
> LoadPin limits loading of kernel modules, firmware and certain
> other files to a 'pinned' file system (typically a read-only
> rootfs). To provide more flexibility LoadPin is being extended
> to also allow loading these files from trusted dm-verity
> devices. For that purpose LoadPin can be provided with a list
> of verity root digests that it should consider as trusted.
> 
> Add a bunch of helpers to allow LoadPin to check whether a DM
> device is a trusted verity device. The new functions broadly
> fall in two categories: those that need access to verity
> internals (like the root digest), and the 'glue' between
> LoadPin and verity. The new file dm-verity-loadpin.c contains
> the glue functions.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

...

> +
> +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> +		return false;

Almost unrelated note, but as there are more and more situations
that checks verity root digest, shouldn't we export this as read-only
sysfs attribute for DM verity devices?

Attacker can always calculate (but not change) Merkle tree, so this
is not something that need to be hidden.

It would allow userspace to easily enumerate trusted DM devices without
calling kernel ioctls...

...

> +
> +	table = dm_get_live_table(md, &srcu_idx);
> +
> +	if (dm_table_get_num_targets(table) != 1)
> +		goto out;
> +
> +	ti = dm_table_get_target(table, 0);
> +
> +	if (is_trusted_verity_target(ti))
> +		trusted = true;

What happens is someone reloads verity table later with
a different content (or even different target type)?
Does LoadPin even care here?

...

>   static struct target_type verity_target = {
>   	.name		= "verity",
>   	.version	= {1, 8, 0},

Please increase the minor version, it is very useful to detect (in logs)
that the target driver has compatible extensions.


I guess this change does not affect userspace veristysetup
(as it is used handled by different tooling), right?

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

