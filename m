Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C983C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 21:43:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-LGFPJJHiMzSzAP_MzilxGQ-1; Wed, 01 Jun 2022 17:43:50 -0400
X-MC-Unique: LGFPJJHiMzSzAP_MzilxGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C7BF802804;
	Wed,  1 Jun 2022 21:43:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D28AD2026985;
	Wed,  1 Jun 2022 21:43:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7979B19451EC;
	Wed,  1 Jun 2022 21:43:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 682DA194707F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 21:43:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4967082882; Wed,  1 Jun 2022 21:43:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 45C793323E
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 21:43:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11EBD3831C4C
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 21:43:41 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-BDa5KcqcMvChdSQUbuWRMg-1; Wed, 01 Jun 2022 17:43:39 -0400
X-MC-Unique: BDa5KcqcMvChdSQUbuWRMg-1
Received: by mail-ej1-f52.google.com with SMTP id me5so5840081ejb.2
 for <dm-devel@redhat.com>; Wed, 01 Jun 2022 14:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rROPJDXC0BSDIKkq62Y3eAfugF0fDNsfhrQHzbt7NtU=;
 b=a9lRu9AVhPHxl/iTe9pYn+WAjJny481EjaRZcdqDP/gbJJqhJ+6tGMC1Mhbkv1jdwC
 RnDP/Yuto3Y83c3yD8JGc8t6oPM6ZRJyeqSbSK3g/KZ95jLHcTnYdI0PaxoELBBt06fd
 WAFwOsBLjO43zst9BzvwE4OYD6VaALCDgJXsjTs57TA4mqCoUpB+Z/1XM1CIOZU4o4Ms
 cPgnkqnIvuMxoHkV9AWKWvDVY0h4Sft8rJR748hWQJBrTzQNy5vqxoA607wZmWuMCZyj
 KpiLOT5ik177IuQzZfcx52zvrR5rdQit/Di4jH23/I1m0xDhEC3BP/BPC/xBpnb+HEq8
 JJdA==
X-Gm-Message-State: AOAM533dw00hJ3veDTCRVGdqsfPn3XkGjro9CB8ydpvghEuKtFqGK4BW
 4noM3B+HXgyIFQX10PeCIldij1dYkoYGANSh
X-Google-Smtp-Source: ABdhPJy5i/i20V2PTHjF1c+SR1Te/fsjY1shE0tuUz6itMnexTefxQSJUEO+/jSZzaqOqcCIhCH8qQ==
X-Received: by 2002:a17:907:7b9a:b0:6fe:c383:8559 with SMTP id
 ne26-20020a1709077b9a00b006fec3838559mr1447335ejc.580.1654119817897; 
 Wed, 01 Jun 2022 14:43:37 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com.
 [209.85.221.54]) by smtp.gmail.com with ESMTPSA id
 bp9-20020a170907918900b00703024202a0sm1091871ejb.166.2022.06.01.14.43.36
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 01 Jun 2022 14:43:36 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id d26so4010651wrb.13
 for <dm-devel@redhat.com>; Wed, 01 Jun 2022 14:43:36 -0700 (PDT)
X-Received: by 2002:a05:6000:1b0f:b0:210:313a:ef2a with SMTP id
 f15-20020a0560001b0f00b00210313aef2amr1083904wrz.281.1654119816176; Wed, 01
 Jun 2022 14:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <YpfTQgw6RsEYxSFD@redhat.com>
In-Reply-To: <YpfTQgw6RsEYxSFD@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Jun 2022 14:43:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjTOB7yuygFwz64xFHYthwdTOYoC=L2kM4k1GW2a80uNQ@mail.gmail.com>
Message-ID: <CAHk-=wjTOB7yuygFwz64xFHYthwdTOYoC=L2kM4k1GW2a80uNQ@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [git pull] device mapper fixes for 5.19-rc1
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
Cc: linux-block <linux-block@vger.kernel.org>,
 Sarthak Kukreti <sarthakkukreti@google.com>,
 device-mapper development <dm-devel@redhat.com>,
 Kees Cook <keescook@chromium.org>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 1, 2022 at 1:59 PM Mike Snitzer <snitzer@kernel.org> wrote:
>
> ----------------------------------------------------------------
> - Fix DM core's dm_table_supports_poll to return false if no data
>   devices.

So looking at that one (mainly because of the incomprehensible
explanation), I do note:

 (a) the caller does

        for (i = 0; i < t->num_targets; i++) {
                ti = t->targets + i;

    while the callee does

        unsigned i = 0;

        while (i < dm_table_get_num_targets(t)) {
                ti = dm_table_get_target(t, i++);

Now, those things are entirely equivalent, but that latter form is
likely to generate horribly bad code because those helper functions
aren't some kind of trivial inline, they are actually normal functions
that are defined later in that same source file.

Maybe a compiler will do optimizations within that source file even
for functions that haven't been defined yet. Traditionally not.

Whatever. Probably not a case where anybody cares about performance,
but it does strike me that the "use abstractions" version probably not
only generates worse code, it seems less legible too.

Very odd pattern.

 (b) The commit message (which is why I started looking at this) says
that it used to return true even if there are no data devices.

     But dm_table_supports_poll() actually _still_ returns true for at
least one case of no data devices: if the dm_table has no targets at
all.

So I don't know. Maybe that is a "can't happen". But since I looked at
this, I thought I'd just point out the two oddities I found while
doing so.

                    Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

