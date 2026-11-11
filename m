Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392354;
	b=L9SqiqQJx1PKE5KLJkzmQ70JpO7xdLGeOVU4k2864nCcXZ58FCBKWvxiyohIs4Gp51MJ
	 PwE7jqUHUw9LkW7wMePIML87dtt8TLXt/GoFB0YEo2lA67QaSb85bW7Lqg1q/n4k4vQMi
	 pgFua3PhKLMInnrEu+2B3bsvDtRKjSRm+HXMWxYPLbi9+AznrcBKI8AIPMpoYsVaHtkeU
	 pAVl8KbsM4WXE+7v3LVkh8jYBLc/dtCt+0Z18/MyQuyt+vNT8beGEzMf5G537mN+j7yMh
	 eGdzWoNo/fWVRGXzMkP1LZF+xRnB8SfsyJguqUuT1RR3/9YBDw+GP5XVtx5mC/7J9tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392354;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=3E50XU3DuowBBTFEZTbbcP4lzUUBRzqdIlBd+nfLf00=;
	b=4v2NtzBiF+vVsDCrMJZfNt/brmBTQJub9rIEGh3Y1O9i6MKqBsWmR8xGyxMnYIhGJBEu
	 ssA25y0DvFIF3/fJUVnbLb9yr15nQ6a4F0HV1rgdJvwAK+7iV0xHjj4gOSk7uVl1VLfF1
	 vR67kLyE3t+Y63QaFOVLI4B9QrWpe0WnDXVVXCJB2Rweq2uDQEMCJ6zhzyJhAntOGK4tG
	 mfjo96m9Qg90ZHUr0ZDNgSeLBl2Wm7jGWvlSo1eS3rz6c8SW6zIGBS3e7YaQ7pA+sm4GJ
	 yo86Fftfglzn+ouD0CMRX0m6u+UmyxTQafPe8hnjvQbAArHu0weG5rniEGgGFngfHKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AWzD7HiW;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E44606A32E
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 10:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52E44606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AWzD7HiW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794392353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3E50XU3DuowBBTFEZTbbcP4lzUUBRzqdIlBd+nfLf00=;
	b=AWzD7HiW72dtC8rlBpLFtWisK7DtALqqn2Pe28S2tqdUw7Y/0qNNP9+awyQRBjznCeWfcG
	IQhMyXVisBkSDKbpyamVhisEr3I4J3ThaFoflY+qwxt+oyddMky+SwDe34X19R2Znm3CDg
	MrKh3WsjDqM39nVIisUr9QfL7SoemA8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-6c10otalNf6-HNJe5ii16A-1; Wed, 11 Nov 2026 05:19:11 -0500
X-MC-Unique: 6c10otalNf6-HNJe5ii16A-1
X-Mimecast-MFC-AGG-ID: 6c10otalNf6-HNJe5ii16A_1794392350
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3acd67793f2so13007631fa.2
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 02:19:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794392350; x=1794997150;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3E50XU3DuowBBTFEZTbbcP4lzUUBRzqdIlBd+nfLf00=;
        b=HQ9IZDL97PDdr2jW0Xrc4nM8+2GkjCnNa8s7gQTvJHtK+QzR1+XG9BrSX+39uahFzL
         v+px8I1hnX2p1HDN/Zev/T7Vfsh6lZ2Y/u6xW58iXLmg2tf6XHpNzVi0aZ+3id3/e6ys
         HwU5DeSYe1rhouB3ihcEj6PJVkX5ALe93DH3A2MVa7EUakFRyqIscnsbyqu7lvxRq4GC
         2cCg1Vdt2ISP0+vihhcDGGvX5oZ6BahZBXyMCfreL2HO4A+c8ZHcuWHG1H91JHVogdkE
         oNbRKjaIFnrdjJZAhj6uyFoCgoX72p9csXE88RfPZptMFKYwHfAAKn/Cm1oJ2PqWEOxE
         GfSw==
