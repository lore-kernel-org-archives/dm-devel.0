Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880DB158868
	for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 10:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728900249; cv=none; b=le8b3lsQKIS/tL8fr+ahf8GnoWIa4n/drAgsPozDadUG7+lkZP8gdNG63yUVgiztu36b+XiuVpCmtI7W6pfKdDwlwVEPv7S4qEuaywE2nmp1jsgtW/IUFM/x7FNbWj0k8p9iSB1Ak0vqWrd+l7dP217RABcLJoHMT4i4cPvwqC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728900249; c=relaxed/simple;
	bh=gxRDnZwXl/5mrp9SDbutci1G7aNGYTG5SqDg7ifmzpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4kc/5XxA4sTXquRhyqwLPZ2OKEH6ex1QsHavv3rKq8BFVKfulwBzy6TztkI+DeoJAsSsw1T4Rtx7KcefQrKnVPOtWR6gR5Vi9+9xgBT4NtYtH8AsBDAtM8Z38QtkNq01Yqpq+uHLrTBX+4pmKgmmSc87pFg5vChFIzj1R3lRck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gd5PgAmW; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gd5PgAmW"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71e625b00bcso751142b3a.3
        for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 03:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728900248; x=1729505048; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1UpkN6G+I3ynXmvcvmHYVqtSomW6VaVjxkgmMaS5WQ=;
        b=Gd5PgAmWxVmueN+Gyfc6vEKtD5PC4WT3ah+2akXfTifwe7B8kBZ9HmJ58byLDbSDcs
         HQWXOMdMgt7oJH/iZIFQeDiqfDL1DxO9qkumUDJdAwT4iOIrgEdxMeeIFzQjtThlYrxY
         znqIwPNAvW2HxItO0fN/RmRyBRYZk/MQ01l5oXRLxmFIvrpW5B7tvNEugfmxQhXc+Ir2
         AsnCI3wZeA3kbfpJHfvHFPNOYmNnLdsvw2LhNrQ2+jw8YeXMyPBy4fiLpgA5mbbVTRXh
         7GhNssQ4i9Z8poj9T6JZACeVHUoRadqdJvr7IeVoSisg0J1GBmHxAcdmpjZTGfzusVJG
         habA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728900248; x=1729505048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1UpkN6G+I3ynXmvcvmHYVqtSomW6VaVjxkgmMaS5WQ=;
        b=FIwaI6pCl0/GDr75Xx7xWioCb5SL5iQEHXjodCNvcqHtjDFGgVWsxChNLGHkjPORxk
         Gs5A2eZr/i/4rcEeuDpcXRlnOHPvKSb5PcBBPHqROmK7vtkC1eawkkpx4B+f6toG0Jb/
         Z8WwSwvRoPZDV1LfYoAo2BANcaFmV4tYvbz8BBnOP1vGf/jFV2WgK+IJWwzapZ14WphE
         pJnsvA8JuxUW8Q2X5lfzQvXHaRXDyMUjn+gOg2PFRSQEc2e8VlpNoO2YW1xZkDp+DtxX
         TXutdOaf51bRspVnNAmnHF1klOYZ5lRNoOv4WCU0GN+SGPVDAHPTmIul/+/uXLOqCysl
         14Rg==
X-Forwarded-Encrypted: i=1; AJvYcCVFiKoSpf0Z83i9WjzNwSEfvdGu3rV96jiWgBW6IT9gL5lGNuzg8LDdgR0YiZ7jqAEnJnqyXPRcLw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzK0DsNBn9Td98seM95Tw/e4cqDMVcLVptoQOLjnllkQnF3eKCN
	eeX9XPtywDZMWgV1ILXH8Es/K9xhP12uAOJBvhI6KU5PzeuK6gAd
X-Google-Smtp-Source: AGHT+IGgEa3bpvndU2jxBEWa1yPYBEP7dBrWvI/1I6n9qW/VRreLiILNdpVJ/aCiWYGC5lADcN/4KA==
X-Received: by 2002:a05:6a21:6e41:b0:1cc:e43e:3a01 with SMTP id adf61e73a8af0-1d8bcfa53ebmr16834401637.33.1728900247665;
        Mon, 14 Oct 2024 03:04:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e618318d3sm2226638b3a.42.2024.10.14.03.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 03:04:07 -0700 (PDT)
Date: Mon, 14 Oct 2024 18:04:01 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/3] Documentation/core-api: Add min heap API introduction
Message-ID: <ZwzskczB85bGKWO/@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-4-visitorckw@gmail.com>
 <ZwzcnHmtRFISI9Ua@casper.infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzcnHmtRFISI9Ua@casper.infradead.org>

On Mon, Oct 14, 2024 at 09:55:56AM +0100, Matthew Wilcox wrote:
> On Mon, Oct 14, 2024 at 02:47:03AM +0800, Kuan-Wei Chiu wrote:
> > Introduce an overview of the min heap API, detailing its usage and
> > functionality. The documentation aims to provide developers with a
> > clear understanding of how to implement and utilize min heaps within
> > the Linux kernel, enhancing the overall accessibility of this data
> > structure.
> 
> Please format this text to 80 columns.  Just pass it through 'fmt'.
> 
> > +This API supports efficient insertion, deletion, and access to the minimum element. It is optimized
> > +for use in systems with performance constraints and is suitable for scenarios where the minimum
> > +element needs to be accessed or updated frequently.
> 
> All systems have "performance constraints".  I'm not sure what that
> means in this context.
> 
> > +This document provides a guide to the Min Heap API, detailing how to define and use min-heaps.
> > +Please note that users should not directly call functions with **__min_heap_*()** names, but should
> > +instead use the provided macro wrappers.
> 
> You can always remove "Please note that".  It has no meaning.  Just say
> "You should not call functions with **__min_heap_** prefixes; use the
> functions documented here instead.
> 
> > +Min-Heap Definition
> > +-------------------
> > +
> > +The core data structure for representing a min-heap is defined using the **MIN_HEAP_PREALLOCATED**
> > +and **DEFINE_MIN_HEAP** macros. These macros allow you to define a min-heap with a preallocated
> > +buffer or dynamically allocated memory.
> > +
> > +Example:
> > +
> > +.. code-block:: c
> > +
> > +    #define MIN_HEAP_PREALLOCATED(_type, _name, _nr)
> > +    struct _name {
> > +        int nr;         /* Number of elements in the heap */
> > +        int size;       /* Maximum number of elements that can be held */
> > +        _type *data;    /* Pointer to the heap data */
> > +        _type preallocated[_nr];  /* Static preallocated array */
> > +    }
> 
> This isn't an example of code the reader of this document would write
> though, is it?  This looks like code already provided.  An example
> should be something like:
> 
> MIN_HEAP_PREALLOCATED(struct page, my_pages, 23);
> 
> ... or whatever would actually make sense.

Thank you for the review. I'll wait for the decision on whether to keep
the non-inline API before sending a v2 patch to address these comments.

Regards,
Kuan-Wei
