Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7778AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:34:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 89B93610A3
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89B93610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-IJwWuDd8NgGKU5JOBbT0mg-1; Mon, 18 Oct 2021 03:34:47 -0400
X-MC-Unique: IJwWuDd8NgGKU5JOBbT0mg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09CE4806668;
	Mon, 18 Oct 2021 07:34:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DEC469203;
	Mon, 18 Oct 2021 07:34:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 32A231809C84;
	Mon, 18 Oct 2021 07:34:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FI1FXw018646 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 14:01:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 38215404727A; Fri, 15 Oct 2021 18:01:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 330C84047272
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 18:01:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1769C811E76
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 18:01:15 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-262-spglJb4FPAiYPrCAlh55Sw-1;
	Fri, 15 Oct 2021 14:01:12 -0400
X-MC-Unique: spglJb4FPAiYPrCAlh55Sw-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2109.outbound.protection.outlook.com [104.47.17.109])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-7-59orNfWqPLe_NL2di8xrVA-1; Fri, 15 Oct 2021 20:01:09 +0200
X-MC-Unique: 59orNfWqPLe_NL2di8xrVA-1
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
	by AS8PR04MB8197.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16;
	Fri, 15 Oct 2021 18:01:06 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
	([fe80::a555:3b27:dc03:8fcb]) by
	AM5PR04MB3089.eurprd04.prod.outlook.com
	([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4587.030;
	Fri, 15 Oct 2021 18:01:06 +0000
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-5-hch@lst.de>
From: Lee Duncan <lduncan@suse.com>
Message-ID: <211d2871-6232-8111-987f-077a95d92a1a@suse.com>
Date: Fri, 15 Oct 2021 11:00:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20211015132643.1621913-5-hch@lst.de>
X-ClientProxiedBy: AM7PR02CA0013.eurprd02.prod.outlook.com
	(2603:10a6:20b:100::23) To AM5PR04MB3089.eurprd04.prod.outlook.com
	(2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by
	AM7PR02CA0013.eurprd02.prod.outlook.com (2603:10a6:20b:100::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16
	via Frontend Transport; Fri, 15 Oct 2021 18:00:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee094ca9-ed7b-4cfc-69c7-08d99005c276
X-MS-TrafficTypeDiagnostic: AS8PR04MB8197:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR04MB8197C5ACCBFBED7DB371A09DDAB99@AS8PR04MB8197.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: GzbIteyedOPac8q2TN/axoG9jTlv8IJTUyUKJCRq0WMWjj6oe6wZwIeved2EBPJkMepYz91pj+aJQRl7dWfSDuXsWeM/aD3y99iwJR47akk9hm6OCT7CSSxDTmsaibRq6KH/CrqLmrcbuVaJEkalO29yOpzsT2ozqk4v6482lciJeV4AdSSvmVSRDDZ1eY4wsCtq/IEYwoPd0uf2IwUsW0WN/c8FPOqg/J2uCiaFaW5B6Bj/j0UnQD48Aa0K4API3uojrLqRSAJFAa2i1bB2aQjKtrxIaCeupZZSfdQLsfkdhHfSU0HkYUzo6y39PI8eI8vzfSDBDhaOOB8KdJIm5YOg4PHc8SU+/yanDY3J6oJbWGNQEq13bTa6fG6BLXZMOw3Yga4HncNScZRaxoCESWQF3IsiUcm8C9CRPZp/imzQZA3skVfUXX1c+QBKWXLu4G3FWWDL26CzwNDeOnUKi5yIj4hcacJTUEt6AMnzUrbxV7HzXyQNJu1wZlCu/4oWtqRiLTCaW6kZJeIP0MRyWeaC2l4+Bny1KzF+IyYDPbWJNvCWU8mNx3zQ+aEntpQajSUEPLfWgLxnz82Sb7QgaKYokBOXpySuxBDJc+hb2POhXYqrRnT7IZI8jSyS9CDKjsTUixhMyCxP4P1XhKefTbR5yW9OGIqhxC36UWi2Wgu8GhsgNSoY8vEOaQrGdTQgnd9pRMCFpIbTkZyg7xIMyEIPXUX7W82aUxu21CgWw7c=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AM5PR04MB3089.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(66946007)(66476007)(7406005)(186003)(66556008)(53546011)(83380400001)(110136005)(8936002)(26005)(4744005)(54906003)(316002)(7416002)(31686004)(16576012)(508600001)(4326008)(8676002)(38100700002)(31696002)(36756003)(2616005)(956004)(6486002)(2906002)(5660300002)(86362001)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXM2cEQ2U2prbWVjcklZNVllMXFhSG9IMVZta25VcnJhbEx1bmtLQnNQMmYx?=
	=?utf-8?B?MmJVdGdTamtVZDB5UWFTMUZ0OURHK2pacEJiRVcrVklYajV2ZHJldEo2NkVt?=
	=?utf-8?B?Y3B6UHZhN1NBZXFtWmxDSzZuaGhmSENNa01JYjNyQlRITnRoNDZZVjc3V0N2?=
	=?utf-8?B?RjNJR1dTZExsMXEyREVOQ2ZSWFBBdUw0bmFtUEZmT2Y2OEg4RzhPM3BKRUJU?=
	=?utf-8?B?QVY0SnRwUDh0TUlTbHhsT2ptZ1VONFIrU2M0ckpqMzl1NGdjcC81RXI5Z0hu?=
	=?utf-8?B?ZTFGeEVBdDVBRWpxOGc2N0RmL1V5R1VVQTF0ZmtQWitaOWZvem15MmpEU2ZW?=
	=?utf-8?B?UnhyT0xxZmhPeWg3bHl0M0pYTkNJSGExcFlzZXdJR01uN0RRV2VvS1RrRExV?=
	=?utf-8?B?UGI0MDgyWFRWbWdCdzVzWEpaYTd2bUxpQ2NhNjd2cE9pRFhkczZIWm5yekdB?=
	=?utf-8?B?NVl6UlAzWnAxbTliVG80YWVIYm1DRXU3Yk81cWJURUM0ME9panNqcDA3YW9B?=
	=?utf-8?B?Zk5rejdmbDdFQXQzMDVwdTRqandUMGcxR0FWNGF6aEhmZmYyNURqRnlsUmlu?=
	=?utf-8?B?bUNZb09KMnE0MUZwb2dFRHVpQ2lmcHVJbnFGTXRRdFowc2RaU3dBemFIRDdE?=
	=?utf-8?B?OWp6YXg3SU1wMGtZbE5GVTkyc3Q0dHhTKzRPdGZQWGNkTGRYc0V0VFprcDdp?=
	=?utf-8?B?RVlvNHRFcFhxZUU5UUpIZGV0SWpGdkx5TU90Y0hrZmFqcGNjaTlndlk5U0lY?=
	=?utf-8?B?eXNnZVZldlBWQnFLSmI3YzlqbFJFRUs0TER5RGhranB2RUF1L3RCakJHREZD?=
	=?utf-8?B?UFVPU3pCeDBMS1hlczlTMkk2OWF1UTdSWk9HK3AxdUJWMzZ5SkZZNFBjOG9T?=
	=?utf-8?B?S0FqVU8wWHlBZFVXZnpJN0wvWDNVZGxSRnFreFFrTU1FWXRpalRsRDF0eHMv?=
	=?utf-8?B?aVB1VFlSeDczOUVacXZqRmJnSjRWdnBnWU9BcnBnaVZVZEgzZ1JOTk92ZzRT?=
	=?utf-8?B?dkh6S3c1QnZGZHhsbnRhWkU1OEhBMVhBYWovWFhKS055SjhpNFgrNzM0SXA4?=
	=?utf-8?B?MWJXbDcvcjB4dkVuYmtjWUhtVlM1bVVaUVJJL0crRDRRdVRzODVtdXdoMWVT?=
	=?utf-8?B?OGRxM1d4aDBnYktKTUg2S013R2hBdm9QY2xWckF2TlpPODVJT2x4Y2lOQXhD?=
	=?utf-8?B?YURtNDlkSUtiMXhqblM2cmcrTFRHOUlmcXBocG94WnJlZlVXeWhDamtNZEMy?=
	=?utf-8?B?TzA2NzJqd0pMM1lmZVNEc2NDSXZVa0JseWpsY2s5SWpWd3paV3ZQR2tQeVpV?=
	=?utf-8?B?Y2NyVlZneVJFTzZScGJZZjBTZHB4VWhuRzl3YTZTbitqWjRkK1VGOHZlWFIx?=
	=?utf-8?B?MHczbDZvV3pSKzRCeWdyVDJzNzR3UDVXa040RTN5RkoyQzg4OTdZTkRzL0d3?=
	=?utf-8?B?OXIwT3VyRzBvU3REN1JJVE8yU2NsNlY2WkdyWnd4MGpGQWZraUp1VUNOa1g1?=
	=?utf-8?B?WTNxVGdZeHFuYkwzckJFNVRzVjB0VnhlNitUN2dadldIZWEzMGtZTjdZUWlK?=
	=?utf-8?B?V2RZRGh4Y01wVHl2V05zUUdvSkV5R1RKZ1VzYVN3QVhqTkVzZFlPSXFKM2sv?=
	=?utf-8?B?cWR0T3ErT3JOZERQTkJWanU2UW91NTlTSTNLZ2JXTkt1ZllSMHNZVWhmSjFQ?=
	=?utf-8?B?cmZvYmVQQUIyL095R3ZXZ090VTZDUXo1U3VsZXFSaUdzUTh3dVFoSENidFZT?=
	=?utf-8?Q?yYYSVh23XQ7xzudDAxPur6QoGlMl+DNkP0H7Acd?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee094ca9-ed7b-4cfc-69c7-08d99005c276
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 18:01:06.4190 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQbtyz182hOsB6th+TGOR3dIkXI5fdd4rfcypUNe3HYsgkin8mJedRs6CL6MH72z32HjahC/KExYTRxvgHHYZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8197
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Oct 2021 03:34:40 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 04/30] drbd: use bdev_nr_sectors instead of
	open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/15/21 6:26 AM, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/block/drbd/drbd_int.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index 5d9181382ce19..75fda53eed8cf 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -1826,8 +1826,7 @@ static inline sector_t drbd_md_last_sector(struct drbd_backing_dev *bdev)
>  /* Returns the number of 512 byte sectors of the device */
>  static inline sector_t drbd_get_capacity(struct block_device *bdev)
>  {
> -	/* return bdev ? get_capacity(bdev->bd_disk) : 0; */
> -	return bdev ? i_size_read(bdev->bd_inode) >> 9 : 0;
> +	return bdev ? bdev_nr_sectors(bdev) : 0;
>  }
>  
>  /**
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