X-Forwarded-Encrypted: i=1; AL+hErH0khtlaasLdvI4YnadmUL4Bba6LZEVGaCGBhoOOadnB3SRKKn0FI1ZzCJESkzmU6BPgRdyeY6N+w==@lists.linux.dev
X-Gm-Message-State: APuU4Z+tEkVsk0ooVWRdo4esxoy2XEnoIazrFw8We8+lfF5pzTdfdI05
	nAkX+gvROBSTFsEzpF8Z/NmHxppyZ1bx8aUu0Utna5GuLJ36oKbiyv7N/k0s84XDVlogvpEHKny
	nM32H1DBMQLQv9sZXpHcCY8aBpKhsFLvgIbvHRPtQWrmlcoYWCaUahTKWmHD2LKFz41164b1UMW
	25gYDZRAR+fifEGvj9mKekYPY8gPjU+e3t9g==
X-Gm-Gg: AYBFou1XMfwfi0zuS42wlghWHFSSNh29coyHLvYLCPXjRASNNWKQxm+W4udmpMJDyS9
	45HIXBp3BBHgBm4gSXhh6ct8fw20P3uHN2KSux1j5H+tsiw3hJdgJ3IMvpSxFaPX6bA22PvZ5z5
	STPABk+RMo4w5HKa3a/UUGM2+5Yptb3l5+4pZVldOVWdzCzrQ89Qklin3oGTN6VaSqE/tIp/xON
	8uISUf1Q762frc=
X-Received: by 2002:a2e:a105:0:b0:3a9:a1ed:634a with SMTP id 38308e7fff4ca-3ae12690d79mr3610241fa.21.1794392349852;
        Wed, 11 Nov 2026 02:19:09 -0800 (PST)
X-Received: by 2002:a2e:a105:0:b0:3a9:a1ed:634a with SMTP id
 38308e7fff4ca-3ae12690d79mr3610181fa.21.1794392349476; Wed, 11 Nov 2026
 02:19:09 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <d89335f5-57ce-dc63-c323-a0c6d150851d@redhat.com>
In-Reply-To: <d89335f5-57ce-dc63-c323-a0c6d150851d@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 11 Nov 2026 18:18:58 +0800
X-Gm-Features: AclHuK-SDgvurDryymcDdpMVEkjunNr4Q5B3clX8SwyPde66H7ZbCAxfskRhLW0
Message-ID: <CALjSBEsWQcO5tvfgLmQVzc4xYB6anqXJ6=4D=aZ7H88zf6Yohw@mail.gmail.com>
Subject: Re: [PATCH] dm-cache: fix ending a cursor that never began
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZXq8KZkJ432xpxeaM81uYPEv6LDpKuzEPH-JSDaUEjg_1794392350
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 2:56=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> If dm_bitset_cursor_begin fails, dm_array_cursor_end(&cmd->hint_cursor)
> is called. However, cmd->hint_cursor was only initialized if the variable
> hints_valid is true. Thus, we must also destroy hint_cursor only if
> hints_valid is true.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
> Cc: stable@vger.kernel.org
> Fixes: 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature")
>
> ---
>  drivers/md/dm-cache-metadata.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-cache-metadata.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-cache-metadata.c
> +++ linux-2.6/drivers/md/dm-cache-metadata.c
> @@ -1433,7 +1433,8 @@ static int __load_mappings(struct dm_cac
>                                            from_cblock(cmd->cache_blocks)=
,
>                                            &cmd->dirty_cursor);
>                 if (r) {
> -                       dm_array_cursor_end(&cmd->hint_cursor);
> +                       if (hints_valid)
> +                               dm_array_cursor_end(&cmd->hint_cursor);
>                         dm_array_cursor_end(&cmd->mapping_cursor);
>                         return r;
>                 }
>
>

This corner case occurs when the metadata is not clean and the dirty
bitset gets corrupted. Although calling dm_array_cursor_end() is safe
because hint_cursor is zero-initialized during dm_cache_metadata
allocation, adding an explicit check is a reasonable safeguard.

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

