Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1911648781
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707760410; cv=none; b=A686dpZiMqeSsf5F5ISc6mn/5BPKeWeL9kqVGvjYkMoI+Mwl9d5C9hpmDq2xl+E9LF7oVACuGZp4wF9cu8SFkZmT/tAIzvR7BCth3+MJLT1triYUPhiYC6XTP/dmu4S71Zw9upFtXczRJQQi5fsSO1TMJ8Bhc4AR/J2ZWQNwkSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707760410; c=relaxed/simple;
	bh=AMTr9pS0tNJvl7fzeDT02NEL1K06Knmv3LsyOhyFsNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTIl+JW+8wLcG/BMJv21xP7BLkLarsduCbez1cwHvpXNAZ5hJ+9YayPYzllsJJFOla7b8aVimRuGsisuzqkaoKwh6wbO4tOm3s0Zew/ZELP5REvWKwvsHHNB/wx/GMArEAFm9jJabCd47Ea+xhwZ6kprTXpbrxl6QJ6A6JSu+Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hJ/Aqpsi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJ/Aqpsi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707760408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yiv5I81n3aA2CE+1zcBFyv3q0KMz1DyI8RGpVHGY6IQ=;
	b=hJ/Aqpsi2pWXOz/r0+gKSuUWzwEd3H5qslHEPcsv0lY/eery05IY10pCiaYPvsgH1E/TpN
	RTgQlGOReZga5jQXSmWWm02G9s5fhjG5vW0O/0IVfUfNNapBwPhAbU5uQE0NQACI4PLEag
	bD2cotPl9K/ZK3DDHNVPz8LMRFhn9Ow=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-L-NphksGO8apeH83o8_PPA-1; Mon, 12 Feb 2024 12:53:26 -0500
X-MC-Unique: L-NphksGO8apeH83o8_PPA-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4c046088b54so30401e0c.3
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 09:53:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707760406; x=1708365206;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiv5I81n3aA2CE+1zcBFyv3q0KMz1DyI8RGpVHGY6IQ=;
        b=vDT6xIqQQ6OEgezxt8CtaoRWOCssgu6zycN3XJ7JUjVGUIVmin2wZCzMHKtRh96wCF
         xq0xa1DD2hXyPplZVR72rWZwYx45QNuhOUxpoRe2e8735EbDUZ5gFNPShaopjY2CNGQK
         h4BbrV4o+BPHGiHWYF9pLRuYvrPVG7lx/wAAz+QTIgK7hJEkYKNMXftWa/Qomk/ScVk/
         6cz5sARnlBGUyElYAUIQo8+KRt5ka8Wny4/YM+7xzo8LffRMhlcFDWRw9abScz88Rt/i
         QSUf6j6f5lAf7+XBkMfu1+TkbQR3AdG0aIk9QB8gYe/iXf7TyHTFUjpixEJEJsyUbugd
         I0GQ==
X-Gm-Message-State: AOJu0YxyMoeD806dZh5DwY5vw53OUVszScQOVqL3jxoFL8HWzFd75Wgq
	HWyr02dUn9aznlkM7W4aIrf0GKtM5REbsxv7o7LPiv4glFe2g/nxV8TPCzLJOiI280lQm7mC4ik
	3sBoAgIk733aM26SQdQna3EX/4tVMZEzEt8XKn1LCV79ExaGTXYg9FwrlstMtrePw
X-Received: by 2002:a1f:e684:0:b0:4c0:1dae:c6a1 with SMTP id d126-20020a1fe684000000b004c01daec6a1mr3543964vkh.14.1707760405977;
        Mon, 12 Feb 2024 09:53:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbxLBEIIzQaDHGiy6LaqdPyIQ8N/xWoSEMxyHEHWwjRQtqEvmT8DOjBOuBxclSCDVcrJ4gvA==
X-Received: by 2002:a1f:e684:0:b0:4c0:1dae:c6a1 with SMTP id d126-20020a1fe684000000b004c01daec6a1mr3543955vkh.14.1707760405679;
        Mon, 12 Feb 2024 09:53:25 -0800 (PST)
