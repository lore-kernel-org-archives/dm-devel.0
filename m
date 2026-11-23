Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441967;
	b=T9GuXJUa69arS5t0NngDO+biGM4ed5ZiDv2Ju5o2ASUMoOu1//4UZLsaJ/Q6dRpYcput
	 l6Nt1wSbYaotU/K06mVcRCTWUTuHbKmwHZHAxHT6X98+NeaSRPTNXkQTR97sBQv7vxYeF
	 lHgrfNH5roiFYialFX11Ud36WE3caDHdfefabYU4QpwyoonzuigWNZ3Nfojg+xgzjnIJO
	 GkyjEhBY0I7uFB2mC09WjC/R9GhKB9b7sLSJ3imhlf9p+e7ToMfG3QbbIuEGiWuyuewXq
	 UCOJk4CHjCUWgvz78d47ETp+LDG3K/u2/HAhGRWdgKP3C6bmBfTsL4dGBs7jM0PbtJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:To:Cc:In-Reply-To:References:Date:
	 Message-Id:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=AXTt2VSG15nAnMzRRo8jA5pAu7GG8lDCQrNPeTIe27g=;
	b=CTxKfbxdLLWlTpvK6wFF8kAxK2GloMe3GMUZyAlvtw+Nbw+HSXxkrRYdCi4WDVQA+cLZ
	 qlUIVe2albycxjvws1iHNmzt4vgADTyC5xB/QXZXqoBJzgqC0JQZL4kkUgp/z354+M7yE
	 cJbuh8L4EYwnTIeUUNmrMURNj3x7wg5GlTI/R8AJHjuZxIgEUv0CEg/TZ+cQ3E7/+koi2
	 yOxh5888VmAj6+npufquHSqt0ehYNYT23UJCoBDb+6ZmPH6zCyT77WsxNoctXWI5t1PUn
	 pbdBB1aMKimJCDSvmu2nFlMG12MgxZ+p22bdtYRZqTPHDVidEazZvuRu6EMscHA352g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Q6eQMqLh;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6547A606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 13:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6547A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Q6eQMqLh
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-492690dd5daso2512640f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 05:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795441966; x=1796046766; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AXTt2VSG15nAnMzRRo8jA5pAu7GG8lDCQrNPeTIe27g=;
        b=Q6eQMqLhuBULrXqAscfQBlP0lGBGe9jFU18LIPDGXVc80fnhrRXm3tR4aKnYEci9/w
         guACIc7kWHTsXLVvvy6PU+YJE6q9556kloWhTe7pJINk0O6q4wTeFDGL++8iDCWgpw+E
         q0e6RFRm4spjvTLwrYg0qIdyDDEYQWQ87Idlsvp3zsfDXzOq9bbPp/VXNg7m3uaEYRdA
         3c5kcAtphz1N06qP0sn5ZZaWNKkBrafFKPOkoOVNPUhF+nXoe8v5L0BhlqPf7ObUAVDp
         QwJ/jTQ4SKkE1OamjGAz4HBi+gnrMsPaUdVJODecLuvRDsc0DLMbW67Hx+6/hfzW+hwf
         JvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441966; x=1796046766;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AXTt2VSG15nAnMzRRo8jA5pAu7GG8lDCQrNPeTIe27g=;
        b=gQztxMVAp9yNbzRlkjVrKcv1v3rMrFIn2Dy0DZvulnmaFohinpd9KL4JpvP7YJ5Kmr
         u6w7iDTSVEirR5aqhAW+mCh+w94lSiXzX990HPGsvgcB0ZVAxouCX4dXTo9OQ+7VRLgL
         j80WDE/TD4SRQaNv21IQPhjsxBOTd/C4bei/StetbgioOi5PRmui1c/3c7t3rS81igkT
         TFN66kmaXOIvf1hA++iu9/ilQ6NHgUWx2XKzITciWGZYQBY2NsORDQBmxlfy5nlnKwHp
         BStdEIS0xHbXchsajo/Ss/5CsWuiwifRc9n/qgfhgMRWTOCI5Lsf9mi8PXT98tPPPNll
         Tpcg==
X-Forwarded-Encrypted: i=1; AL+hErGVEEIz8MMsXwRJdcTwcpOzrT1jIw0ghwxd0dltSZI9K7fvM+oiGGTLLrJkdpNgBI1vjWP+c9sk+Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z+zCI2eagUwFv6T107KxNxKURD88hpMr8Gj4Y7unx+wGGAhZs9a
	6PGSYcseiFP0/yByFt3vTBXSkhWCEZPhebBj+lkC2qhIsW36psW8k2AZNzupZ2nG8MAmKZK8CZU
	lETQOVdA=
