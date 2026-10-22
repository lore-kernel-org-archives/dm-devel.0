Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792700280;
	b=PxbN7AWUFNTtQthuMTLKvGWWav3kEF1HH8pkHijq9WuyVPZsHtsMMpvyisWXRakr2SlA
	 Wzg73UzzkCs3jU8R0463cweNafBq21/HxM3pSwZu7/UGL5BFvlV1edM39UeuUz2DFYZWR
	 khW1ke2oZqqgXrhLS2LnSt5+S+cYLHZvCXIZgcSdRryMqBp1oUnRw+2ZppZ7Ecq1UN4gs
	 uSxv0kjSEMrnECRRi0ujOt66TnVitF72H47y1ubjCHGLEPg3y7+PC6weA3tqBb3XdDLpE
	 gu+7mJKvTCag+WGkdUmrXbhr/D0AyTS/bHHlijs2ay3KlE9eBFkPOnpKPa4h6uHEfcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792700280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:To:Cc:In-Reply-To:References:Date:
	 Message-Id:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=7tZHWHt11vQgrQbj800DIOyAZgAVx7XZ1IJBPsCi0aM=;
	b=BM752xaJCynKvhK96FO7E5FhyyVRPIyX4fLivglzSn40MmUwmeMKXc+a7EdGT4jmVh5f
	 6576soolJCXDT9P2MEIb5CjEp6lMbZahY5ln488lwXr2R0rPfEmaZr+4TYdsk5w0vjf8n
	 fPiIwBNEcmY2I8Q4T+PvadXi0SOyHLo+B8QVEPDfRPDvXi7OCqzpoB6DND+SwgCr02QP2
	 w6WEzejMpZ1LTltEEKpSls69KiEEa18AVjRbSHiEZN/n60beiOQLHvxEHVIiO0rBbOOMQ
	 1p1XfaGF2syv1lHYfqQ9e7KGtb8qPFgDmFg1Qj/3HtbmVc5HKvoHEFDH7ziMh9RsYQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=fykZydpf;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9872D606A31D
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 20:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9872D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=fykZydpf
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48dee593f18so122303f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792700278; x=1793305078; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7tZHWHt11vQgrQbj800DIOyAZgAVx7XZ1IJBPsCi0aM=;
        b=fykZydpfLIFoHLa2KG25+z0XsQTU4iV+EB3/gdaW9IsxQZ90DqeLk0UoJNFhz5YVSh
         InrUTvJLnOPF8Xn/e4HCm5NdM0/fUpzUOPpYuggh3y5h37edisVg28EynH0obBpQdGSF
         9ATTgcbYX/9opM6+gtGy5EDncDv1E/iRX6ijp2VMpI9LoQW40jrawuNQm6B58IMt2gOf
         5wvV9hQJhh9g1lDk1ldfef3RDogrkTNrAcbn6DJQ0/h53IX8kfkyWYU310juo5sMGh15
         GjVlmMhAY3BZXUtWF7odhhltVVOS06RNwV3OMMuwDSP4QTsV3kGhnD1nINFy7Kn0XmIc
         LNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792700278; x=1793305078;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7tZHWHt11vQgrQbj800DIOyAZgAVx7XZ1IJBPsCi0aM=;
        b=otJlSofTjyNUJVYDSbO4wvZKD5JRt63LjElqfXErQoSxrX38fFY6oGBlFNSs6K6F/j
         hiRmknDbEB2j60UVWDJ+dxUzaEQtmyjATF/mzAyo1kQ10EmMcTuZs0aVypjBIbV3O51/
         mH6udd/blnlyHoYGqMpyT/odbXGPag8kg22CwSjLMA9Byzl+7EXqZK83VC/XCh4VcEkL
         HIZ+94LeAH27oDJv21ueq0/GgRGQHr1aAFJ5uW7RvKL/WPuO7jVXX2PR+VnxAxh0NTuY
         JBuUD61N3Ly2WZXFamZgTOy8/gHLKcLLiIM1YvDR54UHEC9xKw2MumyMyOr1lHy+KyjC
         VNyQ==
