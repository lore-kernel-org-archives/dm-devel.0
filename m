Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D97447F2CB
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790177335; cv=none; b=XCsG9obQfv2ZjRNiCJxsjeWwGAxE4XnPUpa3/RCmun26UILn/8gw9sJVEI14EC8YthLmfGRqhUUtcQd2yvVGcavJlKkm0gF6XzAQZXei0XJ7GRVbkZ3aXc2tlyu8fIsIdJ0E7uBBSDCLo8cTDbZg86FxFIWa3C5jAxWjlILP69Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790177335; c=relaxed/simple;
	bh=Ow/b0VBOduzDdhNQXSHxF+1EHuPjcAUN36VvLIo88zA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuN1kXBHPKBM6E7KDbi2aR0eplgH3VdE0/3g1qDdmG4fvSvsj/UkBnvbyLx5jNS6O4oKrWgLfCOR87w1KJT2Q86CB3U7pdJj1R7M5OU7iosnm8gFU3AET6kIjd8V0FY9a6Jcb/vxAf24XSA9VQWlQr2ZKn+fPxwgTPXTZp5Hzrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2XiDRem; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2XiDRem"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e4b11so6752155e9.3
        for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 08:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790177329; x=1790782129; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xX3eRNAQXTB3zUx5ZFPBygn1MGVMvYVvsxUYdBFoBtg=;
        b=W2XiDRem4sG6xQIj6nhElUt76uX1IRUDGSqkMUCAtTgfbW+euvm8LHBBNU/v0jcr1E
         rIG5f69+X8k2KXB7iMh1Rp7SV+0GEUkI/0nisvOsQx6YJWVu4NOWyeoHCBwjjdN3z298
         6/U6McYSCUqvHOG/V7feHbtmrgp/Iyok5J8qXAeD4mSh7J2eHzHlNx45ZFaclsexyCFZ
         xGwskVAjqixdwxT5BrWuBRIba7EN8wfXOVvnMiZYCb9J/6vbfcrw9RJ2iYJAS5m39al4
         CEdYNcX23Zakd+gMCwQPRh4RMKf9EV0sBeFi2fT+UtQUQsGhsm7ERj1qbmC+wxmr2/Y9
         RHWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790177329; x=1790782129;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xX3eRNAQXTB3zUx5ZFPBygn1MGVMvYVvsxUYdBFoBtg=;
        b=Oc2UiCMgwcgp03imF/peCkZNCGXr9BsSIdHLP/HfR44qm+LcaizFadeBia/M+9oyfl
         lN4r65zHnyT/T+SmTOKjy7bCyEh8SMeijwtJzj7+eaj83t2c6tl6KK+NHUX8DgcsbluL
         1FWFFREpd4UdqI0V0IFkz+PtUU54K8gzfdK3+szyaBpRao0sb+fGb3++8K5vEMXPKi+1
         MIMkPCNuZezkTXgyHe9HL8anaO0lWoaPlfC8liXjvyiCbeFqXDJvVLtyAR8HoKx49W2w
         iVzOiPwchw3ih+Sp93nmcNHQQgN1HIphQKcepIK0I8uoHDyQ+eVQ3hGfHYNizgN4S1Ev
         Dpgg==
X-Forwarded-Encrypted: i=1; AKwUvBzWPSbHg/shxRtOz0RV+Wfo66yHOD7Xeb1r1iKtaHo77L9khCeTBPN3QSDwaCCUmrBp0GmRnFu4Gg==@lists.linux.dev
X-Gm-Message-State: AFuF++mGE0tOGrUTniJ7KpE4AW8QsBqxXjs1xHWEw9I5PM0zFG34rTD7
	+PV8VRTaGMQGrebyIHu3Wk37Jg+Yyi7z5bvjUnyNi/2LEfsx3NPihDAVNadjEtdt
