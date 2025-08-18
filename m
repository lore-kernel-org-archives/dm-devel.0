Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6037530F7F1
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755510755; cv=none; b=rtVz/Py79S+zXbV89+XmVLi81BYjqUxT//Y1Rtw32tPX0qtXbfR7Tw59MUw+yIrt39AIVnIFF4NFzO2lfvCBJqLH1jqNRyDGxbrM6bgrAjV/d5ftNYb4X4A02cNtlYOosn/wZL6Oa7OzBW3T6Hd3pv6KR7yA3i93/XiQ/2nJN8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755510755; c=relaxed/simple;
	bh=NIuzhI0qB598fqspWo6Lzp6IfCtKIx9jjA2e/Kr1n0E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pdFV/E+z/+LFcEi9Ecc0LmqxqkLm9xHZYG0DBOSd5UicQBB0NPunuG++7/hKnnObuEgUNsPVTSg9AjTqtQJjUvc7ZCd6Q/3qltXfOGpbcoElH2zxYOve0mZfW0Ik8gjT2NHa4X13bUVcj3pQey85u82enMMdR+1g+OefC+eU99w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WPE0Pg7T; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WPE0Pg7T"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1ac7c066so21653315e9.1
        for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 02:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755510752; x=1756115552; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kdz8bhHZMTDaQf1RSGf9i9HpyfkqiHMvid5rpBpQiRk=;
        b=WPE0Pg7Twi9saZ6AXNBRN+2phW2GW2QK8PfqCLEbtl2vTQLLp22ZLOD9WlNhIxivjU
         jHanRlMRA+7E0qUEzXh0qoqQQKQLAizqF4Vauv+JoXcQ4SQpekunV+/r6OL3IsfoL6VI
         qe0MJJEl97irR94dqSI00nPrjJTRCJWoK2QT4jr+zPYJgtgc3vYAbooWs9aYj5PuKspH
         rtgRRAhaVRTV2dZ1x4cima81oXmrkb8DF0R115mrjkz3f/uSBTDrfnP6ffw/gcYiDhax
         cQq6aKYkRYdfv14gffazIbzcGNDtaHc8P0nwDqwY1D86hQzgxJKRyg6CSVJnmDz9xDDA
         SMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755510752; x=1756115552;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kdz8bhHZMTDaQf1RSGf9i9HpyfkqiHMvid5rpBpQiRk=;
        b=IzuFMhJ2M/+K+zguWhqxLHxaufSb/UFBnJR0yckMrvpka9BB0HC/BW9UBtNX9O2AK6
         Uc3W4iuWF7GD884UVZS9/n7bRSlMbwm5K1EuLpuP+umf20fbIoQuISTu04UIZ+WDX4To
         K7l//C68gpmmJI32BmrLK7P72JxV6wE0KpZ4QLb5mHcbr9HtOYKzTYC9ot6g+DlkdX9M
         M7XwFix9vJQvCXhIbbcAsmEBvbKtUc/uyXeecY0lXEies4onrl5kprgXgXWaGRs/poUv
         GQKU/iUpk/CZCTM2T/V1JyN8kdEalnf0ALwb4vjB4Hr2EuLrjC5eKXqcreHDYezy26Sz
         HWqQ==
X-Gm-Message-State: AOJu0Yw8V31LgQlzdY0JtT7UTlxgQGHs9+W0hNK8mCFccvZO0FqQKisV
	dVidYFIVqyGh9+oFSorvSeTwwsaiOSaaJMkdK4C+24wUgEjSas2yCW71zuVSBq5sEo4=