X-Gm-Gg: AZFdTZc46qo3GeuXaKIf335jKdNSQr5x4/5wvDnc3F09bIagZvsxoS/zpeofI1GqnsE
	ArdG6kq8YfeRtg9x7gGI+LDXp1njVRa4xq58+7UqhlI4w3WEufv7zcCtjx9P8zwDC/hX6Z2VhN6
	hHA7iWarJT3FGa1AqwMFhnZjKlI5ax0lfuZlH9xZGFL7RqEpAm7Gd8fSHzjhlDj1DNmYDMKu5th
	e5HQSqwjWcDBRjwF0zLtZKaUNOw9xrTW5ePZh/RZwNlOov8ufRao+qAbrlLNX3HILxQRSy/9kkn
	+kF1NJ/6yLZMBaqXb7kgG2/EzDHGVYhjjqiucfyrmHBgOu2oWb5siwzUurF3N5UtN7t/did6vv4
	iEZEgeHaV/+HVz67ZSPm0bjEbIeOldo5izQGWDnwhOEdDQdw+c01lNrk6+ptgZjuUb2PMhJ+O/o
	5C8RCddRJijgJUNDq1tQOIkfvRRkkQMsVPQLVbTGqr14fnXK1eK2ikfe23h5ZeEVRVsOBzeyfru
	4qLSuWUx0aVzgG43NvdLLKH7EPMzicjVD3M81EdtIUxmoFiO4DsNOCjgDDK82tYA1fuJ1BfAs0g
	yVWT65eb5gBjLzN1mfiG8EFUVXmLLce9DcIqwfFUct7nv+cyOCcGhu1W501iCj7vKEJPZuITo1A
	179LVj4rXkBSrTVnThzCBSuazZ/HzrHizaqNaoQ==
X-Received: by 2002:adf:e006:0:20b0:4a7:1fca:e52e with SMTP id ffacd0b85a97d-4abb4c7afbbmr15954498f8f.50.1795441965644;
        Mon, 23 Nov 2026 05:52:45 -0800 (PST)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4ab65cb4341sm22797189f8f.4.2026.11.23.05.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 05:52:45 -0800 (PST)
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
Subject: Re: [PATCH] multipathd: cleanup global queues after threads exit
To: Ganesh Andhale <gandhale@redhat.com>
Cc: christophe.varoqui@opensvc.com, dm-devel@lists.linux.dev, 
 bmarzins@redhat.com, mwilck@suse.com
In-Reply-To: <20261112153310.19652-1-gandhale@redhat.com>
References: <20261112153310.19652-1-gandhale@redhat.com>
Date: Mon, 23 Nov 2026 14:52:25 +0100
Message-Id: <179544194538.136667.8418014051789473456.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1150; i=mwilck@suse.com;
 h=from:subject:message-id; bh=p40mOo1GBuvJXFWCO6LSZQojOey15BouiIfClkZQgz8=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBrBEUdBxtQfXZTUs4091sV6DUTOXeAln7VU/dB5
 2E8BzuwZSuJAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCawRFHRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/Nv3lQv9GgHVEnhKgNER/jXAV0NF83Z53YJ/qEc
 jiOCoSJ0LdOt7pVRfWUZf7zR0s3UqvY+UnvoPdek9re86Hp13hhVvR4MVufahxonE+0KM7SXMpw
 tiKrxU3OpQVoaDlzjjjeY2wXs794pGOC73Dkw9xoFyF2xPF/rwmucnEDzq8vjVR2lMtRG4Lm015
 BAbk+hFLucM/EUiSCzTQyf1G1AVCy0yEYmFavwYeLgviiTpA+lGxdGo+ZLdA+rwwfuB+oAOJSpN
 rn2Hq18uxzuCa3ZNHAqR4GXcTmpHGg/2DKZUlDmSf0XS9Y74bUHaV5A/8nysIHh6lAzep6KGD7n
 SPpMZvI+MCwZQgMFNXNufIlzwzJCqA8qHffdi0Ewr6IMWKqRtuXXSrkOJkltBQ/o8eVOLF4Zk+k
 M6fwuQAi10dcLWbcVuusQnJ3+/Jg+eT0L45S+qgjtE7hqs+mZ+eMFPP2zMs1wJrtmjqdsanqWTn
 bSLLSLgxBcrXc1TH0uvgCRmVZDZ5wKT
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754

> cleanup_global_uevq() and cleanup_global_purge_queue() were registered
> as pthread cleanup handlers in worker threads. During shutdown, these
> handlers could run as soon as their owning thread was cancelled, while
> another thread that also accessed the same global queue had not been
> joined yet.
> 
> This allowed the global uevent or purge queue to be cleaned while a
> producer or consumer thread could still touch it.

The consumers of these lists take/hold the respective locks. So no
race would be possible, AFAICT.

If you don't mind, I'll modify the commit message accordingly before applying.

> 
> Move the global queue cleanup to cleanup_queues(), which is called
> after cleanup_threads(), once all related threads have been joined.
> Keep the pthread cleanup handlers only for thread-local temporary lists
> and other resources owned by the cancelling thread.
> 
> Export cleanup_global_uevq() from libmultipath so multipathd can call
> it during daemon shutdown.
> 
> Signed-off-by: Ganesh Andhale <gandhale@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

-- 
Martin Wilck <mwilck@suse.com>
