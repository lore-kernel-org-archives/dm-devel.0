Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F98FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jan 2022 07:02:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-GBn8Hw2bM6uFKxa8kUwiiA-1; Fri, 14 Jan 2022 02:02:39 -0500
X-MC-Unique: GBn8Hw2bM6uFKxa8kUwiiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D261083F61;
	Fri, 14 Jan 2022 07:02:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B915410589DF;
	Fri, 14 Jan 2022 07:02:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EEE851809CB8;
	Fri, 14 Jan 2022 07:02:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DMHQdc024962 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 17:17:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B55491120AC4; Thu, 13 Jan 2022 22:17:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0B9E1120AC2
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 22:17:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0AAD811E7A
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 22:17:21 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-147-TdT-2IYEN2u2D5tvh0U4nQ-1; Thu, 13 Jan 2022 17:17:20 -0500
X-MC-Unique: TdT-2IYEN2u2D5tvh0U4nQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="224813986"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; d="scan'208";a="224813986"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
	by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	13 Jan 2022 14:16:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; d="scan'208";a="475511498"
Received: from nlabrum-mobl.amr.corp.intel.com (HELO [10.209.104.247])
	([10.209.104.247]) by orsmga006-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 14:16:13 -0800
To: "Chang S. Bae" <chang.seok.bae@intel.com>, linux-crypto@vger.kernel.org,
	dm-devel@redhat.com, herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	ardb@kernel.org, x86@kernel.org, luto@kernel.org, tglx@linutronix.de,
	bp@suse.de, dave.hansen@linux.intel.com, mingo@kernel.org
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <215bc107-aa47-62bd-65ad-f76e65ee75d5@intel.com>
Date: Thu, 13 Jan 2022 14:16:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220112211258.21115-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 14 Jan 2022 01:58:10 -0500
Cc: ravi.v.shankar@intel.com, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, charishma1.gairuboyina@intel.com,
	kumar.n.dwarakanath@intel.com
Subject: Re: [dm-devel] [PATCH v5 00/12] x86: Support Key Locker
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/12/22 1:12 PM, Chang S. Bae wrote:
> A couple of other things outside of these patches are still in progress:
> * Support DM-crypt/cryptsetup for Key Locker usage (Andy Lutomirski)
>   [2].
> * Understand decryption under-performance (Eric Biggers and Milan Broz)
>   [3][4].

I really like when contributors are clear about why they are posting
their series and what their expectations are.  This posting leaves me a
bit confused as to what you expect the maintainers to do.

Should the maintainers ignore this series until those in-progress things
are done?  Or, do you expect that this could be merged as-is before
those are resolved?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

