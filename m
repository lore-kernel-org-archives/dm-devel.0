Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69531401B
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 05:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756445998; cv=none; b=qplQg3p97zGjJWiZsC26ccnpwBN5ijrexOgNDCD5EG2tgTIRe2LQLfdPhWwzzPZ0D6NWBIvmY0Eg7ZRXNx90vmNGD6Ks3bfHleFPzyXuWul6PPDpANc+v0DX5661i96OnpIt2tu/30iWyDsCkT8nctljvubpMf8h91CXayl9qTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756445998; c=relaxed/simple;
	bh=qFwSWkaS9kGP5PXElMWEAjT15Mla+E/mI162yE3LYK8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Fb5i5AsHvdhVPd83AGkZtY85XFqw0vneFu6ZgVSH2GwOnAJuyWezxPRukWmjJOyDg5Gb+ttmXSj9JfZQHkDmZPuUga9ataW/8Sr4DmSyp52QKB9HPBn5RGZ0yiX9LRqaVDuKr7wCQ5ujcLR767wUfEa15Jggtdyjd2QD13+vcNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kCFXxTtG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kCFXxTtG"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b0bde14so9945535e9.2
        for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 22:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756445995; x=1757050795; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qIPsEiakAuLf2Sw1TY63CwqxnPuLF5OPbgZG/d4j2vo=;
        b=kCFXxTtGuje4yEsgAl5agqwRa+VplwGzDYFkRPvl29t5Ywrq1oIx5qXgU6n8YSAlbr
         3us+m/+NmuqVfeNq7FwnimGaWZ3Qfi0OvM6iCBmfrCQ2VykyOF0VJ67PFovnL56jW8RN
         4lW6G85zN4mgcH6dnZ2cTv/aoguhaqv/YBOCwDN2UDH8Td91ng/lZFXv6YVX3q9r8rK5
         dSB4tJeuzkgnDTqKlEzWEJchxiCRC/fDbmhGZ+kguSawK9xNVqBk2hg8lZqsuSEVFoZs
         p9FugELuzWlGt/hHeBflEZ6ZsS8mc36av147IMEshXhINaU1J6LM6vule37SLAlg+kmr
         zlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756445995; x=1757050795;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIPsEiakAuLf2Sw1TY63CwqxnPuLF5OPbgZG/d4j2vo=;
        b=d3u/nguqddUXqJZOHHxMBpcvZXV6jMFb0cz4vWSuUnu205Z7WV5DHTWeEyMHp8NAYv
         lcqwDOYhWYaumaAz6tKaI4FkzHg9xf4+xDzhK1FW9JEQEpIMHV7uk8OITMMT6UrwQ7Dn
         kxCKY2QOfp3pNukarB8uxJ5VEh1iGfM9oNVICyJ1Jhq5pOPexfAZwFf6JFFg8GBjc/L+
         an5HAIrbsBBR/Mjkz5kylCo3aef/kWc4mvLaBk2S5sVB1QlbnEJOTESrD/Sbgq3F4TeE
         PncNrDlO9uo9AiWGnN9ZEKnfh7D0FlOtjUQ2iJ5fsT680F2WAxsUhO7MvncqbNlOAmwi
         hzcw==
X-Gm-Message-State: AOJu0YwlOr62OvhRoYLqKBGC2nrMsRURJ6T7+YrZmQRJmjtfrhWIScOG
	2BSmUw+r0atFJZh0XhQLPLeTY7NG2GF+J937JXfQlUdZggFWG9H5hp7AMkxY5J4wIseQAuns49O
	EVb1G
X-Gm-Gg: ASbGncvAtEhHxk1ZE6JBUT0Z4zm4sn1nRLswFwb6ROVwIi7T6yKU6oFYuVC4bQ9By49
	jUyD4rczJUtcCZcmHIU5zS7JzObjHSrT3BPuhf7jVb6hKnBGbSrirArh21sUE9J5UBpLxEkAn/k
	w/rXoqMe0kV1dmyqFbJYdnDsWIQpI6ONozRV0kKY3kDzxEff4GqAfluU0vaiBCE69e61mgKR7JT
	4lngm1PSl70oACZVk7yiJbrh5eIFt3UzFoACHjJEuiZkdOb5hc7SoZkK1LyS4hXQ3gvVj04gl9B
	tI2FNlJDa0vfnEoZyQhSqpInDxdSpqBp1yuF5DB1laddPPnq3UrV5LzoYHKQuoyn43Zhdkq3T9N
	4E2Q66t0Z82V2AkVDY+itVBEAQmz+ZAN6IncDCQ==
