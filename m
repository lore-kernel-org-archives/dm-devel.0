Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16283320F
	for <dm-devel@lists.linux.dev>; Thu, 22 May 2025 07:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747898550; cv=none; b=NTl5tGm/ghRF3nQNntD/z0hDfEnOMpJsISic1YrsaGvGSeuBGx1g9r7VRpjlXd90u1QPubCL6LaeHON4LBDouTy+JZ0Ka/BpbfZRIX45qxK1kXqABhm8U+wy8crutv2+BfOSqyq76JZgdOHNFyBXICGiRR/9S7kuGtdvjOhO0aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747898550; c=relaxed/simple;
	bh=HunEHTYE3cSZTuUsAgx8yjTKBhORspedHL0uTDo5bhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqCRw8HLMROq0/WHgvN5SxfGCaEZrxux5LlKLfcCfrFzA6NFM2GItE68JeT7bCwnnXXvrHltn3g6QXC4nl1yqZ5cyM4OtnujFHfVkB0SWc8XvulQSnG9H50/9Bpj89Ebb0bF+yweB6w2zjv8154mWTOmzY9Kq2lo2jaKRDgz0KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmqDWOL8; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmqDWOL8"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-231e21d3b63so76434865ad.3
        for <dm-devel@lists.linux.dev>; Thu, 22 May 2025 00:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747898548; x=1748503348; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0FfnlbKUuYkszpwzUgwL6UeZTYGqOSljOnLXHv7G8Jw=;
        b=UmqDWOL8gcYwsm8KRj1HZjzi+MXGvLDg1+ENTVZabYMFJMIB5Aet0nxfuQB3vjqXH3
         67j57zl0E7SjpO4S9+Eb9NIIwtpY9631DKtRZeywRJ0xyklALP1cw+42bebFL7iDKS0u
         03OLDert+GtlZdRz9KuyDE9fV+OsZKA/cWNpzuHIjkXSFgafxVnJWFSg2OjDK67iWNFx
         UEqFvm7ddN0fK/wyjGKbzIGX1YaY+TbG0KamK/D+V2c/xaG2quIE/VhZe8Zov84I0Cxt
         FDcG/taasftBpRNe71puRoqXg0+ghU7dNZMMITqZi0MyjX/cL0qQN6m9B0kenQGKlWeO
         ok1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747898548; x=1748503348;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FfnlbKUuYkszpwzUgwL6UeZTYGqOSljOnLXHv7G8Jw=;
        b=eE2/rCh4BMXfZl/h6jdceUFr3D9N4PWQUKrrQ6jpVjtbaUSHbrnNL332icAsRop4Gk
         1TsnhKQgZmDHhJubf7YQOmXys+qrPh0TicAB1ppUPh+/fz24uKxJom7kgZXY6LXqb2XB
         u2KgQoevCzWH3cX2Y0rLFPYuGSQHdqAHxk75LPRhG4jeLOdlkAJB2B8xKB2Zf726Pm+D
         UXdU2b7UT/D77ytDseInMhYOG8bJfFvkrQCSV1VNoP0klc6e0WAyQXff2tePsBd83ngd
         OCIMZsRZtxxB+zdj7KG115J4CSR2eGYCcDErKMTZxaJpDheB+LhUEHt6INJBQ5voHZb/
         5ZlA==
X-Gm-Message-State: AOJu0YycpLSAoRnGamVi6xocNWrulp6sGXGj2FTnO9M8VA+6VxD33NF8
	kEm4mNpPujKgVs+Vmwci3f6gPUK1Ogeg5hZPyT+8w75tXWd3JkamETYM
X-Gm-Gg: ASbGncvqbL5UQDH/N+FGO0UnjlCMaTyi08i+eZPp48CSr9A3GOz7U3CMYlOv7QtmwNv
	8juYVLJmfWxE5JcLyytdwJu+TrTiEGvVpKWgcNSHsfcJ68b3q4/VPZgspJIyl9wZA3b+Z8Filbi
	lFkdQzbBLxfvIWDtdLwHpiT8AuTJvJpEX6zqJScNgYyqinCUQDyRS7LLfHj2x7ttB9rkEhtTHHv
	YbLy3/B1lvWpCtWItSZb33PHW8ud0u+XOKRUNpszLrtGBWqyUHr4LftW1+K69nZvY1Fz19iK5Uo
	XHQY+VcjXjiWZxBy6hK0WNoplNUVqjIztqM9QAgysAOrFOjH+ZIJ0YlTqpoHiQArDEwkATZAiTu
	hH/YW7NCzbvy05g==
X-Google-Smtp-Source: AGHT+IED0B4oRIBlAS3ZvbYdlU/FQR4hT1cK7dpgSdaG/Y2OsDEwUfMm+XniVmcaK9aU3Pzngq2rsQ==
X-Received: by 2002:a17:903:46d0:b0:21f:f3d:d533 with SMTP id d9443c01a7336-231de351537mr294721515ad.2.1747898548249;
        Thu, 22 May 2025 00:22:28 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ebcd45sm102865165ad.210.2025.05.22.00.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 00:22:27 -0700 (PDT)
Date: Thu, 22 May 2025 15:22:24 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	jserv@ccns.ncku.edu.tw
Subject: Re: Potential heapify performance issue in dm-vdo
Message-ID: <aC7QsLCPEt9nm5Pd@visitorckw-System-Product-Name>
References: <aC3riPZ6GV/dlr7Y@visitorckw-System-Product-Name>
 <9501613e-e8e5-4734-aa2f-ca3a3e4ca990@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9501613e-e8e5-4734-aa2f-ca3a3e4ca990@redhat.com>

On Wed, May 21, 2025 at 02:57:26PM -0400, Matthew Sakai wrote:
> 
> 
> On 5/21/25 11:04 AM, Kuan-Wei Chiu wrote:
> > Hi Matthew,
> > 
> > Recently noticed that the current heapify method in min_heap.h may
> > degrade performance when the heap contains many compare-equal elements,
> > compared to the previous version.
> > 
> > In detail, the new heapify reduces the number of comparisons by about
> > 50% when all elements are distinct. However, when all elements are
> > equal, the comparison count can degrade from O(1) to O(log n).
> > 
> > I don't have enough domain knowledge of dm-vdo, so I'd like to ask
> > whether it uses heaps with many compare-equal elements. If so, I'll
> > work on fixing the issue.
> > 
> > Regards,
> > Kuan-Wei
> 
> Hi Kuan-Wei,
> 
> dm-vdo uses heapify for two different operations, but in both cases we
> define heap elements that can never be equal to each other. So I think this
> is not an issue for dm-vdo. (We have not noticed any issues with this in our
> regular testing, either.)
>
Thanks for confirming that dm-vdo won't encounter this issue.

We observed a regression in bcache caused by this behavior, and Coly
was concerned that dm-vdo might be affected in a similar way.
Fortunately, that doesn't seem to be the case.

Regards,
Kuan-Wei
