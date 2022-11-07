Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75C1C43217
	for <dm-devel@archiver.kernel.org>; Tue,  8 Nov 2022 08:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667897996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cYMVzSlbyGAbjTpOUhihZ4U6+d0QVlGNavgGYUZhawk=;
	b=EkyM4lR5s0E+crbVoo8bjJvLIvU9cWl04dZa0DHioTvdqdanmMHb/4nk2X2EZR48RvFphj
	TggCtc4+kPyJF56asQQKfDs68iY80J1gpZ2Hnq9ZBG69vFlo6hymOE/t+O4hSCPzsDZhPF
	TT0tMe1yZE4w8efonh2lYYq8u0bpmh0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-BrIn2A0tO3mFL8IbojEwUQ-1; Tue, 08 Nov 2022 03:59:53 -0500
X-MC-Unique: BrIn2A0tO3mFL8IbojEwUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C7E3186E393;
	Tue,  8 Nov 2022 08:59:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFD3340C9599;
	Tue,  8 Nov 2022 08:59:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 079881946588;
	Tue,  8 Nov 2022 08:59:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8AB9F1946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 11:25:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7375A4221F; Mon,  7 Nov 2022 11:25:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C0DD39DB3
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 11:25:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AC873810783
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 11:25:35 +0000 (UTC)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-UgFnaHhAMhGr3qIe9rcjBw-1; Mon, 07 Nov 2022 06:25:34 -0500
X-MC-Unique: UgFnaHhAMhGr3qIe9rcjBw-1
Received: by mail-pg1-f199.google.com with SMTP id
 v18-20020a637a12000000b0046ed84b94efso6067801pgc.6
 for <dm-devel@redhat.com>; Mon, 07 Nov 2022 03:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dCVCpPKMqtN5wnk1UeEtAp45DPD5WDdi+08rU7HtVp0=;
 b=ihYEMqGI6oIRhKpD0ZGEqGV0cCHXbTlLeydObA+aRsYvD5ybWyv6FaTYREDzYKoQyg
 xguhPpzODc1DyizW0JCVXQC0KOFBxxNlmrPPi6E3YpNZFY3JWdr1iz4QW/Z7JczmO3ST
 yCp7PDEVP28uh6U+Xc1z4xOdaAvWMnFmpxfKqZznj2LAPKqkRWcxbY9ZzY2FiXo9iSTw
 SEsYxEk377zgH35ZQvi3w5iRGsG0K2LarDZncJsfP9PxV8NZXQHATkcF9ZUJsz1or2sF
 TII2ngct/zOQcX/yxhLT0Xx/3X+xXBlJNCW8biz5E0UEJ23a7EWkSNRFMniRjGB4E2at
 bcig==
X-Gm-Message-State: ACrzQf1gRz/tT1Dw2JeI9HD1pq8+NH0eL/AsBzmEH212Vg+Sc/4Swts/
 6E92VProX4zyNjvKw/ArcR/Odzkxt0CbnaO5yIJ9xH96giBJmgmxWmCBTv5/89uW0PrzlPPGPMO
 plXCSqsb9euzrMfE=
X-Received: by 2002:a17:90b:378a:b0:213:803d:3389 with SMTP id
 mz10-20020a17090b378a00b00213803d3389mr59863676pjb.115.1667820333148; 
 Mon, 07 Nov 2022 03:25:33 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4kRlWD2TrlfQwcFjYkARJTFCe1a+ZyHxdAcDHlQVxS+84+J4PGUG5doWP7ysunIg0QVPRwjw==
X-Received: by 2002:a17:90b:378a:b0:213:803d:3389 with SMTP id
 mz10-20020a17090b378a00b00213803d3389mr59863627pjb.115.1667820332821; 
 Mon, 07 Nov 2022 03:25:32 -0800 (PST)
Received: from localhost ([240e:3a1:313:8350:fe71:9f84:6361:a65b])
 by smtp.gmail.com with ESMTPSA id
 y1-20020aa78f21000000b005613220346asm4210353pfr.205.2022.11.07.03.25.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 03:25:32 -0800 (PST)
Date: Mon, 7 Nov 2022 19:20:34 +0800
From: Coiby Xu <coxu@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>
Message-ID: <20221107112034.dxfembsprd2wwnpf@Rk>
References: <20221104113000.487098-1-coxu@redhat.com>
 <20221104113000.487098-5-coxu@redhat.com>
 <1c9a1b86-efef-fa56-4451-ac3348b678bf@intel.com>
MIME-Version: 1.0
In-Reply-To: <1c9a1b86-efef-fa56-4451-ac3348b678bf@intel.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 08 Nov 2022 08:59:40 +0000
Subject: Re: [dm-devel] [RFC v2 4/5] x86/crash: make the page that stores
 the LUKS volume key inaccessible
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
Cc: "maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, kexec@lists.infradead.org,
 dm-devel@redhat.com, Pingfan Liu <kernelfans@gmail.com>,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Dave,

Thanks for the quick review!

On Fri, Nov 04, 2022 at 07:38:17AM -0700, Dave Hansen wrote:
>On 11/4/22 04:29, Coiby Xu wrote:
>> +	if (kexec_crash_image->luks_volume_key_addr) {
>> +		start = kexec_crash_image->luks_volume_key_addr;
>> +		end = start + kexec_crash_image->luks_volume_key_sz - 1;
>> +		page = pfn_to_page(start >> PAGE_SHIFT);
>> +		nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
>> +		set_memory_np((unsigned long)page_address(page), nr_pages);
>> +	}
>
>Why does this go pfn -> page -> vaddr?  What good does having the page
>do? 

Sorry it's an imitation of kexec_mark_crashkres.

> Can you just do phys_to_virt() on the start address?  Maybe:
>
> 	start_paddr = kexec_crash_image->luks_volume_key_addr;
> 	end_paddr   = start_paddr + kexec_crash_image->luks_volume_key_sz - 1;
> 	nr_pages = (PAGE_ALIGN(end_paddr) - PAGE_ALIGN_DOWN(start_paddr))/
>PAGE_SIZE;
> 	set_memory_np((unsigned long)phys_to_virt(start_paddr), nr_pages);

Thanks for suggesting a smarter implementation! I'll apply it to next
version.

>
>Also, if you resend this, please just cc the x86 folks on the series.
>The other patches and cover letter have desperately needed context
>around this.

Sure, I'll cc the x86 list the complete patch set next time. Sorry
you'll have to go to
https://lore.kernel.org/lkml/20221104113000.487098-5-coxu@redhat.com/t/
to read related emails for now.


>

-- 
Best regards,
Coiby

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

