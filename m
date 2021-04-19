Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E533C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 09:47:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9ECE661157
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 09:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ECE661157
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-2-039ZJSP6WF_ph0zkvqew-1; Mon, 19 Apr 2021 05:47:02 -0400
X-MC-Unique: 2-039ZJSP6WF_ph0zkvqew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B46018397A4;
	Mon, 19 Apr 2021 09:46:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B6AC5D9C0;
	Mon, 19 Apr 2021 09:46:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DCE21806D17;
	Mon, 19 Apr 2021 09:46:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13J9koKD030035 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 05:46:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E51A2182DF6; Mon, 19 Apr 2021 09:46:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36EEC2182DF4
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 09:46:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6525385A5BA
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 09:46:42 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-218-U0tIqni7Nmqdh9mkOMc5JQ-1; Mon, 19 Apr 2021 05:46:40 -0400
X-MC-Unique: U0tIqni7Nmqdh9mkOMc5JQ-1
IronPort-SDR: lcobadFrnYdexR1Z7oB0EhQwNUAcNcyzQjdQ8An/jCUTUmDUDrx8UEw6dBudl9sOwINMvDICaO
	9nQxnADXKN8nbGgTP6usggzThcjIi8Eaxob1+DfBX/sFrVzxhArTYhJGjTpHRJ4YuRE/EAuu/o
	yuVE+7KZ0bC/DPNAMIyesKAwVwwWvYMkFe0yiDuvXuxt56JfduUVDQjYAFImQvu5h4Ajvm7xdP
	6zHgFdxWlbBNRLbRbB6vnn+dhAhrLBN+RJv+zAnCZb+WGryD7m2AcBqGTPn3mevGQolIO0oafP
	n4U=
X-IronPort-AV: E=Sophos;i="5.82,233,1613404800"; d="scan'208";a="164772474"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
	by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2021 17:46:38 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4529.namprd04.prod.outlook.com (2603:10b6:208:4b::25)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19;
	Mon, 19 Apr 2021 09:46:36 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4042.024;
	Mon, 19 Apr 2021 09:46:36 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
Thread-Topic: [PATCH 3/4] btrfs: zoned: fail mount if the device does not
	support zone append
Thread-Index: AQHXMm1j7e+Wo1nHt0KL4N4KN5ZXHw==
Date: Mon, 19 Apr 2021 09:46:36 +0000
Message-ID: <BL0PR04MB65145DA8B6252C452EAA8BC9E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-4-damien.lemoal@wdc.com>
	<20210416161720.GA7604@twin.jikos.cz>
	<20210419092855.GA3223318@infradead.org>
	<BL0PR04MB651459AE484861FD4EA20669E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20210419093921.GA3226573@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d019:11b6:a627:87d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebf593b0-40b1-4f22-cab3-08d903180647
