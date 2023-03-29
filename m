Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9ACC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680133790;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lf+48HjqeUB8Oz4JwMp9Xxv0e4PfMPCoIZuqBXGx5CU=;
	b=dkuX9usf6tgoHhAeDLhfr/EsfGF/56PWWi9DJPNU6zTuxKhN7kBdSU+LxlgQKiCuj3p/wW
	s0SY54FZWPpgaSehoQbeGO24yqYiK/aVjeGN2Icv3ovFQPZCt9Jt9+jYFAW+bNxy2TQiK+
	VFBaSqF3LeC3e4ST3gzzphSMGgFecJc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-jhtFbFJOOF6E1mXB1BQG6g-1; Wed, 29 Mar 2023 19:49:46 -0400
X-MC-Unique: jhtFbFJOOF6E1mXB1BQG6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EF0885A588;
	Wed, 29 Mar 2023 23:49:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D6B8492C3E;
	Wed, 29 Mar 2023 23:49:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF0621946588;
	Wed, 29 Mar 2023 23:49:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E5181946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:49:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FD3D2166B34; Wed, 29 Mar 2023 23:49:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 089482166B33
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:49:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCB691C05AD7
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:49:43 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-HnKzi4OSMjW1bAs48C2hGQ-3; Wed, 29 Mar 2023 19:49:39 -0400
X-MC-Unique: HnKzi4OSMjW1bAs48C2hGQ-3
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="338904662"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:49:36 +0800
IronPort-SDR: GAAWx/bLgIfdS1NyGY0ATdcSljk5awVrmvoa4BrhTcBNtL72SDzeThUS3It3yuV81pIZ1fypB1
 X/x9LGNG9M9hOcfTcFgD9n9gYuDYollcYH6KsERKsRFfr0kdN4vIA2U21MxsltCkBQNXGaoCYu
 RM0K3PkLWipGPJeY0v1dPNO2TbiZaUnKva2B/+MSSL8qDApo/gVxwXYJexAVEQbINgyrJeZj9N
 rN16wQVWhWaPiN3DmISsuyBgJ32ifMgvNFyb2MNwJOzNw4Bluj7yK1eWEGO0ciIeKNHcT701Y2
 Erw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:00:04 -0700
IronPort-SDR: SMD09N2LLyy6YbvDzUBn6xT4dyqsXQC1HrGoDYr3e2MHeiQcmq+5rfbEPhpARDT3BnpFo57gAh
 5aXLNi29zXqQ9aB5CkOWHCE7nnVqfwuWzjEzez3QWHXhwdV+YbZ4iaYc3nStG9lUAnuCt6JyeQ
 WDRIyxiyDPVj7LE4uI043HtiqJhCYmXx3H+y0cWBUjGYIqLfOSIqsnLRVaoRwBzc38IaehUJsw
 HZqEoGis+x7K9VTJ+MMDcIK20cstMZTd3uBkhbITeZ1TBJ6RuyQ59x3sBEjbTLFkRtjMGVNs3G
 Xco=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:49:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn3Dv3j7fz1RtVn
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:49:35 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id kWDVrRUP7z61 for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:49:34 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn3Dq22DKz1RtVm;
 Wed, 29 Mar 2023 16:49:31 -0700 (PDT)
Message-ID: <3a0f0c92-63cb-3624-c2fe-049a76d1a64a@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:49:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 18/19] dm-crypt: check if adding pages to
 clone bio fails
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
Cc: linux-raid@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/30/23 02:06, Johannes Thumshirn wrote:
> Check if adding pages to clone bio fails and if bail out.

Nope. The code retries with direct reclaim until it succeeds. Which is very
suspicious...

> 
> This way we can mark bio_add_pages as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

With the commit message fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

