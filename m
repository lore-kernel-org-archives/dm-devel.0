Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DC34F8A0
	for <dm-devel@lists.linux.dev>; Sat, 24 Aug 2024 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724523164; cv=none; b=RM/Klp/Nj+k9U52txh8g/hAyDyMbx8ej5aynoGmiazrQ+muldJedmoy6FWLgAphv5ag1WxSwaJE4r+JcZwdASjKTYAFZkAyi++d+/LZuhccV8SKQZnNl4tsSIE9cWmVx7rf98TsrhkNuHbJX5K5YCqyW2V9VW2sSnyds7GKdeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724523164; c=relaxed/simple;
	bh=YETSCOnsIeBZ5iZDbo+TpWNJY/YMahQmhW+4xSvK7Dg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NaWtBGhZAk37r8RbAjkR7CsgjlBBUR6PelI1JEjWwGjhWg0Lzd14cu2adXynLKD48QIoOFJJoLaZZxDohvLrv/gKZVKsWOln1lweUKBCyxvVVYzegcxunov7onWofHJgrKQLVOUu5Xr2rvnaL0qBGu51QhMwOmdlrGVfdbP+dLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=KnGIDs97; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="KnGIDs97"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2d3c99c5d69so359980a91.1
        for <dm-devel@lists.linux.dev>; Sat, 24 Aug 2024 11:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1724523162; x=1725127962; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ElACriSOYd8nAcwknSV71BfVzwApL6pof2DJpT2TA64=;
        b=KnGIDs97TxqW3Q2sfo5EcrWj2VYenLAuagGYLlvwJLSjGPQ6Y4bSv6a2n/a8tgm5tV
         9fBj7kNPyp6T48vm/VeURDtYoTApyM4VRWn1y5FUKz0PqA22zEd7RtBxEYEhjIZ/4dP8
         IlbwW4taido7Nv2IUk28eZ5oWwuSrxVmiGYmDNF8ytSl03aWy84pBaU7faWzMdQbOkUC
         l1hPC9P5qCny9wD4aR323sjMvCq2knpeARaJnw8A7u3y9WjE+09gKgb+zUu6VR2W1efY
         adYE46oj4kq2RbJXHJoloQ5Cw3ZkRSXvlkQOlxdugQ5rdc03wcr2YrnUp39NXMFVvRhW
         pyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724523162; x=1725127962;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElACriSOYd8nAcwknSV71BfVzwApL6pof2DJpT2TA64=;
        b=Ey/n7kvjX9ejztQ19gmAA+omgldYOrUeV0rPhK5iiaycaKzkvqLN6QkcnmDLWPA7nP
         Xx61zdhQn9C5xthBWnj49oSS28XRqoJ/LkRQmDwNbXEjbhgT2SdBralqB6+MLuHo64E5
         f4/kp9OP8AYMFP39iu2Qfscntj7nZ+44EigZWm967gR4pXjjNrwi109GcyunZ96Of3Sq
         MDSvWjfXWJkEHPUF9kPoTxno62jf4hI/haz8+iGnpTi2Bmz7Sby5Sbe4cp+szCX/q5E1
         juO1dWpFYVT1a05v4s7dZi/hiyx4OrXJRyrYbrwwh9U81rpRCEw0dGPUnD5ASewadIWS
         IWyA==
X-Forwarded-Encrypted: i=1; AJvYcCXlUDIteZgGDjkMQbpoQVp0NiYeVdRspv6DFKVu/+RXm5yi5MMNwxLuLo1NwvWgNgZyyW/uFGuf9A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwrCbzt8WWdUJbKghaIo68vj7wkrD8t9tuZuGLkXTNjU/oBPwKC
	T6i1YwmuxVRns9y55PldvG8E8PR/m36rqKnAuaxvhrTM3AcS5TH3tTN5Wf288YXZZfFtOOyx5/K
	Md6QvXriJAZm0rMU5HrG/OPCDtuSZ9eDM
X-Google-Smtp-Source: AGHT+IGyixcMUS2U07yKW+EnotEo6YYu3PSQ7EpZN9irpYOB9iCLFffhfwL9K4W4XpQ5UawHLxAI5RDAgZ7XOAt5UGU=
X-Received: by 2002:a17:90b:3709:b0:2c8:4623:66cd with SMTP id
 98e67ed59e1d1-2d646b9dc77mr4085809a91.1.1724523161975; Sat, 24 Aug 2024
 11:12:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com> <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io> <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home> <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <26292.54499.173087.840312@quad.stoffel.home> <595DE483-7F2D-4B27-9645-AC51E8B90D0C@gmail.com>
 <26307.45971.357185.491868@quad.stoffel.home>
In-Reply-To: <26307.45971.357185.491868@quad.stoffel.home>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Sat, 24 Aug 2024 20:12:30 +0200
Message-ID: <CALtW_agdJ9RLEit8=3MrOK2R=kT69wQj0oD1O5nEmeEh_WyBHw@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: John Stoffel <john@stoffel.org>
Cc: tihmstar <tihmstar@gmail.com>, Christian Theune <ct@flyingcircus.io>, 
	Yu Kuai <yukuai1@huaweicloud.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

> Interesting.  Why this way?  It would seem you now have to enter N
> passwords on bootup, instead of just one.

On RedHat based distributions, by default, a single entry will unlock
multiple devices.
