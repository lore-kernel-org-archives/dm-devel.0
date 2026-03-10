Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EB135839F
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168054; cv=none; b=RLDsMxToaLxjIRxbWhbHNZ69wy0dzNB/w1ydaff6souQOiWT+XGPvet8RJtFIrRmk83A/6Ag/0r+nb2M2J+yqcw+qwpSe1SxurIFbiWLJ3DLECPVsjXNLU2uZ3iGSdXCy6HccSmpBo4tHS5t/yAJCOLoo1TM2cQATtfr+q39GNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168054; c=relaxed/simple;
	bh=67BO0RZg8rxb/E50RmGcBJlsPR5Ae9xmCy+Q7v8QtDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5YkjUUJBV1v9w6glWVAc19NSmabp+/ufD6M3HIg7xIQ9tPUgJy5EgsyEzePD9HAxwSAXlI3eLb5TtexFnzIjf2AJs2lzJaIT0uPKg/uCAG2KZDFXWryFngDUs8lQ09bBAFlW5M5qn2MOoXMuWCBdUu35regdlVW0rkKDJfSb04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l7G+/4qr; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7G+/4qr"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so4742396a12.3
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 11:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773168050; x=1773772850; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjFZ9oZWWc3RZ4UdO5rq+AZbr7uPDX73K58gh1+yuH0=;
        b=l7G+/4qr5ViVAhZarVR7sYpVC7nNDWFrgTmkDh+IglL4EDFBXK5kmtbOmHOOE+m7ZA
         oKRsbZuBJJAcyKXm0p11yiTyLVNTT3VS6ZYXQOnexXwVrdImouiIT6OxswPKVswgV5TT
         cZK8/R9LzrIGilaVm9CRyDF9trvvbdsbxVwvj+BxRbswXmqkMFvaykVZWCkLmkxY1Uut
         EyaAfbgOPiY9V9eQcoQgNBtyOL2YIDI52loZZxfirEb6793tjh4ysr+VcQ0DGCw/0aL8
         eaymqqt667p5TCNw5hKBc1bqNC8HMwCk6SSFkfjVmoLNSGP1YKoKT23V20lcfhx27Q0I
         JatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773168050; x=1773772850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bjFZ9oZWWc3RZ4UdO5rq+AZbr7uPDX73K58gh1+yuH0=;
        b=iSmZOFY/vQ6bw/MWjf82Go51uTcMSdkaIdtT5UBxXdoM0GfTy8lJ0M3MsZlufp4Gjo
         EvBj7/xnV7W/PciqY3dOsSTe/qu/nodOLjWMDHuiCEvriSUs+s09bX9Pa94PciI2L0GM
         rDG6TDKMN+719H+8tAHPMZDB9JyeD/ae0WKP+NZ+sIayfv+yJOo0kkp8cdFUMy/yYAoD
         j+L3RaYpegJcvC2yG5EneeBheAhekJKeG5ANfKlYKaEStcVBgclemRQ4wGycpvUSUQD9
         TUitjn8Nyc7rPs9hSSceEO3inUv37V5e6kJqwmnlkDhdZ9Jn4kUqGGmo3OmhzEnd8MC+
         //EA==
X-Forwarded-Encrypted: i=1; AJvYcCXSLrCn4vdpe85rPQGtPLfn0/OHwM4e3KtK6Ip8Gxh0p6sOvhHoF/JmOkw5qVce2K7hQ8la/OC6Mg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyUc+DzAE2Pfs1knL2iCN3V2AYlfcs13kCurpRzQxaihcoj95Iz
	UREiz32rBvXQUX9U+oVj4R19n5u5vDEr4TWqZiF0hDsTwwQaZlY/n5gH
X-Gm-Gg: ATEYQzwcQsAi4nOUfaPYlOOGswfS/ZG40UFJLbWUO06fAPIPpU8ZrLfGbakHYLkSpUu
	ejc4n5oyolF5ORXECKfZ23qD8j2uBN52eMenF8M+UB8EJyoI1+8zLrpR9SWOs3+as7DLKv6sonE
	Q9j4o6r3zpvRPheTlgJjeCqY3jSQo6jxQ+cw+oO0JF90xLl5VQW7AHb2e7EcXEmf50sbaaeEzPk
	I/KkNvngXXjM3ixZOaAIBnCrsZb9y4yrv1qr7zUcss878ZYm2sZGfQZpEo9spEbeDU7O2G4nkL3
	cIzL3B3ENqBKG2qn4l9ui4sXFa76NdtLqm4kEI+tvlYk7ISFzAizuIu5S527vRuRpA2XHNPHrfB
	bTdHgzFyx+ryeuIUorhiFQmK1/xT4IBQ7vfoxIQudDatVn8BtjJqsSFmJLL3dzPWwgDnX+Z8xmF
	CtCr1ca57VmE4MJa3BDz3hyMdH2nu0nNyoGv5lAVppPc+TRQ==
X-Received: by 2002:a17:903:28c8:b0:2ae:5671:7071 with SMTP id d9443c01a7336-2ae8252cf0fmr96662285ad.43.1773168050081;
        Tue, 10 Mar 2026 11:40:50 -0700 (PDT)
Received: from google.com ([2402:7500:a44:85b:2953:97d3:b283:95c3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83e58592sm220535625ad.14.2026.03.10.11.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 11:40:49 -0700 (PDT)
Date: Wed, 11 Mar 2026 02:40:36 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <abBlpGKO842B3yl9@google.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>

Hi Philipp,

On Tue, Mar 10, 2026 at 12:48:26PM +0100, Philipp Hahn wrote:
> While doing some static code analysis I stumbled over a common pattern,
> where IS_ERR() is combined with a NULL check. For that there is
> IS_ERR_OR_NULL().
> 
> I've written a Coccinelle patch to find and patch those instances.
> The patches follow grouped by subsystem.
> 
> Patches 55-58 may be dropped as they have a (minor?) semantic change:
> They use WARN_ON() or WARN_ON_ONCE(), but only in the IS_ERR() path, not
> for the NULL check. Iff it is okay to print the warning also for NULL,
> then the patches can be applied.
> 
> While generating the patch set `checkpatch` complained about mixing
> [un]likely() with IS_ERR_OR_NULL(), which already uses likely()
> internally. I found and fixed several locations, where that combination
> has been used.

Thanks for the patchset. However, I think we need a explanation for why
switching to IS_ERR_OR_NULL() is an improvement over the existing code.

IMHO, the necessity of IS_ERR_OR_NULL() often highlights a confusing or
flawed API design. It usually implies that the caller is unsure whether
a failure results in an error pointer or a NULL pointer. Rather than
doing a treewide conversion of this pattern, I believe it would be much
more meaningful to review these instances case-by-case and fix the
underlying APIs or caller logic instead.

Additionally, a treewide refactoring like this has the practical
drawback of creating unnecessary merge conflicts when backporting to
stable trees.

Regards,
Kuan-Wei
