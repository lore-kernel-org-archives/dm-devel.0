Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A330DEBE
	for <dm-devel@lists.linux.dev>; Thu, 23 Oct 2025 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761218968; cv=none; b=heDPHQkoMboyvrbD2jHbyWUxyJSkmny5jp+NMOneNoNif7vaYvPo+vI8pdChigxbLkMTgLLgtxYeIowKuzy3PetZ3w+PI3ia8LURQ+1rrEarqxsFdpla+MD1QdHphm6q1lJafvYhTsXo+jpP2fvLyU/OsEYLlGXBrwxDcc1aSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761218968; c=relaxed/simple;
	bh=xp/QLlNgU9yT5Z0c6lOZJJZGC+bWM5/vOMB349Lhr6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Avm0k1ukq3si3V9Hpp2Q0AwhnqMDnwZW8jvYKWfJC9DKjqgtdAx5arIVapBV4qGUO5ZLKSKeI+kOVub4BBQsxaf159FDDDi5tf+tYEvswF9ZuheRqF0jg/Tg3/YueZVyJ2C10xyJ++lWisg9qh5RRa3Y1x29Jj+mqkfXGjcp6L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4GOOwsE; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4GOOwsE"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b6d5c59f2b6so54699066b.2
        for <dm-devel@lists.linux.dev>; Thu, 23 Oct 2025 04:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761218964; x=1761823764; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GOi8L/T/sc914HyVaQllPfco9t+JbsWkC8LrVlAzwL4=;
        b=b4GOOwsEWBZT2dzhL4RuTjhg4W1cyorM/fa36AkGvpgEId04xONVilvM8iZE1Nlw3P
         Pz5itUvydD1wtQDbRTNjxkkVDZKjltSWfdF5MqtEuz6i7i0RVrMETAB2EIihtZH826ZI
         ITf1khXVe2s6npcQ+eEbz14uFH19M51iFlErwJ/evzt3GHPj6S2818U53ezHHxH235dF
         DIGSP9ZpQQqWE8ugfMWkQXRuxVT3Y3LIq9OMB1fysLgg1/eo/DrsTYS38hCI0IOeHbI8
         HHEYWE04dPeNrPQfwSipF3hNf0C8fCVym0LGuof7uAmf5h1AhrWNZs+ZLxQ/ptio1Pan
         lrog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761218964; x=1761823764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GOi8L/T/sc914HyVaQllPfco9t+JbsWkC8LrVlAzwL4=;
        b=TuNI2E5K92Hk3nih2hM13s98M84U9BSYpp4K0GFbjTpUThygMhJp4UPfBi7QMAidF6
         ERka42uXC77bM5T9qAZfXPRPjOjj1CSjyZyuujK4e3sZ62GNIXmDGXVL8GXRJ6Gp9cqG
         eXt+eYG7IdwocH/0CYxiXKIwZfaCEsyuSPY5OcmFwbTfE+YCE73LvEGZOR9FFtU8DLH0
         7SroK7i3/jbBkLDt+7J+4HpYZBmYQAbFSxGU/T6Wc7cI1zeW0L45Yiw4G11sbF+w9EQe
         dsC3LkWsmbmy0vNb/5ta/23N6OkaRuPM2S6NtiqZsfhFc4UbnI6AvErtLOuKoVoAbyiL
         dMIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlCo/I9RCRLH7X+bWZ5RagJOMe23YQbYjvmnA62Ll5SWd8+z7v1rBGl7KUTc7Cv2YSFhqs6N6p1w==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywant7CyDnK/xD2VI2PfWoCm9PaeAbXk8H6+HQBh1OjkiRRP/IV
	7kXS6tCtpJQctx4C0Z4EYdoyKeVcftWgD4PuorUWBU2OqMUkStJvUvvJ
