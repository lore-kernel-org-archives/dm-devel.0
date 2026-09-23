Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B73044605C
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 07:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148587; cv=pass; b=qSul8tRumICElIOt67mVnzFCKwh64xHVXuaU26G9fSrJH8XR6LidB9GcGOB7f6oCTaEiHYJC7VehaXRdxS3eBAtbnfGdQcL13401EyLllHE0si1ilx6uSA5KZLiv6i/+h8sa5uDtit6Re9vFHx0IoGuXWCG6kjswQMaLCo/Rnzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148587; c=relaxed/simple;
	bh=w81K7uDp3GuPBiEppWUi8J0HYpDyiKUpNPxoR0sXK6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/GUgiFJwB8/TKgkXe5fQOlEO4HD6DUb8CvX5g80htnYp81oD+c2gcMbfdWLCtoI6F/KSnxDJCvgYC4UVKsiO/AJjW6E861DDENfzZ6JFh2lMtWvdX6pcVE2BpaRe+0aOtl6zziolSY4PZtUh+jXtVtc1RZBS0Ioyt8MPwqashQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKOMK2N4; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKOMK2N4"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672c3f467e9so85919d50.3
        for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 00:29:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790148585; cv=none;
        d=google.com; s=arc-20260327;
        b=Vmbf94A9rz77vAKb56vGPg/JfX+WVQJUeBnMx3vn6g5/BWMn/jE6jrGul6CXGHorD8
         Q3V5QLLc2ugBunvQXRUACtt7BBWGNdmGNASKwaTmTVGrxUR02u17cVocm85knUqQMLMN
         p+udup+X0qgc3/+4ZKEJHRrEycr9hmjzvNtiO+QzZ5U2+YgFOjTcMTtLYo+T69+sieHi
         A1Z7/qQ/Z26JfsMU7WoAv3jxAXiJurP/uAtZEPGdXhHMtUs4IJhE1ei11UCmsUf+R5XE
         Xbne+SjgQtgmjjJpU6+TuSh/iAQsn7IjR4xYZR3DeqmmSR0HeyZVLWKKJa2m7gvbjXpW
         aytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LLXhmmwiXGVMSYLL9EVJ5vh7HjECRCSGD3Fcr7GaA/4=;
        fh=4n7OetZj41bAF7pzBKD+W2mPpN4sGLDot5672urimzM=;
        b=MYAJLQGzYqGVW2YSRtB0bII5Pre9ToJYnCjAXKOxJ2ZkRLVEs5V5UXV/j0zDI29rzT
         Hq7xb1j7OniQjAsgjQ9pZj+ygHzKCPcInMaEKSAD0zwrGE+r6JDPjGipXJDLLvzsfqm+
         sUV2tXi9zPKmOuxk+9EHgzibVOt3ylxfeFIIYxwS+I4Bo9BRitKVq5l1BEcwLhA/nr1C
         oAYtnzkY35SIF6hzCXzAvY0MWfRiVCjOBxS3v9h68w4U42VGWsBEnzdmoaPmdyhOEFFz
         8wEIO4tfUtKtH1nymsyscW701u9mbOCUNbb2A4jb0Pr395eKDf/653rRmFug+frIaTTS
         2WnQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790148585; x=1790753385; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LLXhmmwiXGVMSYLL9EVJ5vh7HjECRCSGD3Fcr7GaA/4=;
        b=YKOMK2N47mEt9Y+5vb9l3gGHffeGsVrd9/ZjplLZVX02rHMimt/0fJvUgzfNEv4H6n
         MhvYmEASRV4iRU88YBhjwdht1W7avDnY0objFhn5s2wtb2u9zmp2XEucjUSi+N7nGRrK
         esP826PRbzQClu/eafVd/TqrWOx3EvGe8UFoouYynyyEIeFu2sGaqTpOwhO3hkigV7vs
         8S9HKTHeGgoVY2VwNtzBX7iBfETaarHcyDitp38rMNhM6TC5IhlezSsOEVb+8jiV/R7F
         MvM0sSy+EiuQRaMo31ldydO8/BLACVEKJGHQDMkt2ca6wrHj/Mq7fGutb5aQ0Wifv7Fc
         4dTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790148585; x=1790753385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LLXhmmwiXGVMSYLL9EVJ5vh7HjECRCSGD3Fcr7GaA/4=;
        b=k+SYh+GAh6nbgO1Qtm12PmyjXEKplOGDIjPi4ogZQJxv42MJ0Z9vMOZG/OOA398HkH
         Dt7Liw/5ylSLhaKT5Xm6AoXWQZ55Qk/5jsg5KBccA8Q8Y29N399PeFSWzp21Q4jok+kt
         xL6lDTH/srWwW+C7i5hoNs5ndT1gAhU0wBBeDMJ5xsk75g8hj8CBHv8KS0mhE+WC9jgj
         sbV7M58gfeJBof7PRy2miEbHyyTuTRLekbxkaQNwCA7uqgMBiaYdAgUKqsWDy5GhcSoa
         SVvkIWephg/QWNuqjXEt75UPwTUPCQSlX3t/mH44B90r8QhG15WUOjlEACbqkbtcPuKf
         5CMQ==
