Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073462031E
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707483953; cv=none; b=kItgyshrCuM9dQeszUl9gmoB32Sq2VfC0nJ68wGvbCOpf+tUeatQ9LliVYE97UWiFE9xRlRt6p+cGvqMlTzZvRmsZP4wDQZ4Wz/GaDIspB34Cp8ALSX85EaAtx1CF6ZziC5A0+/S+XPKj8gKMrC/1eozCwTBCecnXhddWl7qKrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707483953; c=relaxed/simple;
	bh=aoGSTVHAxbmzAXiR6jLkYXUUTSrenrqvXRzTO3yTIIo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=d1i5xN6cwRuuKcZ7cz2gl/2L3i31aes2A8m3Yg+TVC4q5UnXlGTXVRWwEsjrTo+0KHEr64ld/0qInPW/ENLsVCziaynW1HjWfHdKC05OJ0gkPP8MBOaA2yLKkrmQwP4L32/n6zYsphTI+9aLV3Img5JW6UC6lJU70WnbgaONq58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LIs658os; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LIs658os"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55f0b2c79cdso1584675a12.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 05:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707483950; x=1708088750; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2MceeLozljmoGM18+gVNMUZR77v0XxADYATh3hH+64=;
        b=LIs658osmE50rQ2f/Y/KiYNyYLNZl5emJxYT49LkEYSVL8HjRfTOCmo1YrJC5rVX0W
         rhlL1yOYa4xYc79quGpnGk+vYiqimZPh+NBEfhf00cRnQn1xP2cgCpzJberid37zoFrp
         8E6gEfciiErpsT4fwdqUKXZIS6QANDvgk2ebWxiooq6p9E0nr081gfzRQZx8aC7Kj/C1
         UxQNrjxL4QaN/dTqyYnRJTsHIHfZAXRHaQeS88W5kUGFH/A6kBD4et1aBSGuz/ull468
         hSKYHTQs2egkN0YMTRtIPgbcx5nNs7DgyP7fOShhWY6pRgDTfh3ELiVEaUiQfmuWX1Kc
         ATSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707483950; x=1708088750;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2MceeLozljmoGM18+gVNMUZR77v0XxADYATh3hH+64=;
        b=X3K7h8HJaAbPzpcSzB3q3Akbb8YOEHg/uaauDHuzYvchjAvYC6vHjY1h12M1j3Vd6z
         M33fuWPyiQThobaKBZlVzBq3qpBq8xTNLKT97PL456tJFTsXfvNohWo/7C5Cu/chddRM
         5xYGpy4dD9spQzF3bws+T7F84+oAFaRg8nENGlALS2ynNefKW6525rY/CgHgmN/C6eBk
         NirEuVJFZUzcsPAxAmbNLxWMwPN8qh+UNVq1iJtKXlb0Snczyk8ocYqoo6WOYJeAwntQ
         FMom3A/xmMstpjnDRqZkBPKzqZFuTb3GdF6Xtpzg2FhdD0Fbc2IJ+hE53ogNRkkcCHsw
         A7qw==
X-Gm-Message-State: AOJu0Yz24DxN0pBeUI9/IFiPFJ7YlcMqtDvPV1CRHL+MPcq/PoaKUKm3
	CcwMU7X5vu8tSjLgJqEAw6Qxh62UX0myo1WYWvz1G6u8epH0M/zPgQvueYevrCI=
X-Google-Smtp-Source: AGHT+IG80j4qI9SZlAvEVpJo6d7OxGL1ciUogD2mdfhFmOanbnKCHkeUlOWVykYjwGkkzZvQhLkAdw==
X-Received: by 2002:a05:6402:649:b0:55f:f1f5:1a41 with SMTP id u9-20020a056402064900b0055ff1f51a41mr1231791edx.15.1707483950317;
        Fri, 09 Feb 2024 05:05:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW2LTx/qO88o48WhjP5gprSCd39Ujqh7Q5K29TjVPlp5TNZpIV/gasNpqbam1zYmS/3eB9pTDNgcQRkt+O0bfV6D9ZRwuJPGXE=
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id k24-20020aa7d8d8000000b00560e72d22b8sm763241eds.2.2024.02.09.05.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 05:05:50 -0800 (PST)
Date: Fri, 9 Feb 2024 16:05:46 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm vdo: add statistics reporting
Message-ID: <f7f19be8-4a86-415d-a995-22d030d35e93@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Matthew Sakai,

The patch 25479d97b12c: "dm vdo: add statistics reporting" from Nov
16, 2023 (linux-next), leads to the following (unpublished) Smatch
static checker warning:

drivers/md/dm-vdo/funnel-workqueue.c:545 vdo_dump_completion_to_buffer() warn: why check scnprintf return value?
drivers/md/dm-vdo/message-stats.c:26 write_u64() warn: why check scnprintf return value?
drivers/md/dm-vdo/message-stats.c:43 write_u32() warn: why check scnprintf return value?
drivers/md/dm-vdo/message-stats.c:60 write_block_count_t() warn: why check scnprintf return value?
drivers/md/dm-vdo/message-stats.c:77 write_string() warn: why check scnprintf return value?
drivers/md/dm-vdo/message-stats.c:94 write_bool() warn: why check scnprintf return value?
drivers/md/dm-vdo/message-stats.c:111 write_u8() warn: why check scnprintf return value?

drivers/md/dm-vdo/message-stats.c
    99 static int write_u8(char *prefix,
    100                     u8 value,
    101                     char *suffix,
    102                     char **buf,
    103                     unsigned int *maxlen)
    104 {
    105         int count = scnprintf(*buf, *maxlen, "%s%u%s",
    106                               prefix == NULL ? "" : prefix,
    107                               value,
    108                               suffix == NULL ? "" : suffix);
    109         *buf += count;
    110         *maxlen -= count;
--> 111         if (count >= *maxlen)
                    ^^^^^^^^^^^^^^^^
snprintf() returns the number of bytes that would have been printed if
we had enough space and scnprintf() returns the number of bytes that
were printed.  (Both functions exclude the NUL terminator from the
returned count).

It seldom makes sense to check the return from scnprintf().  In this
case count can never be >= *maxlen.  The most it can be is *maxlen - 1.

    112                 return VDO_UNEXPECTED_EOF;
    113         return VDO_SUCCESS;
    114 }

The code in vdo_dump_completion_to_buffer() is almost basically correct.
It's just off by one in a totally harmless way and I wouldn't have
reported it if not for these other impossible conditions.

drivers/md/dm-vdo/funnel-workqueue.c
   538  void vdo_dump_completion_to_buffer(struct vdo_completion *completion, char *buffer,
   539                                     size_t length)
   540  {
   541          size_t current_length =
   542                  scnprintf(buffer, length, "%.*s/", TASK_COMM_LEN,
   543                            (completion->my_queue == NULL ? "-" : completion->my_queue->name));
   544  
   545          if (current_length < length - 1) {

The highest valid return is current_length == length - 1 but that's
treated as invalid.  If we changed to snprintf() then we could fix the
condition to allow the final character:

	current_length = snprintf(...);
	if (current_length <= length - 1) {
                          ^^^^

   546                  get_function_name((void *) completion->callback, buffer + current_length,
   547                                    length - current_length);
   548          }
   549  }

regards,
dan carpenter
