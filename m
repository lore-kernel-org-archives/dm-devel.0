Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060441FC0E5
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 12:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741264467; cv=none; b=ZHIsYuetVnOBniQAxHes1Kg+1T3j+Kj5SvbNHU7dNWegXMGMFa8WwMQcCav3yQweyMrvIBBcP7zlm7ymuCWpB5I8t1/CV6gfE91X5XwIJ72y2ZAXPSxfBtTJUCTw2WNMTV9dw6gwea3qPRmGL9pxQGTBo8SqzbTwTObnXV0RGyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741264467; c=relaxed/simple;
	bh=KYgtu9iM6VWvW8Sb1j7IaQzItoQhqQcK33ehnoDudgI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hA+m46mvRDOWscbpeIFKEie+s5d2VM/yKxPRczhow+KJM1VZbG8g7l7zQjqQ4BXxH/jiq2UdFHD5FS1xbSz1JXPyqJZ9Z1lrMeoP1UShMdGdO9vRXyov/xBP3QDH3IM2VBOHg2V1O2SFaxF3c307UwwEarImcWiQB6CAYhxgH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WM6faIGJ; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WM6faIGJ"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac1f5157c90so99012466b.0
        for <dm-devel@lists.linux.dev>; Thu, 06 Mar 2025 04:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741264463; x=1741869263; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KYgtu9iM6VWvW8Sb1j7IaQzItoQhqQcK33ehnoDudgI=;
        b=WM6faIGJ/pqjsss4bVsVo+3em2YKtrEJfpVZAKaFjS1E//27Bb1ESf1QBIWSBeZ4PY
         gt4lKXI+ApQWCzRNLECJY+puXQipwzgMAbGYcnRcgxc5mvoASuDNKiu3jVE4r/6xOsbB
         ktBd5gYbrDeisq8cAbCTOOAntwM2qTymMGVlMXdq5jd+V8+jRW2JYhZa69OxqkzG8Rb+
         luUgQ6PPMjHdLAlIKfLEIILaGK1b5dca6pJUokgBTDpJGip2fCJNZiVpU/BdElTiaY4X
         VGYDwXdujXfOXkqLx/yM/JzzO7OZ2XT6CJ/IPOzHAYP0kk0f1QcvxDeTTMRaI37nlBgE
         yYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741264463; x=1741869263;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KYgtu9iM6VWvW8Sb1j7IaQzItoQhqQcK33ehnoDudgI=;
        b=TFISp4p2hdCVOHTarFFYGmzjCdoW365iqCTdJK/9C4e1JZxjJrQ6igXoI9ndx9pep5
         R5CaZI4Eg2ilZY7P4MPmn0hqgHEbHXXrAHEGXQ9wsENcxBLqOb81zHlWmlZv7KcUVkU5
         2yyjaP/WBKFr8I2kR8rcM8Jz2h7KJJmMpLOFUOBPSOSr6+5zFDhEb6py8NT5tEA+CPf3
         JQJrf5EGab7PwYDldpDWMCDqvdgR02OaAapTWC0HcgsEGOsFV1GOB1SSKlxqVdRd5pc6
         Nd9MTbEKPqfc781w+6/X+U7aLB05IEUMXdrtgowxQLzk4mVfwfhGP15szodJWmouhomC
         WNgQ==
X-Gm-Message-State: AOJu0Yz+XM+ak1doJt0IhRRC6uawNeV4rbkSLgzJtYy7bHhCyToXyeKD
	z97j6fSRLIXh/5CHYcmnemb3vVAfVS1wqRt66VizJljFz1BMgl4CUIS8k8fCShHz+HEcII2Nrhh
	y
X-Gm-Gg: ASbGncv2Ve0yOCq2ggUI5xjA/NSu/rCSe73wTQJbaWBFm8omOOyOGTj5GSjXZaPE7Fe
	xrLTv1V5TaxmP+MoI2rJ6gBUjf3rS9NnWo7YoVRG1OvKNxVxV5kX/GD8mZbf6p62TcjgZGj8RfB
	Bm72FpBIR48Csf13GA6p8StRQg2OkAfkz9lRdDzaA+fJ25neMwCzig4URrnMVgCFutYj3Cnujtc
	Pneg1BcCb358HAQi52XRjr/h2Hke+MyR2RdhWLBEba5VKShcN49KZbN5evJxdc5glOyr4YoxObu
	NmeTOK+KAkpEwvtLLtHKWVilNxMAWWEAy6ksl8Rt9VquHnIgmQ1YXg0wJVZ2IVU/GxdcXSUZk5u
	//0UxsyGRavwKmZ8iIKV7KxoushhLdGjXHmVDXHvPLO92AsRjedd0rtE1pTUguxokxjrABmVqr1
	3utcM=
X-Google-Smtp-Source: AGHT+IHHS1exSGdf8yvzF419b9naZvv3AhI9WGZZqGQrXTkR7JCtk6TtDNP1Oo/qChZ2Gu9e8mrAMw==
X-Received: by 2002:a17:907:9815:b0:ac1:de32:dd82 with SMTP id a640c23a62f3a-ac20e03ab5cmr743769166b.53.1741264463009;
        Thu, 06 Mar 2025 04:34:23 -0800 (PST)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac23943878csm88683766b.23.2025.03.06.04.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 04:34:22 -0800 (PST)
Message-ID: <a5187c231777136030e2768219d5060113b48af4.camel@suse.com>
Subject: Re: [PATCH] multipathd: add multipathd-queueing.service to gitignore
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 06 Mar 2025 13:34:21 +0100
In-Reply-To: <20250306031746.3103639-1-bmarzins@redhat.com>
References: <20250306031746.3103639-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-03-05 at 22:17 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Sorry for the oversight.

