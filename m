Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D257C77B62
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680133105;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=r5kYr8fVTEW04bqRUTrfu4xfRFcljwllGC1KjsWMyX4=;
	b=W7qZx6tIe0edyuhVaL8iVDmjgT1NM/fxBt3OQ3t/Qs4DZhZIpo9DNH78JI9BnD29PsTkDf
	kdWUfG4LybBLExdtHzVc0AVmcPZv+2CovXyGxvr2SbeIBNlbsdtL0KwgjuAUEzyHYNTDxl
	XF9jEjPqVCyOzpipHT+wxUlZXPqdDCM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-T2GX_gfJNMKGqb1fr40tKA-1; Wed, 29 Mar 2023 19:38:24 -0400
X-MC-Unique: T2GX_gfJNMKGqb1fr40tKA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CCCC3823A09;
	Wed, 29 Mar 2023 23:38:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3AB55492B01;
	Wed, 29 Mar 2023 23:38:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00CEC1946588;
	Wed, 29 Mar 2023 23:38:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13F0A1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:38:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0237F1415139; Wed, 29 Mar 2023 23:38:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED54E14171BB
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:38:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1CA93C02B70
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:38:20 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-t1VFpO8LOaGHXimqjJ9g3Q-1; Wed, 29 Mar 2023 19:38:18 -0400
X-MC-Unique: t1VFpO8LOaGHXimqjJ9g3Q-1
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="226828787"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:38:15 +0800
IronPort-SDR: qY6piqA+q5VFASJTC19fvXoIgo1A1+VN//ya/xapd8YINfxKS8RwzHvJywwR0/aZgjwP+szJ1n
 mJAbCcnBQfnx9iA6T5UMr4b7Cjugvk1cznkdmrOtGOwyo9e0+avydIC7YVthDEKp/Qgyu7oXtJ
 HOSWw4M3gfrK42tMeTvj6jJrIODR5oFX5GSpAnl+hzbzEfIxOeAQNyqeebG9QgDuZR9PkvRjcn
 AugUkI2AgcMWw0h7pIt+9+o/U7vB9MweLkRdVcGP5AZ4s03Rr0r4vzxvLTV0gotiGKE58AIhqW
 Y2s=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 15:48:43 -0700
IronPort-SDR: foKzZTwhOP0CDQ4+LUv/BXXnde2TDEH53VCAOoXMfxj0SZi+9GgZ/rSfvuXGcJiyGGJDpxjye8
 EsuHA+cM8pRgvFruYgBghTeyq3e9t4l62uS0IFHEDja0mrhZEpqgM0XT+7NOflpVf70UjxwpYA
 CE90Y6RSPFiWokJ+467zawslAdRczhBwLJDYEPks/umLI9gO5rzmAd+UGiGwj4fKdO2EXjHiOl
 /PosFS/9Hl34ks7zG39Gkge4mCH+k7mJeaL0jJjbph024fM2lS5Pv9exdof98hLlgI216njWvo
 LXc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:38:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2zq0hNbz1RtVw
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:38:15 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id by-l81c-f904 for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:38:14 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2zl2Krzz1RtVm;
 Wed, 29 Mar 2023 16:38:11 -0700 (PDT)
Message-ID: <546786e3-79b3-f9d0-008c-23d2de7eb3de@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:38:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <76f5748e386870c034b46e919101a878b87a79bf.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <76f5748e386870c034b46e919101a878b87a79bf.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 15/19] md: check for failure when adding
 pages in alloc_behind_master_bio
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 jfs-discussion@lists.sourceforge.net, Matthew Wilcox <willy@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, David Sterba <dsterba@suse.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-btrfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/30/23 02:06, Johannes Thumshirn wrote:
> alloc_behind_master_bio() can possibly add multiple pages to a bio, but it
> is not checking for the return value of bio_add_page() if adding really
> succeeded.
> 
> Check if the page adding succeeded and if not bail out.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

