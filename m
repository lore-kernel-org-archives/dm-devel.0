Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793999721;
	b=jEufW5oAWvBZ58S7xpFdzV2i00YGDLoeokZUgxxCCnFn3335aG/Bm++vSD2j1xdYQrZw
	 ooNAdtyJofRN1zmNieGJysYNaapLYzz/6d9kW5tBc3MFOfAMKkH15QsKIAlyN99xcyiY2
	 e+O5QFmcupaPy6aKxRUAy3UiQYp3g/Vguys3HWlTPj+hqqrngLJamt24e+VldBktUQwI9
	 JCDPtvzoWYpvsKiwvI5SKZjOVLefUBU1+ily8Cqv2/KeREVYo0Rg0EobS2o6fxZ3Wbb2g
	 HgxEPjuEy7Ib3CSJ1ibnyqbC1PgcgoKsk69lzmo94beKfKSKjTlOeDPnZPPjAi3IMbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793999721;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=ALsR3YSS9a7g16h53yNdaQsIiph7MBgatm/EMd20hTw=;
	b=MV2KPWSwN5ubZJ8JXpCMhc0i8Pdf/qwhhOzLGr6b6HOYWVMTmQdvdHh2DpP/BL4yhRJN
	 874O5lTJOmJ2o2aF9+EIogE/G37cW71YoALXDV3kkxmiU2RF0xwbrw+ddoelRolrbAHA5
	 iGM3IpzNvvJureZlY4FernP6sRq0RLldwlpp+Rmq6o89yjr7Ahx0qWjVESWrcXtg+N6W5
	 2/DpJSj1xRT+JJ0grObkbSLkjtLDNbas3LvcTWl0cEFixVf+UgDy0/X/JAiXAlDH9pMNi
	 nZZVqsxgAL3Vm+GHEcf88rNFuLWk6F+8iLv71rJ/jGQ1YL7KzrvWx4nfT5UswUtc8xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=f39SN+M4;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E8606A32E
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 21:15:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A1E8606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=f39SN+M4
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so557245e9.1
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 13:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793999719; x=1794604519; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ALsR3YSS9a7g16h53yNdaQsIiph7MBgatm/EMd20hTw=;
        b=f39SN+M4SllQyGyUEPYGXcZDwjfy8jIR/EMFyJDuFaLUqk0jO4f78Ibds3wnuSnu+Z
         O0kVwSigmgf/8yGP5oWSoQJOZzp2jODjQULeU7Ux+pKgdylx4eqPJK8Eub1OjLn3kNGx
         D2tuMb/2WR1Nkg+VtXiqR0fpwWhMDkALQMwVg4DFwqy1a69H5dAE9wvoLZ0rXMPTzfPp
         Zrr5rwJtfKZRdzW9eMGWIiRrglYVc+EuLaZC7upvThLf8wXzWJ3FcmGoHG7RTVzA2aeY
         XaZfcBrE7NrJW1vYmE1g1WpJ/SPVC7O3lil5QXOreMSgd2VXw6TK2JBVqsAg2cifhcBX
         Dwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793999719; x=1794604519;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ALsR3YSS9a7g16h53yNdaQsIiph7MBgatm/EMd20hTw=;
        b=ybxptyfiuX+pUsvSrULrLVMfR8O7Rua502nncWjf5VBAaohxMZLf35IUTuX+Jhdvy9
         h3Jdtrikcpde+luguGePoXic6rPtUNaamI9P9zTj645zrTXI6qC2zddZ11k9tz84WBPF
         RlQBSnWfTX3WjT9fvufa1M3XFHVQKB3VnJ2YAG1sFLTfpalHvmilW+3RUpnLOlfE+XIm
         CeEJz+5TUAYbCIwAPWggs5+TT++Cf2WevbjGWFjSZ+AL14l5r29CEqNxkQ5vCYXe1o24
         u0kXxjXq3RlVzqBl/cOZGw/vxbConChGzL3La9fQif7GCNtMXma3K5NL8aQpSPiEWlJu
         qTvA==
X-Gm-Message-State: APuU4Z+KbeR6Gtzu5pWoMdZfSxDezYz13pHgxv+wwYA7c4rhqzN7BpVg
	jL8QxKfMUpX9yOz3LHJaBXjSPTn9gpcwLZE8BlJwJ8ZF9C0PSut5aT+KWUpVAlo+fJ0=
