Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1F5C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 13:53:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-78x5KuyIMLSel6XGTpWy8w-1; Fri, 18 Mar 2022 09:53:53 -0400
X-MC-Unique: 78x5KuyIMLSel6XGTpWy8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB409811E76;
	Fri, 18 Mar 2022 13:53:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7930040E80E0;
	Fri, 18 Mar 2022 13:53:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DC8E1940370;
	Fri, 18 Mar 2022 13:53:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7E8F194034E
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 13:53:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A577B4021AD; Fri, 18 Mar 2022 13:53:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A11EF492CB1
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 13:53:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88D613C163F7
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 13:53:45 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-WPb7u5f0NdmNnlF9K0yPWA-1; Fri, 18 Mar 2022 09:53:41 -0400
X-MC-Unique: WPb7u5f0NdmNnlF9K0yPWA-1
Received: by mail-wm1-f47.google.com with SMTP id
 7-20020a05600c228700b00385fd860f49so4867928wmf.0; 
 Fri, 18 Mar 2022 06:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=b7mi92NL1Au3kNjhkOmUgX0hQow1JPh6u+4eSDIWQIc=;
 b=eiEMNzlmepkgdR9HlR/zbNdXJzQcWuFKlmD5GYhxiUE7LWvZ8jbyWry2ad7QLU9y1u
 nUczWvlL8tDhxhnqOe3rADCKkxuPzzGq8ffmppvieqRViMfWb7SYg699JxRpV+pVVHfO
 HYWRhX87dXJQy0HACV9xDfuVt+LzLQA9yaUfOwVOSqi/YNzLyBx663NS1smLsD1TwSLr
 2qhp2ko42n5KfE7izTxvxJ1ySVWEDQWKYsXExgmUsyZtIm2Vohw9xDI0jVCSb/UtVDbL
 M2DP5tbljc0pNREUKPKrkHV31PXpaSkKi/6SWmIR+4Y0anuh+fsmi+B71joM4+p+O6dy
 22Iw==
X-Gm-Message-State: AOAM533JKnizF3aUfoM+8sMsmh3KPN4nRvWypW5gzsZsQICFBiF9PQKK
 pQl5Lq/Xzm+9pl6HlBHjf9ajM04KlURofQ==
X-Google-Smtp-Source: ABdhPJzbNwQi18YYbbmjFbq5mvgLobh+pg7PjXQ2Tq3BPsBF8eSR7ZTyQpPBTqXupvpWSH7bJsmHlg==
X-Received: by 2002:a05:600c:35ce:b0:389:ec57:1d7f with SMTP id
 r14-20020a05600c35ce00b00389ec571d7fmr15752827wmq.149.1647611619732; 
 Fri, 18 Mar 2022 06:53:39 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 n16-20020a5d4010000000b001f07772457csm6252032wrp.101.2022.03.18.06.53.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Mar 2022 06:53:39 -0700 (PDT)
Message-ID: <a5b9e66c-235b-51dd-234c-b543dbacc464@gmail.com>
Date: Fri, 18 Mar 2022 14:53:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Coiby Xu <coxu@redhat.com>
References: <20220318103423.286410-1-coxu@redhat.com>
 <c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com>
 <20220318122110.7qjrnrduwytjle3w@Rk>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20220318122110.7qjrnrduwytjle3w@Rk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [RFC 0/4] Support kdump with LUKS encryption by
 reusing LUKS master key
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
Cc: Mike Snitzer <snitzer@redhat.com>, Baoquan He <bhe@redhat.com>,
 kexec@lists.infradead.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 18/03/2022 13:21, Coiby Xu wrote:
...
>> Why is it not done through keyring and forcing kdump to retain key there
>> (under the same keyring key name as dm-crypt used)?
>> Kernel dm-crypt supports this already; LUKS2 uses keyring by default too.
>> That's all you need, or not? Why do you need to add another "kdump:" thing?
>> IOW why kdump cannot copy the key to keyring under the name dm-crypt
>> has in the mapping table and let dm-crypt activate the device almost without
>> code changes?
> 
> Sorry, I haven't explained how kdump works. Once the 1st kernel crashes and
> the system boots into the kdump kernel, the kdump kernel only have direct
> access to the memory exclusively reserved for it i.e. the kdump kernel
> loses the direct access to the keyring constructed in the 1st kernel. In
> theory, the kdump kernel could do some "hacking" to find out the key
> stored in the memory directly managed by the 1st kernel but I imagine
> this would be difficult task (imagine I present the memory dump of my
> computer to you and ask you to rebuild all the relevant kernel data
> structures and find the key). Besides, it's not reliable to read the
> memory directly managed by the first kernel for example the memory could
> be corrupt. So we have to pass the master key from the 1st kernel to the kdump
> kernel.

OK, then why you cannot store it to the (2nd) kdump kernel keyring?
(From the kdump area copy, then you do not need to patch anything else
in dm-crypt than that one line storing the key to the kdump area.)

A clear approach would be to store the key in the 2nd kernel kdump keyring
and allow userspace to read it.
Then cryptsetup can just validate the key (LUKS key digest does not use Argon)
and activates it without asking for a passphrase.
Perhaps this will need some new cryptsetup option (or API call), but I think
it can be done.

Or, you can actually simulate it with
   cryptsetup open ... --master-key-file <file>
where this keyfile contains directly the volume key, not a passphrase.
The key digest is verified in this case only; no costly PBKDF is needed.

If you have a way to retrieve the kdump stored key to kdump userspace, this
is perhaps a much simpler solution.

All this is against all countermeasures to not expose encryption key
directly - but if kdump is debugging environment, just saying...

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

