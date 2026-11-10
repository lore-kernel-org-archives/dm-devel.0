Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289506;
	b=ZuDYR7U44PIexHQaLxtDrzFsj9+AHl4Lih/VLPUvd+WVroBok6bYcuRwG/noaTmHhJJk
	 8BE57Tf9rjdZI9AppTfX2j1htDx9Q12+54GxyWMA3J9N4cYxZm7I+KFWHLtbA2HuqIf2L
	 pBOFHAZ1Cc2Mcgt90cwLoLR80rKY/UQLzvuch6firuToQzsh23Xf2gi1EkDtUTY28CaQy
	 Of4P16fbG8mmArSuYQK9TODzEwyTro9FYbY6DkI7YgkoDHAePNLCyzglouXiqIO8TX3Gc
	 8AFP+v+Gm3DcbXSU9yPQlIMQwl/xyg7M6ENfgdpwk21GC2zMuc5scckKsLCSF2HgRFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+m90ZHP6p5x4AVs4ojsWRq2UWvQJVYuVb7I16eMYE0=;
	b=uwVPmyeQsThsOuFE5F0tXldJqCDGmthdsGIt3fDhTVMmrIpr+CRwrGw8XHaTKFw5Nbhq
	 D8o2pnJJsgzkp0AIiOkK2JsbOMcX3aO3YtQEDyHS2gorRStC0iQ8Di76SWylrCt4xQjM+
	 yy/OKJBALr1OcLgWU+wYwJ97lGjSMjyKk0hmF+JotGMS8WC0DYCx/YR/jIOFimgV+Rw2j
	 nUJ4tsKiCsjDRYWw+JxlW81vrjwAmveZ2OwMBl/rxk7LWeK3qfN4qw6HusdVcE1gpM7HD
	 gRhPAqv81+0eWIlPBUBCGqpV4juQGsj/Kd76nxqYwZEe0zfePCfIlqHnb20SWorU11Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="uo6L4zO/";
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9545606A32E
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 05:45:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9545606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uo6L4zO/
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-490c1d337d8so1099162f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 21:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794289504; x=1794894304; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p+m90ZHP6p5x4AVs4ojsWRq2UWvQJVYuVb7I16eMYE0=;
        b=uo6L4zO/nX/MUInEUBQwIIUJdWebTBtVMqbx1rTNkkfBNZEk6RBj9L6yXki0A+Fat2
         iUR0JKiyLhRAGlnTpeSO8kKNuRKC3bLed+gPaz96HTjjPlZiU53v/jYMUR3dVfD+nOoB
         ek/qYTvY575dyxqWXBCw3DyYB8nT+K1BC7Hr/HUYU/tNaXflGabuhxGswKAmCVf5A2sn
         YmERDVu/Dbbh3eTT0+k9eyykg8nTIrEukT0IosizGx/gTFKRuYZ96Sr11IZzz8Z4LP5P
         5U0JBCcbUgw1YOuL5JqQhe0gZG3BCGjw7cK9fL/3qdL6/ZQqoGK8J0TGhcW/LaWfxIF+
         H4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289504; x=1794894304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p+m90ZHP6p5x4AVs4ojsWRq2UWvQJVYuVb7I16eMYE0=;
        b=B0y7gz0fNOSMkIgwgyiqqQiF/KajaZM8DX3JhdhmiMNbfAhiEFVDkfGOe+lrlCWVut
         rOZyPj9l7r3A4OSuK9or1O14ZUbhRQeJ6XBPNd1KCaE2DZcfRXnc1xjI/hms3kKCrLBo
         taxccUWarpnMlTYqGhQsMzFczJcvpfPuoI7Zf4ldaRH3NFVMjbNgcjUOVCo9BxZeInyf
         PrKrSNs3t68IqmkspnOgWhLFtPfVMTOJS1h4Q9mGO92Z21da8099tB/xfHSKn4oeda01
         MZjeYx7Ka3a3TgJYVtfSCOA8Uyv0PzTs3MSm7QOQXTE+QVv/Rz6Wv1RJQe+nM/qN1eSr
         f+ig==
