Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E49E1DFD2
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 13:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDhZwbK0"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-9c53e8b7cf4so148238666b.1
        for <dm-devel@lists.linux.dev>; Thu, 09 Nov 2023 05:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699537733; x=1700142533; darn=lists.linux.dev;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghat72vdrQFnEjXwocXdY/0imJRu6o97KQo7WO3Sfi0=;
        b=jDhZwbK0rjlJGn5FHYLEfi0Nn/Y7KTcxGL8qixc5McIReO712tF8CswNkUjDBiOCL9
         2B9XG78FfpcbexH1PMmLKi6v4d+DQ9Wgudb+AqdqzqgSiocusiw3EXqDdCdlxfEDP5kQ
         ji1Yqm6SDWDPrUsbL5HPg9+cgEGJcewiS1UrpKi4n7rZqK2aUl96ESb7SYgu98UIqlzH
         98zBQTRLmIjJtPcGDn8TcQJHhvwbgvb/aD36t/UfnV+vShN1pvuSwZ5oCvTeO1vNsEyA
         eKA1MIiQgdv7xOSTa4QAvOcBqEdRGJEe4ue/XbQvJ1fXJF45L0xNDV1SCYsJ6+908dx3
         OYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699537733; x=1700142533;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ghat72vdrQFnEjXwocXdY/0imJRu6o97KQo7WO3Sfi0=;
        b=XU8ytdW87vniRM8QjXONDLFDP6f47lAYRpO58Dtt2UOScwg+OApTYyXPUf6y6zrjND
         I5Sj8cak6lMbhaOx03KVLu+9cQIZKByhOg/zZwNAm5ooAbmO2iJLyiA9VPhiLw2JOVKc
         KNOgJQVw0Uo5aZ7Pb70gmByINQuEjxX5BaT/UjxHQNvD16q234KAWkmZ4OfYAazT6C5v
         imGMAnfERJNbqCHk5ZsZ1VT5BbXM11PXivvpT1KCFicmuIEagCORV6vLOnRCSRovJUVa
         ULIZQATVYtG+ICpPJXcOSse75vnzPhR56rBNsLkaTTIBCoGvo7Qqdjvn2F6uUuQCOOro
         1yLg==
X-Gm-Message-State: AOJu0YxoLQjH3+ztvR7Y+c1aKvpsgPPKy01XEiTKM0XfD9swi3k/BoN7
	+3wlLBuGMNYnZou45CfWjifxC7btqxA=
X-Google-Smtp-Source: AGHT+IGMj26uddgefCjbTnYshrjXsyFPDJgmQGPbmhe3ttTU6WugUP95lxzkBAZxKghopJLby4jlhg==
X-Received: by 2002:a17:907:2da9:b0:9da:ef1a:958c with SMTP id gt41-20020a1709072da900b009daef1a958cmr4238272ejc.40.1699537732472;
        Thu, 09 Nov 2023 05:48:52 -0800 (PST)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id f4-20020a170906c08400b0098ce63e36e9sm2615798ejz.16.2023.11.09.05.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 05:48:51 -0800 (PST)
