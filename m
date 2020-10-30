Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A68C00A89
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:18:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52F81221FA
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52F81221FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-JGNTZgLZM7a1VUgJanSNSA-1; Fri, 30 Oct 2020 17:17:57 -0400
X-MC-Unique: JGNTZgLZM7a1VUgJanSNSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 333D280B71A;
	Fri, 30 Oct 2020 21:17:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C4C17E33F;
	Fri, 30 Oct 2020 21:17:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D3356181A86E;
	Fri, 30 Oct 2020 21:17:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09ULEv1v019994 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 17:14:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E8FE220110C9; Fri, 30 Oct 2020 21:14:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4165200A7CD
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:14:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A10DD811E78
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:14:54 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-497-oLevgRpCPO-t2csWpyLdEA-1; Fri, 30 Oct 2020 17:14:50 -0400
X-MC-Unique: oLevgRpCPO-t2csWpyLdEA-1
Received: by mail-wm1-f53.google.com with SMTP id c9so2530521wml.5;
	Fri, 30 Oct 2020 14:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=hWxhty1lm8yiJl+58insY2E4GGSjDpYY95hD8X0gbaw=;
	b=byzcUJvGqXhjSsVYkmqdTKwKQK2MdvqGpCfssPVXgNDPf45+1D/qll9gAAdwprmBDb
	4kqkiI4bfhNum0OpLadD4b9LwKDg5jhWWh7Y1I4Nr/Y6t6wCBdEG2cDpYL6XP4kGn9co
	o1DSNhz0+tBtP5dJU6lKkM02RYqoEhoTkL4ZdsK+zLiQ0Zhos7G0GLkQfM3S6ahaIBox
	BxDznD+3fag1UjUOc+1AK8uL/iSEGZN/M1hLwK07xkCliAbCgQnhbDOQtGE+QuxHeAbQ
	vazAlPuHDYOx6m8Hd1iYmQ5SxKimCnovtn1KvrWSNhu/0lug4yD6s1sW5iMgLR/2JmEC
	AP/w==
X-Gm-Message-State: AOAM530l1m5rwmN2N0QUWH/BgZKNu0AB+WJ5jSD1cWvaHz9Nn4FfD4je
	+yIS4bfiXjKYYNvvEobkoRSiwaN/CA==
X-Google-Smtp-Source: ABdhPJyfBxWYA1i34fzOjc5APkDSKrm8Ao4krdOnr/xoMba3idTdbqnEDN9aEoOwkPBMKRdj9htMmg==
X-Received: by 2002:a1c:4e0e:: with SMTP id g14mr4788052wmh.69.1604092488744; 
	Fri, 30 Oct 2020 14:14:48 -0700 (PDT)
Received: from localhost (47.red-95-127-152.staticip.rima-tde.net.
	[95.127.152.47]) by smtp.gmail.com with ESMTPSA id
	30sm11845946wrs.84.2020.10.30.14.14.47
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 30 Oct 2020 14:14:48 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>
References: <20201028141411.23806-1-xose.vazquez@gmail.com>
	<c75f584a7475a0094e90a91786d5ef114a761b3a.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <e010e46e-f84c-73e4-a592-a0131a7fe507@gmail.com>
Date: Fri, 30 Oct 2020 22:14:46 +0100
MIME-Version: 1.0
In-Reply-To: <c75f584a7475a0094e90a91786d5ef114a761b3a.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: delete auto-generated
 tests/test-log.d file with make clean
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/30/20 9:34 PM, Martin Wilck wrote:

> Nack. The correct fix is attached.

Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

