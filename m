Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4584C636D3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Qu5K4KSDOew4vBHiG9q5TuS2ol/ACos4na0Ieh9L1WE=;
	b=Xqw6FLe309mU8mNIVfKBVPHc03baMJmNP5H8oM31VT5k/IwKMPf66KLodH6ahnmrCF2fpa
	H7QmZBRiOmNBYAtHsMorSGfbV585LdCzLM40b6Gbhj4+HfCJFAfF4tmnhRBjV5ieoqjVqb
	11hNCbWWBP+Iep/2I9gxk+33XsO9HvA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-vNLvmNWrMmaULoojiGBXlQ-1; Mon, 06 Feb 2023 02:38:38 -0500
X-MC-Unique: vNLvmNWrMmaULoojiGBXlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77BA82A59570;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63417112131B;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C6BCF19465A8;
	Mon,  6 Feb 2023 07:38:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6970B1946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 19:00:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5878C404CD81; Thu,  2 Feb 2023 19:00:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5139C404CD80
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:00:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 352AD857A94
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:00:54 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-498-RF94skA7MVSR9z8RiqdVhQ-1; Thu, 02 Feb 2023 14:00:50 -0500
X-MC-Unique: RF94skA7MVSR9z8RiqdVhQ-1
Received: by mail-pg1-f180.google.com with SMTP id 143so2024792pgg.6
 for <dm-devel@redhat.com>; Thu, 02 Feb 2023 11:00:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=p3ZYbtaIavkAf5aV8P1noUyCGHCi0NGSeVESNHvFnYY=;
 b=nMSydHRgDetKS/xR5ftSCt6f5zJmhFuRTbjWnDhqJbzWdK88BsIIXY7w7c91NuVOGV
 FBaJwiGs8ZTMfurZcZn6NRDxl9QxxMC4VMVPMr0KgCis11MRcVOiUTgwDqJXYkOYz2Uf
 lEsLc2z5pPvrWuyuBhiTBzUGz0W/CXIqkLht7OLUWboxHtxIexsBTa+rpT0UL7JKRbVC
 xQe/zvZKQN0dJEZLufvW1ClF11OnPQfQM/aNyJz/2osFIVdh776w2uRPKU/ZV7HVyN7h
 SOWZ0bZWZm8D+1WUYZt0cXwNYzPQFNzM1bYTGpYp8VHXZMn/gYIGpW2v17dD2B7qhrVm
 rMXQ==
X-Gm-Message-State: AO0yUKVSxQ/X8XpaCWKxE9qJihlooz45326F4bTho+riULqLqgzDQHr6
 sX0cYEUChZckU0/tiNm61aBqvr2v7Js+lFghhJkIFg==
X-Google-Smtp-Source: AK7set8NvDoA9gf4AicHigBtu9UpVuZVLhwEfuP2Vzy2j1FjpsC9TsZ1y3DDjZctSawx3/ctiEaprHJ0rsQLVFXvU3g=
X-Received: by 2002:a63:dd43:0:b0:4da:af6:ed with SMTP id
 g3-20020a63dd43000000b004da0af600edmr1187478pgj.30.1675364449073; 
 Thu, 02 Feb 2023 11:00:49 -0800 (PST)
MIME-Version: 1.0
References: <20230202-dm-parenthesis-warning-v1-1-ebdee213eeb9@kernel.org>
In-Reply-To: <20230202-dm-parenthesis-warning-v1-1-ebdee213eeb9@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 2 Feb 2023 11:00:37 -0800
Message-ID: <CAKwvOdnffHbU4ObT2jDr_iASEC==CUsX2FfqdA-+iLU4y5Ma=g@mail.gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
Subject: Re: [dm-devel] [PATCH] dm flakey: Fix clang -Wparentheses-equality
 in flakey_map()
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
Cc: trix@redhat.com, llvm@lists.linux.dev, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, dm-devel@redhat.com,
 mpatocka@redhat.com, sweettea-kernel@dorminy.me, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 2, 2023 at 9:00 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   ../drivers/md/dm-flakey.c:369:28: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
>                           if ((fc->corrupt_bio_rw == WRITE)) {
>                                ~~~~~~~~~~~~~~~~~~~^~~~~~~~
>   ../drivers/md/dm-flakey.c:369:28: note: remove extraneous parentheses around the comparison to silence this warning
>                           if ((fc->corrupt_bio_rw == WRITE)) {
>                               ~                   ^       ~
>   ../drivers/md/dm-flakey.c:369:28: note: use '=' to turn this equality comparison into an assignment
>                           if ((fc->corrupt_bio_rw == WRITE)) {
>                                                   ^~
>                                                   =
>   1 error generated.
>
> GCC only warns when one set of parentheses are used for assignment
> expressions, whereas clang additionally warns when two sets of
> parentheses are used for equality comparisons. Remove the extra set of
> parentheses to silence the warning as it suggests, as this is obviously
> supposed to be an equality comparison.
>
> Fixes: 0e766389cedc ("dm flakey: fix logic when corrupting a bio")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1798
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
> I do not mind this change being squashed with the offending commit, as I
> noticed it was Cc'd for stable, which would minimize the chance for
> breakage.
> ---
>  drivers/md/dm-flakey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index 08f9aa476d97..335684a1aeaa 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -366,7 +366,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
>                  * Corrupt matching writes.
>                  */
>                 if (fc->corrupt_bio_byte) {
> -                       if ((fc->corrupt_bio_rw == WRITE)) {
> +                       if (fc->corrupt_bio_rw == WRITE) {
>                                 if (all_corrupt_bio_flags_match(bio, fc))
>                                         corrupt_bio_data(bio, fc);
>                         }
>
> ---
> base-commit: 6f30cc248507ee96c22ff4c3cbc86099ff12b7a9
> change-id: 20230202-dm-parenthesis-warning-6139f4b5020b
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


-- 
Thanks,
~Nick Desaulniers

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

