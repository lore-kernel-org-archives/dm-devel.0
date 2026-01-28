Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448AF34253C
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 22:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769638301; cv=none; b=pYgv3i9SjK+miLtGI3A/YtMGinV77sn5AI67XVDrcWVJWpgIdndWFYvpMLz9sI7caV2mVi+JVQ2iCFy8NTcSqNaSo5sJu7nD/Ay9w+QN99zttcocWOnw3BXgUtnXkYwQ6o1uCMx17PaBVYQvom0aAwJy5bVkX0O4vkDb2/p//RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769638301; c=relaxed/simple;
	bh=QxkdfRGJAKgdB+0bryxR7WomppWJfsDTxi5I65ovev4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LpTHUhfyr9cJHsxKngnSKkWsg2nNTnYl2jPv8wxBYRzNXFNXRXvJ5uBr2YthfNWEKYdN8VxSr1A7eN85LNF5QtOnwA0XRa7/SGVy/l2yoWUOaZaS84f03WKbhJiTlW46ynIYcmpSUEOjxkkXHGhQ5xFdZqvGB8cGVmAsOkJIUf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hv5ZC+7w; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hv5ZC+7w"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso2883225e9.0
        for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 14:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769638298; x=1770243098; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QxkdfRGJAKgdB+0bryxR7WomppWJfsDTxi5I65ovev4=;
        b=Hv5ZC+7wOeOjKLoqS4P++B4KxeaKFBo+ep2x1NLGJytHOh8FnYiqjC2ayiomd7SjOP
         Odx1G8z60Utix6oZtDiSmAZ4vfhTk29OPpQRP4zFoXoXnagbQRNmdo5hCsCulTI3cu8J
         OZ5pNRRRliO9QH/wMuxOWQKDRDan9p5zd3iIX+7X8Ue97OtFY2kucixFpumDKVAQs3qj
         Y1k6KADmy2vQAP0OpOrd2CT5I/ZTsekB5CwxmBogl7TAUk6UQoNFwSDYisnvHGqCmPVW
         hBt0d5rRwDA8AGv1EIUTdGDdg1NT+KyvyZmhg7J6CrpHJNwix3cGkcwqkFLa3VRnjEnG
         t24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769638298; x=1770243098;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QxkdfRGJAKgdB+0bryxR7WomppWJfsDTxi5I65ovev4=;
        b=krXeJDxvf9G+L38EQ7Mlq3j/zBX06bzH101nygIdBvlufIYn6fR1KhA/8SN8Ade042
         +0GQggZu3iSpK4rUhebwzfsMNYgZrCVLCa75781+X1fCndq5ITqOpkYgNQTtLXje8X48
         ZQsgNEDXUkABibkI23ILmOXHrvbt62UsgkqWgxcK008CBDwfQvtBScBe5utQuRX8b8/Z
         lxd87TWDZUQ6MwWi/SFID+oZsLOofQa3WsV5FdzWsYJOB6ziE1CnQaJwz+HJIDYs5xDC
         NUkENZ/GZOa2glrceYJcEZ7KKOGrhzdbjtmfg2mbiT97KRijZM3ZVzt0NWQxZoCF+9Uc
         e33w==
X-Gm-Message-State: AOJu0Yx6nm/AZwawFQ+X/dCtPrXJvTZogoEjxqunWY9STB6Qx3/8xWz1
	ipRxTBtCsf/tDUc+FduOVf9aDypb3yAj0AHn20RqWiBTa7QEq0hUhpfcKFG25/IY/sQ=
X-Gm-Gg: AZuq6aIw61Fc0QsPSIHoxyGas3XwdAm2YnNPhxmm8K1qj4EfBQWaNecEiaytOznnRw6
	dBghaoPZw7F9L1VuOx3xVkACQfuS0vucb6k6aGqkNkXHHku07y+NaWxwVb+AaNIWBeIvrvjeJYb
	8WFLGVmd00R+ykD5Ue6kmUZ3uG/syvt76RfS1X7dsFj9hYsUxAGlPNL4kcwUO3klQE8AjyILEvL
	fssyF1jBVO9Q6gtYMXF9vDuXz136DYeTmuXxm0h/Aa9GL+wtRqGAm98+E7rbzwmb4r40lfHoV1E
	QQ4xT1avO43H3OnsJO2wCcf3692/xEw89f32aoF3gBI5V0EgyTRRt/NAWu6e79yyM6//2qT+xyf
	V6dAQwzJnTZVWPMuhUb6N/s4ImmGc7lnRcYh+L1k3ha7ECAhxMPedWLRTUlec2srFWARurxgyAy
	5/M2Friwxw63KaUqZ0jPE84+bhEfHaURGMDXJ08vYx7PV/xaZe13DostE4VcPruhiPxgDhk5khZ
	hoVGYx2Z+9aPsRcugPo7+A6mOZpjt26Fos2C0Iv01YoHgc=
X-Received: by 2002:a05:600c:a08c:b0:47a:975b:e3e6 with SMTP id 5b1f17b1804b1-48069c540camr75771045e9.18.1769638298429;
        Wed, 28 Jan 2026 14:11:38 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-481a5dc8d3esm36955e9.13.2026.01.28.14.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:11:38 -0800 (PST)
Message-ID: <c9bfd614e5cdb0a90d312d9053f7b935c11f69a0.camel@suse.com>
Subject: Re: [PATCH] multipathd: fix possible null deference in
 purge_disconnected code
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Brian Bunker
	 <brian@purestorage.com>
Date: Wed, 28 Jan 2026 23:11:37 +0100
In-Reply-To: <20260128214651.499138-1-bmarzins@redhat.com>
References: <20260128214651.499138-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2026-01-28 at 16:46 -0500, Benjamin Marzinski wrote:
> purge_disconnected only works on paths that are part of a multipath
> device. However, get_new_state() is also run on uninitialized paths
> that
> are not part of any multipath device, and the purge_disconnected code
> in
> it was dereferencing pp->mpp, without checking if it was NULL. Fix
> that.
>=20
> Fixes: 690550a1 ("multipathd: implement purge functionality for
> disconnected paths")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