Message-ID: <fa17b8d8-2d84-45c8-ac6a-1876f1f55a52@gmail.com>
Date: Thu, 9 Nov 2023 14:48:51 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Subject: Crash in dm-verity/bufio if use with tasklets
Autocrypt: addr=gmazyland@gmail.com; keydata=
 xsFNBE94p38BEADZRET8y1gVxlfDk44/XwBbFjC7eM6EanyCuivUPMmPwYDo9qRey0JdOGhW
 hAZeutGGxsKliozmeTL25Z6wWICu2oeY+ZfbgJQYHFeQ01NVwoYy57hhytZw/6IMLFRcIaWS
 Hd7oNdneQg6mVJcGdA/BOX68uo3RKSHj6Q8GoQ54F/NpCotzVcP1ORpVJ5ptyG0x6OZm5Esn
 61pKE979wcHsz7EzcDYl+3MS63gZm+O3D1u80bUMmBUlxyEiC5jo5ksTFheA8m/5CAPQtxzY
 vgezYlLLS3nkxaq2ERK5DhvMv0NktXSutfWQsOI5WLjG7UWStwAnO2W+CVZLcnZV0K6OKDaF
 bCj4ovg5HV0FyQZknN2O5QbxesNlNWkMOJAnnX6c/zowO7jq8GCpa3oJl3xxmwFbCZtH4z3f
 EVw0wAFc2JlnufR4dhaax9fhNoUJ4OSVTi9zqstxhEyywkazakEvAYwOlC5+1FKoc9UIvApA
 GvgcTJGTOp7MuHptHGwWvGZEaJqcsqoy7rsYPxtDQ7bJuJJblzGIUxWAl8qsUsF8M4ISxBkf
 fcUYiR0wh1luUhXFo2rRTKT+Ic/nJDE66Ee4Ecn9+BPlNODhlEG1vk62rhiYSnyzy5MAUhUl
 stDxuEjYK+NGd2aYH0VANZalqlUZFTEdOdA6NYROxkYZVsVtXQARAQABzSBNaWxhbiBCcm96
 IDxnbWF6eWxhbmRAZ21haWwuY29tPsLBlQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwEC
 HgECF4AWIQQqKRgkP95GZI0GhvnZsFd72T6Y/AUCYaUUZgUJJPhv5wAKCRDZsFd72T6Y/D5N
 D/438pkYd5NyycQ2Gu8YAjF57Od2GfeiftCDBOMXzh1XxIx7gLosLHvzCZ0SaRYPVF/Nr/X9
 sreJVrMkwd1ILNdCQB1rLBhhKzwYFztmOYvdCG9LRrBVJPgtaYqO/0493CzXwQ7FfkEc4OVB
 uhBs4YwFu+kmhh0NngcP4jaaaIziHw/rQ9vLiAi28p1WeVTzOjtBt8QisTidS2VkZ+/iAgqB
 9zz2UPkE1UXBAPU4iEsGCVXGWRz99IULsTNjP4K3p8ZpdZ6ovy7X6EN3lYhbpmXYLzZ3RXst
 PEojSvqpkSQsjUksR5VBE0GnaY4B8ZlM3Ng2o7vcxbToQOsOkbVGn+59rpBKgiRadRFuT+2D
 x80VrwWBccaph+VOfll9/4FVv+SBQ1wSPOUHl11TWVpdMFKtQgA5/HHldVqrcEssWJb9/tew
 9pqxTDn6RHV/pfzKCspiiLVkI66BF802cpyboLBBSvcDuLHbOBHrpC+IXCZ7mgkCrgMlZMql
 wFWBjAu8Zlc5tQJPgE9eeQAQrfZRcLgux88PtxhVihA1OsMNoqYapgMzMTubLUMYCCsjrHZe
 nzw5uTcjig0RHz9ilMJlvVbhwVVLmmmf4p/R37QYaqm1RycLpvkUZUzSz2NCyTcZp9nM6ooR
 GhpDQWmUdH1Jz9T6E9//KIhI6xt4//P15ZfiIs7BTQRPeKd/ARAA3oR1fJ/D3GvnoInVqydD
 U9LGnMQaVSwQe+fjBy5/ILwo3pUZSVHdaKeVoa84gLO9g6JLToTo+ooMSBtsCkGHb//oiGTU
 7KdLTLiFh6kmL6my11eiK53o1BI1CVwWMJ8jxbMBPet6exUubBzceBFbmqq3lVz4RZ2D1zKV
 njxB0/KjdbI53anIv7Ko1k+MwaKMTzO/O6vBmI71oGQkKO6WpcyzVjLIip9PEpDUYJRCrhKg
 hBeMPwe+AntP9Om4N/3AWF6icarGImnFvTYswR2Q+C6AoiAbqI4WmXOuzJLKiImwZrSYnSfQ
 7qtdDGXWYr/N1+C+bgI8O6NuAg2cjFHE96xwJVhyaMzyROUZgm4qngaBvBvCQIhKzit61oBe
 I/drZ/d5JolzlKdZZrcmofmiCQRa+57OM3Fbl8ykFazN1ASyCex2UrftX5oHmhaeeRlGVaTV
 iEbAvU4PP4RnNKwaWQivsFhqQrfFFhvFV9CRSvsR6qu5eiFI6c8CjB49gBcKKAJ9a8gkyWs8
 sg4PYY7L15XdRn8kOf/tg98UCM1vSBV2moEJA0f98/Z48LQXNb7dgvVRtH6owARspsV6nJyD
 vktsLTyMW5BW9q4NC1rgQC8GQXjrQ+iyQLNwy5ESe2MzGKkHogxKg4Pvi1wZh9Snr+RyB0Rq
 rIrzbXhyi47+7wcAEQEAAcLBfAQYAQgAJgIbDBYhBCopGCQ/3kZkjQaG+dmwV3vZPpj8BQJh
 pRSXBQkk+HAYAAoJENmwV3vZPpj8BPMP/iZV+XROOhs/MsKd7ngQeFgETkmt8YVhb2Rg3Vgp
 AQe9cn6aw9jk3CnB0ecNBdoyyt33t3vGNau6iCwlRfaTdXg9qtIyctuCQSewY2YMk5AS8Mmb
 XoGvjH1Z/irrVsoSz+N7HFPKIlAy8D/aRwS1CHm9saPQiGoeR/zThciVYncRG/U9J6sV8XH9
 OEPnQQR4w/V1bYI9Sk+suGcSFN7pMRMsSslOma429A3bEbZ7Ikt9WTJnUY9XfL5ZqQnjLeRl
 8243OTfuHSth26upjZIQ2esccZMYpQg0/MOlHvuFuFu6MFL/gZDNzH8jAcBrNd/6ABKsecYT
 nBInKH2TONc0kC65oAhrSSBNLudTuPHce/YBCsUCAEMwgJTybdpMQh9NkS68WxQtXxU6neoQ
 U7kEJGGFsc7/yXiQXuVvJUkK/Xs04X6j0l1f/6KLoNQ9ep/2In596B0BcvvaKv7gdDt1Trgg
 vlB+GpT+iFRLvhCBe5kAERREfRfmWJq1bHod/ulrp/VLGAaZlOBTgsCzufWF5SOLbZkmV2b5
 xy2F/AU3oQUZncCvFMTWpBC+gO/o3kZCyyGCaQdQe4jS/FUJqR1suVwNMzcOJOP/LMQwujE/
 Ch7XLM35VICo9qqhih4OvLHUAWzC5dNSipL+rSGHvWBdfXDhbezJIl6sp7/1rJfS8qPs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

