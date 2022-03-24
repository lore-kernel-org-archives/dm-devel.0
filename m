Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFF6C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 17:08:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-v_LeqjDcOfe8vYM0AnKO4g-1; Thu, 24 Mar 2022 13:08:22 -0400
X-MC-Unique: v_LeqjDcOfe8vYM0AnKO4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 665BC3C00125;
	Thu, 24 Mar 2022 17:08:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B9FA340D0166;
	Thu, 24 Mar 2022 17:08:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6344C194034B;
	Thu, 24 Mar 2022 17:08:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55A5D1940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 17:08:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E76211410DD5; Thu, 24 Mar 2022 17:08:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E35901454539
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 17:08:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FD88802803
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 17:08:16 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-SmYcdML6P9SNSs-tBZAFTw-1; Thu, 24 Mar 2022 13:08:14 -0400
X-MC-Unique: SmYcdML6P9SNSs-tBZAFTw-1
Received: by mail-pl1-f182.google.com with SMTP id w8so5385865pll.10
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 10:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OAX2s1YJUK+JCKPSRFH3r/eBPmJj6BkhAiKg365PhCU=;
 b=QI7XL7vkWAhYZMAvv6e50s+tugH7JigMi7dDM5Qi4rWKE64mqYf0KSOeA7hiX+1r9k
 I6Pcz8OXOr+6oYOsojSN9O7kGfbniaHg9PUlh2P3ft7oCBRv3Sg/Kr4oz+Jxp14RFdce
 kX5kk5QQzV6XRzFGo1V7LbAZRJeNYrxBfpvKIKRXNOkOIeRZyAiJDwDncDF3ASQBosrw
 eugAoROXw25zTK1noDvEwYfBwp7oBwTFslcx+MgOjL+9L86ILEmboXNIV1/in02D5DlY
 XFzLRbOCoKkOzWQS3qS2NB7SaBnK0eNaKRPU2JvA/A9bTxOLJJbiXgBof/YxpW/mzKxh
 v0dA==
X-Gm-Message-State: AOAM533pO2FzHaF4LycY40RpnUkUeMsZs1hpxIRPxn5ZX04HX7mBlTSk
 emB5F6NReFvTuxqwX8YGAhS5Bu6D+SkK3A==
X-Google-Smtp-Source: ABdhPJw3BneT0xR/MwT4/MddsdiR3WrnDJW5OsHQXRPz2HaOQS2AtrK79G/Gr319u98jgbNUm8fMHw==
X-Received: by 2002:a17:90a:5293:b0:1bc:a544:a638 with SMTP id
 w19-20020a17090a529300b001bca544a638mr7346478pjh.174.1648141693134; 
 Thu, 24 Mar 2022 10:08:13 -0700 (PDT)
Received: from dev-ushankar.dev.purestorage.com ([208.88.159.128])
 by smtp.gmail.com with ESMTPSA id
 l27-20020a63701b000000b0038233e59422sm3032040pgc.84.2022.03.24.10.08.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 10:08:12 -0700 (PDT)
Date: Thu, 24 Mar 2022 11:08:09 -0600
From: Uday Shankar <ushankar@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220324170809.GA2213089@dev-ushankar.dev.purestorage.com>
References: <20220309200325.2490463-1-ushankar@purestorage.com>
 <20220323231023.GL24684@octiron.msp.redhat.com>
 <3fdc891239f9c45f8b4c034eae9ded9572f2a0ad.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <3fdc891239f9c45f8b4c034eae9ded9572f2a0ad.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] multipath-tools: update mpp->force_readonly
 in ev_add_path
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
Cc: dm-devel@redhat.com
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

Thanks to Benjamin for the review and to Martin for taking the patch.

> https://github.com/openSUSE/multipath-tools/tree/queue
Benjamin, does RedHat take patches from this repo? The
device-mapper-multipath spec file seems to point to git.opensvc.com
(which is dead), and the upstream URL christophe.varoqui.free.fr refers
to github.com/opensvc/multipath-tools. Will patches committed to the
above openSUSE repo will make their way to the opensvc one (since
openSUSE forks opensvc)?
 
> (Please set me on CC next time to speed up review).
Sure, is there a list of maintainers and email addresses somewhere?
Everywhere I look I only see Christophe Varoqui listed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

