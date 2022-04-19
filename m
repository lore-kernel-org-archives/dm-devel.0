Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A7FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 06:47:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-ywJLJLTLOQ2LCtNA56fMMQ-1; Wed, 20 Apr 2022 02:46:56 -0400
X-MC-Unique: ywJLJLTLOQ2LCtNA56fMMQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91928299E749;
	Wed, 20 Apr 2022 06:46:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 448B643211E;
	Wed, 20 Apr 2022 06:46:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D949019451F2;
	Wed, 20 Apr 2022 06:46:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E6DA1947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 19 Apr 2022 10:33:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2067D40FF720; Tue, 19 Apr 2022 10:33:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C5B440FF71F
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 10:33:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04CB83811A30
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 10:33:06 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-rf4icdSENCW0hG6vTzHieQ-1; Tue, 19 Apr 2022 06:33:04 -0400
X-MC-Unique: rf4icdSENCW0hG6vTzHieQ-1
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="326631385"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; d="scan'208";a="326631385"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Apr 2022 03:32:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; d="scan'208";a="529259623"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314)
 ([10.237.222.76])
 by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Apr 2022 03:31:58 -0700
Date: Tue, 19 Apr 2022 11:31:50 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <Yl6PlqyucVLCzwF5@silpixa00400314>
References: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
 <20220410194707.9746-2-giovanni.cabiddu@intel.com>
 <YlRnVBYl1eJ+zvM5@gmail.com>
MIME-Version: 1.0
In-Reply-To: <YlRnVBYl1eJ+zvM5@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 20 Apr 2022 06:46:52 +0000
Subject: Re: [dm-devel] [PATCH v3 1/3] crypto: qat - use pre-allocated
 buffers in datapath
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
Cc: Marco Chiappero <marco.chiappero@intel.com>, herbert@gondor.apana.org.au,
 qat-linux@intel.com, stable@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org,
 Wojciech Ziemba <wojciech.ziemba@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Belated response on this - I was out last week.

On Mon, Apr 11, 2022 at 05:37:24PM +0000, Eric Biggers wrote:
> On Sun, Apr 10, 2022 at 08:47:05PM +0100, Giovanni Cabiddu wrote:
> > If requests exceed 4 entries buffers, memory is allocated dynamically.
> > 
> > In addition, remove the CRYPTO_ALG_ALLOCATES_MEMORY flag from both aead
> > and skcipher alg structures.
> > 
> 
> There is nothing that says that algorithms can ignore
> !CRYPTO_ALG_ALLOCATES_MEMORY if there are too many scatterlist entries.  See the
> comment above the definition of CRYPTO_ALG_ALLOCATES_MEMORY.
From the conversation in [1], I assumed that a cap on the number of
pre-allocated entries in the scatterlists was already agreed.

> If you need to introduce this constraint, then you will need to audit the users
> of !CRYPTO_ALG_ALLOCATES_MEMORY to verify that none of them are issuing requests
> that violate this constraint, then add this to the documentation comment for
> CRYPTO_ALG_ALLOCATES_MEMORY.
Makes sense. I see that the only users of !CRYPTO_ALG_ALLOCATES_MEMORY
are dm-crypt and dm-integrity but I haven't done an audit on those yet
to understand if they use more than 4 entries.

Regards,

[1] https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/

-- 
Giovanni

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