X-Forwarded-Encrypted: i=1; AKwUvBy8YhYuDoebw9Aa5c3MqSrMixvnN8W5wBysWncNBmobPJZkgOUmPnax7Sce5FzciQqN4DpCi6Af9A==@lists.linux.dev
X-Gm-Message-State: AFuF++lffpuJmJkEruK3c6sO/vtFUWMgFdubsN20J1K7HjLT6LHIaDOv
	Zm2ox2Sca5o/Vz96CT2gRqxb9vWXQDRFS9vnDlMz2qslNv4K4nQ9nIZcSOTIdFPB0O0uSc6/N2N
	fY0+VlW86085O+gzlOFKU6NWn7Kj7Kgc=
X-Gm-Gg: AYBFou20kXRGEbpUzySn6vdkG4s+DYkyLagsIS9g2iZoI0/LmnQ4arj6RWyb1rTOBWu
	DRJ0hOk1VbFV7aXJT2rtlVJiryh1evtoLKZgPS/8nwTvFDTGSSalfdu7VVBEzLXvw0tfj1qd/E5
	Qp14y+4Bca9YSoIsh0EE+wAamd+e9A0UrkQl2r8Hx5Dnui4/jUbJmTLhZXMt7LCN2R4M3FQoe/j
	HEuTjY5Bp8lhJhlbXGelHftLLrIK4S6XZ0tjJlooWfM9ILM1/6x4tdry953p/wYI7AWZOaYhZTV
	52kYPs12vKGC/d4peuJvlqtq5sMnKQ81fpuhRlCpcPS/V397sI467JLT
X-Received: by 2002:a05:690c:6709:b0:85e:3071:f103 with SMTP id
 00721157ae682-8a4574a521emr18830827b3.1.1790148584934; Wed, 23 Sep 2026
 00:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922120330.127262-1-itai.handler@gmail.com>
 <07e750dc-570b-4f69-9ec3-68de51416a06@gmail.com> <20260922134945.667305-1-itai.handler@gmail.com>
 <20260922213457.GA3536981@google.com>
