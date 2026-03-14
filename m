Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178142050
	for <dm-devel@lists.linux.dev>; Sat, 14 Mar 2026 12:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491652; cv=none; b=Ch0Ddi+Nc8nWNx64Q24BTXaPGrdQGgrYpotoXe1kilkQu3xAqF7gDJdiiT/Pr4mZFOTE8kDPoemL8Ofy8VS+GfS2ZDHFC5MWru13wJU/0zjggXjYpqNGvJ6+R9Gwskq6DwO2Zvan3LAu8OlDywQdeZF1yQWA1VJYMKQP1coE03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491652; c=relaxed/simple;
	bh=gcpaoxO2P/AH9wlhsLxUU5QsH7kLdAhp88MyIBChIgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QyRmKmy3smdOpPDOBTlh7j5nFYRO4Pra8ZPVTzp9+7iLpGPdJ7289/9krGDY8fOkBg+Eg+JfDhqGNdkOpLFDDYKCAjs6DvdszMBy4nmWmXQE298LUr8u0BJJiOONwoKaC4lIoqwD93maS3nothW+mTDXRui6RdqjKgY1izEvACA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvkQRhJ+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvkQRhJ+"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43a03284a08so341314f8f.0
        for <dm-devel@lists.linux.dev>; Sat, 14 Mar 2026 05:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491649; x=1774096449; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHntqabEKcrw1MZVvgB78HRCFNhYC3Zvh1GdB0SK/ag=;
        b=bvkQRhJ+W9BgUakf0YPZlO0nFuhTXCTzY2T7IFh1kfVebF1LVYEt0mRGGG/3Vy9/QJ
         t9x3MrPECOn/p+Sp5MXKdq/l1QEELmAzPyP3hFmGDOMRibXg4whv29SyX9MKZOlRtK0R
         zw2jdd/TQWuPdbedmd3FoRF+X9GCbxmKDkL1zsllrZq1BKf6TTD9W3FDcBJFFpbhNRZt
         DvfumGIAfE4nTI1SblByOpjCvJdo7A8Ii79zcJf8eYI5+4axHhnwiAMTOyCjJYSSy1YJ
         xfq2c1SjGuG9bZWNaS9QRJfEGLdI9/cS6m2VcrGfRw2uWx+Ppk1UDzRF433au+DZHYxQ
         42Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491649; x=1774096449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FHntqabEKcrw1MZVvgB78HRCFNhYC3Zvh1GdB0SK/ag=;
        b=Hwi4ylEATV5L+GTZE2Pz5hFEC4IrBI/y6eA39sHRNBLzHZ1S1l47kt3T5kZEhnpWef
         1ZWfWIZ5NxZZKHScWAKIIkHyxt8bgXKJve8Wvk6RtUzSsRpzgn7J1ykT1jpEAME+5wvT
         yxLpgMePHe/p9EAQjv+Bz7Ax/HQtbdhXHcLm2foofOQ/YqqO362KCqdYAgrWaLGEIBna
         ofr7PYIjMiRsN+x0jIIXwY2cOyDfJl81s3wIzv+5c5tSq4hgPJyqO/26APajRKWAAuIs
         /baUaN8s4CghMmsw4Uvc9SCo+xB/ySAJ6dVhk1qZ/drVbGEP1toVwcMCBIC2A1/j71I3
         ICJw==
X-Forwarded-Encrypted: i=1; AJvYcCUpg0Zg32V+yzFK4iVid0Dg+yh8VGE0k/Y0ZrXUIjUp9aBJIFmqB/Rojn8ErQEyrXS53CawGnVNOw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwVbyWXYsKOIRtQBzl51OkFWyRtx9+fLCVAaB2XJ1SWoMFnIULB
	JSXfGt9PNkgKxVtPKJF0eAow6ORw1UaAqRruboRCpw3fluL6yw9IpQY=
X-Gm-Gg: ATEYQzyfC3taOVroJL2GXaJGCXBxqGHKbACdxHm0qnslFlUXDcWlSekTUZlgaGM2q/S
	mge/abYjd46YcmwB6OiJ0dNU0e0W7T7ImG0nKS6O1OtmekIzDVH7ZirD9lIGdMYPOXRQll25bIK
	KM+VUKD6W7QBg6NR7A4Sa05r7jvvT3A0qm+3b4UP4gJY4xNWqAI0DO02SPp0VO4UTiwUE9Wiikc
	xnJNgppdJy8t/buw2nr9X75b0teW2p3x+0w9AiDLQZl5lNdL+Px+zc459v9eenFxuwq1EMj5yMf
	2QDw/W4tbUKFiKg4g2s/iTXx0UkcBOJibL1yCQQCgJY6caG0JA3J227el4USnp8Q5dZUNTFILNv
	yVuR7xptG3vVghztLmLQRib35lpGwbXCkgIgxgNRC+GmZGCe0lkRPZZU0yRzutXPADPvTmheFsx
	UpFgJsKWL+/Jra8yolxmNf4wNEdUXC+AnJLiIjvL+UYQz3b9U6QfpAfhPPnTwoKDxWD/Y=
X-Received: by 2002:a05:600c:4689:b0:485:2af3:3f89 with SMTP id 5b1f17b1804b1-485566d2d5amr60207195e9.2.1773491649112;
        Sat, 14 Mar 2026 05:34:09 -0700 (PDT)
Received: from localhost (255.red-2-138-248.dynamicip.rima-tde.net. [2.138.248.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48557c6c69fsm45795145e9.26.2026.03.14.05.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 05:34:08 -0700 (PDT)
Message-ID: <f8ce5537-d704-43cf-a06a-56450f0a5015@gmail.com>
Date: Sat, 14 Mar 2026 13:34:07 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] multipath-tools: link LICENSES/LGPL-2.0 to
 LICENSE.default
To: Martin Wilck <mwilck@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20180412145757.4130-1-xose.vazquez@gmail.com>
 <20180412145757.4130-2-xose.vazquez@gmail.com>
 <1523573573.4346.130.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <1523573573.4346.130.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/13/18 12:52 AM, Martin Wilck wrote:

> On Thu, 2018-04-12 at 16:57 +0200, Xose Vazquez Perez wrote:
>> To indicate that the default licence is LGPL-2.0,
>> since there are still a lot of files without a licence header.
>>
>> Result:
>> multipath-tools/
>> └── LICENSE.default -> LICENSES/LGPL-2.0
> 
> License.default is better than COPYING, which, as you said yourself,
> normally refers to a GPL-type license.
> 
> But I'm unsure if this really clarifies matters. If adding my lenghty
> review document to the tree is out of the question, a note in the
> README might be more helpful than this link:
>
> License
> =======
> 
> The multipath-tools source code is covered by several different
> licenses. Refer to the individual source files for details.

> Source files which do not have a license header are shipped under <-------
> LGPL-2.0 (see LICENSES/LGPL-2.0).                                 <-------

This was added to README: https://github.com/opensvc/multipath-tools/commit/a4c4b80a32e43598aac40a6b25c871b20a7ca1f8
However, there are file where this is not true, e.g.: some of them under libmultipath/nvme/
