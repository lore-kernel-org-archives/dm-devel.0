Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F3D2D0606
	for <dm-devel@lists.linux.dev>; Thu, 15 Jan 2026 10:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768473457; cv=none; b=pt7SzUmzzRsQHtcJoEgJ7iUuphTlkZhJz9h9X5oSfcLq/nwwUJLBbqXaZSJOxikjVC40oAmCyBSjSx9ouFGepJINIRZ5nmMXButU6aM1m5yBl6lbN7NomtEz50O/7nDHuAcN5v+k1Ryra9KfxoMs4WEiPWa48Pu4WVUrRyRgB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768473457; c=relaxed/simple;
	bh=wMHfTGtCn/Cp5rCdpRSRQAoNuPzm8mGo2uEIkJzXPew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NF8OY3/K8T0hhwDxEcS6YmVCSQagspZFfQzUYlG2XsO7cfjsdSlFkl5NvAgd1iJ9zkfCZkQDiaWutAU8HrAETLk0eryQvUshUPBvI4qoURaygIyuEC/x/SLJfNx2wMxSTMB1NE+xMOweiY9+J0Ai58qGLmmFtXAVMQK33gH7cnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgvJkKKs; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgvJkKKs"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6455a60c11fso509125d50.2
        for <dm-devel@lists.linux.dev>; Thu, 15 Jan 2026 02:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768473455; x=1769078255; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMHfTGtCn/Cp5rCdpRSRQAoNuPzm8mGo2uEIkJzXPew=;
        b=OgvJkKKsOLjPT8H/5fwNuDbUj9XRIU24vLEtvryMy30pvs03BM9mFBLNZkddhoyciF
         ZQxnuGiLcFynHBU5AEpmbuVe0CZULU8FCQqm0WGASLsYod1ACmciaJTkn4rS5gLWvyD5
         QEYyNoB+dN7Z2Wnk2x5P0GEM/GnDO92G7lo9nms6pJ32Gf/iu5UrVsAeKJtWlXuBCj+G
         OUp/ECXCPaRMPXIucHoBFCokAYgvzZzH7TI43Cfu9rZAcbHSu7MyWxVLMoGY22ggzTFq
         TIyuRdUfjl554/4f+tQQi6+wkg3uuNRENOgsO1Q0EDBGtI0oPJjyZ5pHDgmY3tKied13
         VLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768473455; x=1769078255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMHfTGtCn/Cp5rCdpRSRQAoNuPzm8mGo2uEIkJzXPew=;
        b=pyUUwMphLqY/JZRxMwrJB2Wk27qOTTSWefWqs2n8uhdTmqD1k45oay7pbAf2OKBom+
         M/fDTy3Htlrq+MdTN1yfKSGD8FIGywrFeNxLXUW+QJjWx6AKAu/mOt+X1m9pwhG0GbWz
         mZV2lY4q+/Nn7/0iTxyb5t5x7MvIRMYw93qwzXSedueYUSalgVo0F8UE3ggx8i+nuKaF
         Wz4rJWvF+36fYe5FVnSUSTntudSdKP7gZV9HkhBEBfih5sqZ7Y7/dIWxR1Jdwb1kM1fn
         O09Eq+hwIP9KaRGCLDjGNZYPzhyGZB5KipuhqElXinwUHFDbQJDi4fgrKAuHE+x+a9MV
         H66g==
X-Forwarded-Encrypted: i=1; AJvYcCUA4E2MCgte01OQBV5Kw/odMDmmfRhi8ibepS8mtHssaYhmXwY3Ebr9Bqp0bZTVM6IkBuMWeC+y1A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJFLw24K37g/AJCZHVgyxFeCRLsKA5guegrrkSlqI+HK3mYl/a
	wMunZehxqQcrrF4XzfEKxMsF+fOly1t9K7yEtV9+79NV/PuNPGB/0/6kOVVnno6P7xGHYf3f7f4
	PX3OnzSr4KjZWSMH50EIZphCP/KNt118=
X-Gm-Gg: AY/fxX78stbcw4hwqrf4a7G/fy5UGtJWv1TiVDYAEgUua4DPeLzhacS4OoBPBpDYQ2F
	BoPvDQ2R6OyiDqovdHDGzUQ2hKAlDOdtiOZQpzUO9ag44TKK880H1wWdg42tanR54D5W6+AZNyN
	4spCGsWdu/D5q6Sfqrgggpto0SENDNlOs5WWhhuk85TTrlDX141i84K+m5Es+xQYcXt5NfzfeZN
	gexbyNlJUGQHrrQZS7wC7TGor5pkFFMx6CXnsNSFteT+/j82pciWYB/MZAfpuWudhOIF4Y=
