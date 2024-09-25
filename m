Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AFE1547E3
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 06:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727244689; cv=none; b=Z/M19Jz4Q12Ox3eZkFCGyvxBii5AzpqaXgraPmsko/2OdMfLWzWDCHDSJM4ECp3D2sujWziC4G38Eb978iAzVi8NFzfFTpekhlLEDXabbnOC7jVCMv4J4qVxsXLtMjv5yJwqRGxs5mFj7zVoE85R6tcOnL0JKZzGDqp/D8PbhY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727244689; c=relaxed/simple;
	bh=H0XV+ySVkLMFX3AAuN7oE49zUIYS1Luo3PXoLGirxw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oLmPhN+J3+dvbNqCb+m/VBFtil9YyKliyVdAZhiCP+VG3abLv3OpZwV/aGWVoOnNSE8cCPDqlcVZNgv2W4qeI7AetQY9RyDMxRqfTMa5tIEDQR+CMTyQNpAHAVCa91Dj7a927aoG/YHtNXoN34+wzqCndAixjbBwFWNFByxYTUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKxQRe1I; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKxQRe1I"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e2226b9f246so5147428276.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 23:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727244687; x=1727849487; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H0XV+ySVkLMFX3AAuN7oE49zUIYS1Luo3PXoLGirxw0=;
        b=AKxQRe1IQfnJzxqCnBFp8zORt9DHQlDNkVk+iMx15Brwrrhgky71/jwCM8BifWyzm8
         3dERqS4adMLNR+DnNTGIFNDF81qs4+qrwxArjZJqjYxmFeXBGkXROI4M4zbifhjJD1ch
         QjNa1Y3IkrjMEUMzna/sUohMFt9sDinBJdCW50uxh0syaiRzrEEd55PQ4V7dM8L2sU4I
         R2JP6PxuvrMJXlwkwg5tHJWuN/5kWxW3Eoy1AhwUWkM4mJRctQLDKVc5wpBO3rtMgnE4
         kKA1thBZ5gu8Rv9AYIWY+acwAhtN8iPRCoVqKPq3gTH9ypEtEsj1NSm00MuRb6gFN36L
         QB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727244687; x=1727849487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H0XV+ySVkLMFX3AAuN7oE49zUIYS1Luo3PXoLGirxw0=;
        b=uBhRqEL8Yw87GxViiNA+/YkTjDRTr0U+XLsgL1Q7su8EFXOuxVa2qDE6vKyO4t2RT2
         LyqUctAigUxmh/fO6vmqP7a1Eni9cSf3JK6MaY3m1gJmVjXxK0h+jmLByuKvblcdm3cg
         T2PlioWWoCm4iMTe1s0U1luQKJeAIbG8VmF5fvmG4/qDcmRxN6bDOM//Fkp52quE8P0s
         8ci3w8IKcQ0gYEY1qcyjiZdWlQjntbeoKTcyhupQgNCmcseBrYHThdXX2iaGQlJjkD0L
         rxtNiDegi+bHl9wjv+RQ+a7YePrxz2FJhEdj6qXi3MeG/yewX6l1a46y8VV7LGaFl3m6
         7ang==
X-Forwarded-Encrypted: i=1; AJvYcCWeB8PtwYsjw+iJCGdbM5QwT3rNSMVBNfs9wF/WLC2ZtlDEIfH9rrE/5/PY5/Btdh91Pu6djt/o2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzsqVTNLwqkzJbw+IcKjfGpbcQtLuUnx8qvO96wHpIi8wFegNff
	5AyMaLt3phhEe6F+YANyerknA83dB/PdJmnW1levYtllQrcoJXd41/rsFKoUHUhljSv0GwjrY2Q
	00/WviTadftg+ffoNQZfqjvv0fl4=
X-Google-Smtp-Source: AGHT+IGyUpo/l4rQZ3RRZAqKyfCS5zdmgvOzIA5uVJBADlbHsfA61QuAhKBi3k1SadC96iKksERPl6Y+CT6tDJogIrk=
X-Received: by 2002:a5b:bd2:0:b0:e24:a23d:1f2a with SMTP id
 3f1490d57ef6-e24da2a48bamr1088533276.51.1727244686788; Tue, 24 Sep 2024
 23:11:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
 <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com> <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
In-Reply-To: <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
From: Maxim Suhanov <dfirblog@gmail.com>
Date: Wed, 25 Sep 2024 09:09:22 +0300
Message-ID: <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Milan Broz <gmazyland@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Akilesh Kailash <akailash@google.com>, 
	Sami Tolvanen <samitolvanen@google.com>, Alasdair G Kergon <agk@redhat.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
	dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello.

> This is a very strange reasoning. I can say that restarting on an IO error
> (that can happen in normal situations) could cause another security issue,
> such as DoS. EIO is not a data integrity error; it can happen even higher
> in the storage stack... and the application should handle it anyway.

In the default mode of operation, there should be no panic/reboot on
an I/O error.

The issue and the proposed patch affect the non-default modes:
panic_on_corruption and restart_on_corruption.
Users relying on one of those two modes expect the system to crash if
something goes wrong [1]. So, DoS is expected here. Returning I/O
errors to the reader isn't something that is expected here (see [1]).

The issue allows the attacker to "downgrade" the "panic_on_corruption"
and "restart_on_corruption" modes to the default one by creating
unreadable sectors on the underlying media (e.g., through the Write
Uncorrectable command).

References:
1. https://github.com/flatcar/Flatcar/issues/422
