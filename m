Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0116415F27
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080512; cv=pass; b=XQZ8XM2gePDBzVw5xLpCzBdl3PXI+SdMaUBY8gT/kq2s2XC2FLKyYUxrxQvfJf8fUgtxNGeTqwLweX6LcXj2M+MzwXs7iYzTRzhcFQR530RJRD+EKbXovl+XCnxEQ4V5zzx4nlzXol17apVbOSLXn5XGJ0uaW4i5WWDL/E/klMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080512; c=relaxed/simple;
	bh=ALQACn46SAuo6ABqMmWIs/jscEBUUZDaANiX89ENIH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Tuvt+YlKNNvlacDj/VVjJIa/Gp3eQH5tS6ezvCj9ek6lnos2KTrYp0NXVhf+gUYQlCR+Bf4Z21610NbCj4JLul4knHT+CDd+lJyWDMqY9dGuorA9Nc+q6FtjI6XpgzjRxAv1MxeVWkqMsub3OSVi89ZtZrU899hx4O8fCkBV5uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOhweyTC; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOhweyTC"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66d20c35575so492961d50.3
        for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 05:35:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790080510; cv=none;
        d=google.com; s=arc-20260327;
        b=G2CPCVzvHox+EA13KqSzL71ScyfrEsWazimd5LUs9kM/lPyCcDosRhi5psjPXytgZJ
         PpDZbi/e2xmInx5svQNXz+abpmrmERxh8s1gXDDc2cVRhrLOV5pzHSykD1ko7woQJlNx
         NXQ8tqyV4OmWsO38NMDRrz3UsqqHg/CUwkvG6HcqCnQc4FDy+p4qPw4NuFmRnea1Wl7Z
         9YsQmL9NuwuoEoeXzZp/hxJRcfoQSMohZf5qZ25QQaME9pMsNmeFO4FH719sSv/4v+9M
         xGu7evGR7wwAkaXrwt/ND6wrpkkpzcZ+aW9zxevYv+KO3dtg/9I4QnNwWhT+SELzdw64
         DrcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t43upwUK0feeI320sY22/K/H7Nx8XNjdpVO2i6jn6cI=;
        fh=WRlfBNqcWQTtTQGTCDrdglthCw3R8K6x0AoZEo35klc=;
        b=GXQaSvt448xUQd14/4aDPn9IvfEqKVAx6qhzd/VD4crROryitNmxrmpMrBPg4VevhG
         LG3u5eCT9cKj6jCv2zeSTJ4XOupi+mI8EhoPntMEiMHqJmBh/3sqqcZQGGVEiFcUc7f1
         m6wc92dKSecqQJJSucOPsxLFj9qfDEShM90+XbZt0tOgc/ytdohQsXsaJHg4lAjc1PGQ
         jjfJsUdqKxXLGEEakqOo66xYMqi2jfx283Z5JcavTCkSSfPOhbs1xnUitSrnlqHUObKs
         B2syU75Ufp49fF5K74KTlGHqKkQsNvTSrLt6zULLMXMieaiRXbOaFHQh0MWH5uRqNyTq
         p/Qg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790080510; x=1790685310; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t43upwUK0feeI320sY22/K/H7Nx8XNjdpVO2i6jn6cI=;
        b=cOhweyTCq9TPNplsAExw2+HLrLB6HCB8o6MSOxS5kRvTmPzFqCUCa1I+ZLujgc+uyv
         i1cJb8L+lwFa3eIQVPaSJbhnXBieDR+ezaCBwR0MwhaxeIJ2fWeGRQaAEBA/lK2Mttlu
         5Wu7XEXzi2pN1tK0O2O+OPNLtoVft2VOdfBc3NKyrMSr0/GSyVzkQbmAiHZWzqvAvGHh
         shgSVg/LGX/5EZgWY4mc+c+S3UA/tHM5xQnE0cy+PIMlF2OIrTkL4j1hlBxgrc+ra1VS
         YktvSww3zIZw5gnT8mTQDt8VCoTVQob1YcEihgJm8sqcuIly1FnCVz+/Jsl3U56+aZ9Y
         mV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790080510; x=1790685310;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t43upwUK0feeI320sY22/K/H7Nx8XNjdpVO2i6jn6cI=;
        b=CFKTK/PAceHKKAQxbCS62U9bMJec5CkNo1HTapHXLS9OMVvyY3OnsuDGfhLM7BZHZs
         0FuXsKUoyEJFvaomhUg9U3YIHZnPH6r8hrDdtJB9/gu4i7JlDlSbpsv4uoeV3yRyLR4B
         NEN85IN+trcGrjHRolNvY9EHWj8VN4bP1UkeSDRn/9Uho/Ui35Gzlxg+csjgdomb9Nz9
         gmWryg7AMbcEkulYyUXMtALBgMHbg88vwb2ETMQOvGonA1D/UJNiSWPwSHln9r1oJJSe
         inYt0T5QO0c+DxLX1Odc5wNcLfapr6mNOzrgj9WBMZBT8+hgqBkS0gQVxN3SDLyBpA7a
         7xnA==