X-Gm-Gg: ASbGncsWXgDvgoYKmcZQMasKdJ8Me+bWuxiLHyTNJQIhoFzWaCCCNW+XSbxiR0kh0PV
	JdZ8rMyCNEC24ZW7S9Q+RJ68WtVnuNPf1o/LIMT989MHA9XWC74v8IwKMBKEpsN3g2hXdpNOZL+
	wtcQO6qBgL0g7UH6KPjOGxd4jEpu3+nfnCAoO6x1BTq0yJXjJTVVhAe2EjAAqT9JaJTolLGpsQu
	sm1DR+TdaWcM/0gwrSCHpxe2Htx8+kEk49W24zH0RmYPKS0/J8kc/KqBjT9c1jpInxCo4f4sXms
	owfgDjTzOLFuSM7KU2WBb0fIT7zNqDfCcN8dmOewhI2amWTrGYMRZsOPnpRexOVGcOle0sSc5bu
	tsby/unQ4l8EAmIjGEkspKxcvF+HPzUrrqlhDoFJL9krp9ruWhf/qV1+NRAmxhbonpRE5dNino+
	PX
X-Google-Smtp-Source: AGHT+IGVcD+OUFGiPRHpX8Zf9AyspMjR70F5rNVEqM4+m7vN8XE7B3HIHBPjz9kYyXDPcdhsgkufaQ==
X-Received: by 2002:a17:907:1b06:b0:b6d:2f3f:3f98 with SMTP id a640c23a62f3a-b6d2f3f4014mr685674566b.41.1761218963986;
        Thu, 23 Oct 2025 04:29:23 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b6d51471ef6sm182393366b.72.2025.10.23.04.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 04:29:23 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	lvm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	"DellClientKernel" <Dell.Client.Kernel@dell.com>,
	dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Cc: Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <ryncsn@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Rodolfo=20Garc=C3=ADa=20Pe=C3=B1as=20=28kix=29?= <kix@kix.es>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Lennart Poettering" <mzxreary@0pointer.de>,
	Christian Brauner <brauner@kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>
Subject: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Thu, 23 Oct 2025 14:29:13 +0300
Message-ID: <20251023112920.133897-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi.

Hibernate to swap located on dm-integrity doesn't work.
Let me first describe why I need this, then I will describe a bug with steps to reproduce
(and some speculation on cause of the bug).

I want a personal Linux laptop fully protected from data corruption (cosmic rays, etc).
And even if data corruption does happen, I want reliable indication of that,
so that I know that I need to restore from backups and replace faulty hardware.

So I did this:
- I bought a laptop with ECC memory: Dell Precision 7780. It seems to be one of
the few laptop models in the world with ECC memory. And probably the only model
in the world, which DOES HAVE ECC memory, but DOES NOT HAVE nvidia card
- I set up btrfs raid-1

So far, so good. I'm protected from both memory errors and disk errors.

But my swap partition stays unprotected. And yes, I need swap. I have 64 GiB of RAM,
but this still is not enough for zillions of Chromium tabs and vscode windows.

And, according to btrfs docs, if I put swapfile to btrfs, it will be exempt from raid-1 guarantees.

It seems that the only solution in this case is to put swap partition on top of dm-integrity.

Note: I don't need error correcting code for my swap. I don't need a self-healing swap.
The only thing I need is reliable error detection.

There is discussion on Stack Exchange on exactly the same problem:
https://unix.stackexchange.com/questions/269098/silent-disk-errors-and-reliability-of-linux-swap .
I think it reached the same conclusion: the only solution is dm-integrity.

Also, as well as I understand, md raid is not a solution: when reading, it reads
from one disk only, and thus doesn't detect all errors. It can detect remaining errors
during scrub, which is too late (wrong data may be already consumed by some app).

Also: I don't need encryption.

(Also: there is other solution: "cryptsetup --integrity", but it uses dm-integrity anyway. We will
get to it.)

Okay, so I put swap partition to dm-integrity, and it worked!

But then hibernation stopped to work.

And here come steps to reproduce.

Okay, so I have Dell Precision 7780. I bought it year ago, so I don't
think my hardware is faulty. Also, I recently updated BIOS.

My OS is Debian Trixie amd64. My kernel is Linux 6.12.48-1 from Debian.
I created swap partition so:

