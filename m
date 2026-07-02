Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F44367B6B
	for <dm-devel@lists.linux.dev>; Thu,  2 Jul 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988860; cv=none; b=purPDh/Fl4X2RNF58/DKLmqUaXgtU45P+cHoNRZpnPzKkndJUTqK0nytGpudLBZfi5tB0iRj8q++H7udg+YTG3RzZqQ3wlkBhDmtiIeEFCiLDJkXK1VrhpLEHwebcF9PJ1Mc4hyLwwMXqPlGn6jlnes6zNN41tDZ6uR+fLdsqXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988860; c=relaxed/simple;
	bh=9YzbojeXNlnzLK1B5oj2JfvWshAWiMXeL6mmMwGfh2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtTEybkHhAOsZH9SSZSeS1dSVNavP9WiSRaaHFS7eu1RAIsA2L56nvXg7ZrdgXD8Tl9OX1dcpMaZznZRpG8SAHMjryUOlTj/FD9TBeyF3SnzRkROvwJ2blZKTpQ4jZ3rBgiT9UrGg/jlTbDLXiE/cDbEpOHHAlxX3zKuHov5Mek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hl/xZkjH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hl/xZkjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782988858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1S5rFZYWMM0y6IKRawKEvo5guFtOQNqmUYSlSoGfdlI=;
	b=hl/xZkjH5QxiK8tIpJNILl6LN6VtbgIFbVS8Qrw8xYjOrpWVThQUeeM3025kFPNq3rbbNN
	x5FZr7r5XM3neSEjfi0Gri4Qdw6orLe7A8PalQp1lBVYNK7xH/z7QkwePdq7EZ+/269Pxd
	pTiC+UJG7jSWL8n9NbxcHkua33ZAbik=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-r0gE1Pt7NcGNOzg9u2W_vw-1; Thu, 02 Jul 2026 06:40:57 -0400
X-MC-Unique: r0gE1Pt7NcGNOzg9u2W_vw-1
X-Mimecast-MFC-AGG-ID: r0gE1Pt7NcGNOzg9u2W_vw_1782988856
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3997407a7b9so13885821fa.1
        for <dm-devel@lists.linux.dev>; Thu, 02 Jul 2026 03:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988856; x=1783593656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1S5rFZYWMM0y6IKRawKEvo5guFtOQNqmUYSlSoGfdlI=;
        b=j7EjmSW/9z+244gaYtWapah21fizYdVgIzIv6/aIptVJGId5EQ2Hq1w9AgF/fdcXsC
         +CP7SLXeHeqLMIn25gTJDYflucUmUIeFnW4pQU3idUo2ZuCzNQXUQt0EMExI30RPK744
         cYIA+pIR/D3OZBkDYOd0avjelKxycpJL9zi2tTA8zoqwfrooUayBBPfWeBbJgukDtj0V
         d9DbHes2d5WGiB9Yslh/KMaxOycm5oBQlN7UJlw1ttcRxT3Duf+qOQylyECoXvDRKBc4
         lpaxfPFzRhnJsaz9gvY2/aZqajTjN1nIYkN4un3yEZeFMUXh8j4XNXDQ/Li59k3I81PV
         bJOQ==
X-Forwarded-Encrypted: i=1; AHgh+RqYhZQFLTyy4zXf39RuFaPv+aEMPXWuQjMj7UXG5eK0HJrFvmZndAwnQRgaw0t/PSsQ+nTtIVAycg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwVh28nXa4yovyKLjwcaee1sI8/GKNR2zxCf8vw3SHE6ltEaEOv
	VGNL4oeXD2ku8X/3CYR0XVu9cFopTxHViUD/ZQWo1PJqGgnZxfN+K4fPW5nfLX3bBkbg5qW/KQ3
	lugQR3ToLGGyIJYWFb1XMKeSBcFoZ37DzqxBhKnYExvbwrurJQ3ipE+SJu70CqNwLnrjGIxZmNd
	NvYpvCt4/buoGcec7W1b3vMjO1U4Mx3ZPiig==
X-Gm-Gg: AfdE7clpQ5Khbn+EeFVQCJBTVXkNXnG8jfTGV2FEE6+3/C/GYopjjSOpIxXVJwXhlQv
	NdDR4lyMgaXUS61AonoW5Q2ahgLMNU0Sj0zXZyqI1gPhAPynbEHwg0r+QD4c0Ye3vSvswI3MrlO
	OL9fcLgT379kww1Jf5HeRKTw/HlxgDEzYPltLFPc/x2a0AcOYaM+2VvVNBlrPGz1QI1A==
X-Received: by 2002:a05:651c:88b:b0:396:a7f5:5e9c with SMTP id 38308e7fff4ca-39b340d561fmr11782951fa.25.1782988855697;
        Thu, 02 Jul 2026 03:40:55 -0700 (PDT)
X-Received: by 2002:a05:651c:88b:b0:396:a7f5:5e9c with SMTP id
 38308e7fff4ca-39b340d561fmr11782921fa.25.1782988855291; Thu, 02 Jul 2026
 03:40:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260702002734.300353.794e3849918e.dm-era-target-offset-mapping@trailofbits.com>
In-Reply-To: <20260702002734.300353.794e3849918e.dm-era-target-offset-mapping@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 2 Jul 2026 18:40:43 +0800
X-Gm-Features: AVVi8CfZp-gmtZJadxHQg6QAG3NSH6UWW9-gAH4l8LRkaAEanXIKbVG7XOfG-Us
Message-ID: <CALjSBEteAnvKTa9nTeK9x+aoN8wZSmA=1fKpqxiwkTTDrxDQzQ@mail.gmail.com>
Subject: Re: [PATCH] dm era: fix out-of-bounds memory access for non-zero
 start sector
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lf-Snq8m9U0ML31lWhbGLYmKuYuExv4RAUsmR05NsMc_1782988856
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 8:34=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> dm-era tracks writes in target-relative blocks, but era_map() calculates
> the writeset block before applying the target offset.  Tables with a
> non-zero start sector can therefore pass an absolute mapped-device block
> to metadata_current_marked().
>
> If the absolute block is beyond the current writeset size,
> writeset_marked() tests past the end of the in-core bitset.  KASAN report=
s
> this as a vmalloc-out-of-bounds access.
>
> Apply the target offset before calculating the era block so writeset
> lookups use the target-relative block number.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