X-Forwarded-Encrypted: i=1; AKwUvBwm5cey8HSb+oTH2yuBmjDMEhONhory5hPS1vDvJF6lQ9gTohBRV0ZCX3SL/RN92/34Vfsd0F5iig==@lists.linux.dev
X-Gm-Message-State: AFuF++kxoM04kb4DDnKRwqUwHF+gu+Jh+dccsRNBQiQxMWZAUY8fz18X
	ZpTBCIDsjKMc22yk6e6rh0+N4SkDeXPPfbAG59Jk88PqWOqPenWSrJ+cL+DTLWcNtrZb0OmlCX5
	FbmLIGmVk6yrtSZ/k5bJExEQ/0RhBQRg=
X-Gm-Gg: AYBFou3QlHXBcD59LTet+3egZeQNz4746jNb92079mRWp/1jtiiA2icaaJWCLmxx8R/
	uizJsbQlTRzDppw9bv5/xfby1K7upniMosr05EjPZ5KJT+MTVkN8pcY+J/Zk4Ymll8+cZ2Ojrlt
	RryJhmfbxWRTM4NXVCUlvy6RhPGsfro2ts6rNGnYxZCp3j3G2d/zbxe9sDP3JGpeRpaaqHtJGVa
	gL26wyeYdL68LpKSq58yHfS9u6MaYnq8zmvCJTRjkD2iN9dzj42E3E4cYuUvif4hgZcROOgffI5
	2k/kv5TjtKvh9PB3CVNDIXx0mJQyuc4oTViVXFid/NrknnucovfBAjjL
X-Received: by 2002:a53:c847:0:b0:66d:14db:b5a4 with SMTP id
 956f58d0204a3-67182e32973mr6312973d50.1.1790080509741; Tue, 22 Sep 2026
 05:35:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922120330.127262-1-itai.handler@gmail.com>
In-Reply-To: <20260922120330.127262-1-itai.handler@gmail.com>
From: Itai Handler <itai.handler@gmail.com>
Date: Tue, 22 Sep 2026 15:34:58 +0300
X-Gm-Features: AclHuK9M1FiHPYW0MDamOqCGXrHsZodxWnPTe6_1DsJAstTJCmij7YJNysXMWIE
Message-ID: <CAFpOueSSGssTvQ6q2q-piK4uzdaoUQBvtU4H_yjvN7hyfVa0uQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 3:04=E2=80=AFPM Itai Handler <itai.handler@gmail.co=
m> wrote:

> A patch doing that is posted:
>
>   https://lore.kernel.org/cryptsetup/20260922100554.28692-1-itai.handler@=
gmail.com/
>
> It is not merged yet.

That cryptsetup patch has since been declined, four minutes after I sent
this series. Correcting the record here rather than leaving the
reference dangling:

  https://lore.kernel.org/cryptsetup/d3823e0b-3387-4b3a-b5e8-a3d5f266308a@r=
edhat.com/

Ondrej Kozina's reasoning is that the missing upper bound in LUKS2
header validation is deliberate: bounding it would stop an older
cryptsetup from even dumping a header that a newer dm-crypt might
support, and the corruption case is already covered by the LUKS2 header
checksum. Both points are correct, and I have withdrawn the patch.

It does not change the position of this one, and it is worth spelling
out why:

- cryptsetup caps the encryption sector size at 4096 on every path that
  *writes* a LUKS header, and this patch does not touch that. No tool
  creates a LUKS device above 4096, so the portability of what
  cryptsetup produces is unchanged.

- A LUKS header declaring more than 4096 can therefore only come from a
  deliberate edit, and as Ondrej notes LUKS2 metadata does not protect
  against deliberate harmful edits in general - changing 512 to 4096
  breaks a device just as effectively.

So the paragraph above should be read as: this is a case that requires
hand-editing metadata, upstream cryptsetup considers guarding it the
wrong trade-off, and I agree.

Two remarks from that thread bear on this patch. Neither is an ack of
it, but both are worth having in this thread:

  "There may be support for larger sectors in future dm-crypt."

  "Since dm-crypt constructor currently stops you from activating such
   device (w/ sector_size > 4096), it's ok."

That is, cryptsetup deliberately leaves this limit to the dm-crypt
constructor. This patch keeps it exactly there. It only changes the
limit from a fixed 4096 to PAGE_SIZE, which is the bound dm-verity
already applies to its own block size.

Itai
