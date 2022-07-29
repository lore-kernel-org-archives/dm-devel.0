Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC68EC00144
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 04:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659070336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fmK6BKlg63SkXbLDV4F7jWs9OZ4RDf3yJixD4EY/nIQ=;
	b=i62DPPBY4oRiTVYB3OvcMaNZ821OYs0YpxYfW+tCqFDGQK3pdJ5gkCMrv02emrYyZq1asp
	MXs3jpXrct4o2nVqv/tK1YI4I6f4D71jlGSZ1Hai2DTWVJJhdvrlqncIxWBHLbNZaypxI5
	frWOD6n9RZQfZcjzkrk01AeknoLcCNo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-ioPjmr14OAKif4Enb8bB9Q-1; Fri, 29 Jul 2022 00:52:13 -0400
X-MC-Unique: ioPjmr14OAKif4Enb8bB9Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF69B2999B2E;
	Fri, 29 Jul 2022 04:52:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30709492C3B;
	Fri, 29 Jul 2022 04:52:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0656193211F;
	Fri, 29 Jul 2022 04:52:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 280031932118
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 04:52:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0B001415118; Fri, 29 Jul 2022 04:52:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC016140EBE3
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 04:52:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3A1A80418F
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 04:52:06 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-Qa4jzqhLMzWnuAfA1x4gFQ-1; Fri, 29 Jul 2022 00:52:04 -0400
X-MC-Unique: Qa4jzqhLMzWnuAfA1x4gFQ-1
Received: by mail-pj1-f49.google.com with SMTP id y1so3647679pja.4
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 21:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Nih3CQ3bvbr3caRHPwLofzDk9DoHwlUp15C4DMS5PBo=;
 b=iX3uhTY4I4RftJdqBAvPVux62fVwBR2b9wP8v3aG21duu1iVyf35rgqdKJ9PVZh4/g
 rpIVo0+TPOyWMSYw+7ZhkjqnU+GNHs4b6sXQM/T7gJgVsk90kI3S0NqJiX1QYPwTCsP3
 VmVWxAzLXKLZMvP0n8EIALYw2Ceuqe0fGDpPz3JXQEf+EuuUiS1sdL7hNT3fp9PQZdxq
 9Bif5ciJephiArbiuX5Q6OEICy78ETF7z4qZ6zpigHn5hDp+MgTrwSqFxI6qXrw37Ihx
 QK/dDJ5Lt7IuQoH8uaL4cZUAvFOyQN6R6zM/q+ldAQdLQAXUon0dduN6PDJ1+DO+ezQO
 q83Q==
X-Gm-Message-State: ACgBeo299FlJnIpJxNpNkEizODu1tRhiYlXvrCK85NWi+oneziYksyBo
 7eypz5mkSd5FZVTzVOJiPNkntA==
X-Google-Smtp-Source: AA6agR5FJP+NYrdW/k3FkoK3eSp4f0Ik9rJBgd0bR1FQThkmO9kyKATOXvMgiQu4Mti2542araL9Iw==
X-Received: by 2002:a17:90b:3c42:b0:1f3:2e03:d9dc with SMTP id
 pm2-20020a17090b3c4200b001f32e03d9dcmr2228881pjb.8.1659070323606; 
 Thu, 28 Jul 2022 21:52:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 200-20020a6304d1000000b004126fc7c986sm1808648pge.13.2022.07.28.21.52.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Jul 2022 21:52:03 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: mka@chromium.org, jmorris@namei.org, agk@redhat.com, serge@hallyn.com,
 snitzer@kernel.org
Date: Thu, 28 Jul 2022 21:51:55 -0700
Message-Id: <165907031305.2130609.16869003416171682751.b4-ty@chromium.org>
In-Reply-To: <20220728085412.1.I242d21b378410eb6f9897a3160efb56e5608c59d@changeid>
References: <20220728085412.1.I242d21b378410eb6f9897a3160efb56e5608c59d@changeid>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] dm: verity-loadpin: Drop use of
 dm_table_get_num_targets()
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
Cc: sfr@canb.auug.org.au, Kees Cook <keescook@chromium.org>,
 linux-security-module@vger.kernel.org, dianders@chromium.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, gmazyland@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 28 Jul 2022 08:54:41 -0700, Matthias Kaehlcke wrote:
> Commit 2aec377a2925 ("dm table: remove dm_table_get_num_targets()
> wrapper") in linux-dm/for-next removed the function
> dm_table_get_num_targets() which is used by verity-loadpin. Access
> table->num_targets directly instead of using the defunct wrapper.
> 
> 

Applied to for-next/hardening, thanks!

[1/1] dm: verity-loadpin: Drop use of dm_table_get_num_targets()
      https://git.kernel.org/kees/c/27603a606fda

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

