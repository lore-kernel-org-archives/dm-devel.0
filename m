Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ABB13D8A0
	for <dm-devel@lists.linux.dev>; Wed, 21 May 2025 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839886; cv=none; b=vAfKg3siXNQjPWkaGkUVBcS1cKzVWkAz9D88z+4hnJomHuscx9Dm+HCZPArUpRAJPOO9qVdkx0FkE+0+Tk1wFYpma+RSmsrzjfAUVz5KgHVdY1QFq2TeRE0vLgzxK6K/g6zhVjAJBa/x/gYTXVKQQWAeswPW5zkW3eIIo2e9OE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839886; c=relaxed/simple;
	bh=q9tHTExnf3cNbpfcUNsJ4hfobtVJGEmcSXBRXYS0vUU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZSJrG+AkS/+9HnZge97CDly2KHCp/aqqLBySBOsxdfo28tgHmfDm55wfpXbcS7odnNUYVcbuq+8Cxu0JAHeKpZr3uSRuMOpLeZlhph6fnNCWJ5Rv29JLXafUnnyc8DjaS9gDgTEFuIkOoWUH+VCpbUB9doR/1XUZANpTB4kQZ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBI0dzn1; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBI0dzn1"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3081fe5987eso5762698a91.3
        for <dm-devel@lists.linux.dev>; Wed, 21 May 2025 08:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747839884; x=1748444684; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9tHTExnf3cNbpfcUNsJ4hfobtVJGEmcSXBRXYS0vUU=;
        b=jBI0dzn13Mi2rrLJ2fN/hFNlfMclpiLxPvAWYHwCR0umni3+THfL2ouNwOucG8gZkp
         eMFEI/3+Ax56MdeUC3X3jCNjiCrxyRTXCgWPm17te9BtGqArCt+O5hEkqr7LMWMAlTyI
         eZLy2U7DLSePX+Ze6twq0oOnWfs6XQ/Oiqy6SlPUFfD3uoLq0YRnJAB6FNRHjyt8DyOI
         JAptMXe3JvyfYFYfoY23baPuF1w3MZPchp15ptUcqCYhx1spmBmc5v5VGrBV2/BjwDe+
         wXRyRe0rezVCb71dbsE7kkEdahq8AwDw6K4g0bpfZA1tftX5GywPa073+F/cGHsBTBUI
         xFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839884; x=1748444684;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9tHTExnf3cNbpfcUNsJ4hfobtVJGEmcSXBRXYS0vUU=;
        b=q1Ojzvbo7qewYIeRf/+4Q4fLJwJufuG6xKhOSDXWQLZ3Kd4eXcZYPeUOyGBCW3ltcm
         yvpumWstZ09X8Kn4s+OomX1YVFi3PXkPrF795hhQ6dzUNHcLGBSZ1fJsejCOOr5MS0+2
         gL2aepj3PCAajUegTw5uKGAQLarybMTGtQqvj5HE9e1IJcOrwhGkiEyOuJLqOPsMK9/f
         elHLiGNMuInxj8VpA23OOsGYedSHcG3DNpixY4gZ0jIXj6hUi0OTiKSYOnvq+zDCk/od
         QHsbJBqmxfYZdgEaNpvQJXhib8rlpbIZW/qP2j/m1z8/iO7L6T6tEYFAoA71bQq7Alk7
         up5g==
X-Gm-Message-State: AOJu0YxRpkSru9+8VQzJt0PEghbF1Try/S3QAIgsuGeVvlAxJqlh74V2
	3tWo7tI1rEDsIx6RHCsH/qLd9TCFb1RLfQJaIyiQgNfhyR73c0hJtGIi
X-Gm-Gg: ASbGncsNwEshRxYEe0bmnbHrAAO9oJERx+EGK5YwBa3vOD2VDkxmhJeUGowkKyOfUrt
	/Bd8LcESpHBiw9JrvXlwGwnYa6YL4RV8tsEyLmV1jOEaOHxuYtgBu8gp98KF/z0Fp7iIdaEjD5N
	Suo+KGb8v+KzKCbjvBoqcwZyNfOO5coomZ7WoSjcIZftpJqToZLKmUroZRk/JEDFMFJLs2llXd/
	/nde94PxVmZwGEBQ7wiafCGyRwTQoSqKdKS+5NLEp5vmHec5RYLX+3gew4vv1JNH9DdnTbAz2SF
	WJ61VZeAbP3s90cZHZqWS7o9Lvqd32JN9c/MNAL+G0aANsFZY4oJXleGS+/PbWkTmcMUpyNM9pp
	qaaw67UZSYM1Ctw==
X-Google-Smtp-Source: AGHT+IEjGUTqHb5NWIMvtvGZkJbc7R1HW0J1hE1aCq3tEY5gctFQ+ulCehqVQi+uXSiUTqWJAMnJIQ==
X-Received: by 2002:a17:90b:3f8f:b0:310:8d51:c427 with SMTP id 98e67ed59e1d1-3108d51c444mr6066662a91.0.1747839883716;
        Wed, 21 May 2025 08:04:43 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36366219sm3768202a91.6.2025.05.21.08.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 08:04:43 -0700 (PDT)
Date: Wed, 21 May 2025 23:04:40 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	jserv@ccns.ncku.edu.tw
Subject: Potential heapify performance issue in dm-vdo
Message-ID: <aC3riPZ6GV/dlr7Y@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Matthew,

Recently noticed that the current heapify method in min_heap.h may
degrade performance when the heap contains many compare-equal elements,
compared to the previous version.

In detail, the new heapify reduces the number of comparisons by about
50% when all elements are distinct. However, when all elements are
equal, the comparison count can degrade from O(1) to O(log n).

I don't have enough domain knowledge of dm-vdo, so I'd like to ask
whether it uses heaps with many compare-equal elements. If so, I'll
work on fixing the issue.

Regards,
Kuan-Wei
