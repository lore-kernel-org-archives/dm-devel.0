Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345982882B4
	for <dm-devel@lists.linux.dev>; Tue, 19 May 2026 23:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779232518; cv=none; b=cq+xsJCj0xEQDzPpiy68kT5Sz9ZuUd+n6b7tK0PZZAp78LQ70X8/21nzu9XytliMXdC4QJYY9Cd1rv1ar3GzdaounaSNrguWi5VwgI07cw9VMoNWKeBiOTGqXV5E8lMCRDh53C2A3mNkLlmeatsfrPjtVh/OsOxVxWC0eA6Sd9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779232518; c=relaxed/simple;
	bh=lHDb2wCVccf4bMdzNh2Rk4e/R44omaI3P5HbRgBPcAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STBNkFIFSvcA8MTi7wXYmQvlm9BwjqA+EdqRB46vnv1F7NmcgFH/JDCEVmc9f5lVGokH1H1kpVpMdMZc6XsBZwnUVSocZdqj0rrkjhLqz/L2JVmho5Qz0RHJpw4bhY9hjCYVvyaZA3eO3XC/eoRnIy9JGajQfQZPJTYkViXZX/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj4KldkA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj4KldkA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779232515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rH7Rm/MFTCSCauaDmPiyviKdVdO8hos6+4Wjad+hNUA=;
	b=Gj4KldkAtk5UX77voTCUJE86KFER7aQOlI5KhT7X/EPRsb16ZTiqWmyZZ/4M+EKaPdyVSz
	LxC44mV2mrS7EzLw7fzw5g9aEtvZ4NCD6H8J266VoxoUtas7Rt1tCww97az7wvQChROdgb
	PTuz4WskyOSl7W9IXJQC42Oml7uqlJc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-fQQ9LcdZM2S8gYUYAYULEQ-1; Tue, 19 May 2026 19:15:13 -0400
X-MC-Unique: fQQ9LcdZM2S8gYUYAYULEQ-1
X-Mimecast-MFC-AGG-ID: fQQ9LcdZM2S8gYUYAYULEQ_1779232513
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-913fcc4c164so946730685a.1
        for <dm-devel@lists.linux.dev>; Tue, 19 May 2026 16:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779232513; x=1779837313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rH7Rm/MFTCSCauaDmPiyviKdVdO8hos6+4Wjad+hNUA=;
        b=NHS6dzl7HLDKtsHH9QnGI1HZAbUgNw8enTLJIELy2SDmDmIqi2slbGVkDZQTMJSdN5
         5oB74dV8o9KDqbMv+rpYbpt3zeB6Bwfv8Qt7hw94tYt5CfbBZApu/07uvBNtYmUNpWwj
         mvbmdcp6p5Ht/bdBTdmEeR6MmBrF0bLbfLZOYJhdYHrnUEzzX0ubJZ4K+K24QyPAqDTi
         ZNWy74OAbb2lBCSYmWKAxBf3lzL3wX0XmNImRxMgIF+RonnTgt/xGlwHGf1SD8czZ/xp
         GzgVI3MSOJ4skDiiaTUU/E6fzso8VQEVcdAVhDYcFhPMZeHttC1EOaT2LArpSmu/3WMe
         VFaQ==
X-Gm-Message-State: AOJu0Yx3kvkApoqYtAqkyYDGxPj9DuWf7DMZnP62HJVjj8owrCg3uwEw
	3Du21CFkTEWufxvv5LtS7tlpxUNAVy7PIC2bO/XLuC9PG7wWT2o1jvbmY208kuOijgXzctGEvjg
	5XNGJnPHpJslJCHCBwyNF1kdze2dHJAZk8U6Sl2JIAerHq3CiuF0sKtScL7SI
X-Gm-Gg: Acq92OFWHF5BORilHvztZitEaq5qthNs+Gdr8MxQlJrxyik3Gh7NIyvSB5UvszGpwlf
	0iPG/lsrxevwMo5Ze3iSuUm2urF2RhSyUAv7YTun2AppiQ2fONX853XmChnersDS5ck26VDAWGk
	myKt18W5cHYtKOw38yPq8dNX9EaKq6VKTSbISF4PFTSZZPDv9FSNMmSTC3b0tj43Ct73K69iNEt
	qa8kMrGZPWgoPXiwCDmrkDMVPyl4yJ3lIgRGclZrWlfIQAp4KWZMOJH4ehTIDfVyPLirsFSfBqz
	X4aaMx06h/lUp1/GKb/8AbVX9WNKXUN1ZJbXePhffblv98hlt2MsRP7h5pqFCM1SG5D1VamMWkL
	b2ViXDZ7vnus+qHpinx9YvVcHZ8yFd5dhf6kSEF2exDV8iku12O2uOuTGLiVemZ1ByEpNOkQ9ts
	LQWwF/
