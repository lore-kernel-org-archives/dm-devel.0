Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394AA13777E
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727376126; cv=none; b=IVG9c72Kmc9fQltucFTDSDI3HE3fkCWr+Aw1g6rCwFkw6kZRk6Zz/AwU8/Tv+eAK8Ab03LIdU3cc3625GagG/mjC058zsk01y2FskflYEpHJPqOvn8nIE2+LWVqY+fYKjVTMhucEGR8b+D1vFGaEQDxik6W2SDhMuuL6nGkdFRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727376126; c=relaxed/simple;
	bh=mdtWgHOSv7cRSOQz0SWRBzCItlrZRx9Rlk9Xf54gNQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tytEMCoBObBYntBvDt8dfPrz7JZSO56RbOSJomk2eplBIaYooYnTFVmYAAgDfNirviY68Xps+iLqaNLCzrjVX+dqZ/iXsLD0bsBdJFMxVMkUnrm5RBLiI0MM+0wQWV5g0PpQG2jaJEu34/K44Dd0QiQmII7kvAjGJZZydQeOjag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ccaUXG+B; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccaUXG+B"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e22531db3baso1337590276.3
        for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 11:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727376124; x=1727980924; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mdtWgHOSv7cRSOQz0SWRBzCItlrZRx9Rlk9Xf54gNQM=;
        b=ccaUXG+BE5mm33SJ+Yui8xwDrtH8xWz6o5RnixSqrfQPcjvlMjYgiHHKBUTcz50hpr
         8ALSQzL8h4FpGhphIs/hmYggY4N5wRnhtnqVkkYba/awDjrzKCNB/67bzQxJIZ6iBsvJ
         5D+tNoMLAXB9QFOQ5971LBGjq6PNwKWaJ0PyYaYYMX+uz7Vjr5cQEZFSmrN56YHfL5mt
         Ulp0Y2aLlwWac4uS8MJCXz8fPhb4r9E/RhtIUWsfrORTYPsDEz1DZ6S9OmNRbjWPKkvz
         Umtj9xipAd7V1+84wr8wRgJS7UA8Yelej+To/m3sHFCiBe5TDy5IsMPD8McKzT3+GxRz
         qEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727376124; x=1727980924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mdtWgHOSv7cRSOQz0SWRBzCItlrZRx9Rlk9Xf54gNQM=;
        b=SgKTQ8aQmqkciF/kr71907sMSO/iV0RWv6SqNziqzirsy4jbXmOWEs4L5VUbOlG7mT
         tuwbwgzU+JZYEf0rN1zafuVaIvTNFO9xzi6ui+U0zITfuTZM/OJ9SofMrPlFJRsMYJQF
         bx8mZ+FT4UxmNNkVTMXdFNJDHzpyi/WQAZNpS0sj7oazklhdHzR3x60V+1wcUUuMNN3g
         TJ9os8lFNzu2RflmMjTRioyo8fzoKSpV4X+Ku4UB5KatdYpa1WOl+t3rXa2YPzFBK779
         0Wzi28QzEPu8RCU5XbTaQ//cBJbHgbDzQm03M2/j4pK3zJRno8s33WBV+0oFV6cClz7R
         4jtw==
X-Forwarded-Encrypted: i=1; AJvYcCXXDklzo2OASDMq5cofYMEn176aPrEmx89TRYEDcpNpG6NX3aA8rSlJkjEWDpFD+c1kM9xKdZlQCQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwGz1Vz2uugAoz5yCuyMCDAOpYfmXnPSpHF4clg7Msbmtj+Nlsj
	HIhL7EbyYdxlyrnoKkwkfH29+EvhrYmqClwluH89DX7KKPTqb1zj7nQHRbGYkJmXMRm7Wlok+8n
	FXuKF0jEk82g3JTWeZTkcgK5uNfI=
X-Google-Smtp-Source: AGHT+IFxxwt2ziwHX3VZSiIejAqJupJVSo9A6X8dRmAcBQxSLsutS5O5WpbZXt7KM2viC3lC+PdWGR9Kpie1GRjeDzA=
X-Received: by 2002:a05:6902:11cd:b0:e25:cf31:eef2 with SMTP id
 3f1490d57ef6-e2604b7d8famr337103276.28.1727376124204; Thu, 26 Sep 2024
 11:42:04 -0700 (PDT)
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
 <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
 <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
In-Reply-To: <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
From: Maxim Suhanov <dfirblog@gmail.com>
Date: Thu, 26 Sep 2024 21:41:53 +0300
Message-ID: <CAKeu6dXFxY8HaZM0m4ZPY2dM8J4WfjWoR4XpKm47nbY1k8_dhA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
	dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

> I thought about this a bit more, and I agree with Milan. I/O errors
> can be temporary and applications should be expected to handle them.

Are we sure that I/O errors always reach a usermode reader? E.g., in
the file system metadata corruption case (like EIO for a file system
driver becoming ENOENT for an application).

> Android devices, which I assume are the largest users of this
> functionality, are expected to switch dm-verity partitions back to
> normal mode after the first restart is triggered, and userspace is
> therefore expected to handle I/O errors gracefully anyway.

And there is a warning displayed:
"When booting in eio mode, the device shows an error screen informing
the user that [...] the device might not function correctly."

https://source.android.com/docs/security/features/verifiedboot/verified-boot#handling-verification-errors