X-Forwarded-Encrypted: i=1; AL+hErE9dR+XhVO0wCdstfoy1HACfanPyFM68cGliKvYQbaGSbgtm3L0yobJf20/GKWbMlLK2bZ7CUpUnQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z89wN7dWCVKBz8pTwpuHEBfL+mNu3hRmASvan2YcgEvHHS3+fV9
	SFCqFa59j3RdOQ+/DebQu171fyhdA6aCNdNT24N1aQzGkzAAChYx+m5l
X-Gm-Gg: AYBFou3gCOCLTZqMZRsi4HgUutc9As0M1JXB+P+66f9R333kZXkEud+v/PtHoXVN/dW
	a0CS91mPSpUtgPzxJbRS53m9pNw7uUWqjnKVeme+1eQH66p36lzuSR3huNhmCVqvqFlUreafNtP
	t5kiZ1M+I2elSNevefUGwT32OGurI8MJMHdQvhOu99LBsqSWB8SpNGNn3qnyn/AYB6i7ZYWHNDM
	TXhlmDS69Yd5dgkSXnPe9+1UFao4TU3odwc/tycDGERG/R7S0qrBB/xPm146vtFxG89o5mqtC+d
	oDUNkaAQ/S0o3IImfjgmnqcxG2IznL5JNXKMEXF4sa7UTlDI4zm3b+KmF4ZW2njxMK+8BhoFwAh
	STDTF++qXqweBaZpkTYO/n4Ku2wENZXmUq1vwJQb3rtpoPbSe79EouHU00NlSyuzUB+somwh8ph
	PlzfvoKzo9bI98VdYyeaBooauHEVnCdLP0LyoAMQLXU3vCMysRPamG6LVBmoNncY1NsHrAEuGkl
	FT1cqS6QaSuDdrZgYueQCGIPpTPIt5m/ctStIHtUucDQdrPRM1tj32h7qYXb6owUQPnabMTf9QQ
	IzAT/NvmuLtAQ6XWhnpuNCHwfmaJSy587LiPrYpNhAjO5lyVEMGV3GVQhCiXDb5RAfUr0XzaLhe
	zYuTTg9yh4hLbEQ==
X-Received: by 2002:a05:6000:2482:b0:48e:353b:9f28 with SMTP id ffacd0b85a97d-4982b28ac5emr3169751f8f.1.1794289504112;
        Mon, 09 Nov 2026 21:45:04 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain (109-92-113-33.dynamic.isp.telekom.rs. [109.92.113.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cbfc6sm3083123f8f.41.2026.11.09.21.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:45:03 -0800 (PST)
From: Hristos Nenkov <nenkov2004@gmail.com>
To: Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH] md/raid10: preserve recovery flags on reshape abort
Date: Tue, 10 Nov 2026 06:44:56 +0100
Message-ID: <20261110054456.625-1-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6aec6738.059f5055.2712e4.0005.GAE@google.com>
References: <6aec6738.059f5055.2712e4.0005.GAE@google.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_start_reshape() can fail while resizing a bitmap before it
changes any recovery bits on its success path. Its abort path nevertheless
clears the entire mddev->recovery bitmap.

dm-raid keeps MD_RECOVERY_FROZEN set across suspend and resume. If RAID10
reshape setup fails, raid_preresume() logs the failure and continues with
resume. Clearing the bitmap removes MD_RECOVERY_FROZEN and makes
raid_resume() hit its invariant warning.

Do not clear mddev->recovery from the RAID10 abort path. The error paths
reach abort before raid10_start_reshape() modifies the recovery bits, so
there is no personality-owned recovery state to roll back there.

Fixes: bb63a7019df9 ("md/raid10: resize bitmap when required during reshape.")
Reported-by: syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8b22a0459202f76b4096
Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
---
 drivers/md/raid10.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154..1fd3f5f4f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4490,7 +4490,6 @@ static int raid10_start_reshape(struct mddev *mddev)
 	return 0;
 
 abort:
-	mddev->recovery = 0;
 	spin_lock_irq(&conf->device_lock);
 	conf->geo = conf->prev;
 	mddev->raid_disks = conf->geo.raid_disks;

base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
-- 
2.43.0