X-Gm-Gg: AYBFou0ZDYSuLKVu2c5dwxz3yUhF7O1fhOyPwQicbSXR/RyJ+LsgNBZgtAsCNaL/l/5
	1nMdrbccBP/NKBx+iFQ0boXgHw6bdOrR7YcWAvbEiTQoALNR7lI0P5MUOtv+F+TWehZMc4JWNlk
	YwOR1wbSAzVKj7OgqqCtvr7zT+DuZy6ac+P3OvHwkJfAoOuJdDN3inknVUoy/6oEmFiT1F4pLXL
	n8mELsZzG1tvTf5c3R31KCUmnTmbT1pX5XG4saR/tRqTkAeAijSRZPoEte2m2zUXRi82Pr0lVlK
	u12rGAH5cOvG1EhH6L0Kn55RQ5E6Z8SQZgA7tttZv31pbRNqjFbn4GuvNNcgKU1aldQ1z/qkz2v
	ba1hoLKYaaWpb1HxoQVa/w9U/7fgfWsHrrJjAYry7W8CLa9/b2aKdu+sOohoMnv8m/6ETczK6Te
	g6xHzwo0PVZMNi7A19whiidgc9NWkfJYmEjOFNO6fJvkdBXyDtPnLvWderRJdpiPtSbcqku9ppK
	ZQGcpUMhwy4djS7IAP3fd9UKa5ojru4926eSlq+VCpELh6zKlm4XVu4skgkt7CwxzoRzKIuxhnC
	X3vSDYtb9QztLnA1uGDYklC88jzTeRgddxAbqkGfeSmtw5BSLELCvKT85GmCEDlk68katVxvKQq
	BIBWmEzH2cckLF5Zsrw==
X-Received: by 2002:a05:600c:4f8a:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4b819f51afbmr2879765e9.13.1793999719255;
        Fri, 06 Nov 2026 13:15:19 -0800 (PST)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4b7efb1547fsm14618515e9.11.2026.11.06.13.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 13:15:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: dm-devel@lists.linux.dev, Alex Brett <alex.brett@citrix.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
In-Reply-To: <20261106152444.1541438-1-alex.brett@citrix.com>
References: <20261106152444.1541438-1-alex.brett@citrix.com>
Subject: Re: [PATCH] libmultipath: open_file: rewind after writing the
 header
Message-Id: <179399968631.151553.9923163041735485407.b4-ty@b4>
Date: Fri, 06 Nov 2026 22:14:46 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=311; i=mwilck@suse.com;
 h=from:subject:message-id; bh=paWibvRVjMM3kZYJMieAuzxD1dv+0Ik5nMNWVhsAHIE=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBq7kNfTjLurS/UHHaSiY5025kX9qZcn6eOMgB8k
 pkBZzoln5GJAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCau5DXxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/NuM/Av9EW2OmKW8wVHm6RwWkV/gm3toUyURQVB
 83AsziSaJnqcu6lYfII+LJcnGjqMxmmheE7LH4XPiKBi4Xfr7FS/InazH8b9y4L7LJHQdWfz334
 mbRBg93VLC3+JkEsxyoFet4PUr1Uyr0a8tD6zsazdvaaG09q07gPZnFbMWr+sbPARrAF9uyocsv
 /s/LpKBpWI4NfuBUgqwTkfxVo4gRRamI7/H50jICI48aDhAfpi5H7BxDJ4mlDsSNrWGOa21RQB9
 VjxfH6BwgraZGwiL7kuweoFDjNZ+uxncHsrbqlB8Hfpiv2OBmtlGWIbtx8AqX3xElekfJkPhayI
 wojnbIf8S/zrmblaT3wUuDFvLZZx5T1qgSnD0Gq+GvFn6NvrfAMyOaq4kVVmEp+i8ua2nNinXdL
 r4jlDezBetY8xg0z4nDhQ+OlhHHxQRRcdi8k56Eq5GS1e6Qs+xxOtlXfJWQYwvvvJx2FQLLTNpX
 0ptQLoJoWNskNnbs1osMCdrQMGbbzhV
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754


On Fri, 06 Nov 2026 15:24:44 +0000, Alex Brett wrote:
> libmultipath: open_file: rewind after writing the header

Applied, thanks!

[1/1] libmultipath: open_file: rewind after writing the header
      commit: 29c489fe288f461789970ff7f607a7ded16d1c59

Best regards,
-- 
Martin Wilck <mwilck@suse.com>

