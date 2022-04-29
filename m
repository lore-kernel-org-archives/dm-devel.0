Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF47C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 07:34:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-04OymbTHNj-tQlc2dY0qZQ-1; Mon, 02 May 2022 03:34:33 -0400
X-MC-Unique: 04OymbTHNj-tQlc2dY0qZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 777EB3C025C9;
	Mon,  2 May 2022 07:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50E5D53CD;
	Mon,  2 May 2022 07:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D3941947063;
	Mon,  2 May 2022 07:34:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 46A68194704B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Apr 2022 17:27:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 227F9416385; Fri, 29 Apr 2022 17:27:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E35B415F50
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 17:27:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02FC01014A67
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 17:27:16 +0000 (UTC)
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-V2kYEpn5Ns-EoNKdqobrow-1; Fri, 29 Apr 2022 13:27:14 -0400
X-MC-Unique: V2kYEpn5Ns-EoNKdqobrow-1
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
 by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id
 20220429172713usoutp02645adda6df5e5dd344de6f9eb3a4506a~qbhE6Gv4Q0403704037usoutp021;
 Fri, 29 Apr 2022 17:27:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com
 20220429172713usoutp02645adda6df5e5dd344de6f9eb3a4506a~qbhE6Gv4Q0403704037usoutp021
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
 [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220429172713uscas1p2d8cbaee723fac12a091c47f415ff47f3~qbhEhXC2I0887908879uscas1p2u;
 Fri, 29 Apr 2022 17:27:13 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
 ussmges3new.samsung.com (USCPEMTA) with SMTP id A1.6D.09749.1FF1C626; Fri,
 29 Apr 2022 13:27:13 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
 [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220429172712uscas1p2364e5c23f9df513deed5c6c522e9d6b1~qbhD_H7sP0887908879uscas1p2s;
 Fri, 29 Apr 2022 17:27:12 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-8b-626c1ff14c8b
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
 ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id D7.83.09672.0FF1C626; Fri,
 29 Apr 2022 13:27:12 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
 SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.2375.7; Fri, 29 Apr 2022 10:27:11 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
 SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
 29 Apr 2022 10:27:11 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Thread-Topic: [PATCH 06/16] nvmet: use blk_queue_zone_no()
Thread-Index: AQHYWlBImLMJLgQoTkmYJjdfDQL7UK0HnXCA
Date: Fri, 29 Apr 2022 17:27:11 +0000
Message-ID: <20220429172711.GC174938@bgt-140510-bm01>
In-Reply-To: <20220427160255.300418-7-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbVRjGc+69vS1g3aUj4wDLmI0fk2mljGVHtoHo4q5TGcnikjmdFLmW
 z4Lt6th0CmGMUYaULWx6UVrQVBhsrHTRSVtEdHwMm5ry3Qw2AkwMUEDYCiJMyu0S/vu9532e
 8zw5OQJc1EwGC1IUxxmlQpYuJn2JH1sf2F+cDU1PDO9lSVR/uxVHtYMlJLo0s4ijzjIbhi6U
 fMVHSzY7jqyuch76cyEXQzW1tzA0Ws/i6HzzDIGWNUOrZ2eGcfTfsBRdaOkFaKyHxZDVuR05
 Rqr5yFG1H1msHQTqavyGRDrDGB9pzz7AUb92DKDSNhMPXZuYJlC7M+SVELqr+016pb2OpEvz
 XHzaPmQk6C6bmm64UkjSlTllOG36/gvarJ/DaPNADkkX57lI+uf8uzx6uqmHpOtv9BC01mTk
 0XMNW+L93/Xdk8Skp3zCKF+KTvBNts0O8bLmfbK/0z/CcoBOoAE+AkhFQk2uGdcAX4GIqgHQ
 cHaU51mIqHwMdrjfeiyyDjYRnOgqgBP3dF7HLIA/VHzpHQwAjl97SHosJBUOl9qMuIcDqG3w
 frcJ8zBOafzgYFmkhzdSL8OixcZVvWBVEwWn9DSHEVD/+5qToJ6BFa2ONaeQ2gkrrk4SHvah
 dsOugeK1JEBtgu7bdd7bA6FzVIdxpf1hVbkF53gTXGkcJjl+Ct51/83n9C9AvfkfkuNo2Ovq
 xjneDg2VEziX6w87vh4lOG8Q/LW6f+0hIGX0hc4itzdsHxwaqfSGhcDlQQPGiQoAnNE28bhB
 C+CdqUVvjd1wpbCXrwVPs+uas+tasetasetaseta6QHvCghUq1QZcka1Q8GckKhkGSq1Qi75
 MDOjAax+8s6V37JuAqdzVtICMAFoAVCAiwOE8+bkRJEwSXbyFKPM/ECpTmdULSBEQIgDhYaU
 6zIRJZcdZ9IYJotRPt5iAp/gHGxvWqi96nS89Dml9tDbsURsLDsQ91fMVkUb61cdhIvaZLLK
 0+5UC1lQ0x5DJOx57/0a17kjAaUFS53lm3mTVlYf5so40Jdw6qdzOcJ7KxVw7yWxunuz/B13
 3hNxc/yLRw8Khw/P7Kpbfv7Zz6buB40Umq6HHiX8mcxx6f5d0ptRWH6kX5vlzLxkZ0/f64fj
 ojYcU7gb5c5Eh1+R7o+D/75hOf/Ro7TWGzGfH7kcEd+ccGJLM+EIpz/NJosrEiNei264eCz1
 l6SChT510cOSmMnw1PG+AduGsG12P0nwkyMhjlr7yelbC/1bExROiTG6NDRzR2r2pJJ49dDH
 dzaymtyOb21iQpUsk4bhSpXsf7Ss+D1TBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWS2cA0SfeDfE6SwddX0hbrTx1jtlh9t5/N
 YtqHn8wWp6eeZbKY1D+D3eL32fPMFnvfzWa1uPCjkcli5eqjTBZP1s9itug58IHF4m/XPaBY
 y0Nmiz8PDS0mHbrGaPH06iwmi723tC0uPV7BbnFpkbvFnr0nWSwu75rDZjF/2VN2iwltX5kt
 bkx4ymgx8fhmVot1r9+zWJy4Je0g7XH5irfHvxNr2DwmNr9j9zh/byOLx+WzpR6bVnWyeSxs
 mMrssXlJvcfuBZ+ZPHbfbGDz6G1+x+axs/U+q8f7fVfZPNZvucriMWHzRlaPz5vkAgSjuGxS
 UnMyy1KL9O0SuDLOfrzHWvCFs2Lxgv9MDYzzOboYOTkkBEwk9t7dx9LFyMUhJLCaUeLVwj42
 COcjo0T31lWsEM4yRomjJ1vYQFrYBAwkfh/fyAxiiwhoSDy7spkJpIhZoINb4uvPJYwgCWEB
 S4nun7uAGjiAiqwk3i7wgDCNJBYcAWtlEVCVmHfsEhOIzStgKjFv7RuoK/YzStzpOQC2i1PA
 WuLyzV4wm1FATOL7qTVgDcwC4hK3nsxngnhBQGLJnvPMELaoxMvH/1ghbEWJ+99fskPU60gs
 2P2JDcK2k7j27gozhK0tsWzha2aIIwQlTs58wgLRKylxcMUNlgmMErOQrJuFZNQsJKNmIRk1
 C8moBYysqxjFS4uLc9Mrio3yUsv1ihNzi0vz0vWS83M3MQKT4Ol/h6N3MN6+9VHvECMTB+Mh
 RgkOZiUR3i+7M5KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ876MmhgvJJCeWJKanZpakFoEk2Xi
 4JRqYLI1iLl7813Xrp8bvba3TPXdWX7PIehUzAJew58Lku136jnPr5/ey6NsrWKgezbSu2lF
 8fv6O8HJn0TWV4mu1XXylPktK3Hx8OFt+7SnP1q12Srvs57x8pUlDi7vxGWWPb3EZa7qyr4v
 9Oh8ubaDq320vewdpVQ8o5hYOb5NrT512flPaCXnDn1hJw0/cbfusltfv/BdfXB90ctfoUc8
 JQrZ1LakHM8MD+RjqJt1nfv4h4o7kkFnnFIvV4rkVj5W2rIq+KG1EvNDNnO50vbNy8x27V25
 4Z7AmXnzfKrml+YmT9Y5/Ez9F5fYjOW/eV6ub9Q7ukhgrZLXldZ9OV/+yj1ar/D3ui3fs0QV
 /qINt5RYijMSDbWYi4oTAXgIuhDxAwAA
X-CMS-MailID: 20220429172712uscas1p2364e5c23f9df513deed5c6c522e9d6b1
CMS-TYPE: 301P
X-CMS-RootMailID: 20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035@eucas1p1.samsung.com>
 <20220427160255.300418-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 02 May 2022 07:34:27 +0000
Subject: Re: [dm-devel] [PATCH 06/16] nvmet: use blk_queue_zone_no()
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
Cc: "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jonathan.derrick@linux.dev" <jonathan.derrick@linux.dev>,
 "kch@nvidia.com" <kch@nvidia.com>, "chao@kernel.org" <chao@kernel.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <38ADAEB8F5BE6745ACC883C41F5D725E@ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 27, 2022 at 06:02:45PM +0200, Pankaj Raghav wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Instead of open coding the number of zones given a sector, use the helper
> blk_queue_zone_no(). This let's us make modifications to the math if
> needed in one place and adds now support for npo2 zone devices.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/nvme/target/zns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index e34718b09550..e41b6a6ef048 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -243,7 +243,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
>  	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
>  
>  	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
> -		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
> +	       bdev_zone_no(req->ns->bdev, sect);
>  }
>  
>  static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
> -- 
> 2.25.1
>


Looks good.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

