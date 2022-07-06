Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4148EC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657120067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yFKi5q+ayHUJdMekOulc/IbqGAwVQJRMYvJSJAVRTSk=;
	b=DIsVVP2fFtCfQ0sBqmmZegYA9kjloAP95O/1v7sUGxRfeC0HRC//MZQC49JGMSi5wCjyZE
	BSLRojyvYNp9Pk0IhyACIgaNZCAHfyZBpnIsKywsS+BJHRMPWoCZAaxPt2Cf5V/aik6e9u
	kFoONXU+8sNpt/KnNiEltkDt3iPIaxA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-IHWojOa_Nm2rMYt3aThM1g-1; Wed, 06 Jul 2022 11:07:38 -0400
X-MC-Unique: IHWojOa_Nm2rMYt3aThM1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E5A7811E90;
	Wed,  6 Jul 2022 15:07:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D14440CFD0A;
	Wed,  6 Jul 2022 15:07:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 067351947063;
	Wed,  6 Jul 2022 15:07:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 41FB9194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 15:07:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1BDA818ECC; Wed,  6 Jul 2022 15:07:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A1B18ECB
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:07:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F14B6811E84
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:07:02 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-VwjuFPP1PHayl9z93Ym8VA-1; Wed, 06 Jul 2022 11:07:01 -0400
X-MC-Unique: VwjuFPP1PHayl9z93Ym8VA-1
Received: by mail-qt1-f171.google.com with SMTP id i11so18598065qtr.4
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 08:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=I0RXuzZs3s0id/kcom5gH7O0HmNMUUNPAv91LFO4+a4=;
 b=1n5e+u8y4QDPvuMiJ9+Y4rCZvKnnilBMHDqNgBcrrT2lOnZIq6A+lD17V746JbsIZN
 xnYgSVhu+XsCwvPseuHHc+AjQAYsFmchGN+SU7CliSw1sBuu8tvOzfzZ30UeiWLEzfxa
 Zrog3XebR74ulHrGwYChRRo/z7sUkXNMJB9twXqhUlcak004yjn9PTQDiFOOAb11/Yxr
 SnPVhNyf1Yc8BYB4A67p2ip2FaFfSqj0RZUeR2a/o088sZJ/netrv4IRYkHw5nM/CGvg
 AOqTX8bpA2tgC7UYeA2e5wYoABucFsrfVTUUuMX+qLcrLSoRTzZVF7/VRY5vd+g5fndf
 C1gg==
X-Gm-Message-State: AJIora83dLymRdC763KQ75fMPcyKwS3XgTmrALN3PosCMyIvBA9nCJCM
 lQwdhBEHkz149xkYK3ScX4EdAWg=
X-Google-Smtp-Source: AGRyM1syM2piJxHzgzwmYO+2F/M3+bHsRSC/l80bNxbiOkjZ/DCWE9FGy+Tge1oNYwtQpJp5Yz7jXQ==
X-Received: by 2002:a05:6214:29e6:b0:470:44d9:1ec5 with SMTP id
 jv6-20020a05621429e600b0047044d91ec5mr36520228qvb.95.1657120020754; 
 Wed, 06 Jul 2022 08:07:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 d3-20020ac81183000000b0031a2cdab5cesm19492709qtj.37.2022.07.06.08.06.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 08:07:00 -0700 (PDT)
Date: Wed, 6 Jul 2022 11:06:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <YsWlEmaQsIVUiKC0@redhat.com>
References: <20220627153526.3750341-1-mka@chromium.org>
 <20220627083512.v7.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
MIME-Version: 1.0
In-Reply-To: <20220627083512.v7.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v7 1/3] dm: Add verity helpers for LoadPin
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 27 2022 at 11:35P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

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
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

