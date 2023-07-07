Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00ECEB64D9
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jul 2023 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688726486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hKI7XCEj0FL23XfOYw7coThBDK237KwynGS2qc7Io2o=;
	b=T45ZMa1i4hB95GuQ8dRoJbeILu7ta99ZrBY1/SahRphjB40RL4d0Fiov+eClJgInUH+13B
	jdCAn70rfOXgKQjlXfA+uIsMDPH3O2Ls+rZHyWpZCNhbhY3FOU8YoH8wqgNabpbfwsNjSy
	Y+o39WOjGK9M46mXhdbFAA8gyKa1jVU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-KrEkCIUCOWiw2_5WCLkD_g-1; Fri, 07 Jul 2023 06:41:23 -0400
X-MC-Unique: KrEkCIUCOWiw2_5WCLkD_g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ABEC8910FB;
	Fri,  7 Jul 2023 10:41:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E380492B01;
	Fri,  7 Jul 2023 10:41:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 061C7194658F;
	Fri,  7 Jul 2023 10:41:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CE2A1946589
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C332F6424; Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F4B6F640B;
 Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 0A67530C0457; Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 06C5A3FB76; Fri,  7 Jul 2023 12:41:19 +0200 (CEST)
Date: Fri, 7 Jul 2023 12:41:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
In-Reply-To: <20230705201812.GB866@sol.localdomain>
Message-ID: <daf1c4c8-292f-4954-9bde-b6d891a832dc@redhat.com>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-3-giovanni.cabiddu@intel.com>
 <20230705201812.GB866@sol.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 2/3] crypto: api - adjust meaning of
 CRYPTO_ALG_ALLOCATES_MEMORY
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Fiona Trahe <fiona.trahe@intel.com>, herbert@gondor.apana.org.au,
 horia.geanta@nxp.com, gaurav.jain@nxp.com, heinzm@redhat.com,
 snitzer@kernel.org, pankaj.gupta@nxp.com, linux-kernel@vger.kernel.org,
 iuliana.prodan@nxp.com, dm-devel@redhat.com, qat-linux@intel.com,
 linux-crypto@vger.kernel.org, meenakshi.aggarwal@nxp.com, davem@davemloft.net,
 agk@redhat.com, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 5 Jul 2023, Eric Biggers wrote:

> On Wed, Jul 05, 2023 at 05:40:08PM +0100, Giovanni Cabiddu wrote:
> 
> > Algorithms that do not set this flag will guarantee
> 
> "will guarantee" => "guarantee"
>  
> > that memory is not allocated during request processing, except in
> > the avoidable exception cases described below.
> 
> "avoidable exception cases" => "exception cases"
> 
> Whether they are avoidable depends on the user.
> 
> > * Users can request an algorithm with this flag unset if they can't handle
> > * memory allocation failures or sleeping during request processing.
> 
> Why add the "sleeping during request processing" part?  Isn't that controlled on
> a per-request basis by CRYPTO_TFM_REQ_MAY_SLEEP which is a separate thing?
> 
> > * They should also follow the constraints below.
> 
> "should" => "must"
> 
> > + *	- The input and output scatterlists must have no more than 4 entries.
> > + *	  If the scatterlists contain more than 4 entries, the algorithm may
> > + *	  allocate memory.
> 
> "If the scatterlists contains" => "If either scatterlist contains"
> 
> Otherwise it is unclear whether this is talking about the length of each
> scatterlist individually, or the sum of their lengths.
> 
> - Eric

Hi

I wouldn't change the meaning of CRYPTO_ALG_ALLOCATES_MEMORY (because 
people will forget about this subtle change anyway).

Also note that dm-integrity allocates arbitrarily large sg-lists when 
encrypting the journal, so if you change the meaning of 
CRYPTO_ALG_ALLOCATES_MEMORY, there would be no flag left for dm-integrity 
to test.

I would introduce a new flag, something like 
CRYPTO_ALG_ALLOCATES_MEMORY_FOR_5_OR_MORE_SG_ENTRIES. dm-crypt can then 
filter the algorithms based on this flag - and the rest of the kernel code 
may stay unchanged.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

