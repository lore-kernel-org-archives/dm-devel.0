Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140B0C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jan 2022 20:51:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-fxXWNpiAMTO7RZTNEacZzw-1; Fri, 14 Jan 2022 15:51:38 -0500
X-MC-Unique: fxXWNpiAMTO7RZTNEacZzw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E03FE10B7467;
	Fri, 14 Jan 2022 20:51:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB225E484;
	Fri, 14 Jan 2022 20:51:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DB304BB7C;
	Fri, 14 Jan 2022 20:51:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20EKpPh5031041 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 Jan 2022 15:51:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7157140CFD37; Fri, 14 Jan 2022 20:51:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C8DD40CFD04
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 20:51:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53CBE185A7BA
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 20:51:25 +0000 (UTC)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
	[209.85.208.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-73-mXlOskSXNYixQE1YtEP9cw-1; Fri, 14 Jan 2022 15:51:23 -0500
X-MC-Unique: mXlOskSXNYixQE1YtEP9cw-1
Received: by mail-ed1-f44.google.com with SMTP id o6so38361145edc.4
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 12:51:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=U34S8MFZI0SN/YJSalKgQrislTv19rNvp8ARtSynQVw=;
	b=PMQ0vMsBQbR40uE7lhkiW4zZL6PcJbAv9vK8htEmZcvhcNHz36tjlOuy0H10wXXMlg
	nfsYUhkEe2N3wnTsr231a/B1XGCpcAN+h5KUHBylu0oSC1svBd6XBaIdY7Wul0jZxaX7
	9rUtnDojG7rppdZee1bEmgjbfD5DakrSCIm5NH8m7QQIE2bgQCq1IO1gF/pzx52gbeqV
	a5NtdgvsPILDActJ0OTfD0VuOcI195zb8pjKK5jW0U6pYGBHjpkBqVbA4br7imJycw2Y
	8z5EfU3ufYNTZf4taIaMeHwjax957XY6DXMNwuaF9FJM+9aEOIfqZD/PVNCbnzofetm1
	DIHQ==
X-Gm-Message-State: AOAM530/qg9lmTDusJMIWojIdqxfosZBJSspPSrfw3MTzvtnRP55TUJm
	cgKl8huXcoNh6H6Kj1tt3S2aK0+2mQ0=
X-Google-Smtp-Source: ABdhPJzH3Xmy/n6cn08KaCjVifAv4kxcNvJP44Va6uWbAV9L1vhlforP77in7DgJvgrAhapYiXqqsQ==
X-Received: by 2002:a17:906:270b:: with SMTP id
	z11mr8299870ejc.87.1642193482575; 
	Fri, 14 Jan 2022 12:51:22 -0800 (PST)
Received: from [192.168.8.101] (89-24-44-210.nat.epc.tmcz.cz. [89.24.44.210])
	by smtp.gmail.com with ESMTPSA id
	qf22sm2096520ejc.85.2022.01.14.12.51.21
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 14 Jan 2022 12:51:21 -0800 (PST)
Message-ID: <9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
Date: Fri, 14 Jan 2022 21:51:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Israel Rukshin <israelr@nvidia.com>, dm-devel <dm-devel@redhat.com>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Nitzan Carmi <nitzanc@nvidia.com>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 13/01/2022 19:09, Israel Rukshin wrote:
> Hi,
> 
> I am working to add support for inline encryption/decryption
> at storage protocols like nvmf over RDMA. The HW that I am
> working with is ConnecX-6 Dx, which supports inline crypto
> and can send the data on the fabric at the same time.

This idea comes from time to time, and it makes dm-crypt bloated,
and mainly it moves responsibility for encryption to block layer
crypto.
It adds two completely different sector encryption paths there.

Also, see my comments here (for similar patches)
https://lore.kernel.org/dm-devel/c94d425a-bca4-8a8b-47bf-451239d29ebd@gmail.com/

I think dm-crypt should stay as SW crypto only (using kernel crypto API,
so HW acceleration is done through crypto drivers there).

A cleaner solution is to write a much simpler new dm-crypt-inline target,
which will implement only inline encryption.
(And userspace can decide which target to use.)
Code should be just an extension to the dm-linear target, most
of dm-crypt complexity is not needed here.

Also, please think about configuration - how do you want to configure it?

Just my opinion, it is, of course, up to DM maintainer if he takes such patches.

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

