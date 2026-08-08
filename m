Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FD826AC3
	for <dm-devel@lists.linux.dev>; Sat,  8 Aug 2026 01:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786153083; cv=none; b=A1Pw+4INxieiDaOJrlNqVsuWiUjy/knyAWLjOmIwS7Ji6TydjFtvIwZBkM1OHxJlubUnX6ghwJja2IBvrn6mrAvY/gIzT8phW2sxFZ7TElhrablYnpG4S/atl2yH6bPTP+xEl8tCuTGopp7GcAGG8J1AdMDwjEzWjgFQKAxF/S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786153083; c=relaxed/simple;
	bh=1+2zQ4RinlUrrBiW5t5/9uO3USppgPAIhvCZB4mi3II=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kUPI09+4Mb49/3iFyXbjY8VYqtdQAGo0oO6BGG//gZcZUoWtDX0Dlr2WlRC1YeoWvKmRN6oJIMbckXF6F41c+Lnzl1gwGRg/fCnNVpj6jJm2SgbOig5wjLtk4I6Ua9OlCTtZ0AtezY7lhNo4LPjzwilN+nAnogtWmo1vmZsUTP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TCOjk4V0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCOjk4V0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786153081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Me4aN7jMWKJe1W1UXyARPL1nrirBBQ/uNdLMiUwiK6I=;
	b=TCOjk4V0ZBSBUF6YiAFG55HjY+D6N+8xh154IcAaH9mgVGSp7FPUSKz1pFyr8OJP4gJE5C
	S5qfDytBEZNrymf5LNanB/dnV7TOYTmIP9FcWY8YJHLrcKAtdFcQlYtEMvmXArAfB1ZRkc
	S3UOW8pkeJWWAAwa0KnQyBeAlCuKsUs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-EtQo0wXVPaKxxfHOmV4WiA-1; Fri, 07 Aug 2026 21:37:59 -0400
X-MC-Unique: EtQo0wXVPaKxxfHOmV4WiA-1
X-Mimecast-MFC-AGG-ID: EtQo0wXVPaKxxfHOmV4WiA_1786153079
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e5e38fbc5so12567885a.2
        for <dm-devel@lists.linux.dev>; Fri, 07 Aug 2026 18:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786153079; x=1786757879;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Me4aN7jMWKJe1W1UXyARPL1nrirBBQ/uNdLMiUwiK6I=;
        b=tVDjG0zOg/qbXm29kqq8Za15XAj7l0WGyRxCmIlZwe1ZR4kAHI1P+7UyKAUiAdTdfV
         jvTIk7b08oSd2XitW3fHYdQi/CFRIC5cqa7seqp40kTWVNUOiYhzg+Gl6sBq2sbZWEtf
         P254oXn6puQLs86oNUL3rHWfwvQ/oShzOxNk2EeXNkKDmQuMPPyNVjn6USDJEi6tJYZp
         5cbM0Fp+z99sCZ4Td13A+romkSwgvx9W1OR+4YnDmWOc8MVpCyrOd2M3jiOX/J+/YxMS
         j8zxH1AT4iMASjUUYlCW2sd0lr5u57ejItRIuuoKWeYcAAom2+GkZsjAk9U8iAVBSoTz
         IVmg==
X-Forwarded-Encrypted: i=1; AHgh+RqV9IxL7ot2Xia4gM2GIhhKNtFFRMx7BQCfcXW7ks53EUUSulyaDj1oKnmMw8d2S4jnUL6iPvK/gg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7rvy75YQUtsQrHfruLJc2yR3PFZGyNJm0n11MOU80dZ9rCf4J
	2bH9JlBTV+/H1qhoHP3RuZkvfXWftMQ56fKNqjgPU1OUARFDfXVMM3270zPW/RGIuVMR+1eofBF
	t1ap+63I5tHLZ48n4LL8MSaM69XbNTXGMN82fM7wIscJvU3CoBTSsb4GYKbThpz3y9/80
X-Gm-Gg: AR+sD13C5fWeAjVYjOmzguLeGhSKqPK8zgd+K9ZrwhasBx0dhxHP0oDomyXEFOmgnJ4
	LavE/0tTKABPlAlyC1G3oc9oGO6NNkYsfxK4q3istAT/u2ssu6z/cssZqgDi+T+cTxrOX2rzy4e
	l0sqBW9TOtNOMDDXKTnS76YMYx1psqhO3vVT+rXyF87iKYXfeql0wsUk9QHvxrBbtetot2BVCL1
	bSnVU0jitJhvkhFA+3QeNcdhMsT+zW2yQaxbP891uNPY5AqF84gDuyPtW6x/ibaYwFxAKwlaDyg
	ZE6drxoN6q0vop5dK10M/MJuW05wjHbzaNwSREr/py9Kq1FEnDofDIeW4b95Dd36+I+HNRSuKgb
	TrjEkkd7Fm3y+Hl4PfNwSSh9JURN0qXGopE/m/xXALg99XGur
