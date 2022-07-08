Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0345AC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jul 2022 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657302507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sEnNTzKCfx19RPkZ+NZuZj1BVe7vbRWucREFmbZWtD8=;
	b=MDE1qKCetvOL1AiT8Yu9Hpl7TOGz8+ERIhM9LXYjfVEQpFqBvuTiUJlIU+VROaTqDyQhjy
	nfIMBmJbgCbRHVexAmmZX9HbTwFKJ5HKa0u4L+SIqSEnX9Mrbp2lDQ5HwmPz49hcR/519+
	x/zT+HHhU2/oKhKLis3iuc7vaJqoAcU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-gp3Zw9HHNESI325aBoVKhg-1; Fri, 08 Jul 2022 13:48:24 -0400
X-MC-Unique: gp3Zw9HHNESI325aBoVKhg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50B8F1C05AF1;
	Fri,  8 Jul 2022 17:48:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82876492CA2;
	Fri,  8 Jul 2022 17:48:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 806F61947072;
	Fri,  8 Jul 2022 17:48:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 61E871947075
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 17:48:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4CFD940315C; Fri,  8 Jul 2022 17:48:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47F82492C3B
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 17:48:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC40101A58D
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 17:48:16 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-yvjIgUykPk2LabWKUTxQgQ-1; Fri, 08 Jul 2022 13:48:14 -0400
X-MC-Unique: yvjIgUykPk2LabWKUTxQgQ-1
Received: by mail-pg1-f169.google.com with SMTP id 72so1430531pge.0
 for <dm-devel@redhat.com>; Fri, 08 Jul 2022 10:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=SCpgoi0bej3E/k3q1Zzvx8WQzQbsCorWnUbIjfYa/X8=;
 b=bkBx/CsmqDZHjWZp0MDn7tPmBZMF47gOe3fRxcM11opve8/fVO2CRcb32sfuBLVsJ/
 jVWOooRFntvBZsHr3Eg7447gj9wLE1daIxNoiaD6SDg++qslAnFAMf8tjKXWNnfk6ET8
 GjmCw6xic9su548YV3BP7jdIa170mqmbA6ep6PR7XvUcAwFsEVMSVo95bA6jnCNot9Y1
 29sQA+KXcxxilDGAf0MqRdTAU8P4rW2MIrFODWNooUk+w1GtBgBU/dzL3UzFBJEJc55k
 ziuRB6blxQLvwSP2Hau9pUoISTMnh/IefLKeizjT7k47ju299qNR2JDrg8nvUlS3umWo
 gxdw==
X-Gm-Message-State: AJIora9qd90TUa9X1gQLgzXPd2Zf4Gls7I3iItr3dFT2mWyUhNdl84bC
 ZOTuRn2i4TmZ8uVudQrehFgzdA==
X-Google-Smtp-Source: AGRyM1sZCb3nACbVv0Xqctc8zBRDdY2BX228aDhc1USUQoc2fpKbCJNkaQ1aAGFkZEau8j+w/Chrcg==
X-Received: by 2002:a63:187:0:b0:411:6434:d017 with SMTP id
 129-20020a630187000000b004116434d017mr4274618pgb.350.1657302487803; 
 Fri, 08 Jul 2022 10:48:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 a74-20020a621a4d000000b00528d4f647f2sm3404184pfa.91.2022.07.08.10.48.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 08 Jul 2022 10:48:07 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: jmorris@namei.org, agk@redhat.com, snitzer@kernel.org, mka@chromium.org,
 serge@hallyn.com
Date: Fri,  8 Jul 2022 10:47:59 -0700
Message-Id: <165730247648.3882109.12888837825450019581.b4-ty@chromium.org>
In-Reply-To: <20220627153526.3750341-1-mka@chromium.org>
References: <20220627153526.3750341-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 0/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, dianders@chromium.org, linux-raid@vger.kernel.org,
 song@kernel.org, linux-security-module@vger.kernel.org, gmazyland@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 27 Jun 2022 08:35:23 -0700, Matthias Kaehlcke wrote:
> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity [2] to
> verify the integrity of the DLC content.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/3] dm: Add verity helpers for LoadPin
      https://git.kernel.org/kees/c/b6c1c5745ccc
[2/3] LoadPin: Enable loading from trusted dm-verity devices
      https://git.kernel.org/kees/c/3f805f8cc23b
[3/3] dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
      https://git.kernel.org/kees/c/231af4709018

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

