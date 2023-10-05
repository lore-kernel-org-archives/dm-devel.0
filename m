Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57792E65A
	for <dm-devel@lists.linux.dev>; Thu,  5 Oct 2023 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=contractor.linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=contractor.linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=contractor.linuxfoundation.org header.i=@contractor.linuxfoundation.org header.b="k4bWI/cM"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2bfed7c4e6dso12931871fa.1
        for <dm-devel@lists.linux.dev>; Thu, 05 Oct 2023 08:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=contractor.linuxfoundation.org; s=google; t=1696520480; x=1697125280; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C42k84GzffZqTOnO/uP1ga9lJ/Xg9YHVbpgAbKdjwc0=;
        b=k4bWI/cM0XznJ7ZIeAnLUFRhd9hnBpzSkh227C01zr9vFoGEHtqyUz3FpBKxMJQfAy
         xR+4j2j85gVFQzZOADZsNLV0F9zbzmPUfpaFRnG9sO4Eau4XV9aQsS76ukEJ3XSUxCQr
         xeDbtZOYoSKeYVw8AcZHMnU8VY7Xvode9PixIYE/+OBZoz2Nq05Rb03hfLiJIH6FUQr7
         zM3ISkPb4YQ+UCRrBt+BO4J0A+By1Z02zrjJLjJhrWTYuG94RWx6Xh3o4clLNzZBsgp4
         vKKHMuvgwP/dV6WAunuKqWHB+jfjm9HxVnrhmM1bc6PaG9GH8zcOMOhPOWHiTJWhGAJD
         63/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696520480; x=1697125280;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C42k84GzffZqTOnO/uP1ga9lJ/Xg9YHVbpgAbKdjwc0=;
        b=CyUArsg6f8IffnsTpkIUdj337X/CZ8fcjWj4Zb/jKLC5wEAwHt481i22MS6479KU2R
         Vvs2ld0bqNky5PMN65ySd8r1Pqpmo9sWVFcjoONHhX8/wUlIE1dFJblfkgdeATZDwf9L
         IIbwULhwMZv5XhaJxYgq+9yYwVko6wXP+iguiUUPuVb/2Kz337ggyS4+uJwB2wBhu5qm
         83SbpiTpYui1x63pQgBIhbrHbYSFDuj9ygjLxDpBVLKNo9zIkerk3Kerix3BupVh8M0I
         yeQl/cld4moEdkOhji8CBLLzYsuawRxHRSpphgpSPrTPyNtxoS0dxW0nhEGOuhwnyDNS
         dMqg==
X-Gm-Message-State: AOJu0YzBeRUKH31PAn3gahvtkxyA+W4q4Ro/N6asmhZC3slcnXja7UBU
	IxIM/TWK/2bJBVUjqyRjIqscDKey58+bC0/JxAu9D2MbA0C6XsBaoiQ=
X-Google-Smtp-Source: AGHT+IHNCYEDyEM7vFwQ3VvGDT/AmNgTpHveljP0IHnIzRF+0M4Pppgd5hxW7e26iugDQo6+MUrCS6BAXhdsJkV59b0=
X-Received: by 2002:a05:6512:238f:b0:500:a002:292a with SMTP id
 c15-20020a056512238f00b00500a002292amr6861940lfv.29.1696520480469; Thu, 05
 Oct 2023 08:41:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Shyam Kumar <skachukattu@contractor.linuxfoundation.org>
Date: Thu, 5 Oct 2023 21:11:09 +0530
Message-ID: <CAH=dH9-GgQNqPizaAhYcDFYbs9gof_wtFztTFuFYTEvCFrom1w@mail.gmail.com>
Subject: test mail
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello:

 This is a test message to test successful delivery and start the
 archive for the list. Please ignore

-- 
Regards
Shyam Kumar
The Linux Foundation Core Projects
