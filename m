Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D82C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205--0Lzw1l-NVq20dMScRAnQg-1; Thu, 24 Mar 2022 11:34:48 -0400
X-MC-Unique: -0Lzw1l-NVq20dMScRAnQg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04DBC3C021B3;
	Thu, 24 Mar 2022 15:34:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8058401475;
	Thu, 24 Mar 2022 15:34:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D151194034F;
	Thu, 24 Mar 2022 15:34:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BD97619451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 21 Mar 2022 12:28:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ACC371410F35; Mon, 21 Mar 2022 12:28:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A933C1410DD5
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 12:28:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EC5D1066558
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 12:28:57 +0000 (UTC)
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-5Y3oyvEdOzKwB40ayiGmKg-1; Mon, 21 Mar 2022 08:28:52 -0400
X-MC-Unique: 5Y3oyvEdOzKwB40ayiGmKg-1
Received: from [187.39.124.208] (helo=[192.168.0.110])
 by fanzine2.igalia.com with esmtpsa 
 (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
 id 1nWH9I-000BLL-CG; Mon, 21 Mar 2022 13:28:36 +0100
Message-ID: <1ccc06f4-3fff-8a6e-2a66-3f117ca6f282@igalia.com>
Date: Mon, 21 Mar 2022 09:28:15 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Coiby Xu <coxu@redhat.com>
References: <20220318103423.286410-1-coxu@redhat.com>
 <c06a21cc-e1c1-e627-f908-ebc2a041e29a@igalia.com>
 <20220321014150.w6wux5azabweu7dr@Rk>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220321014150.w6wux5azabweu7dr@Rk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:41 +0000
Subject: Re: [dm-devel] [RFC 0/4] Support kdump with LUKS encryption by
 reusing LUKS master key
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
Cc: Baoquan He <bhe@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 kexec@lists.infradead.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 20/03/2022 22:41, Coiby Xu wrote:
> [...]
> 
> I believe some users have security concern for where to save vmcore.
> This use case exactly fits your description and your proposed solution
> shall be good for this type of users. But I think many more users may
> just choose to encrypt the hard drive when installing the system and
> they would naturally expect kdump to work for the case of full disk
> encryption. So your proposed solution may not address the latter case 
> where there is a much large user base.
> 

Thanks Coiby, makes sense, your idea is more generic and seems to
address all the use cases!
Cheers,


Guilherme

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

