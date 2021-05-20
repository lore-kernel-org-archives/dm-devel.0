Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EE7C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 00:01:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8AB3600CC
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 00:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8AB3600CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-aWIQ_g3OPeWTawxn8eRyTw-1; Wed, 19 May 2021 20:01:42 -0400
X-MC-Unique: aWIQ_g3OPeWTawxn8eRyTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F25E08015C6;
	Thu, 20 May 2021 00:01:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F2BC1B471;
	Thu, 20 May 2021 00:01:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B69E2180B463;
	Thu, 20 May 2021 00:01:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K00iZj013458 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 20:00:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B0251115D7BB; Thu, 20 May 2021 00:00:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA0AB115D7B8
	for <dm-devel@redhat.com>; Thu, 20 May 2021 00:00:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 092D483395C
	for <dm-devel@redhat.com>; Thu, 20 May 2021 00:00:42 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-549-_LNkH6kYMUeDSjLIN_CsCg-1; Wed, 19 May 2021 20:00:37 -0400
X-MC-Unique: _LNkH6kYMUeDSjLIN_CsCg-1
IronPort-SDR: 2+fbRkZ7jvirCSphrVccDFcnvKjvs8fYLIonRzdCsCjkUjoYg2Xd6uSQxcItkoGyo7ujW4CHKS
	kKEP7/Qf3LNQ3n8+7C6Dgv8xsUroNOj0bP/CPFxYKM1Ck9rY2V36XBxMS5ezXnxO8YM9d6WWtt
	oC0f96uL3siAjxNGaTyl1qRLa3g+Ht+CnJNSqtCMoVbMYE/oa8ej/cKjEoDBK8naaKRm3YD13f
	FIEOMySperZ6Eek9aR38u9yHP9auaLhf6Kl65Lo3xzfQ8zVuopW5x1Esu8UbvjIrnL3jeai2FB
	nr4=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="168079308"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 08:00:35 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB5658.namprd04.prod.outlook.com (2603:10b6:5:168::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28;
	Thu, 20 May 2021 00:00:34 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.033;
	Thu, 20 May 2021 00:00:34 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Milan Broz <gmazyland@gmail.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [dm-devel] [PATCH 11/11] dm crypt: Fix zoned block device support
Thread-Index: AQHXTFp6KMWepVasxEixIhToOv0t7g==
Date: Thu, 20 May 2021 00:00:34 +0000
Message-ID: <DM6PR04MB7081B7965B612300F87C77F9E72A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-12-damien.lemoal@wdc.com>
	<cbbf8310-cc46-7925-c8e9-1edb23d245ca@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d5e8:c272:2ab7:c99a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: debf7499-c0ba-451f-d3b2-08d91b224acb
x-ms-traffictypediagnostic: DM6PR04MB5658:
x-microsoft-antispam-prvs: <DM6PR04MB565866903D3550404EBB1FD7E72A9@DM6PR04MB5658.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QRwGRcyzZO9x+7tCZrRg414iNq3TMgefH6C7T6TO1RWgI49IZBYGeMGAosca0Fn75PP4DPBbSnx7RHY2M/IiKNCKbDDaQoaeWuJIVlXs0B/AWDhcE45Ay6w3ExDbMkcqRD4mJ7OtyoisQDMd0OPca+e3Vjblk+fXNcOb5B9/dVhpoW096AeiJDO2WDymZwI6JonL1u82jPmgiZW3TtOE2/JpY+QMQqc2QY5duCT64Z/Sh4FOQJJsN5NzUFIiQr3aDG3Phyxxec6Jtb2RJ88VcBPYcRBSY/gQcE3es020naAiAk2bxn7HQkHLkVkaZiTYVcrgxHPmFyqqpMkdJlXunU1kV47dsm966eANMNo0YStasG9FdEHxb0IocL36rDjL0R0bJyleU09xcocqljqM6sqI6O4QOlcStAhvMomNukFsWh6k7KPykQZkaTExWaLKHFn/lA9wiIDI91PX+CCRFPhGV1wcGwvpdPu/VUqC6G+FNz2TuOOdsj8WiJQNlbzOpnlvVLOx3sv6Ezu7C8/URgMciaApCqmrNQwELrb2h3+sFKb0Up1vBUtvht4ydxEVQMSmimjgollQhKcxClRIQ6Ps/IY1aRYp6iJQtQMA/UrLfw+rJWqUXwMtkRHZYEAyVS9mO5Lty2VpwTxgBd6yfA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(83380400001)(5660300002)(66556008)(110136005)(7696005)(76116006)(91956017)(66946007)(66476007)(316002)(33656002)(38100700002)(186003)(122000001)(71200400001)(9686003)(8676002)(64756008)(66446008)(6506007)(53546011)(2906002)(52536014)(55016002)(478600001)(86362001)(8936002)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?j5ognqkMSWCH4iq8+JQSQyzS9hWkZHq8PPGf5ndomrPl7EHfVcE8Vclf1u3o?=
	=?us-ascii?Q?ZOBLycHVmMlV6f+H4U/h0POvOjm978Otq4Px4zugVc8QqJWfyqlzodUAChNN?=
	=?us-ascii?Q?o1Yah3PQNc3SIo8dgijIKdxXFksVQrZwoEwP5h0EU53C6C7zZl5eMvsrzeiZ?=
	=?us-ascii?Q?A+NRbgK3APOAsCJfuabWfmIndLq21tubILXjCV7bWc+UkNPF9XgOnUc1bcTR?=
	=?us-ascii?Q?0gi1hQA1VutSxpc8OyvttYABZZ08bo1htDQOrqBmhYKtXOHLXKZjmFUZExIX?=
	=?us-ascii?Q?dd7l50F6h3DiBvGgo7/IY5WB7aMnKJRvDqfMzkD3hZFSXABwetGZogmHgitS?=
	=?us-ascii?Q?TmMzOvaFiEF1H687tRtlN9kuloGxSKbteXQw9CZM3QNwxoZ0sZr1apQS+NLH?=
	=?us-ascii?Q?gWQs3NbNi6CsmM2d4IuTODQL9n0hyKKTIfH+KCU5/qYBHDaGJJIfoXRO8VUU?=
	=?us-ascii?Q?I5JReY95Nb8Ksxllq7W/MXiAZxCK/QABq+6ySQLuTRe3Lo5b41+LlHc8y2RM?=
	=?us-ascii?Q?i9XtgrcmPIG4EjLj8IE226qro3KUe0e88nEj9V/u0JLW6NaXvARey+FHvR2a?=
	=?us-ascii?Q?DrMGDT5voNHpH3EVmTCNBjfe1dXDkMjL8tjSAMAX8Eirgc1tKPIRs38nKBD5?=
	=?us-ascii?Q?ERakVpCKHQZeV0cNMZdsFPhvsTqZORFeJEVZy6E/aRsn+MiuQMMyC/xBdv9m?=
	=?us-ascii?Q?n24oV3EA1fcYeDGTHC8rSjf4Uzix5hquZSo8C4VwLH2TT6FSf40/FYk2vN0g?=
	=?us-ascii?Q?Lfsn6XJjvfr8airlIDr6YyWQtBtOoUw/Om7lgh1HnxeFr/Z0dWPGMcBUG7/u?=
	=?us-ascii?Q?VAK/Pys+CN2VNliPR2fKCUZxwx+7b5b8gc0JGm+rQTeIG2bjnORraxDxwShg?=
	=?us-ascii?Q?p5KOMe9LjyqjwpYLCz+vI3p8ymWlNkFG0nNEHreDufesqmPEFiKVGtE5e6DR?=
	=?us-ascii?Q?zaI2Ezsk5ttYNw6eyqwl5HsaB0NU5EjlO79t/ooRxFT8JyXWlD0OtfRStCnX?=
	=?us-ascii?Q?oTAgvGddKlDIwgOBDz91slQLYZ2JyIdkrNU1VmWe0R9qPtb5KNdOLR20jKm0?=
	=?us-ascii?Q?URg/gD7CpfUL3RZ+1eLkLKblcASC5kueOOOHyy/tPREKy98MWzB3zyV+y6Zz?=
	=?us-ascii?Q?7WX3zeGrUoEiEpII3h6tfE0cSdXFlZrDOGq5QtUcwYAXaLWOx+xYORX1qcik?=
	=?us-ascii?Q?HNrlGMiQcB9lEAEx3xKy5MsC9MIRPcMntf2hRqjqP+XkQ8VZOLdr+6sB9mzm?=
	=?us-ascii?Q?E2zPk9oZ2QvCiI/fVxbqsBuSetnAOQKa/tQl/4IlQRqSdgsR16EPnBNnp3aK?=
	=?us-ascii?Q?RFMYBc0Vl8U+ekRIkoyBZ+ZE5TvNNjQQvs4Mh/jx6U0LBa9PwLJ2zuo//y47?=
	=?us-ascii?Q?i+mmtVynlld+J9vv891MQFgTXlULuUKRkppN906r1xELWPFvCA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: debf7499-c0ba-451f-d3b2-08d91b224acb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 00:00:34.6185 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9hcWi3UPzM5XS30uX+/nlC5xcPYSTbnGglj4yORp/IgjUVvWReHjjJ2MarXLN7VjrBItdWEKkNzn9FXYQWErVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5658
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K00iZj013458
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 11/11] dm crypt: Fix zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/20 0:46, Milan Broz wrote:
> On 19/05/2021 04:55, Damien Le Moal wrote:
>> Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
>> of the zone to be written instead of the actual sector location to
>> write. The write location is determined by the device and returned to
>> the host upon completion of the operation. This interface, while simple
>> and efficient for writing into sequential zones of a zoned block
>> device, is incompatible with the use of sector values to calculate a
>> cypher block IV. All data written in a zone end up using the same IV
>> values corresponding to the first sectors of the zone, but read
>> operation will specify any sector within the zone resulting in an IV
>> mismatch between encryption and decryption.
>>
>> To solve this problem, report to DM core that zone append operations are
>> not supported. This result in the zone append operations being emulated
>> using regular write operations.
> 
> Yes, I think this is definitive better approach and it does not need
> to fiddle with dm-crypt crypto, thanks.
> 
> Just one comment below:
> 
>>
>> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>  drivers/md/dm-crypt.c | 24 +++++++++++++++++++-----
>>  1 file changed, 19 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index f410ceee51d7..44339823371c 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -3280,14 +3280,28 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>  	}
>>  	cc->start = tmpll;
>>  
>> -	/*
>> -	 * For zoned block devices, we need to preserve the issuer write
>> -	 * ordering. To do so, disable write workqueues and force inline
>> -	 * encryption completion.
>> -	 */
>>  	if (bdev_is_zoned(cc->dev->bdev)) {
>> +		/*
>> +		 * For zoned block devices, we need to preserve the issuer write
>> +		 * ordering. To do so, disable write workqueues and force inline
>> +		 * encryption completion.
>> +		 */
>>  		set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
>>  		set_bit(DM_CRYPT_WRITE_INLINE, &cc->flags);
>> +
>> +		/*
>> +		 * All zone append writes to a zone of a zoned block device will
>> +		 * have the same BIO sector, the start of the zone. When the
>> +		 * cypher IV mode uses sector values, all data targeting a
>> +		 * zone will be encrypted using the first sector numbers of the
>> +		 * zone. This will not result in write errors but will
>> +		 * cause most reads to fail as reads will use the sector values
>> +		 * for the actual data locations, resulting in IV mismatch.
>> +		 * To avoid this problem, ask DM core to emulate zone append
>> +		 * operations with regular writes.
>> +		 */
>> +		DMWARN("Zone append operations will be emulated");
> 
> Do we really want to fill log with these?

I added this to signal to the user, indirectly, that performance may be impacted
as the zone write locking mechanism used for the emulation essentially limits
write operations to at most 1 per zone. Overall, the drive QD can still be high,
but per zone, it will be at most one write per zone at any time.

> (I know it is not a good example in this context - but during online reencryption,
> dm-crypt table segments are continuously reloaded and because the message is in in table constructor,
> it will flood the syslog with repeated message.)
> 
> Maybe move it to debug or remove it completely?

OK. I will change this to debug.

> What would be nice to have some zoned info extension to lsblk so we can investigate
> storage stack over zoned device (if there is some sysfs knob to detect it, it should be trivial)... 

Yes, it is simple to add a sysfs attribute like
/sys/block/xxx/queue/zone_append_emulated.

That can be done later though. I will see if that can really help applications
or FSes. Right now, I do not see the need for this attribute. After all, all
scsi SMR drives already have zone append emulation (in the SD driver).

Thanks for the review. Will send V2 later today.

> 
> Thanks,
> Milan
> 
>> +		ti->emulate_zone_append = true;
>>  	}
>>  
>>  	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
>>
> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