X-Gm-Gg: AYBFou0E1yit81ciGsQOtIXQkr8G9oe4kFilZYtso8HbaSU75gW//aZp446TJhvJhUk
	n9av0u9C7F8yX8pc7bCpT8BfTi1FE9EdEUP5DKM5yzdEYn0hHT7Roldo/TlVWlTh4z8VpO7snwh
	JXb3jPLgZTHo3Po2WJloACvJZiRckCPE3235BsHGYTB0S4Br8I3oh3RnjqKbowNTeSuxtmHPBDf
	RYxbEnFvbrD2OFVVQzNIUWkzpeAr7G4dYpDkqWkxxv7tJpgvYFiEU7t7OkgKrGL7eyUwtezRzTV
	Pl67ejX5USritl+VfNtDYwSCx2JmW8fQ14Cv8MzQYJU7HZeIzp0xGwPbuvV7emtZYLq7oIu3ioZ
	/DJv1F4rgdB7x5Po+wKaNTcb01zQ02hwAuZT5M4JBmoAc4oVmvOQ+cIX5XAeyJw4ZdwDugM2vUk
	wD2w8e7EK18Kd6Xhv70KiCaDLSzACpYbL9WHVGfhgiTmdEpq13YXQZLIZihtUEUA6g2mzwJpJmB
	vLhgiEyP3zRkcOxd57xvOpqu073wwgVUQM=
X-Received: by 2002:a05:600c:46d1:b0:49d:15b9:2a2a with SMTP id 5b1f17b1804b1-49fdefffe1fmr44920755e9.10.1790177328585;
        Wed, 23 Sep 2026 08:28:48 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1c159esm94134555e9.4.2026.09.23.08.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:28:47 -0700 (PDT)
Date: Wed, 23 Sep 2026 16:28:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Itai Handler <itai.handler@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers
 <ebiggers@kernel.org>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski
 <bmarzins@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 dm-devel@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to
 PAGE_SIZE
Message-ID: <20260923162846.0d198104@pumpkin>
In-Reply-To: <20260923113903.901245-1-itai.handler@gmail.com>
References: <20260922120330.127262-1-itai.handler@gmail.com>
	<20260922213457.GA3536981@google.com>
	<CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com>
	<9a6c20da-4da9-4a8d-a6d4-f18900228bf6@redhat.com>
	<20260923113903.901245-1-itai.handler@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Sep 2026 14:39:03 +0300
Itai Handler <itai.handler@gmail.com> wrote:

> On Wed, 23 Sep 2026, Mikulas Patocka wrote:
> > There is one important problem - the SSDs and HDDs today have 4k hardware
> > sector size.
> >
> > If you use 64k encryption sectors, the disk may write only a part of the
> > 64k sector during power failure. When you attempt to read and decrypt such
> > a sector, you get garbage.
> >
> > This is not a problem for XTS or ECB, but it is problem for CBC and most
> > other encryption modes. So, the patch should reject using larger sectors
> > with cipher modes other than XTS and ECB.  
> 
> The mechanism is real and I am not disputing it. What I would like to
> put to you is that it is not new, that this patch does not change it,
> and that documenting it fits what dm-crypt already does better than a
> new restriction would.
> 
> A torn sector is possible today
> -------------------------------
> 
> Consumer NVMe are generally shipped with 512-byte logical blocks and
> stay that way in use. Installing Linux does not change it: partitioning
> and mkfs work inside the logical blocks the drive already exposes.
> Changing the block size is a separate low-level operation - nvme format
> with a different LBA format - which is destructive, which no installer
> performs, and which a drive may not offer at all.

And you really better do 4k aligned 4k writes.
Otherwise performance and device lifetime are likely to suffer badly.

David

