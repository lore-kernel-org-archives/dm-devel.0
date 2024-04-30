Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE22175560
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714499694; cv=none; b=Y694g3eEzaf88Oq2Tc7Cc2gtrrv7ncWZgmfQUI6EjiGg8uR3LsabZheqzka7pLDtP7vzEXuA/lkhEY7D2mapTy7M8F8sSuWAMnWbymjrPaSQq7Jn5+XRFJOz2OBb2F3XXUy35f6l5gvFQ9NuOFcfyy/floich/aj+fGNme/5eno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714499694; c=relaxed/simple;
	bh=JajfIpDaI/yq4q9+JKZr88WyiW/MMlFj62bmsJ8WTtY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ZjLXDJ7kgEjgaug04D50ui/n6ea3lBviBiNKfj0lLnA/9StwBhpwg9I43UMvE60DQbHXIqgFb8/AUlsB0T5XFDltRB3J1NqkRbsPC61v9dkjv2Hc3lrMYxj+4KxIjlMmsbtBbYgt1uVoko9R97uqJFpdb0poAEzP0QqwNQtKv7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kC4ZOQev; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kC4ZOQev"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a58e787130fso14003566b.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714499691; x=1715104491; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+cIvZk7m5hBvp56eIwGJOqKD7C6vbAOb/Qn31AA0GVM=;
        b=kC4ZOQevfUTtmueLWKN9W/uoSJzLtDvhlKGv0Xd8pxfTlSrnxDOyxVNnSKNISxVtei
         ex3FZVT3+lyo6YfTzg2PLgdCGq38CM+8RRMn3SPaaKlgXpE01IluiNkywgMULTlWBdod
         YRNfIbi1i57kOfAT7ZZipiL/+DMmzeeaAmZ7FptWOe/Mx0r5nB9/v6v288IRxVpdKm34
         I5nqaAFdYwCZAJTeHgp298r+5Fta6jPDyhdCdQljzqIidEA/YwmoI5hB4hSeODhwNNBf
         VrJ/QUzZ7v0JpJPOBHDhrIXfIfY5DfrJITsaPG63nfO8oysgAVzsBuV9+9noSU9Pxoye
         h5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714499691; x=1715104491;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+cIvZk7m5hBvp56eIwGJOqKD7C6vbAOb/Qn31AA0GVM=;
        b=G023yKYWnss0nVTofEjS2WNjzN+mExHZ+cCO+fWWoxU6qJBZaL8ffjw4UW0Sp7z3xk
         K7C+OO2L8/xgKmijHCktEL5JKKuuVe/6tskqkLqg0DkruWn+okpgeaTYhqqfQFY52bOD
         LG+FZhAlZwEPw60ip+Ch+w+LlB11YAlPA2l4hKB+qjYNQsJyOLMN28/DRh/wWqR0xIoH
         MwMEFpqmiLjr5uDQtmEALHP4aiIXR6Xyx9D21OdfLvDShnA9UCHbdsDATUlVrQhHb9iM
         stl8CylqfE7dJR1OPd6YXV2XjS/mSoJ9e7gEHMUq4ttHvCm5GOZ+lg2/n6V9lE6rEbmh
         umDg==
X-Gm-Message-State: AOJu0YwfojhFKJbw4sq+XKbLfURoztgIpdtPQaceDZAdkVzvTVVjlahq
	xoz6bwiu/cASerr6v5aIu+t8rlvu88lonu6iD3aZxhsi2R1lANC0r5+uYr+PMptVy3Nu8R1iZop
	SZrXFIq5+wympof5Ipdr1hflvJxlsOuWi
X-Google-Smtp-Source: AGHT+IEUVYhsoJDKegG1hBmdWUEyqOAfGkoV8feiTC5nx4mdcNpa+LlilCJM3DnTRfFfmcGB4QmLDHL1WYhU7PdSb70=
X-Received: by 2002:a17:906:6c99:b0:a55:adf5:e698 with SMTP id
 s25-20020a1709066c9900b00a55adf5e698mr3320442ejr.28.1714499691347; Tue, 30
 Apr 2024 10:54:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Michael DiDomenico <mdidomenico4@gmail.com>
Date: Tue, 30 Apr 2024 13:54:39 -0400
Message-ID: <CABOsP2PL9AM5phv4ZhucGmpk6V1x+DozXLaPTBVaWqMdy-KdPA@mail.gmail.com>
Subject: delete on snapshot does not free space
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

this is probably expected behavior, but i'd like to confirm as i'm not
a device-mapper expert

we're using COW snapshots overtop of a readonly block device.  this
seems to be working fine, however, when a person deletes files the
blocks are not freed.  case in point a RO block device with a COW
filled up to 100% as shown in df.  when i deleted some files to free
space the usage never decreased

to create the mount we do

echo "0 <realsize> linear /dev/loop1 0" | dmsetup create roimage-base-real
echo "0 <cowsize> linear /dev/loop2 0" | dmsetup create roimage-snap-cow
echo "0 <realsize> snapshot-origin /dev/mapper/roimage-base-real" |
dmsetup create roimage-base
echo "0 <realsize> snapshot /dev/mapper/roimage-base-real
/dev/mapper/roimage-snap-cow n 1" | dmsetup create roimage-cow

mount /dev/mapper/roimage-cow /roimagemntpnt

this is working as the origin device is Read-Only, but we can change files.

so two questions come up

1 when we delete files, how do we reclaim the space
2 should/can we roll the snapshots to reclaim space?
- if i wanted to create a new snapshot and discard the existing one,
do i basically just to the fourth step again to a different device?  i
haven't found a "clear" how-to on this.  most people just stop after
the fourth line and then tear it all down

ideally what i'm looking to do is create a filesystem where the base
is read-only, but we can make changes.  i'm okay with all those
changes getting lost after a reboot/unmount/etc.  the issue right now
is when df shows 100% usage it seems the only recourse is reboot(aka
clear it all out) and restart.  i'm hoping there's something more
graceful