x-ms-traffictypediagnostic: BL0PR04MB4529:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB45291647424ACD99A03CA3BCE7499@BL0PR04MB4529.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qWetnChTNH0NjnRA3dpb4dJssJ6EnGX6GqMfbE+TOsAhxtuEWu3BeVbgNRy582MT+8qkeGkLzujQ+/SisYqPfQyVGJKp24os+OfZrUtC65V7G1cJj/3lrlq63k5xakrxwilgkwYxn/C9CnAZPOxjFDuKYT6bj71sLQ4DX5Jhqt4kHgTYtIKZznI2NEBGG6ShOwcAqo45xyyFc0GNZ7tBdev6XC8bmAM/ve+uA0Gp/lViqUfH1dx4WtsVralnyuWcj/noN5hTgURCr7cIIgJBUbikAVEePE7Gfms8TpaZ+VBsTHWGeXdwv1F3EGHyMXkxSri3t1Bmvi55b3TCmMf1NkrZrgGL4DmsR1Lc6g1tq/b4EozAnqyKoOzyGZw2MzKIll4xBp7Co7vBHe+XKf2saEVao02rtZ6NpYvhOx/8nZRrdEOAP7QTrEOW8eNJz4LRUVFl0SNaL8v1Ua4geoDnvGMP6tODWWRByAtLeTB0MzhlsvcjDZQBIHGTHx67+yTaaftvep+qWYlMX48AfXS7i0p1lzF4Ttr13890h1dXuXSNFg9WA9SJKwWk/YKs2ADo879OqHve4oA9k2vsDjRHZrTr/1ribyUu8EtLWHOTd70=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(38100700002)(71200400001)(8936002)(54906003)(122000001)(91956017)(7696005)(76116006)(2906002)(186003)(66946007)(64756008)(86362001)(9686003)(52536014)(8676002)(316002)(5660300002)(55016002)(53546011)(66556008)(478600001)(7416002)(66446008)(66476007)(6916009)(33656002)(83380400001)(4326008)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3yo1PO2anyL8+WM57r/JZnk3c9GLGEqv3SnBeyXy/I93Bt/Cs6/1xxpjWi4p?=
	=?us-ascii?Q?WjvxboVN3E1YDQL+MVgRVJeXiLl7F/UNMEo4QNVgTSBYPA31UeCYcRbm56PW?=
	=?us-ascii?Q?bOKKwrvoixzw8jG+doQEBRlQ5rOUQstLoZiZ841iXALkBXM/XpFEfOeEeQTp?=
	=?us-ascii?Q?6h6LgN2hyWkVmcK4GmZtVMcCnuBPzHWQeCoUM5+7Wmft/gPkrt3IsJ9UGLQp?=
	=?us-ascii?Q?11d5pSRpqEQrNcB8SiBt5HOKEmy/+OxVL1ze/fNglUaHamVeXStE/Gu6+vAT?=
	=?us-ascii?Q?ckCLm2BRHoLqT1n84sEcyxCjxfqRYPMwaH9BzfWYlZmS7uoOaBNEnRrFEz73?=
	=?us-ascii?Q?oJFItAoVHv/rY1p5vPSIg1LJxASwslcMssCybQxNX1DH9i3DgqfEQsAUXF6T?=
	=?us-ascii?Q?4MUgiSCeZXDg9ilrJOXoBKi80oDrsUXkVkJ+eWWJi6XQSfMmCr6y68BPqi7n?=
	=?us-ascii?Q?6YGIS3Zd8Qcx6F7JEWv5dppkUNLBLXEmoU6Id60LdC/KY0WTLJHB3DtFmaPW?=
	=?us-ascii?Q?re2dLa6FU7aUgyBR/5DWw4A7Ip4+tKZoskIuREdjXPfAMM4uuAZY6ADFG/98?=
	=?us-ascii?Q?hFtztSXaH/b6U1aO8eU7Cxpn9AYhMGrepk4M9s8PdS216llXkr5nq+AgEex7?=
	=?us-ascii?Q?0ANS+YZJJNFbCcqTC0wKcCdQzXd9C9aAty8p73HjMboglrN0KOeNwEQuFtqC?=
	=?us-ascii?Q?APUPShv4RCJKTHrGKywVTQ8cRIjgt5t3Fw2vwOGCF8+/vvrmSKDqhKP7AOw+?=
	=?us-ascii?Q?/3YOMqCy2fOrxpzCnSw1DJBOKuX2ooxq4OkwJfOCFfdzpb2Wnqr+KT4nPDNP?=
	=?us-ascii?Q?9vx/HdKfebm+4x69G3VCGibBPbKfXLH1Zo2sDtTDUGTVnHC3qKU9V5X63UFp?=
	=?us-ascii?Q?Ibvf9JqN4CGllEr4miuv194a/ZKVYDxPyPaNykbDmqxpV6rEI4b0fpUF9PvN?=
	=?us-ascii?Q?LZ8ndPv3yT+A0+7ELLCMl75RjqkIeU/LcC0hgVFs1aB196aerERpYA5x96kY?=
	=?us-ascii?Q?i+DHzQI1efFTok9TWdJLtO/3LdjnBM+2ZLUDTMrn5vzzgvVIMVRhc8QcCPbh?=
	=?us-ascii?Q?f8Asi/BuaHI5ZbCPSmNJ6/MhRmwhhfniGmbgGCVHMghqXrRMQat6oOMBBZkz?=
	=?us-ascii?Q?MpveVSZsirCe6fJmNAljrNf3uyYQ9RQpcVhB6qUCHFYkVwXPEYOcNQszz8Jm?=
	=?us-ascii?Q?px9b/qLVIzz25XEurXOyu9gx86OTg6GsRKy9c1nCugodMLAv/NtqvOM5091t?=
	=?us-ascii?Q?ka2fahh+O67YFrYzSQhQ6nznSvr6p+DV0I6k0IEpW/HwUzhZhAuDihc/qtdB?=
	=?us-ascii?Q?acCDnbAplXhfQvpkSE2yKg0V8oBSfq+hgtKm6ogyhdtEu6zgNOJROnPahaHe?=
	=?us-ascii?Q?PqoMacyGcTVOFSKZiHCjzl6mJTW2B1WZGU0wHXPcnZXlSOf88Q=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf593b0-40b1-4f22-cab3-08d903180647
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 09:46:36.8027 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BE3Pds+nebfcoaAzLQrkvZRpVcMvDNrAneZDak6IZItjx21vANLf8T8BTcxAJ2J9GAvvoYWfQaC9JUz3uxl0mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4529
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13J9koKD030035
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Naohiro Aota <Naohiro.Aota@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"dsterba@suse.cz" <dsterba@suse.cz>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	David Sterba <dsterba@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "Martin K .
	Petersen" <martin.petersen@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 3/4] btrfs: zoned: fail mount if the device
 does not support zone append
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/19 18:41, hch@infradead.org wrote:
> On Mon, Apr 19, 2021 at 09:35:37AM +0000, Damien Le Moal wrote:
>> This is only to avoid someone from running zoned-btrfs on top of dm-crypt.
>> Without this patch, mount will be OK and file data writes will also actually be
>> OK. But all reads will miserably fail... I would rather have this patch in than
>> deal with the "bug reports" about btrfs failing to read files. No ?
>>
>> Note that like you, I dislike having to add such code. But it was my oversight
>> when I worked on getting dm-crypt to work on zoned drives. Zone append was
>> overlooked at that time... My bad, really.
> 
> dm-crypt needs to stop pretending it supports zoned devices if it
> doesn't.  Note that dm-crypt could fairly trivially support zone append
> by doing the same kind of emulation that the sd driver does.

I am not so sure about the "trivial" but yes, it is feasible. Let me think about
something then. Whatever we do, performance with ZNS will no be great, for
sure... But for SMR HDDs, we likely will not notice any difference in performance.


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

