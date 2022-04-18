Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 364A6C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 03:01:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-dCJrJJmsPym8odBZw-6GHA-1; Sun, 17 Apr 2022 23:01:08 -0400
X-MC-Unique: dCJrJJmsPym8odBZw-6GHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09E451C068C4;
	Mon, 18 Apr 2022 03:01:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 652B8145BA54;
	Mon, 18 Apr 2022 03:01:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 380BC19451F3;
	Mon, 18 Apr 2022 03:01:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8EF6E19451F3
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 03:01:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8205D2166B1A; Mon, 18 Apr 2022 03:01:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D1082166B26
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 03:01:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97AE529AB3ED
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 03:01:00 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-OhE7F9w0MTOyUNq3Dwci0Q-2; Sun, 17 Apr 2022 23:00:59 -0400
X-MC-Unique: OhE7F9w0MTOyUNq3Dwci0Q-2
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; d="scan'208";a="310099194"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 11:00:56 +0800
IronPort-SDR: DVNvXUepcoG36JOv82PZVldpdflqzSfxZ10AiGqjKqIDhWs5zVISn/wFdTS5uJPHiD/8VZSB4b
 5nrAyzO99flt8gRDl/s01VdXyptAU4whUTokCEN4fzEguDkrmhwnQpZgm2xhQFhO8kTipF/xcz
 vTQTssEJ9wuhJGVdFxBxRjchSRwP5l2l3NR4ebLSPTI/yso0l5CIRSBvTikL+XiYfdjT1q6sdz
 yCOs79MYg1c+3Bo5s1L/2rBJ3sAYVi8vsY/Vw0sJdQ3iTULAWYSstIHFtU9KuaiGrGXT+Ex6Is
 0hPJYjnE5zC7TwS+7Nt4Xpf/
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 17 Apr 2022 19:31:17 -0700
IronPort-SDR: K9C5NZAIK048tXI8LFFkSX3dwVItY+aqcwY1ocs3AWZqCcPR9NhDdwO6LQcKNpJ+Qr5qPc6qNZ
 mCG0RLDI0NfOozEL0i1S8Z/0vJbRW1LYp0zCICtIMRAc/HAKo/Yah/T+qOn5r8lISmkFEAuDhP
 Ej1CpCYKhMAot6MNnCoP4dxZA/t4sG/e3NUv5Xz4ItGBnxZKjMswPzsf9M0vd9EyApaUv4tzT6
 8VT3b3XCDrHm+8G+UFDqAeDw0A33aQXYGVTEp9mqqny1JKOLk/Pi5J4Z+EMCqiycBPfgU0gRSB
 aMs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 17 Apr 2022 20:00:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhWsM6ZYfz1SVny
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 20:00:55 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id ZIjJvPSqPAtu for <dm-devel@redhat.com>;
 Sun, 17 Apr 2022 20:00:55 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhWsL3LHnz1Rvlx;
 Sun, 17 Apr 2022 20:00:54 -0700 (PDT)
Message-ID: <378611be-45ea-6085-7848-83380642c81a@opensource.wdc.com>
Date: Mon, 18 Apr 2022 12:00:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
References: <20220418022733.56168-1-snitzer@kernel.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [dm-5.19 PATCH 00/21] dm: changes staged for 5.19
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/18/22 11:27, Mike Snitzer wrote:
> Hi,
> 
> This patchset reflects what I've staged in linux-dm.git's "dm-5.19"
> branch (also staged in "for-next" for linux-next):
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
> 
> It build's on jens/for-5.19/block branch (which is based on v5.18-rc3)

Mike, thanks for posting. We will run this on zoned stuff to check.
Note that patches 13 to 20 are empty...

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