In-Reply-To: <20260922213457.GA3536981@google.com>
From: Itai Handler <itai.handler@gmail.com>
Date: Wed, 23 Sep 2026 10:29:34 +0300
X-Gm-Features: AclHuK8toaulBOT-3YOE_3phn9wcYRLjApTWuJJjZ2V6oTfFGkdD_31cj0caEbI
Message-ID: <CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
To: Eric Biggers <ebiggers@kernel.org>
Cc: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 12:34=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Tue, Sep 22, 2026 at 04:49:45PM +0300, Itai Handler wrote:
> > Storage is not the use case - crypto offload is.
> >
> > Where the cipher is a hardware engine driven over DMA, the per-request
> > cost is a descriptor setup and a round trip, and that cost dominates.
> > Making the request sixteen times larger amortises it. With the in-tree
> > qce driver on an arm64 64k-page board, plain dm-crypt over a ramdisk,
> > MB/s:
>
> That isn't a real use case, though.  Using the QCE driver is *much*
> slower than just using the encryption on the CPU, even on long messages.
> That's been established in many previous discussions and is now even
> admitted by the maintainers of the QCE driver.  The QCE driver even
> (incredibly) uses more CPU time than just doing the crypto on the CPU,
> due to all its driver, scheduling, and IRQ overhead.  The pending
> patches to add BAM locking will make it even slower.
>
> The fix is to not use QCE.  (And also ensure that
> CONFIG_CRYPTO_AES_ARM64_CE_BLK=3Dy is set, to get the ARMv8 CE accelerate=
d
> code.  But even on legacy CPUs without ARMv8 CE, QCE is still slower.)
>
> Unsurprisingly, the numbers in this patch's cover letter show this as
> well, with much higher throughput reported for the CPU-based encryption.
>
> (Also note that QCE is currently marked as BROKEN upstream.)
>
> I really do not think dm-crypt should accept changes to further
> accommodate obsolete and problematic external crypto engines like this.

Thanks for the detailed feedback.

I agree that QCE is not a good example to use as the main motivation for
this change if its driver overhead makes it slower, and even more so if
the driver consumes more CPU time than the software implementation. I
will therefore not argue that QCE itself justifies changing dm-crypt.

However, I don't think this necessarily establishes that the generic
dm-crypt change is unnecessary.

One point regarding the suggested ARMv8 Crypto Extensions implementation:
PAGE_SIZE and the presence of ARMv8 Crypto Extensions are independent
properties. In particular, an ARM64 system can use 64 KiB pages without
having ARMv8 Crypto Extensions. Therefore, the fact that AES-CE is faster
than QCE on CPUs which support it does not apply to all systems where the
proposed change would be possible.

There is also a more general reason why hardware crypto offload can be
useful even when its raw throughput is lower than CPU-based encryption.
Offloading encryption can leave CPU cycles available for the application,
filesystem, networking, or other work. Of course, this only makes sense
when the accelerator and its driver have reasonable overhead; I agree that
QCE is a poor example if its driver overhead outweighs this benefit.

My main question with the patch is therefore independent of QCE:

Is there a reason for dm-crypt itself to impose a fixed 4096-byte
encryption-unit limit, rather than allowing an encryption unit up to the
size that its existing I/O conversion path can safely handle?

The patch does not make larger sectors the default, and it does not
remove the kernel-side validation. The default remains 512 bytes, and a
larger sector must be explicitly requested. The proposed upper bound is
the smaller of PAGE_SIZE and BLK_MAX_BLOCK_SIZE, so configurations that
cannot represent such an I/O unit are still rejected.

The motivation for using PAGE_SIZE as the upper bound is also not tied
to any particular crypto accelerator. The current dm-crypt conversion
path processes the encryption unit through the bio/scatterlist
representation, and the relevant bio vector cannot represent more than
PAGE_SIZE in a single entry. Consequently, PAGE_SIZE is already a
natural upper bound for the current implementation.

The performance measurements with QCE were intended to demonstrate the
kind of workload where reducing the number of crypto submissions can
matter, rather than to claim that QCE is itself a desirable accelerator.
I agree that I should find a better hardware-accelerator example before
using those measurements as evidence for the patch.

I also don't intend this change to imply that larger encryption sectors
are appropriate for LUKS or other portable on-disk formats. That is a
separate userspace/on-disk-format consideration. The kernel would still
enforce the limits of the dm-crypt implementation itself.

So I would frame the patch more narrowly: this is an attempt to remove
an apparently arbitrary 4096-byte limitation from dm-crypt and allow
larger encryption units on systems where PAGE_SIZE and the block-layer
limits permit them, without changing the default behavior.

If there is a specific correctness, security, or architectural reason
why dm-crypt should retain 4096 bytes as an absolute limit even on
systems with larger PAGE_SIZE, I would be very interested to understand
it. Otherwise, I think the question is better evaluated independently
of whether QCE is a suitable accelerator.

Thanks,
Itai
