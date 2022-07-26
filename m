Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FE8C43334
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 02:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658803233;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QU36v/0ob++DWNX43qW2EUZRbQaHTOM2avxfbNvJ660=;
	b=dJ9M4S+th6IXmwsfbGqccwKit6GP/j+qvOwepdh+YUsmkIeUGrA7BMf5IgBOHS5JTyHo6h
	SzhSPbEB0sBCFNp2Ai2a/mAmzGgpjngzHaBo3DFQ8uGWZjqKKKc7xa9/VmE4SrBpvI46+q
	8hlictBg6r5UgTFgK9XU0qvfVR/iMgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-3Yq2I1JFP9-mX2YXPW1RfA-1; Mon, 25 Jul 2022 22:40:30 -0400
X-MC-Unique: 3Yq2I1JFP9-mX2YXPW1RfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08D091019DE0;
	Tue, 26 Jul 2022 02:40:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74E0690A04;
	Tue, 26 Jul 2022 02:40:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FADB1945D88;
	Tue, 26 Jul 2022 02:40:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ACF7B1945D8A
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 02:40:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98DCDC27DB3; Tue, 26 Jul 2022 02:40:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94AC0C04482
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 02:40:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DD483C0ED48
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 02:40:25 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-Gbnqh2BNM-OUUlHNHbS94w-1; Mon, 25 Jul 2022 22:40:23 -0400
X-MC-Unique: Gbnqh2BNM-OUUlHNHbS94w-1
Received: by mail-pf1-f171.google.com with SMTP id 70so12098127pfx.1
 for <dm-devel@redhat.com>; Mon, 25 Jul 2022 19:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YDCQ69+j6DNEGXcsFGhvww2iHW1abII9YyREo17Wc9M=;
 b=vTE1K+CTe4wsosKWLCxAU8zea+jbyYMDYHIYNWoIXisurGUIxRLTqPujxU65K24lDf
 dJP61bxYFFF95zyS17BY53QIxQZQWAEGyoWSK8WwJPNj2iXSOAfUj8SSCd95CTnvvh1S
 Vzgt1X5bopFwukasT7GUJ9YBIFUuSByyeYHwQJbFUNHc30dDHPh3wLw2Egd7lQZ3wRxg
 2vA5+IBmFs3F6QqXLnMLNo4xb5Am2RH1MH1QIchlYXFZNTLnpqf+IIjG7l1J2/Lq+3Ic
 svBA8hAuh/K5hfq89il58MPb8BWXDbI+nCm2elAQoEzsheW0Oy8KcVPQYTQ0Ia6lYm2h
 mVew==
X-Gm-Message-State: AJIora8Jk+ZUuwry1LvgJl4G9hJU1sq7USSdXgU1dNCW3aULNA4QX35w
 9XcCzuaGHq2XhN8sYdfuSDoc0Q==
X-Google-Smtp-Source: AGRyM1vx5o3O82d+UwS4QXR3lui4cdf2xPHbdWNIwHc/5apxbNSIwtpsF6MA6NxtaEX1qzpjbghRdw==
X-Received: by 2002:a63:5fc9:0:b0:419:9871:fc8d with SMTP id
 t192-20020a635fc9000000b004199871fc8dmr13109285pgb.422.1658803222173; 
 Mon, 25 Jul 2022 19:40:22 -0700 (PDT)
Received: from google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au.
 [122.107.196.14]) by smtp.gmail.com with ESMTPSA id
 a16-20020aa78e90000000b0052b29fd7982sm10250313pfr.85.2022.07.25.19.40.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Jul 2022 19:40:21 -0700 (PDT)
From: Daniil Lunev <dlunev@chromium.org>
X-Google-Original-From: Daniil Lunev <dlunev@google.com>
Date: Tue, 26 Jul 2022 12:40:14 +1000
To: Israel Rukshin <israelr@nvidia.com>, Eric Biggers <ebiggers@kernel.org>
Message-ID: <Yt9UDoKbidXaTmYd@google.com>
References: <1658316391-13472-1-git-send-email-israelr@nvidia.com>
 <1658316391-13472-2-git-send-email-israelr@nvidia.com>
 <Ytj249InQTKdFshA@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <Ytj249InQTKdFshA@sol.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/1] block: Add support for setting inline
 encryption key per block device
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
Cc: Jens Axboe <axboe@kernel.dk>, Max Gurtovoy <mgurtovoy@nvidia.com>,
 linux-fscrypt@vger.kernel.org, Linux-block <linux-block@vger.kernel.org>,
 dm-devel@redhat.com, Nitzan Carmi <nitzanc@nvidia.com>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 20, 2022 at 11:49:07PM -0700, Eric Biggers wrote:
> I'm glad to see a proposal in this area -- this is something that is greatly
> needed.  Chrome OS is looking for something like "dm-crypt with inline crypto
> support", which this should work for.  Android is also looking for something
> similar with the additional property that filesystems can override the key used.
Yes, this is exciting to see proposals in this area. In ChromeOS we were
contemplating ways to upstream Eric's work for Android. This solution should
work generally for our use-case, however I would like to add a few extra pieces
we were considering.

One thing we were looking for is having an option to pass inline encryption keys
via keyrings, similarly to how dm-crypt allows suuplying keys both ways: raw and
keyring attached. I would assume that is something that should still be possible
with the IOCTL-based approach, though proposed API can make it a bit obscure. I
was wondering whether there should be a separate field to allow this kind of
differentiation?

The other aspect is the key lifetime. Current implementation doesn't allow to
unset the key once set. This is something that would still work with dm setups,
presumably, since the key lifetime is tied to the lifetime of the device itself,
but may render problematic if this is applied to a raw device or partition of a
raw device, I would assume - allowing no ways to rotate the key without reboot.
I am not sure if this is a particularly important issue, but something that I
wanted to raise for the discussion. This also becomes relevant in the context of
the keyring usages, i.e. whether to revoke the key from the block device when
the key is removed from the keyring, or assume it is bound at the time of device
setup. The dm-crypt follows the latter model, AFAIU, and it is fine to keep it
consistent, but then the question comes back to inability to remove the key in
the current API in general.

And speaking about dm, the other thing we were looking into is compatibility of
inline encryption key setup with dm stacks. Current kernel implementaiton
propagates the crypto context through linear and flakey target, we also had
initial tests enabling it on thin pools by adding DM_TARGET_PASSES_CRYPTO, which
didn't show any problems at first glance (but more testing is required). We
believe that an ability to setup multiple different dm targets with different
keys over the same physical device is an important use case - and as far as I
can tell proposed approach supports it, but wanted to highlight that as well.

--Daniil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

