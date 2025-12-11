Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12E031986E
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765477481; cv=none; b=r8rs1dxGjvsz7nnMlgO8+ArUE0TgSXJFPlQLoSghhWSVeWDI4X5EdO0UPTkaQN+MQTkV7O5Vz62zXD64QfbLeYl09yN1+73xd/LPtBPdAeni6RzolVckxs8R91wLj5jggSdQ3BuRDvbe1h8Nh9l8BNPrHo/uVW5P3HLaKod/pOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765477481; c=relaxed/simple;
	bh=EDMOplte/tGjhTTSCm/+jZSsBCs02rA4rbpme3uwP5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6EtJFYAn023yK/LneVxpp3GJD/Joj4fu9QZTHXFy7ZrnEp1jwf0tzmrpon25pr5YtksCBs4R7P2Il1SS1ptJXB8vCXBndf+LOoWtsFtv2odFFCB9zyW0BNgRn1y9x7IcBE3RRcblTzmjuMePdnXTAn3JA0+kLL3S3jLLcquB24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oej0AlI7; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oej0AlI7"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5942bac322dso395848e87.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 10:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765477478; x=1766082278; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFrFvBFoSBllsimam77yErITX9FHt6tAqE6M9ZfsDfs=;
        b=Oej0AlI7iPp9ifY1Eu2oY5j2laoexaL0OBCeQOLqtXhC+s0HaJrMokfCCraxtQfknW
         T99V06W5TnX1XtSD0vsArtQp9TFIw2CEWDqCP0bjQt60sxCfcO9B7x31Oq/t+3xtibhQ
         oXX1gpVLLYHZZskUEzMLwo/uZvYvF6+5lN9UAUCnE9JBTGqSqbZGd03iRY1r25qXE8ZW
         KajLTKe6zFk+pi24W2VL0a7wal1xm5OfE+ag/ljFP/AaKIo4Qz1/qbgRZReO/yY3zZ6a
         5DOSpWX5Cw1MPGfvSStEc/09zB59BcpivOLoXxsbqt9T30b71lIoS/T7BWCud4wOyh+t
         gD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765477478; x=1766082278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JFrFvBFoSBllsimam77yErITX9FHt6tAqE6M9ZfsDfs=;
        b=IRYghW9LY3XNbjHwyXQuGSK+OXaIDVJK78QH2CYH/R0Uzkf2BVAOtwg+6FsNOxyDf6
         IxqzChSVQWvDkODDKHmPajAxifBMPRVj89KM5gXfkTVuAVRPWE8O6SXmIAUNYZdjdCOz
         iK2mTgtSuCSuEOfl/tgWNRZtW0H/VE8WadbwAaxXhDLQKCHZbfbyNhmRMpxvmxNKrmv9
         wnf4znvlIDeIu3Zrnvw0jG1u82xsd/e34OqhUUKuTtwhPaGx1PRlgnpb9p/kRtkWh55H
         nRTVK3SylPrD9VPPbpzYGm25Qmkvy7K7YYpAyJzM3tniFRDxKk2xgrP78/X55ZywBQMd
         BQ8A==
X-Forwarded-Encrypted: i=1; AJvYcCVRbuGXCHufe2sxmyJ70G4ohqqgqYSD60sS+2wEPQwxmGdTfxs5BzSYPjk3zecrJk3UxXXTIVEN4Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxIZlYtGQ+WgAps+y8JZ6io/b4Njdmfq65fIjb+Qk+m4apRkeMJ
	2bfDuLJEuZbyGxlplX6vXojuNE7Bu0O6QngcJGKyVAGezcThSiKq8nok
X-Gm-Gg: AY/fxX4ChQsJEiVNn8O6urxODZ1qPbNgIjcz1BJIg5RGGDdhjQDSxJ89YrqlHlmAjOA
	bUrsTRCsfLziyhUBvrHLcwbGuAlRWk1cErXKXQbzmy+CHUlyHMVuKPPsn0jB9D7sqZC7RSFbYKg
	gBEcf91twOnnIsYbNeRChuA96/TGNFxVfBjDc4cjqhfIy3+8QSXWdlRDOgAS0sxMzo7SBBT8aHQ
	u08/Bcm9KyRxvTXvGzMB2aswfXuYat/jf8Hk4kN5kdwgnBqJJX0xKUszJUoPsB3nQaS591iY0q5
	wjspJ9DDBpN+4dI/Rsy7Zqc66L6uPVl1BP15TCH7yluZAuUOSaxMB7zHqqe0MJra19UI1VkUT8O
	FIC6KEQxuF45cl54FLZjZYm2/jrYLQMvjWZnWSn9f1KNe+6kD4XLklxlmwV8JIbPIZwmaS15bd3
	hJDHCx4hRn6IlCzizKFmc=
X-Google-Smtp-Source: AGHT+IFVxKB8gDiBMiJbinTn0xv4lsyliE65oXrRemLZRXTKoRg4ZE3AckW0VEdwuOTGsUa7HltYPg==
X-Received: by 2002:a05:6512:3089:b0:598:ef2a:448e with SMTP id 2adb3069b0e04-598ef2a4493mr2784604e87.10.1765477477520;
        Thu, 11 Dec 2025 10:24:37 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-598f3195189sm1060918e87.83.2025.12.11.10.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 10:24:36 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: adrelanos@whonix.org,
	arraybolt3@gmail.com,
	cryptsetup@lists.linux.dev,
	dm-devel@lists.linux.dev,
	gmazyland@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is exhausted
Date: Thu, 11 Dec 2025 21:24:29 +0300
Message-ID: <20251211182429.3300562-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> So, this is what happened to you - the machine runs out of memory, it 
> needs to swap out some pages, dm-crypt encrypts the pages and generates 
> write bios, the write bios are directed to the loop device, the loop 
> device directs them to the filesystem, the filesystem attempts to allocate 
> more memory => deadlock.

Does similar thing happen in my case? I. e. swap on top of dm-integrity on
top of partition? Is my use case supported? (I'm not talking about
hibernation now, just about swap.)

-- 
Askar Safin
