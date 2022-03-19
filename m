Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38064C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-4lYf3jygNNCpi5ZelWR1kQ-1; Mon, 21 Mar 2022 02:54:59 -0400
X-MC-Unique: 4lYf3jygNNCpi5ZelWR1kQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B15E1066561;
	Mon, 21 Mar 2022 06:54:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09581428F08;
	Mon, 21 Mar 2022 06:54:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04D91193F6DD;
	Mon, 21 Mar 2022 06:54:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C23A1953552
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 20:47:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 082EEC090DA; Sat, 19 Mar 2022 20:47:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03B35C15D56
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 20:47:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C41FC1C0514F
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 20:47:03 +0000 (UTC)
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-wmZEDy7jMfyP8_0iBHn2hw-1; Sat, 19 Mar 2022 16:47:01 -0400
X-MC-Unique: wmZEDy7jMfyP8_0iBHn2hw-1
Received: from [187.39.124.208] (helo=[192.168.0.110])
 by fanzine2.igalia.com with esmtpsa 
 (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
 id 1nVfSE-00047T-NZ; Sat, 19 Mar 2022 21:13:39 +0100
Message-ID: <c06a21cc-e1c1-e627-f908-ebc2a041e29a@igalia.com>
Date: Sat, 19 Mar 2022 17:13:21 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org
References: <20220318103423.286410-1-coxu@redhat.com>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220318103423.286410-1-coxu@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
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
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 18/03/2022 07:34, Coiby Xu wrote:
> [...]
> Based on Milan's feedback [1] on Kairui's ideas to support kdump with
> LUKS encryption, this patch set addresses the above issues by
>  1) first saving the LUKS master key to kexec when opening the encrypted
>     device 
>  2) then saving the master key to the reserved memory for kdump when 
>     loading kdump kernel image.
> 
> So the LUKS master key never leaves the kernel space and once the key has
> been saved to the reserved memory for kdump, it would be wiped 
> immediately. If there is no security concern with this approach or any
> other concern, I will drop the following assumptions made for this RFC
> version in v1,
>  - only x86 is supported
>  - there is only one LUKS device for the system
> 
> to extend the support to other architectures including POWER, ARM and
> s390x and address the case of multiple LUKS devices. Any feedback will be 
> appreciated, thanks!
> 

Hi Coiby, thanks for the very interesting work!
I confess I didn't review the code as I have not much experience in
dm-crypt/key management, but I have a generic question related with the
motivation of the patch set.

My understanding is that one (the main?) motivation of this series would
be to protect the saved memory (vmcore) from being read by some
"unauthorized" entity - in order to achieve this goal, it is hereby
proposed to allow kdump kernel to access a memory-saved key and with
that, mount an encrypted volume, saving the vmcore over there correct?

So, what if instead of playing with the volume key, users with this
concern address that by reserving some *unencrypted partition* for
saving the vmcore, but then *encrypt the vmcore* itself! So, instead of
requiring saving a full-volume key, mount everything, risk data
corruption if something goes bad...we just have makedumpfile encrypting
the vmcore with some preloaded key (which might be saved inside the
kdump minimal intird, for example), and saving the encrypted file into a
clear/unencrypted volume? This way we also prevent excessive memory
consumption during kdump due to the lvm/dm-userspace paraphernalia usage.

Does it make sense or am I being silly or missing something?
Cheers,


Guilherme

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

