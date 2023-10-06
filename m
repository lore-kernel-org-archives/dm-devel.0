Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DECED5
	for <dm-devel@lists.linux.dev>; Fri,  6 Oct 2023 23:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-774141bb415so158865485a.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Oct 2023 16:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696634955; x=1697239755;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HfUJzt+n01J/+6OZ0d7b2+6T1BhByIZ5iv/QJkJu/Qc=;
        b=TuTcfJ55serGP2Q9d3lPD67dNyx878DZzdSzeuRhc8xBkEHmp6nHrRvU3J3V5sgKAr
         9bH+HxLgRo5EpixPh0IYACTOP01ylXC31+M2p2NlBljWQF/e1tPA6lalTK2aszlrRbyo
         DvNo8a7Vb8J/8kQwfCdG+0PDJNFZWvAvRW3L0TJGQtHywfAmx4Z35/WBC6ewVDkGPbVr
         CeaBItLJaguN+MKPvgLVMX9wNTaLionVBJFQ/m37Hfa8LL5iVtowCJTufnyeQlrhO7ve
         sSIT5i2wtq9l+LVn2gWLA/ZKhMzHn4swqtl8FkoMgnEqakcECWNnRw8A7s4B4UKvxuga
         4WSQ==
X-Gm-Message-State: AOJu0YxWp6Vb2j8Vx2zyPvbz9gT9NUqsEKjxMNcEBDZRnh87I3y3BRt5
	BNs8zbrkIK6OfXGPdokuGAl3oEOMxpWwgfMV50Qf9teno1x7Go/0tQ2ZxWnfHdetMzMR4+Cd6iU
	HP9IqOqVIyapW/+hEF8AIZ/fYg74j3XORBmNwndPfEKbL5P+sZ1hgc6wWsjmqSQDPrNgKUDCiRu
	9W
X-Google-Smtp-Source: AGHT+IHjMjdsAj9tzuE7yqH0Q0PA8p2Gr8RbHmcmY/DwLJirIC62E4QOrUqFmQX9Fb8S0QfU+6wWUA==
X-Received: by 2002:a05:620a:2408:b0:777:3c2:31da with SMTP id d8-20020a05620a240800b0077703c231damr326396qkn.5.1696634954706;
        Fri, 06 Oct 2023 16:29:14 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id m11-20020ae9e00b000000b0076f124abe4dsm1651312qkk.77.2023.10.06.16.29.13
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 16:29:14 -0700 (PDT)
Date: Fri, 6 Oct 2023 19:29:12 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@lists.linux.dev
Subject: dm-devel has migrated to lists.linux.dev
Message-ID: <ZSCYSO8wlg4keAmY@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

As a dm-devel@redhat.com subscriber, you have been silently subscribed
to the new mailing list: dm-devel@lists.linux.dev.

Effective immediately, all dm-devel email should be addressed to:
dm-devel@lists.linux.dev

(I say this but my "git pull" request that I just sent to Linus, to
update the MAINTAINERS file accordingly, cc'd dm-devel@redhat.com --
dm-devel@redhat.com will still function as it has, but nobody should
use it moving forward).

If you do send email to dm-devel@redhat.com you will get this
auto-response: 

  As of 2023.10.06: dm-devel@redhat.com has migrated to
  dm-devel@lists.linux.dev

  If you were a dm-devel@redhat.com subscriber you have been silently
  subscribed to dm-devel@lists.linux.dev

  NOTE: If you were a dm-devel@redhat.com subscriber but you disabled
  mail delivery: then you must subscribe to dm-devel@lists.linux.dev.
  To do so please send email to: dm-devel+subscribe@lists.linux.dev

  To unsubscribe from dm-devel@lists.linux.dev please send email to:
  dm-devel+unsubscribe@lists.linux.dev

Thanks,
Mike