Received: from [192.168.1.158] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id s15-20020ad4500f000000b0068c776b01fdsm372534qvo.65.2024.02.12.09.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 09:53:25 -0800 (PST)
Message-ID: <d6bfb932-84aa-53ed-bad3-f05a7292d476@redhat.com>
Date: Mon, 12 Feb 2024 12:53:24 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [bug report] dm vdo: add statistics reporting
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dm-devel@lists.linux.dev
References: <f7f19be8-4a86-415d-a995-22d030d35e93@moroto.mountain>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <f7f19be8-4a86-415d-a995-22d030d35e93@moroto.mountain>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dan,

Thanks for this report (and the others). It looks like we may have 
changed our minds about how to do this formatting at some point but 
never cleaned it up. I'll put this on the list of things to improve.

Thanks,
matt

On 2/9/24 08:05, Dan Carpenter wrote:
> Hello Matthew Sakai,
> 
> The patch 25479d97b12c: "dm vdo: add statistics reporting" from Nov
> 16, 2023 (linux-next), leads to the following (unpublished) Smatch
> static checker warning:
> 
> drivers/md/dm-vdo/funnel-workqueue.c:545 vdo_dump_completion_to_buffer() warn: why check scnprintf return value?
> drivers/md/dm-vdo/message-stats.c:26 write_u64() warn: why check scnprintf return value?
> drivers/md/dm-vdo/message-stats.c:43 write_u32() warn: why check scnprintf return value?
> drivers/md/dm-vdo/message-stats.c:60 write_block_count_t() warn: why check scnprintf return value?
> drivers/md/dm-vdo/message-stats.c:77 write_string() warn: why check scnprintf return value?
> drivers/md/dm-vdo/message-stats.c:94 write_bool() warn: why check scnprintf return value?
> drivers/md/dm-vdo/message-stats.c:111 write_u8() warn: why check scnprintf return value?
> 
> drivers/md/dm-vdo/message-stats.c
>      99 static int write_u8(char *prefix,
>      100                     u8 value,
>      101                     char *suffix,
>      102                     char **buf,
>      103                     unsigned int *maxlen)
>      104 {
>      105         int count = scnprintf(*buf, *maxlen, "%s%u%s",
>      106                               prefix == NULL ? "" : prefix,
>      107                               value,
>      108                               suffix == NULL ? "" : suffix);
>      109         *buf += count;
>      110         *maxlen -= count;
> --> 111         if (count >= *maxlen)
>                      ^^^^^^^^^^^^^^^^
> snprintf() returns the number of bytes that would have been printed if
> we had enough space and scnprintf() returns the number of bytes that
> were printed.  (Both functions exclude the NUL terminator from the
> returned count).
> 
> It seldom makes sense to check the return from scnprintf().  In this
> case count can never be >= *maxlen.  The most it can be is *maxlen - 1.
> 
>      112                 return VDO_UNEXPECTED_EOF;
>      113         return VDO_SUCCESS;
>      114 }
> 
> The code in vdo_dump_completion_to_buffer() is almost basically correct.
> It's just off by one in a totally harmless way and I wouldn't have
> reported it if not for these other impossible conditions.
> 
> drivers/md/dm-vdo/funnel-workqueue.c
>     538  void vdo_dump_completion_to_buffer(struct vdo_completion *completion, char *buffer,
>     539                                     size_t length)
>     540  {
>     541          size_t current_length =
>     542                  scnprintf(buffer, length, "%.*s/", TASK_COMM_LEN,
>     543                            (completion->my_queue == NULL ? "-" : completion->my_queue->name));
>     544
>     545          if (current_length < length - 1) {
> 
> The highest valid return is current_length == length - 1 but that's
> treated as invalid.  If we changed to snprintf() then we could fix the
> condition to allow the final character:
> 
> 	current_length = snprintf(...);
> 	if (current_length <= length - 1) {
>                            ^^^^
> 
>     546                  get_function_name((void *) completion->callback, buffer + current_length,
>     547                                    length - current_length);
>     548          }
>     549  }
> 
> regards,
> dan carpenter
> 

