Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE533EB64D7
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687974707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Kxxwnw9lQmyYxhBv4lDf6JaX7bHIwmtjAq6YiJ53xuw=;
	b=ME1r+3axWrFlYM054A8DIyPcvN2I+m/bCpx86zFWEeFzeklcV1/xXf0HCjleYcuAUT/Qzy
	u3BIBs+s3oYIy4DqX4FpI4iFEzPHOoa6N//t74BWhgOL6TOzAZDNssTuFx2qjwZZ1h/zM3
	gUzF1nnXvAivPpKlZ/VpG6tdQEN/gs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-Eu0uT9PBOPqNzcV7uarlAw-1; Wed, 28 Jun 2023 13:51:46 -0400
X-MC-Unique: Eu0uT9PBOPqNzcV7uarlAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 462B9101A54E;
	Wed, 28 Jun 2023 17:51:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D63A8140EBB8;
	Wed, 28 Jun 2023 17:51:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E8031946589;
	Wed, 28 Jun 2023 17:51:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB17B1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 17:51:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5E802166B26; Wed, 28 Jun 2023 17:51:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE0702166B25
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 17:51:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D99E381D4C9
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 17:51:38 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-bsviz94lOsuLX-5bMz7nbg-1; Wed, 28 Jun 2023 13:51:36 -0400
X-MC-Unique: bsviz94lOsuLX-5bMz7nbg-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1b8062c1ee1so1465605ad.3
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 10:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687974695; x=1690566695;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Na6wbo2C6aZoJR9rArIrRD0H3fmD8LNX5u5EBRrSJvE=;
 b=BMEDaQvGf/xGX4BmV3MnieHEmT6XbohFJ8+uziASt+Ya0XDWyd9fCGsr5ZbJahtphi
 91yxiawg97lkVE4k8m2JdAuWsFe8QFlMkHRwtFhOPPuu1q0S4QWBW0mpNn9SfuKr4+3v
 pIuxn+LWrpFTevNNqxmUoysxRmp69WnVSlRz1skGEzIgheAFEBxMkWmAVPJde70JzA2f
 HWTXxR9gbHxL70eJG2JlihQSnB4VftTkSeHnzDO/qKTePS8NwFebcqofz0qDnAWZqhKj
 keLtIhuL0xaFOpJVcK+rsNIx86RAROlIIA9UyuO8+3UU28At6gqTJ/+UAgOiwUFyb/8J
 qzzg==
X-Gm-Message-State: AC+VfDwxxQapHF3tQ3kbYcYNFLvetGf3vdyzUkgMN2mZTzp7LJ/IM8Hz
 1LF95QnPZJypzU0M3TYcqF+wqA==
X-Google-Smtp-Source: ACHHUZ63L9QbPfTdUQ6qSD2HU+s2JHZnlPcbunw6wounkGXlQH24tFhd3uE8uPfzqtWHgRWnVYh8wA==
X-Received: by 2002:a17:903:24d:b0:1b6:9b38:6004 with SMTP id
 j13-20020a170903024d00b001b69b386004mr16700746plh.22.1687974695060; 
 Wed, 28 Jun 2023 10:51:35 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 l13-20020a170902f68d00b001b843593e48sm1326552plg.228.2023.06.28.10.51.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Jun 2023 10:51:33 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Matthias Kaehlcke <mka@chromium.org>
Date: Wed, 28 Jun 2023 10:51:29 -0700
Message-Id: <168797468756.1160226.11804940754677813929.b4-ty@chromium.org>
In-Reply-To: <20230627202800.1.Id63f7f59536d20f1ab83e1abdc1fda1471c7d031@changeid>
References: <20230627202800.1.Id63f7f59536d20f1ab83e1abdc1fda1471c7d031@changeid>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] dm: verity-loadpin: Add NULL pointer check
 for 'bdev' parameter
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
Cc: dm-devel@redhat.com, Kees Cook <keescook@chromium.org>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Tue, 27 Jun 2023 20:28:01 +0000, Matthias Kaehlcke wrote:
> Add a NULL check for the 'bdev' parameter of
> dm_verity_loadpin_is_bdev_trusted(). The function is called
> by loadpin_check(), which passes the block device that
> corresponds to the super block of the file system from which
> a file is being loaded. Generally a super_block structure has
> an associated block device, however that is not always the
> case (e.g. tmpfs).
> 
> [...]

Applied, thanks!

[1/1] dm: verity-loadpin: Add NULL pointer check for 'bdev' parameter
      https://git.kernel.org/kees/c/47f04616f2c9

Best regards,
-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