there is a kernel crash during when running our cryptsetup testsuite
if using veritysetup with  --use-tasklets option (try_verify_in_tasklet table option).

With
  # veritysetup format /dev/sdb /dev/sdc
  # veritysetup open /dev/sdb test /dev/sdc --use-tasklets <root_hash>

it generates BUG below, bisect point to

450e8dee51aa6fa1dd0f64073e88235f1a77b035 is the first bad commit
commit 450e8dee51aa6fa1dd0f64073e88235f1a77b035
Author: Joe Thornber <ejt@redhat.com>
Date:   Fri Mar 10 16:02:29 2023 +0000

     dm bufio: improve concurrent IO performance

So, it is broken since kernel 6.4 ... !

(I wonder why we added dm-verity tasklet option when nobody apparently use it...)

: =============================
: [ BUG: Invalid wait context ]
: 6.6.0+ #170 Not tainted
: -----------------------------
: ksoftirqd/2/25 is trying to lock:
: ffff88810f57c6f8 (&bc->trees[i].lock){.+.+}-{3:3}, at: cache_get+0x46/0xc0 [dm_bufio]
: other info that might help us debug this:
: context-{2:2}
: no locks held by ksoftirqd/2/25.
: stack backtrace:
: CPU: 2 PID: 25 Comm: ksoftirqd/2 Not tainted 6.6.0+ #170
: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
: Call Trace:
:  <TASK>
:  dump_stack_lvl+0x5c/0xc0
:  dump_stack+0x10/0x20
:  __lock_acquire+0xa3f/0x2800
:  lock_acquire+0xd8/0x2d0
:  ? cache_get+0x46/0xc0 [dm_bufio]
:  ? __this_cpu_preempt_check+0x13/0x20
:  down_read+0x30/0x270
:  ? cache_get+0x46/0xc0 [dm_bufio]
:  cache_get+0x46/0xc0 [dm_bufio]
:  new_read+0x53/0x1d0 [dm_bufio]
:  dm_bufio_get+0x11/0x20 [dm_bufio]
:  verity_verify_level+0x17d/0x230 [dm_verity]
:  verity_hash_for_block+0x37/0xe0 [dm_verity]
:  verity_verify_io+0x124/0x5d0 [dm_verity]
:  ? find_held_lock+0x31/0x80
:  ? __this_cpu_preempt_check+0x13/0x20
:  ? percpu_ref_put_many.constprop.0+0x6a/0x110
:  ? blk_queue_exit+0xd/0x10
:  ? __blk_mq_free_request+0x65/0xc0
:  ? tasklet_action_common.isra.0+0x34/0x250
:  verity_tasklet+0x11/0x90 [dm_verity]
:  tasklet_action_common.isra.0+0xdf/0x250
:  tasklet_action+0x28/0x30
:  __do_softirq+0xcf/0x459
:  run_ksoftirqd+0x32/0x50
:  smpboot_thread_fn+0x17c/0x220
:  ? sort_range+0x20/0x20
:  kthread+0xfc/0x130
:  ? kthread_complete_and_exit+0x20/0x20
:  ret_from_fork+0x31/0x50
:  ? kthread_complete_and_exit+0x20/0x20
:  ret_from_fork_asm+0x11/0x20
:  </TASK>


Thanks,
Milan
