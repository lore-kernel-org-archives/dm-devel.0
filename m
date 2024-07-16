Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C09913E40F
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721172893; cv=none; b=h4tsqhPPkfG47qjlSsmghv0yzKcQw/48CeOhqbWjWEX24nqofSgSATVuSvVGvfXiI5noFWT1bVzaRWWo9TCCZ0m0s9okrfFVBFxgaBDaPvUmB1YFW8CPgvEYWDGms4irCrUNEq4j/iisp0sBUrVfQXOuj3/9s5WD01frVSG2rLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721172893; c=relaxed/simple;
	bh=3nB1boiG1A2kWJMubHu7Tj7tDnrXQiEKyO2QJfNF6Us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u2VVsxEUzPVdMo7waYVxPuyjrki0VZyfB9zJGy93iphgScd089+XbeEMiAFMdN44en1xkiTl78WXZ5CEVg9edupkk5kC4kA6zMMHUvU6Yb7ltwQONe5cy5wwkI91Riz10PBPMBLminNj8AOShmaSKJHCmebwdhT1wNOoL5tnXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDe4c2x2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDe4c2x2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721172890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ce3oiwNi7t9StCHmh3dnbHVqDD34QccC4Vb0kWTpmbU=;
	b=jDe4c2x2jFqsONSHQJ+KJxqn+U884hATLye4nNDrBrAGWt0PRbv+KpIDCxVNPNLEJ4C3mJ
	T5oKlzh/Ak6k2yYpWO0t/sbyNnh9Xv/DDY/9zJf6pEVYf4Xhaa8GebOdewmfH0kf4OCbwy
	N8VkFGWf+EtEATpgXgOViRa6o2SSLsw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-SR8qvGASPxSIhWxVAtuTew-1; Tue, 16 Jul 2024 19:34:48 -0400
X-MC-Unique: SR8qvGASPxSIhWxVAtuTew-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79f0e024ae2so697482585a.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 16:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721172888; x=1721777688;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce3oiwNi7t9StCHmh3dnbHVqDD34QccC4Vb0kWTpmbU=;
        b=VZgLa55+mtT5z1DWzf/KuRMS9cX0nzfja1yViQpirjNuy5M8QDcJ9temcSdCFka0RJ
         jQmkKTyD4BTieavfDAJ2gmSYLsPIJx4EM0y5k68MABoXZ/Bn6jrRiTfHML0y/7B4v0K5
         Jk+iFA9dihJVu+PmW8Fmc//Lxf6+4x0Yoh5ILeswRP7Vmzk9SDfdskKy9OkSYGymaNl8
         uo2Owp9ZylgmER7zDUo4CPYiaVUebInZZqTS5yD0j4oNUZh+G+k0CF9VTfF2BtNYGqiL
         pKmjqX1g8J9pyYqoQm1EL99xYAn+itweErZoWAa9Lv8ko+vtZ6UqxqnXJpovgmsSoTjZ
         pNCA==
X-Gm-Message-State: AOJu0YxFyabr5mB5eqgMo/SO1ruFRCXxXOdyGMAeNgfBFteZ/na1bKx0
	2bnLqFmVBO06o13kL2FAghd5Rl5TeuGytjOWg3f0cBUQx24B22a62DEHlsOVLOf5z5ZJKdnZiP2
	pwzT+iG/ZriAbkDCjhcAdvXweyMFTz7B8POL7zeAZseDQyXNj5Xqb5xXE
X-Received: by 2002:a05:620a:1a28:b0:79e:ff0a:a10d with SMTP id af79cd13be357-7a17b691168mr414899885a.39.1721172887762;
        Tue, 16 Jul 2024 16:34:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvak+ZP8NES87xHiJsRxARxOOUUOyrZ6LQUGOqOsy5UAFu/hUczgJ91LesooxankFVUPn2og==
X-Received: by 2002:a05:620a:1a28:b0:79e:ff0a:a10d with SMTP id af79cd13be357-7a17b691168mr414898485a.39.1721172887351;
        Tue, 16 Jul 2024 16:34:47 -0700 (PDT)
Received: from [192.168.1.152] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a160ba82cdsm338674385a.4.2024.07.16.16.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 16:34:46 -0700 (PDT)
Message-ID: <2d0a578d-aa8e-be21-f80f-3ba6c62be1f5@redhat.com>
Date: Tue, 16 Jul 2024 19:34:45 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH -next] dm: vdo: Add missing kernel-doc function comments.
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20240712081204.79723-1-yang.lee@linux.alibaba.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240712081204.79723-1-yang.lee@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/12/24 04:12, Yang Li wrote:
> Add missing kernel-doc function comments to enhance code readability and
> maintainability in accordance with the kernel coding standards.

I've prepared a patch to add correct documentation which will I will 
send out soon.

Matt Sakai

> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9518
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   drivers/md/dm-vdo/repair.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> index ff09e4a14333..8947e6092a91 100644
> --- a/drivers/md/dm-vdo/repair.c
> +++ b/drivers/md/dm-vdo/repair.c
> @@ -319,6 +319,7 @@ static bool __must_check abort_on_error(int result, struct repair_completion *re
>   /**
>    * drain_slab_depot() - Flush out all dirty refcounts blocks now that they have been rebuilt or
>    *                      recovered.
> + * @completion: The completion to convert.
>    */
>   static void drain_slab_depot(struct vdo_completion *completion)
>   {
> @@ -656,6 +657,7 @@ static void rebuild_reference_counts(struct vdo_completion *completion)
>   
>   /**
>    * increment_recovery_point() - Move the given recovery point forward by one entry.
> + * @point: The location of the next recovery journal entry to apply.
>    */
>   static void increment_recovery_point(struct recovery_point *point)
>   {
> @@ -953,6 +955,7 @@ static void abort_block_map_recovery(struct repair_completion *repair, int resul
>   /**
>    * find_entry_starting_next_page() - Find the first journal entry after a given entry which is not
>    *                                   on the same block map page.
> + * @repair: The repair completion.
>    * @current_entry: The entry to search from.
>    * @needs_sort: Whether sorting is needed to proceed.
>    *
> @@ -1219,6 +1222,7 @@ static bool __must_check is_exact_recovery_journal_block(const struct recovery_j
>   
>   /**
>    * find_recovery_journal_head_and_tail() - Find the tail and head of the journal.
> + * @repair: The repair completion.
>    *
>    * Return: True if there were valid journal blocks.
>    */
> @@ -1447,6 +1451,7 @@ static int validate_heads(struct repair_completion *repair)
>   
>   /**
>    * extract_new_mappings() - Find all valid new mappings to be applied to the block map.
> + * @repair: The repair completion.
>    *
>    * The mappings are extracted from the journal and stored in a sortable array so that all of the
>    * mappings to be applied to a given block map page can be done in a single page fetch.
> @@ -1501,6 +1506,7 @@ static int extract_new_mappings(struct repair_completion *repair)
>   /**
>    * compute_usages() - Compute the lbns in use and block map data blocks counts from the tail of
>    *                    the journal.
> + * @repair: The repair completion.
>    */
>   static noinline int compute_usages(struct repair_completion *repair)
>   {