X-Received: by 2002:a05:620a:2614:b0:932:deb4:7788 with SMTP id af79cd13be357-93648fc7072mr3082413185a.2.1786153079361;
        Fri, 07 Aug 2026 18:37:59 -0700 (PDT)
X-Received: by 2002:a05:620a:2614:b0:932:deb4:7788 with SMTP id af79cd13be357-93648fc7072mr3082409385a.2.1786153078802;
        Fri, 07 Aug 2026 18:37:58 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e07b6basm274045485a.11.2026.08.07.18.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 18:37:58 -0700 (PDT)
Message-ID: <25a53d68-e1ab-4262-9ee4-36dac5980fa0@redhat.com>
Date: Fri, 7 Aug 2026 21:37:57 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vdo: add zstd compression support
To: June Park <june@pythonplayer123.dev>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
 <178a5039-1817-4e13-8937-12eee8b26cc6@redhat.com>
 <012e81d2-dd6e-4977-b385-d7ac890be2a2@pythonplayer123.dev>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <012e81d2-dd6e-4977-b385-d7ac890be2a2@pythonplayer123.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 525PTvak7lwJr_6jhVgRONzNzrjraNsKJGU_vPN-ZLM_1786153079
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/27/26 9:43 AM, June Park wrote:
> Hello! Thank you for the thoughtful comments.

Thank you for your patience. This took me longer to get to than I had hoped.

>> I have to ask, what is the motivation for this change? Do you have a workload that shows some kind of improvement from this proposal?
> 
> My initial testing in QEMU, storing files from the kernel source tree, showed noticeable improvements in compression ratio (around 2.4 to 3.5), even though vdo uses small block sizes. However, I did notice that certain types of data (such as long synthetic streams of repeating bytes) showed far less improvement with zstd, at the expense of more CPU cycles. I had concluded that it could outperform LZ4 in some workloads in terms of compression ratio, for more CPU, a trade-off that could be made on a case-by-case basis.

If you have data handy from these experiments, it would be interesting 
to see it. This is the sort of information that would go well in a cover 
letter explaining what you want to do, and why. At any rate, if you have 
cases that seem to benefit from this, we can certainly revisit whether 
this is worth adding.

Another thing to consider is that we originally chose the LZ4 algorithm 
because it is fairly cheap to compute. If you can, it's worth trying to 
quantify what the extra computational load does to vdo throughput, 
especially with fast storage. The throughput for a vdo volume will often 
lag the raw storage speed significantly (due to the deduplication 
machinery) and it's worth knowing if changing the algorithm will make 
that worse.

> The discussion you linked to proposes the ability to swap the algorithm without reformatting. My current implementation tries to reduce breaking changes as much as possible, so I had decided on storing the compression algorithm directly in the volume geometry, instead of for every block. This has the downside of requiring reformatting, but since the focus of vdo is deduplication, I don't think the large amounts of additional machinery needed to support live changes is justified.

I appreciate that you're attempting to minimize disruption. I admit that 
it is simpler, in terms of pure implementation, to make this a 
format-time choice. However, imagine what happen next:  Long-time vdo 
users will inquire whether they can use this new feature, and we will 
have to tell them no. For new users, I think they may not know all the 
data they will store on a volume up front, but they will be locked into 
their first choice. Given the case-by-case variability of the tradeoff, 
I expect users will appreciate being able to change this setting to fit 
their current needs.

In short, doing this as a format-only option looks like implementing 
half a feature to me, and I think we would be better off starting with 
full flexibility. Also remember that every version of this feature that 
we expose to users is a feature we will have to maintain for the 
lifetime of the dm-vdo driver, and I would rather not have to support 
both versions.

(I believe the difference in complexity is also not that large, but 
that's a bit more subjective. Setting the algorithm as a run-time option 
means extending the compressed block format, but adding a format-time 
option involves more work updating the user space tools, including the 
formatter. Both options also require updating the table line and the 
super block format, so there's also considerable overlap.)

So anyway. If you can show there is utility in doing this, we can look 
at adding it. I will probably want to do it by building on what we did 
last year, though. You can look at what I've already done on the branch 
feature/allow-compression-configuration in the vdo-devel project. I 
haven't rebased the branch in a while, but you can get an idea of how I 
was planning the table line and super block changes, at least.

> June
> 

Matt