X-Received: by 2002:a05:620a:698a:b0:8cd:8884:2509 with SMTP id af79cd13be357-911cf2f0e0cmr3317756085a.55.1779232512572;
        Tue, 19 May 2026 16:15:12 -0700 (PDT)
X-Received: by 2002:a05:620a:698a:b0:8cd:8884:2509 with SMTP id af79cd13be357-911cf2f0e0cmr3317747985a.55.1779232512071;
        Tue, 19 May 2026 16:15:12 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba9454basm2007293485a.12.2026.05.19.16.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 16:15:11 -0700 (PDT)
Message-ID: <f46045af-5705-4c5e-98e8-80b8c2c5387e@redhat.com>
Date: Tue, 19 May 2026 19:15:11 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-vdo: iterator after loop end in mark_slab_journal_dirty?
To: Maoyi Xie <maoyixie.tju@gmail.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260519094132.1964544-1-maoyixie.tju@gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260519094132.1964544-1-maoyixie.tju@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z0jUm_LssuFkfO_U100ZetDO9ZJmr6gRNzC8L6mKBF0_1779232513
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/19/26 5:41 AM, Maoyi Xie wrote:
> Hi all,
> 
> While reading drivers/md/dm-vdo/slab-depot.c I noticed
> something that looks like a past the end iterator pattern.
> I would appreciate it if you could take a look and let me
> know whether this is a real issue, and whether it is worth
> fixing.
> 
> The site is mark_slab_journal_dirty() (linux-7.1-rc1, around
> line 156):
> 
>      list_for_each_entry_reverse(dirty_journal, dirty_list,
>                                  dirty_entry) {
>              if (dirty_journal->recovery_lock <=
>                  journal->recovery_lock)
>                      break;
>      }
> 
>      list_move_tail(&journal->dirty_entry,
>                     dirty_journal->dirty_entry.next);
> 
> When the loop walks all entries without break (the new
> journal's recovery_lock is smaller than every existing
> entry), dirty_journal is past the end.
> dirty_journal->dirty_entry then aliases dirty_list (the
> list head) via container_of offset cancellation. So
> dirty_journal->dirty_entry.next is head->next, the first
> real entry. list_move_tail then inserts journal just
> before the first entry, i.e. at the front of the list.
> That is the intended behaviour for a sorted insertion
> where the new entry has the smallest recovery_lock. The
> dereference of the past the end iterator is undefined per
> C11.

I don't quite follow your train of thought here. Which dereference do 
you think produces undefined behavior, and why? Everything you describe 
sounds valid.

> Jakob Koschel cleaned up many such sites in 2022, for
> example commits 99d8ae4ec8a (tracing: Remove usage of list
> iterator variable after the loop), 2966a9918df (clockevents:
> Use dedicated list iterator variable) and dc1acd5c946 (dlm:
> replace usage of found with dedicated list iterator
> variable). This site was not covered.

Jakob's series did not address this driver, because this driver was 
added to the Linux kernel after 2022.

I think I understand your point that the code really shouldn't use 
dirty_journal outside the loop, since it doesn't point to a valid struct 
slab_journal object. I certainly wouldn't mind a patch to clean this up 
a bit (perhaps by doing the list insertion inside the loop when 
possible). But as a practical matter it doesn't seem to matter all that 
much, since this function is only manipulating the list heads.

If you do decide to patch this, it would be nice to clean up the list 
insertion, too. It's more indirect than it needs to be.

> A candidate fix would track an explicit insertion target.
> Declare `struct list_head *insert_after = dirty_list` before
> the loop. Overwrite it to `&dirty_journal->dirty_entry` only
> when the loop breaks early. The final list_move_tail then
> reads `insert_after->next`. On break that points to the
> entry right after the insertion position. On fall-through
> it points to `head->next`, the first real entry. The
> behaviour is unchanged in all cases, including an empty
> list and a list with one entry.

Please don't fix it like this, this would just makes the code messier.

Matt

> If this is intentional or already known, please disregard.
> Otherwise, I am happy to send a [PATCH] or to leave the fix
> to you. Thank you for your time, and sorry for the noise if
> this is not actually worth fixing or has already been
> spotted.
> 
> Thanks,
> Maoyi Xie
> https://maoyixie.com/
> 