X-Received: by 2002:a05:690e:1893:b0:646:5127:ad81 with SMTP id
 956f58d0204a3-64901b29241mr4226063d50.95.1768473455240; Thu, 15 Jan 2026
 02:37:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
 <20251211182429.3300562-1-safinaskar@gmail.com> <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
 <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com> <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
In-Reply-To: <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Thu, 15 Jan 2026 13:36:58 +0300
X-Gm-Features: AZwV_Qhtkh4Hv5K6ULjZc1z1XJ89DJDGm5amELxKsmdkaAk7JPublSpdt5t7sQM
Message-ID: <CAPnZJGBkR-ossXKGAj-62Wf-stiuWUwKQUGNo286J_jEiA+nDw@mail.gmail.com>
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is exhausted
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, adrelanos@whonix.org, arraybolt3@gmail.com, 
	cryptsetup@lists.linux.dev, dm-devel@lists.linux.dev, gmazyland@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 4:34=E2=80=AFPM Zdenek Kabelac <zkabelac@redhat.com=
> wrote:
> You probably do need to configure your systemd-oom killer to prevent gett=
ing

[[ I think I know why I get this behaviour, see section "Why
dm-integrity behaves so"
below. ]]

I don't like systemd-oomd. It starts to kill processes long before
both memory and
swap is full.

Let me repeat what I need: I have big RAM and big swap. And I want OOM kill=
er
to kill processes only when absolutely necessary, i. e. when both RAM and s=
wap
is full. systemd-oomd is opposite of this: it kills processes long before t=
hat
moment, in misguided attempt to keep the system responsive.

But for me my apps are more important than responsiveness. I. e. 4 minutes =
long
freezes I talk about are lesser evil than killing everything.

So I explicitly disabled systemd-oomd on my system.

> configuration - as OOM is supposed to kill userland RAM hogging task much

I will repeat: "free -h" output at that moment showed that my RAM is full,
but swap is 23% full (87 Gb out of 378 Gb are used). So, there is
a lot of space.

> So I think you should also show whole device tree of your system and some=
 more

My system is not unusual at all. It is a laptop. With 64 Gb memory and
378 Gb swap.

I will repeat: swap is located on dm-integrity.

CPU is Intel Core i9.

> information - so there is even 'remote' chance trying to reproduce your s=
cenario.

Here are steps to reproduce:
- Take some high-specced machine. I. e. this should be machine, which
is fast, and which never experiences
slowdowns in normal situations
- Put swap on dm-integrity in journaled mode
- RAM should be 64 Gb and swap should be 378 Gb
- Open a lot of Chromium tabs until your RAM is nearly full and your
swap is 23% full
- Work at your computer for some days (play Youtube videos and perform
various other activity)
- At some point your whole computer will freeze for some time, say 4 minute=
s
- You will also notice that this happens with journaled dm-integrity
mode, but doesn't happen in non-journaled mode
- (Kernel version is 6.12.48)

I'm nearly sure that everybody will be able to successfully reproduce
this. I don't think precise device tree matters.

=3D Why dm-integrity behaves so =3D

I think I know why this happens.

- Some process needs memory, but RAM is full
- So kernel attempts to send some memory (i. e. some page) to swap
- But swap is located on top of dm-integrity
- And dm-integrity (in journaled mode) write everything twice: once to
journal and then to final place
- So dm-integrity layer at first writes that page to journal
- But journal is cached. Using so-called dm-bufio cache
- And this cache is located in RAM as opposed to disk!
- So that page is written to dm-bufio cache, which is located in memory!
- Thus this page is not actually removed from memory, it is merely
moved from one
memory place to another (!!!!!!)
- This means that the system is still short of memory (!!!!!)
- Thus kernel attempts to flush to swap more memory
- But this merely causes whole process to repeat

I think that is why I experience freezes. But I'm not sure about this.

Also, I will repeat: this is merely an experience report. I'm not
really interested
in fixing of this bug. I merely sent this report for your information.
I personally
switched to non-journaled mode, and I'm happy.

I'm okay with sharing more info about my setup. But I will not test any pat=
ches.

--
Askar Safin
