Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23928C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 09:11:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C8D76113B
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 09:11:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C8D76113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-54tAQ89XOBaAuPXAdFDFUQ-1; Fri, 16 Apr 2021 05:11:33 -0400
X-MC-Unique: 54tAQ89XOBaAuPXAdFDFUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AF738030A1;
	Fri, 16 Apr 2021 09:11:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E449869FD0;
	Fri, 16 Apr 2021 09:11:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B06CD1806D0F;
	Fri, 16 Apr 2021 09:11:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G9BPY9002565 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 05:11:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 66E8D2035758; Fri, 16 Apr 2021 09:11:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EE3D21D4F3C
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 09:11:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFBF985A5B9
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 09:11:22 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-103-E0QYzMsUOMCqANcr-BZrFQ-1; Fri, 16 Apr 2021 05:11:20 -0400
X-MC-Unique: E0QYzMsUOMCqANcr-BZrFQ-1
IronPort-SDR: MiLZfWoRNKg8KEuWG+klkIgLCDI9CP4wEIvuTEEDTXz9mO29wOqR7LDnfGeSM/rVkys9ZdOGS7
	kDFTaPDVyEnuOe0uKwFSnN0HoFvwrH/aNsugTAdoFa8mH014+jP8E30PpnXhh04QtNCCe5u8Td
	AjwT9iOW8QxQGA5iGeB66fI7ZccyjE0unyVMrwv9oTp7M/Ge1Fkv2+MRnIyCrMWmp8n+/MUEvH
	pbtsIklrx1A0ltVjwj4++Ux4ETpCAmXK3/09drbI+9qgP/JU+aCsSUWABFc3UbiUIaOnInx1KZ
	x64=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="165068791"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 17:10:14 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18;
	Fri, 16 Apr 2021 09:10:12 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4042.018;
	Fri, 16 Apr 2021 09:10:12 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik
	<josef@toxicpanda.com>
Thread-Topic: [PATCH 2/4] dm crypt: Fix zoned block device support
Thread-Index: AQHXMm1huarhzLzpkk6eySNmcPNHIA==
Date: Fri, 16 Apr 2021 09:10:12 +0000
Message-ID: <PH0PR04MB7416D55514E54F67BD8D92A89B4C9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-3-damien.lemoal@wdc.com>
	<PH0PR04MB74165367AACA8F3D9F7B023A9B4C9@PH0PR04MB7416.namprd04.prod.outlook.com>
	<BL0PR04MB6514908FACBF6A34D8A085C9E74C9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:15ab:1:e10b:72a5:d443:5e5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4ad6c94-3f01-45bb-a9b0-08d900b77107