X-Gm-Message-State: AFq9FYKS03ZH0uyV48MQrxRkSfooGjsJaesXwVSlWeCHtxg0HMwYJRJC
	S/Ym9y9zjkXk554b/9t70PASERdnldz+Uen/UycPukNqGUUxKwB6jOBmfnfEgqoofbww1aa0eat
	/nizkJ98=
X-Gm-Gg: AYBFou26Ek1SxjVZMn0J+WMfxpkze3Mb6+qVRv+kF/CYsqx9G6x/u7gXtQmUXjS7Ofu
	zPDJdL70iIZjgfa3K9NQw516cCKnUoeWSC54ps9wo+HDkXbIe2/TBhcLdXw4Z740snS+1LYxIMX
	1IvnKoMWq0VDqMLhx3zhq6H5SQVqo0I8UoofnTji4VO4ykHGxF1OcY8v1DnBxxJMLeon5sbE9DJ
	sPh1mFhuUEXHFXtiOS2eG4NX2zAGUIhvbg8M86GBIEsW/zhbmMA0FCud/nh1zcsBigIJw8WKNPq
	pj9dzuf4iPky6NMj1RUVlNt0nOxmJhXXNanPLUCT2yzPXCDF5zzmu2rq6aCz1M9+UIg/46FRQdt
	cj7pJKsayF/G0J8vHaBL1Rm/fd9NI+bp7OdmymWeieiFnAimliYaevTtFa77YF4MoOPgo5DGe9a
	DytkZDWbKaLaT0sJ1pm4ubhKDtd1hWdWHAz8Df/QtsWVNjaPc5QUWKgqZXcB5eoGHR8mj+SZheK
	YVOYllE/KPxtf7dFZ+BrRe8ijpIvW7gMtPBu9t8DEFap4CFNE2SP/Ascl3oY2TmGdq6dEbZhrm+
	/QK71tcl5pDTLHY/Zsxtu/AFi2ftzI+YLOnURev7ueSR6jvudkwWC4W5YBOA1hK0PA==
X-Received: by 2002:a05:6000:2287:b0:48c:7f18:c85e with SMTP id ffacd0b85a97d-48e264ddf2emr12415418f8f.45.1792700277844;
        Thu, 22 Oct 2026 13:17:57 -0700 (PDT)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-48e38031534sm219107f8f.25.2026.10.22.13.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 13:17:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
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
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>, 
 Martin Wilck <mwilck@suse.com>, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
In-Reply-To: <20261021231959.69270-2-brian@purestorage.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
 <20261021231959.69270-1-brian@purestorage.com>
 <20261021231959.69270-2-brian@purestorage.com>
Date: Thu, 22 Oct 2026 22:17:39 +0200
Message-Id: <179270025923.152861.15521453184442767016.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3807; i=mwilck@suse.com;
 h=from:subject:message-id; bh=3SLSSFFtu0Pw/RagW7b5zGA+0GVnvhoOhg5CO/57qy8=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBq2m9l7EKtOfpmB9PJ/r3j2g1lLtlZh7WVeD0P4
 FUNgD6Vhk6JAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCatpvZRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/Nt8/wv9HOlUNHjdTX0HNusC5yj+DA2YxUfdOqW
 HEKSGMR048JDdkTIUDHiK37zhu6AxY3aHwgFNDEyYJ9qtM8q3ngXCROHFhryh/1cqGGcaXEiuZC
 kr/b9/umtyGL+NBzo70PjdmpOT1LahtCu5lDTxuGdtgkIRGx9Gu/qKIV38V8Gwne5IaAE56cSH9
 CqMvH/BP2caL03lN5ookkL7pWVbjIL6bNRuNENnLpi3uY7GVZuMi/Bi5BcN0zs/X1p5l/w3SP00
 2+WN0Dw42q6GbXg0gXUGHId+YKcKM/zaQ+2pawGBS3vd+xUF0hY0YTqPR03nS1DR9qxlDVYP8hy
 X/GoLT7Rn0+8g9GEeLVvvmq1wQ/s+H4xPMdE0MsbaBtyDRe4EXbE0Za9iMV9DZ90ef9vQ7tSCpG
 W2JG2BDzPAV1G+bb9fSOqc/7wD+UL+tXDcTy5s/x3fjn19v+Sgxxr1M/dheep+wQGHT/28obroY
 cG74A2AnqEytBgNju8jTm4r5hPqenjJ
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754