X-Google-Smtp-Source: AGHT+IFON71MLmsXNSBSyPKvo7nGumsz7BAteQ7phPXOCScMElmf5xHHnXlrxtli8vx50STB501kZw==
X-Received: by 2002:a05:600c:1f1a:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-45b517cbee2mr197962655e9.34.1756445995099;
        Thu, 28 Aug 2025 22:39:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e886619sm21705265e9.15.2025.08.28.22.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 22:39:54 -0700 (PDT)
Date: Fri, 29 Aug 2025 08:39:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm-pcache: add persistent cache target in device-mapper
Message-ID: <aLE9JjiTzKmeKzsN@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Dongsheng Yang,

Commit 1d57628ff95b ("dm-pcache: add persistent cache target in
device-mapper") from Aug 12, 2025 (linux-next), leads to the
following Smatch static checker warning:

	drivers/md/dm-pcache/cache_segment.c:263 cache_seg_gen_increase()
	warn: sleeping in atomic context

drivers/md/dm-pcache/cache_segment.c
    257 static void cache_seg_gen_increase(struct pcache_cache_segment *cache_seg)
    258 {
    259         spin_lock(&cache_seg->gen_lock);
    260         cache_seg->gen++;
    261         spin_unlock(&cache_seg->gen_lock);
    262 
--> 263         cache_seg_ctrl_write(cache_seg);

cache_seg_ctrl_write() takes a mutex so it can't be called with
preemption disabled.

    264 }

There are a few callers which Smatch says have preemption disabled:
The call tree is kind of messy but the point is that there are four
callers which Smatch says disable preemption.

miss_read_end_req() <- disables preempt
-> cache_data_alloc() <- disables preempt
miss_read_end_req() <- disables preempt <duplicate>
cache_write() <- disables preempt
   -> cache_seg_put()
      -> cache_seg_invalidate()
         -> cache_seg_gen_increase()

drivers/md/dm-pcache/cache_req.c
    36  static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key *key)
    37  {
    38          struct pcache_cache_data_head *data_head;
    39          struct pcache_cache_pos *head_pos;
    40          struct pcache_cache_segment *cache_seg;
    41          u32 seg_remain;
    42          u32 allocated = 0, to_alloc;
    43          int ret = 0;
    44  
    45          preempt_disable();
                ^^^^^^^^^^^^^^^^^^

    46          data_head = get_data_head(cache);
    47  again:
    48          to_alloc = key->len - allocated;
    49          if (!data_head->head_pos.cache_seg) {
    50                  seg_remain = 0;
    51          } else {
    52                  cache_pos_copy(&key->cache_pos, &data_head->head_pos);
    53                  key->seg_gen = key->cache_pos.cache_seg->gen;
    54  
    55                  head_pos = &data_head->head_pos;
    56                  cache_seg = head_pos->cache_seg;
    57                  seg_remain = cache_seg_remain(head_pos);
    58          }
    59  
    60          if (seg_remain > to_alloc) {
    61                  /* If remaining space in segment is sufficient for the cache key, allocate it. */
    62                  cache_pos_advance(head_pos, to_alloc);
    63                  allocated += to_alloc;
    64                  cache_seg_get(cache_seg);
    65          } else if (seg_remain) {
    66                  /* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
    67                  cache_pos_advance(head_pos, seg_remain);
    68                  key->len = seg_remain;
    69  
    70                  /* Get for key: obtain a reference to the cache segment for the key. */
    71                  cache_seg_get(cache_seg);
    72                  /* Put for head_pos->cache_seg: release the reference for the current head's segment. */
    73                  cache_seg_put(head_pos->cache_seg);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If we still are holding a second reference, then this warning is a false
positive, but the commen suggests that we might actually free it.

    74                  head_pos->cache_seg = NULL;
    75          } else {
    76                  /* Initialize a new data head if no segment is available. */
    77                  ret = cache_data_head_init(cache);
    78                  if (ret)
    79                          goto out;
    80  
    81                  goto again;
    82          }
    83  
    84  out:
    85          preempt_enable();
    86  
    87          return ret;
    88  }

regards,
dan carpenter