integritysetup format --integrity xxhash64 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7
integritysetup open --integrity xxhash64 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

When I need to activate swap, I do this:

integritysetup open --integrity xxhash64 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
swapon /dev/mapper/swap

When I need to hibernate, I do "systemctl hibernate".

And hibernate appears to work.

Then, when I need to resume, I boot to my hand-crafted initramfs.
That initramfs does this (I slightly simplified this script):

==
busybox mount -t proc proc /proc
busybox mount -t devtmpfs devtmpfs /dev
busybox mount -t sysfs sysfs /sys
modprobe nvme
modprobe dm-integrity
modprobe xxhash64
sleep 1
integritysetup open --integrity xxhash64 "$LOWER_SWAP_DEV" early-swap
sleep 1
# The following "blkid" command should detect what is present on /dev/mapper/early-swap
TYPE="$(blkid --match-tag TYPE --output value /dev/mapper/early-swap)"
if [ "$TYPE" = 'swsuspend' ]; then
  echo "got hibernation image, trying to resume"
  echo /dev/mapper/early-swap > /sys/power/resume
elif [ "$TYPE" = 'swap' ]; then
  echo 'got normal swap without hibernation image'
  integritysetup close early-swap
  # proceed with fresh boot here
fi
==

And this doesn't work. Hibernate works, resume doesn't. :)
"blkid" reports swap as "swap" as opposed to "swsuspend".

I suspect this is because hibernation doesn't flush dm-integrity journal.

Also I tried to add "--integrity-bitmap-mode" to "format" and "open".
Resume started to work, but when I try to shutdown resumed system,
I get errors about corrupted dm-integrity partition. (Of course, I
did necessary edits to initramfs script above.)

Also I tried to add "--integrity-no-journal" to "format" and "open".
It didn't work, either. (I don't remember what exactly didn't work.
I can do this experiment again, if needed.)

Then I tried to do "cryptsetup" instead of "integritysetup". I created
swap partition so:

cryptsetup luksFormat --type luks2 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 /tmp/key
cryptsetup open --type luks2 --key-file /tmp/key /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

And, of course, I did all necessary edits to initramfs.

And this time everything worked. This proves that I didn't do any mistakes in my setup
(i. e. I got initramfs right, etc), and this is actual bug in dm-integrity.

Unfortunately, LUKS created such way doesn't have any redundancy. So this is not solution for me.

So I did this:
cryptsetup luksFormat --type luks2 --integrity hmac-sha256 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 /tmp/key
cryptsetup open --type luks2 --key-file /tmp/key /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
mkswap /dev/mapper/swap
swapon /dev/mapper/swap

And this time everything stopped to work, again. I don't remember what exactly went wrong.
As well as I remember, that "blkid" again returned "swap" instead of "swsuspend".
I can run experiment again, if needed.

The commands above use dm-integrity internally. So we clearly see: if dm-integrity is involved, then hibernation
doesn't work.

Here is a user with exactly same problem:
https://www.reddit.com/r/archlinux/comments/atg18t/hibernation_wipes_swap_and_my_system_hangs_on_boot/ .
I. e. "hibernation doesn't work if swap is on LUKS with integrity protection".

So, please, fix this bug. Or say me how to solve my original problem (i. e. achieving full reliable error
reporting). I'm available for testing. Send me experimental patches. I can provide more info, if needed.

There is yet another potential solution: uswsusp ( https://docs.kernel.org/power/userland-swsusp.html ).
In short, this is hibernation driven from userspace. I. e. uswsusp allows for finer control of hibernation.
Thus, I can write my own userspace util, which will do hibernation, and execute "integritysetup close"
after writing image. Assuming that original problem is what I think (i. e. lack of journal flush after writing of image),
this may work. The problem is... latest commit to userspace implementation is dated 2012-09-15
( https://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git/ ). Do I really need to use such ancient
technology? I didn't test this yet, I will test it in coming days. Even if it works, this will still mean that dm-integrity
is buggy with kernel-based hibernation.

-- 
Askar Safin