> ev_add_path() sets mpp->force_readonly when a newly added path is
> read-only, but never clears it. If a map is created or reloaded while
> its storage is write protected, the flag stays set. When write protect
> is cleared, the reload that uev_update_path() does for the DISK_RO=0
> uevent uses the stale flag and loads the map read-only, even though all
> of its paths are read-write. uev_update_path() clears the flag after
> that reload, so the map only recovers if another DISK_RO=0 uevent
> reloads it again. If none comes, the map stays read-only, and since
> mpp->dmi.read_only is then 1, needs_ro_update() also ignores later
> DISK_RO=1 uevents for it.
> 
> Fix this by setting force_readonly before each load and clearing it
> when the load reads it:
> 
> - needs_ro_update() now sets force_readonly whenever it returns true:
>   to 1 for a DISK_RO=1 uevent, and to 0 when all of the map's paths
>   are writable. uev_update_path() no longer sets or clears it itself.
>   If the map has no dm info, needs_ro_update() now fetches it, and
>   returns false if that fails, instead of assuming a reload is needed.
> 
> - ev_add_path() sets it from all of the map's paths rather than only
>   the path being added, and only when it is about to load the map
>   (need_do_map). mpp->paths is up to date there after adopt_paths(),
>   while mpp->pg doesn't contain the new paths yet.
> 
> - update_map(), which does reloads that were delayed while the map was
>   waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
>   paths before setting up the map.
> 
> - dm_addmap_create() and dm_addmap_reload() clear it as soon as they
>   have read it, so it only applies to the load it was set for, even if
>   that load fails. Otherwise a failed load would leave it set, and a
>   later reload for an unrelated reason, such as a path group change,
>   would load the map read-only.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>

Almost there. One remark below.

>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index e3870f5..c994715 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -539,10 +539,15 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
>  
>  int dm_addmap_create (struct multipath *mpp, char *params)
>  {
> -	int ro;
> +	int ro = mpp->force_readonly ? 1 : 0;
>  	uint16_t udev_flags = build_udev_flags(mpp, 0);
>  
> -	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
> +	/*
> +	 * force_readonly only applies to this load. Clear it, so that it
> +	 * can't affect later loads, even if this one fails.
> +	 */
> +	mpp->force_readonly = 0;
> +	for (; ro <= 1; ro++) {
>  		int err;
>  
>  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
> @@ -578,19 +583,23 @@ int dm_addmap_create (struct multipath *mpp, char *params)
>  int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  {
>  	int r = 0;
> +	int force_ro = mpp->force_readonly;
>  	uint16_t udev_flags = build_udev_flags(mpp, 1);
>  
> +	/* As in dm_addmap_create(), force_readonly only applies to this load */
> +	mpp->force_readonly = 0;
> +

One minor issue here. If the reload below fails, the map is still read-write
in the kernel. As we reset force_readonly, it will remain so, at least until
we get another event with RO=1.

If the RO reload fails with force_readonly=1, we could set force_readonly to 1 again
after the failure. In needs_ro_update(), we'd then need to modify the fast
return clause "if (mpp->dmi.read_only == ro)"; if both are 0 and force_readonly is
still set, you'd need to check the paths and see if there's still a read-only path
around.

Martin

-- 
Martin Wilck <mwilck@suse.com>
