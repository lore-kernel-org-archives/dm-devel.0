Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264D333FE
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730664810; cv=none; b=js6Xf6Ae0K2S1Bar1L6P2ByhQPTbaQOa7gVpoAOni2Ay0t6PO6Oti1l2I9uyxvK+Wd86vXFLS2VEE+lUoZtEGtqCH3QRbvCoG++t7iEBk53q65U6azmTyM5qUYpBmR1oqQeI30olRG91Huxd/zge8T7nC48iHwD/KHXAnCFLi0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730664810; c=relaxed/simple;
	bh=znx4Ol+dyasz3n6WJeXXhoqYW+1q30JOp6LY1YAf4Uc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G59Wf1QWZmT6GO+fqnTKFWCnxCskJ7NgTjH93qK7FVWtC37tRQf+BZhGGN0pIO0Q5KRnAuqnwCrD890Pyxw+7dvX236iU1jkG6D/EVm6W7WbI3SdgrcyXNvKq4lRzaWU3TxKJmkAxAOqsUZIQHgdbHttwpn5wYNAMZ6kA021AiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aPV3VbeB; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aPV3VbeB"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d447de11dso2878270f8f.1
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730664805; x=1731269605; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=znx4Ol+dyasz3n6WJeXXhoqYW+1q30JOp6LY1YAf4Uc=;
        b=aPV3VbeB+CrKNsDibPvQnmnvxeWra7UK8HHXkqqYIQO3Ej0ijyasMguBJzD1xUA4tx
         70eXJ3lfqA8lKhSI1XFrVihdT6Pr7LhUkqp1k5Bwg82UnLqPuB4OusRSRZjmdoVKQCOy
         LAims8gRH0WZHnumSeI1+J/UGv/NtTYbq4F9UwiZm6PmBttJrGO3g+io0HtL7UwhMqrR
         jysx7iuXhxdM7nTOFL/SruVYono2YtpEAd4xBsCM+SDFvUr7jz+fLZAQnx5Sufk8dxuf
         7KNsqsU2wABOvXrDFP8lybKF1/3tZQ+6ZO277EwHagx8T5xfT7+ginhjEgfmmEI+KSXZ
         qKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730664805; x=1731269605;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=znx4Ol+dyasz3n6WJeXXhoqYW+1q30JOp6LY1YAf4Uc=;
        b=i3G8L/+CgjLGmyBgex8ctJy/MNUfrYRiOvvukTbq+XALHpPJ09+viM33jxFJGCOBfC
         zSWbt+p2dUQ/jMKoW/V363D6g6DbL4pND28zjECN8rVr7OWtDxqngXfsU+MLKdjlXZO5
         Suz2uTKI/gUzg9ui7NpvicHX6nGCABawR03mIa/j0Y/wF/MJg4w9eNO7vLRoROdNczN1
         FCJ7bUxehlcvXAaYXrlchMTqlT4pRKyfW2sLlWx2HPKAUHHGl/WeVl9+hqQVRz7Rgvoh
         IIHOwQ2nkVBPVvh/Ku1uUU0n04d2aYBSqCRbYoKFW1/lpbk+b5Xi0IdaU7l2XxU5NWhk
         VUig==
X-Gm-Message-State: AOJu0YwRcUDF5xInDHnQI6MpEUjiJ+58v4QmeF/D4uXjxJFGxH4qpglz
	DnB2hiQ13ghetAARUS9ZDpkVaY+QO1D2U6lVbqp6pUtFiPdLQtz2idhQMai6cLQ=
X-Google-Smtp-Source: AGHT+IGEFZqBkFtTWamn08ru7dZiQ8w5UTppheAYEjow5jfo0Sb5aKtIg5SdshELpi3lM3arnegT/A==
X-Received: by 2002:a5d:6c61:0:b0:35f:d70:6193 with SMTP id ffacd0b85a97d-381bea1c0c9mr12070206f8f.41.1730664805083;
        Sun, 03 Nov 2024 12:13:25 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d35415a640sm41043946d6.89.2024.11.03.12.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:13:23 -0800 (PST)
Message-ID: <9b4be59b0f7258aaf165d05a5023d82bf4243a8a.camel@suse.com>
Subject: Re: [PATCH v5 11/23] multipathd: split handle_uninitialized_path
 into two functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:13:21 +0100
In-Reply-To: <20241015032835.2693247-12-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-12-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> Split handle_uninitialized_path() into check_uninitialized_path,
> which
> handles udev retriggers for INIT_MISSING_UDEV paths and starts the
> path
> checker for INIT_FAILED and INIT_NEW paths, and
> update_uninitialized_path() which gets the path checker result and
> reruns pathinfo if the path is up.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