x-ms-traffictypediagnostic: PH0PR04MB7383:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB738342B28ABD0A6C388BC20D9B4C9@PH0PR04MB7383.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4xeyFLY6B13CHdzzBRHxZkc6JQJOEEY4M/Jxs319Bw9Wb+I7PG0Gq6+8Z6fUuWdbqdkABcLc2T9NqtM85KtzOcau4WLRp6urzABncuhRG2UV4TfZTlYJsEqxSqFweJHFS84Re24yhT2spCzWbb2EjTBaDQE2k/QaBdD3yK4rQMj3NjunMq69QcbEIFyNxzO6/IMy7ZbQBZS0xIzJoYP4sKVRlshYpYEV+OnxDAECgP0n6e/fEhb80PMcXFh42KkBQzedKfaI7yoIBzSfVrLr9se+HMRo8YLE2Qf21tq+gxWDu+iYSC0xTcglVzzc36IDm0l3n99SajIenTfBvfLQ5hv9JOnn3P0kLrpIoAluhrXVf3E/Wgli1dubp1+RY9MO0MCFwN/NKKO/RVEuE5OW762hj1Foab54CVBETq+U94N2W1rwJggissfE5FsrHZ0UqeWB+vNpQaoQCCpWuE/R+N3Kd/bFbrOnUoo66mJdBV8NsvpQ8CXcGSK6UHD54g7vTQuxwhJxilDZ2GFQZRkS22RsyB7sNXBuYrerN5rWN5g7UkinWrYVYdBG2jver3XP92jfDejA+XzcpBzsRxdADmIN9zx+fv/Y0Y/3DtEOS4b94zwdRPyVrefJxgFfoJ1Ukq9z7hkBi5sBupmb05fpZQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(52536014)(38100700002)(2906002)(9686003)(71200400001)(54906003)(55016002)(64756008)(122000001)(66556008)(76116006)(91956017)(110136005)(66946007)(478600001)(66446008)(8676002)(66476007)(53546011)(5660300002)(7416002)(33656002)(6506007)(7696005)(186003)(921005)(8936002)(86362001)(4326008)(316002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ty19zkY6Jdr5NtQbX+ggf7h9/50G1UwFhltIcvwk9VggmMw68QQy6ON7GJuh?=
	=?us-ascii?Q?WQKb2wCJAA4QkZ1nhgv+3OLTUisS3WLGdTUSKhftThezH1rqwnSZlUHbBKM0?=
	=?us-ascii?Q?RkYqp1fqomGYC22prcLjRi/oILczQk5XarxBw7fs99zJSHvhMwLEC54eUv7l?=
	=?us-ascii?Q?5mOu5k0Tzy/mJg0C/4h6nWjA3t7jrD0fYBet1nNZScAQgkPV22o8ibAzHxx0?=
	=?us-ascii?Q?65E9JVY3iFL78wDZhNNUEjWeYs0jI4+euR/vyvXrSFrtXbOMcCSTYD1TbK4e?=
	=?us-ascii?Q?sWqUOwnxnvYvpFWaICL6c2rOiGZqvuP53ipzLrXnCZD9kU6rl8/az90QLHkI?=
	=?us-ascii?Q?5oroliQqPMBQ0V9UluqJr1sOJGU2g3nzmEZM0C7l2okZFmAV/g0EJQVKS4Ee?=
	=?us-ascii?Q?/bcuIrie2DYR8XD6MtQ9+N3+y1cJn/knDDhXXo+rbqfdKwZdTDNE7cor5reB?=
	=?us-ascii?Q?jaxB8p+3BUiBHtb7uXqp5UOY9R7mob8iZneDNlqvnzU13j1/CZqhBkEpuWFU?=
	=?us-ascii?Q?ZFsfpv88u4n3kFP22RfP3OOaZv2NKNphzf7F9dq+8zP4QpbJ7dCH6WN9datA?=
	=?us-ascii?Q?kF/Qt2txqb7wlk0OEkNFMSvztXcZG1ZWtmVQSYZOmqstqA80GEuEF6NouPOA?=
	=?us-ascii?Q?Kbdof/CHnuagCnCr3pOY1DpIuI3FlkeECPSLhK8iNCYi9ecKd3Ke9fNrOC0a?=
	=?us-ascii?Q?+2JStHSrAdMgT3fPS+QYo+U5eO8yCtfHReU6JyO2b0i1MuY5yvMmZD0eUZzN?=
	=?us-ascii?Q?4tvQNjrF8KpOn3eiThBKQxSgVDbW4uWsQNWA8g32/UUWxi4N8gf3UbAmRqds?=
	=?us-ascii?Q?4CrGSxjTEAtlrx8HFW7SkXrKB1Sw/r6wBl5Szs2YJ3SX91SbvoEeV+b6N6bU?=
	=?us-ascii?Q?urTVd7TWWdocODAbIrj7bOWABZTzr2qXRfULvHxFTwfHQan4RmWdLnDVB7dt?=
	=?us-ascii?Q?m+SUJn3UBjoaTMbXDHhTCAIKl9Dv5DAVA34EkoD5zW+lOdtEDvWTLUjL7rKL?=
	=?us-ascii?Q?lsjzMPqHwi6dXwYnQv36scsvfNye7+H/hq4jWsoOXXdHU0EOlDnnsOQoXhMB?=
	=?us-ascii?Q?xJkTVO29CBFE0KnlBU9+kkjEocxOlXZvgeyAW3ka+4Ny3Y3ndSxmsjNa70y+?=
	=?us-ascii?Q?pStKzsF31H6Z2U/BDEvLAh9Ixa3knMz/iEAV4yHy+M1Ha01qVTLaW1iIHfih?=
	=?us-ascii?Q?dHHFeBiVNEPCakRluwWtwwIruYwLgZEmoXyKBXBkxVFbQvBH/51fTKLf3iO1?=
	=?us-ascii?Q?5ut40MRnjeqnrMjD8ev6B3A5kkT+1rnhx87prYBbwqgu56sJ7UwQuiCNCfSo?=
	=?us-ascii?Q?5tvz6v71comvE7XiATWmhTlm2cf5MVcq55qqn/Q8gnbbN8kg7PN9iL4rtl9Q?=
	=?us-ascii?Q?/WYv2AP/0paSUh7qxmU/b0wVAO6Y?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ad6c94-3f01-45bb-a9b0-08d900b77107
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 09:10:12.2728 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TAPdkGmSMRhun19++2LBJRIEDul1dl8d/WSy8EaLdWDoz4WWXu0jAJy8Emq0UhzeE0ysgPg0qBCsvdi/2EHYH3kwCrb0gR01iSJH/RhLkr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13G9BPY9002565
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [dm-devel] [PATCH 2/4] dm crypt: Fix zoned block device support
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

On 16/04/2021 09:30, Damien Le Moal wrote:
> On 2021/04/16 16:13, Johannes Thumshirn wrote:
>> On 16/04/2021 05:05, Damien Le Moal wrote:
>>
>> [...]
>>
>>> +	CRYPT_IV_NO_SECTORS,		/* IV calculation does not use sectors */
>>
>> [...]
>>
>>> -	if (ivmode == NULL)
>>> +	if (ivmode == NULL) {
>>>  		cc->iv_gen_ops = NULL;
>>> -	else if (strcmp(ivmode, "plain") == 0)
>>> +		set_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags);
>>> +	} else if (strcmp(ivmode, "plain") == 0)
>>
>> [...]
>>
>>> +		if (!test_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags)) {
>>> +			DMWARN("Zone append is not supported with sector-based IV cyphers");
>>> +			ti->zone_append_not_supported = true;
>>> +		}
>>
>> I think this negation is hard to follow, at least I had a hard time
>> reviewing it.
>>
>> Wouldn't it make more sense to use CRYPT_IV_USE_SECTORS, set the bit
>> for algorithms that use sectors as IV (like plain64) and then do a 
>> normal
> 
> There are only 2 IV modes that do not use sectors. null and random. All others
> do. Hence the "NO_SECTORS" choice. That is the exception rather than the norm,
> the flag indicates that.
> 
>>
>> 	if (test_bit(CRYPT_IV_USE_SECTORS, &cc->cipher_flags)) {
>> 		DMWARN("Zone append is not supported with sector-based IV cyphers");
>> 		ti->zone_append_not_supported = true;
>> 	}
>>
>> i.e. without the double negation?
> 
> Yes. I agree, it is more readable. But adds more lines for the same result. I
> could add a small boolean helper to make the "!test_bit(CRYPT_IV_NO_SECTORS,
> &cc->cipher_flags)" easier to understand.
> 

Yes I guessed this was the reason for the choice.
Maybe 

set_bit(CRYPT_IV_USE_SECTORS, &cc->cipher_flags);

if (!strcmp(ivmode, "plain") || !strcmp(ivmode, "random"))
	clear_bit(CRYPT_IV_USE_SECTORS, &cc->cipher_flags);

if (test_bit(CRYPT_IV_USE_SECTORS, &cc->cipher_flags)) {
	DMWARN("Zone append is not supported with sector-based IV cyphers");
	ti->zone_append_not_supported = true;
}


Ultimately it's your and Mikes's call, but I /think/ this makes the code easier
to understand.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