> 
> The machine I am writing from is one: a Samsung PM981a carrying a
> complete Ubuntu install - GPT, EFI partition, /boot, and the rest of the
> drive as LUKS over dm-crypt with LVM and ext4 on top - and it still
> reports logical_block_size = physical_block_size = 512, with no
> atomic_write_* attributes at all. The dm-crypt device on it reports a
> 512-byte logical block too.
> 
> The atomic write unit follows that format.
> nvme_configure_atomic_write() takes it from NAWUPF, and where the
> namespace does not advertise one the unit is a single logical block;
> controller-level AWUPF is explicitly ignored. So on that drive the
> guaranteed atomic unit is 512 bytes, not 4096.
> 
> Which means dm-crypt already permits, and has permitted for as long as
> sector_size has existed, exactly the situation the restriction is meant
> to prevent: a 4096-byte encryption sector spans eight device writes
> there, with seven places to tear, in any cipher mode including CBC.
> 
> What this patch changes is the maximum size. It does not change what
> any mode does when a sector is torn, and it does not make a torn sector
> possible where it was not before.
> 
> What a tear costs
> -----------------
> 
>   XTS, ECB     each cipher block is independent, so the sector decrypts
>                to a mixture of old and new plaintext - what a torn write
>                gives on an unencrypted device
>   CBC          P_i = D(C_i) ^ C_(i-1), so exactly one block, the one
>                whose predecessor is on the other side of the tear,
>                decrypts to garbage; the rest is old or new data
>   AEAD         authentication fails and the read returns an error rather
>                than data, which is the loudest and arguably the best of
>                these outcomes
>   diffusers    the whole sector decrypts to garbage; in practice only
>                reachable by writing a table by hand, since BITLK uses
>                512 or 4096
> 
> My view is that all of these are acceptable, because a sector whose
> write was not atomic is lost data in every one of them. The filesystem
> above cannot rely on a partially written block whatever comes back from
> it; the cipher mode decides whether the loss looks like stale data,
> like one corrupt block, or like an I/O error. It does not decide whether
> the data survived, because it did not.
> 
> Documenting it
> --------------
> 
> So I would rather say this plainly in
> Documentation/admin-guide/device-mapper/dm-crypt.rst than refuse
> configurations:
> 
>     An encryption sector larger than the unit the underlying device
>     writes atomically can be torn by a power failure, leaving part of
>     the sector written and part not. This is already possible with a
>     4096 byte sector on a device whose atomic write unit is 512 bytes,
>     which is the common case; a larger sector widens the window. With
>     XTS and ECB the torn sector decrypts to a mixture of old and new
>     data, as a torn write does on an unencrypted device. With chaining
>     modes the block at the tear also decrypts to garbage, and with the
>     wide-block diffusers the whole sector does. Use a large sector only
>     where losing a sector to a power failure is acceptable.
> 
> Reworded however you prefer, and I will send it as part of v3.
> 
> Rejecting modes above 4096 would be a new restriction on a hazard that
> already exists below 4096, and it would have to be revisited for every
> mode added later. It would also read oddly to a user who meets it as
> "use ECB instead", ECB being tear-tolerant but not something anyone
> should choose for disk encryption.
> 
> For what it is worth I do not think many people would meet it either
> way: cryptsetup has defaulted to xts-plain64 for plain mode, LUKS1 and
> LUKS2 for years - plain-mode, luks1-mode and luks2-keyslot-cipher in its
> configure.ac - so almost anyone asking for a large sector is on XTS
> already.
> 
> If it turns out to matter
> -------------------------
> 
> If experience shows this does need enforcing, the version worth having
> is not a mode allow-list against a constant but a comparison against
> what the device actually advertises: refuse a sector larger than
> queue_atomic_write_unit_max_bytes() for modes that cannot absorb a tear.
> That plumbing exists, and you enabled DM_TARGET_ATOMIC_WRITES for
> dm-crypt yourself last year.
> 
> It cannot go in now, because on drives like the one above it would also
> refuse 4096 and break existing tables, so it needs a deprecation path
> rather than a one-line check. That seems to me a better use of the
> effort than freezing 4096 into the code as though it were a safe size,
> and I am happy to work on it as a follow-up.
> 
> v3 will carry the documentation above, and the two changes I already owe
> this thread: dropping the dm-verity comparison, which does not apply to
> a writable target as Milan pointed out, and dropping QCE as the stated
> motivation, which Eric was right about.
> 
> Thanks,
> Itai
> 

