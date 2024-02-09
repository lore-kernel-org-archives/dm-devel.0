Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6627664A2
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 08:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707468518; cv=none; b=Xw8Jjnqqwih7ZFj3TxmxcNJHNL5d48FEVSfEvvLdXiQiJLepE1dDI9k5+uJru7dKrJpT/iQCN0WFzNECI4iSQ/5oEXWC3vCBIJ0arVHB8IGyxbILNx8YsRa1E92qf0FEO+je+/lvCK2NXWJ8kHStoWezYKVnjuEi7CxJuddL2Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707468518; c=relaxed/simple;
	bh=Mq6BFCfR6BDYDeHetr86ogMkPu4jZPzZwvmvbBPyP7c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WhZIuvfw+N/Znjo33d1QMR70FICbkUpc70af2uC80/Xi131TDywJf2JQv8epLe93k/PaPlSCJtBf7YY3mXybAfrC3WoAzaDeL66uK9hoRIWj0RT+RmRf08hnEddk7Ope6kpcY9smyffuNznl+9Or3c237tTd0pK4oVN97Ns76/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uXG417Ht; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uXG417Ht"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-55ee686b5d5so1047473a12.0
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 00:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707468515; x=1708073315; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IrDLzyu7aPX7JQqBSW32uMQttYeUKv2kX92GhSyHAGQ=;
        b=uXG417HtMzIb/HR/8tXuAo1SMvCCnH+QEViqsJ4Rgd7j1bywqC6n21s+NkrBvW70gs
         fTIuZkvC5QuENxAiQa2GsMtpq9B5xkNGJH3hpoLdQjK7ZLxr1MkZbNqycym6rpGccRqx
         +6652uc09k41ETv/ZMNr47CNew1dPwwN21DyaF9d8Mi7MUjdY2+QnaW8ytlcafR+zKKv
         HV2BRy6IIOSROM+gUx9Yg1S3TGF2ayiB9U4824aMr7XPaJVJi/yA+4sQSspYfYnyqgsm
         UfxTIJiHwh4mad6VysjuLlaurE7S1pslnP6tAWOo0tR35qeJNK6W2PMFtyns26CIt/jz
         Sz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707468515; x=1708073315;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrDLzyu7aPX7JQqBSW32uMQttYeUKv2kX92GhSyHAGQ=;
        b=vQ0zsHuBUeDgB5nugL+LMCDfWyfzXk+YjcMLRQDzUUK9AcSY+jes0Qev5E31T8wRUH
         6fXruXZYDWUu0xmesNJf+ATzNfZ7g6D4GUB3G01GXocUjKPBNrRcEJvukoWg1s9/qm6J
         2gte9AJ2GfElI04Un0sLCbY9qx63get9Br1R04sT5gRdRO/9M2UhjVM6tp35YVaX6sw3
         6t/KhhIv/+yaHvQIQKGWAvWnGhIJwTIQ5jfwglS6p/lzspnVlUDW9+Aa6pIxDMqBAO+Z
         U9reol3PqrNNDyzc5xYDRTFaZVdgHRwYqic5zupnZorTKRn9Gf1+jkfb5ZbFLX3Y6hnY
         Cegw==
X-Gm-Message-State: AOJu0YxXTz28/bQ8om6TEXF5wz1tlLyV0jR5TIumASDXYCS7ex3gpod0
	LWvK68REltMc1wCowJTBBDdfqtEvHKskX6tGTOIJ3vSb4Xc7ejaWHu2a9kuWEog=
X-Google-Smtp-Source: AGHT+IFB8P3PLIRcH6ZKHx0Cb4iE2sTPU94Lf3r31ke0iTQslO8t+LI/DeOSCJvpSLfruXnT9yr7cQ==
X-Received: by 2002:aa7:c2cf:0:b0:561:1917:eb9e with SMTP id m15-20020aa7c2cf000000b005611917eb9emr858434edp.35.1707468514918;
        Fri, 09 Feb 2024 00:48:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXEPJsXOE4QqX9e+TceyJsixu3WeKTp78zdBB9U86WVGmlD2iMKPy9TI41Q12q5hZm7GvC55zTDOIR6GEKuJqE3yC/bh11OiXg=
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id b14-20020a0564021f0e00b00560651808a6sm570055edb.67.2024.02.09.00.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 00:48:34 -0800 (PST)
Date: Fri, 9 Feb 2024 11:48:30 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm vdo: add flush support
Message-ID: <c91e8c15-d418-419c-aebe-078bd8f12687@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Matthew Sakai,

The patch 7d7084389ab3: "dm vdo: add flush support" from Nov 16, 2023
(linux-next), leads to the following Smatch static checker warning:

	drivers/md/dm-vdo/flush.c:114 allocate_flush()
	error: uninitialized symbol 'flush'.

drivers/md/dm-vdo/flush.c
    101 static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
    102 {
    103         struct vdo_flush *flush;
    104 
    105         if ((gfp_mask & GFP_NOWAIT) == GFP_NOWAIT) {
    106                 flush = uds_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
    107         } else {
    108                 int result = uds_allocate(1, struct vdo_flush, __func__, &flush);
    109 
    110                 if (result != VDO_SUCCESS)
    111                         uds_log_error_strerror(result, "failed to allocate spare flush");

In real life, uds_allocate_memory() isn't going to fail here, but
if it did then "flush" isn't initialized...

    112         }
    113 
--> 114         if (flush != NULL) {
    115                 struct flusher *flusher = pool_data;
    116 
    117                 vdo_initialize_completion(&flush->completion, flusher->vdo,
    118                                           VDO_FLUSH_COMPLETION);
    119         }
    120 
    121         return flush;
    122 }

regards,
dan carpenter