X-Gm-Gg: ASbGncsYusa9M8Z6pNAjyvTaYEerT7c68g+lbOkaUXFOiWt7+OVHP8lo8P2brLUSqI9
	y2epexv2FjaEqFY0TvBGrSw8j0SCchyWlcin3wE2Afvm5R97F74K83zR+R/AkEz89nN0fbBL/KB
	XaLbH9HCe/tRZsXpcie47AJchF2amdNaBqJlJuPgc4iVUMQqRIKqYdfdGsZxVchpS9De2kBb+Ly
	jH5cpkhpJkify5etleBnHFRBP2saZxNiVl1oZT8j8XWDcY1qgqROev8DL1z4f91xcXaDeZStxdZ
	JlF/ha0DyIM6XzcW+0V8xSHt76vBbiri0tqPttTKEEDs1MGAUmtlJ5Iw162SNlQ8VnGUl5BmgNR
	gS9nBKVxbrj+R4sI83V6S0xi6Dg4=
X-Google-Smtp-Source: AGHT+IEgnxBbVcc+kK/jLxu9MjgdsRTHx2pWugmkQu+PHqqWwhObmptTOnHRonMx3GbMyli5j2DyXw==
X-Received: by 2002:a05:600c:444d:b0:459:e39e:e5a5 with SMTP id 5b1f17b1804b1-45a22345439mr82499585e9.5.1755510751644;
        Mon, 18 Aug 2025 02:52:31 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3bb93862fe7sm12166133f8f.64.2025.08.18.02.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 02:52:31 -0700 (PDT)
Date: Mon, 18 Aug 2025 12:52:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm-pcache: add persistent cache target in device-mapper
Message-ID: <aKL33O_yChKJ-4_G@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Dongsheng Yang,

Commit 6fb8fbbaf147 ("dm-pcache: add persistent cache target in
device-mapper") from Aug 12, 2025 (linux-next), leads to the
following Smatch static checker warning:

	drivers/md/dm-pcache/cache_req.c:60 cache_data_alloc()
	error: uninitialized symbol 'to_alloc'.

drivers/md/dm-pcache/cache_req.c
    36 static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key *key)
    37 {
    38         struct pcache_cache_data_head *data_head;
    39         struct pcache_cache_pos *head_pos;
    40         struct pcache_cache_segment *cache_seg;
    41         u32 seg_remain;
    42         u32 allocated = 0, to_alloc;
    43         int ret = 0;
    44 
    45         preempt_disable();
    46         data_head = get_data_head(cache);
    47 again:
    48         if (!data_head->head_pos.cache_seg) {
    49                 seg_remain = 0;

to_alloc isn't initialized on this path.

    50         } else {
    51                 cache_pos_copy(&key->cache_pos, &data_head->head_pos);
    52                 key->seg_gen = key->cache_pos.cache_seg->gen;
    53 
    54                 head_pos = &data_head->head_pos;
    55                 cache_seg = head_pos->cache_seg;
    56                 seg_remain = cache_seg_remain(head_pos);
    57                 to_alloc = key->len - allocated;
    58         }
    59 
--> 60         if (seg_remain > to_alloc) {
                                ^^^^^^^^

    61                 /* If remaining space in segment is sufficient for the cache key, allocate it. */
    62                 cache_pos_advance(head_pos, to_alloc);
    63                 allocated += to_alloc;
    64                 cache_seg_get(cache_seg);
    65         } else if (seg_remain) {
    66                 /* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
    67                 cache_pos_advance(head_pos, seg_remain);
    68                 key->len = seg_remain;
    69 
    70                 /* Get for key: obtain a reference to the cache segment for the key. */
    71                 cache_seg_get(cache_seg);
    72                 /* Put for head_pos->cache_seg: release the reference for the current head's segment. */
    73                 cache_seg_put(head_pos->cache_seg);
    74                 head_pos->cache_seg = NULL;
    75         } else {
    76                 /* Initialize a new data head if no segment is available. */
    77                 ret = cache_data_head_init(cache);
    78                 if (ret)
    79                         goto out;
    80 
    81                 goto again;
    82         }
    83 
    84 out:
    85         preempt_enable();
    86 
    87         return ret;
    88 }

regards,
dan carpenter
