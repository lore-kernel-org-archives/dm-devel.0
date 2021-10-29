Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC396C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:06:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D0CF6112F
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D0CF6112F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-u05IMI4APtKz2m98IopvHw-1; Fri, 29 Oct 2021 07:06:28 -0400
X-MC-Unique: u05IMI4APtKz2m98IopvHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F078E80A5C1;
	Fri, 29 Oct 2021 11:06:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBDE26788C;
	Fri, 29 Oct 2021 11:06:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B233D1806D04;
	Fri, 29 Oct 2021 11:06:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19T0Lk4f008859 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Oct 2021 20:21:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1EFCB40C1242; Fri, 29 Oct 2021 00:21:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19857400F3E5
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 00:21:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF72D802A6A
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 00:21:45 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
	(mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-488-NETN4r-5NTaoocaRhVo4VQ-1; Thu, 28 Oct 2021 20:21:44 -0400
X-MC-Unique: NETN4r-5NTaoocaRhVo4VQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1328.namprd12.prod.outlook.com (2603:10b6:300:c::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Fri, 29 Oct 2021 00:21:37 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4649.015;
	Fri, 29 Oct 2021 00:21:37 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: =?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXtJz3aovD145e60qqb0tlGftm/6u8xNMAgAkFTYCAAH02AIACcLOAgCCUmwA=
Date: Fri, 29 Oct 2021 00:21:37 +0000
Message-ID: <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
In-Reply-To: <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 502ed39e-6de0-4210-c699-08d99a72129c
x-ms-traffictypediagnostic: MWHPR12MB1328:
x-microsoft-antispam-prvs: <MWHPR12MB1328545DA617D58091C15128A3879@MWHPR12MB1328.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YeMzO0ehQEFtXZp1IbAaL5xwj9cKK9rTv9aL2blBLbE3UZoeU2S96jFiLvre90+Yv/MVg5e40pRdBKc/MDhA1G7pnZenNMvc+allpLIhaTfwkw5xYGZ/0L0wuGQsVvuy+lxG7KmdsKbWid73lZEzu2lc7sZn7O5bcuBqloskQLiLWYuc7o6EDbUpqA7+JoABDpoTx7w5UrVIdk7mqfIaiVDzIZK48WpRJ9OSO0tWobofHEUBZ/Hn42G7rfgP6OqMcJ3SiUXIISULtZkypX+zuBX4ggxIpUxN33LJkvlpvSscfNVL2Mi6qFgv6f6j3xjnrm/3B4zjQWJGHewHd3yOAOcNuoS2uCmbKqMAHuODCWB/Kh5L1Q8UR8nGRtvtJAMonaHdvsCeb8w0VUNvGmwq7GJw8DJIiFPUfEV3+WyetAh3UNf2O14p4pBh/A1FZu4a6Nv8akI09+6okJ7vNtuedxDgxJLHCNTChTN2soqOp2H85kLfcSvUpwbRWcX1r7uaq8PFPsphyrSQrPnQTMqklUP6QQYEbCqAh9j65kFwzGdP7q55buEMYYzlOcJFtSVub6ZW2+p6o1g+yslqxl1z57Bll1kYkoja9TMM1WddTDZo5/Q5fieBksjSTbg4nbj6zmr5kPIzJiA7guMwgRMhodL0Qzp2VosPGCXF+mKUdgnqrV7e1RKHIFboLtlB6fw8kjNwevn2cKlf7W2FRkW/PIywUzRkW6V+w945OXUGzSLznVhKSrCqFzpwzHVNs57mLSLSgNdjlSEiAZiHtJtt1UwMwfTwMGZO7zTDLNuRL04/e++yJmiwbx+i5JDibmB+Lys8oljAGNksjJCrbnHxDMUOCW83k/ElHGG99AXeSM3GrlrPvacCPddqwBLPjb5A
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(38070700005)(2906002)(6512007)(36756003)(66574015)(508600001)(31696002)(966005)(8676002)(186003)(5660300002)(2616005)(4326008)(8936002)(6506007)(7416002)(53546011)(86362001)(76116006)(71200400001)(6486002)(6916009)(54906003)(66946007)(316002)(66556008)(31686004)(66476007)(38100700002)(122000001)(66446008)(64756008)(21314003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVJYeSs4YTNmeUFVWEQ0R0dFMXpBbHl2K3ltOTYyQW1NZ1VENjY0VzRkMG9m?=
	=?utf-8?B?bVo2R0dkdEFSenE1SXQvanZqaGp3eDZLL1Qvcmp4MXZxeVdEWXFvVGhTdnJG?=
	=?utf-8?B?ZkN3SlZCSThEZ1hCMW9wVnM0SWVyM0R1REM2TS9KOEQzaUdJWG5aOUEyN2pi?=
	=?utf-8?B?MVZwTm5rcnBhMTk1WERIenk2T0RLMFJQcHJpenN0RVJOTzlmZUlaVjlKck44?=
	=?utf-8?B?REFGa0NxWEFHd2c2RkZ2VDVvNXhST01rZDY5R3VyMEdOcmdVL3IvbHpXQU5y?=
	=?utf-8?B?Rk9OTjFCeXVWbnpoU3RWZUozWDRyY0lYQVJvUmwvYjByMGNPUkprWmhYN0FD?=
	=?utf-8?B?V0hRTWlXR0dzVzlJbXFhd0F5dEU4WlBIMWFiNzV5UVdjRENQNlFlaHhTbUdB?=
	=?utf-8?B?MGo4WUpqb3JQZWg1eCtGTEphYjlYREJsekJCZ0hhQ3lRb2ZpcUd4OW9keXl5?=
	=?utf-8?B?cVBHN1g5d0pWSHVyZ1FST09QckN4WFNyWDJlT2lGWE5FZjJDSDBMVW1SUnZO?=
	=?utf-8?B?R01abzZRUVJ1TmFkODR5ZXBTaEJBTExWdUlhWHR4TU1uUE5Qa3J2d2hzT0Q2?=
	=?utf-8?B?VDdtZGY2YTNYSEdUVXNJYVhGejkzb2tJT1VObzkwQWNnOENpT05IaGJhYlgv?=
	=?utf-8?B?Wks0L3RwMzZGMG5ZandXWVhnZmJoZGtxU1RQVkpMTzV6YVN2akJHSS9YOGJF?=
	=?utf-8?B?QVgrM3kzQjNzd1RBU21hbCtRYTFQVG1laFBFRDVTb0RiVjZsSjIra1lOdUpP?=
	=?utf-8?B?RmVna1BWZXhINzlYMjFDTWVEUHEwQjNNZDZQN3dpcTdGMEpsOVcvdlFML3E2?=
	=?utf-8?B?eEZWZ0Vrak5rTWl2djRzYmNmTXJjVVh3UXZmdHRZUzMyc2NqR1FtL2U2T2ts?=
	=?utf-8?B?TURkMmptY1dwSjFOa3lPYmFFSlJSQ2VtOTBWSDlUYTFKdWRpV1BlQnA4U2JH?=
	=?utf-8?B?MEN4RlFNYkthTC9RaERNd2FSeXRhUkZ0SnBONlNMdzlneE1Wa0pJeDF0QmF4?=
	=?utf-8?B?c1ZjS2tnejFLQklyb0V6MmZVaFl5aXhYV29mcG1hUVZBUW1CdjV0SDI5dXpG?=
	=?utf-8?B?dGpQK3dPWEpBOC90aGRUTlNqZzRPMzB3NlNHZ0VWelJNSm15NStQUmhsRm8z?=
	=?utf-8?B?TlFaMjlGQjVXalBaKzlrL0RuSFpxSzFwRlpqREYwaGw5a2RRa0tOZXdySWwz?=
	=?utf-8?B?S2w3ZzdveVZFbDJKc2FCcHR2NEVPL3FzYmw2RnY3OUJVSUZOTHRiMWlCcWZN?=
	=?utf-8?B?aFRlUTdFVGNUZjRUZml2Rkdid1FaWS8yN2NtOEpSUnhIR1g2NFFYZTY5T3ds?=
	=?utf-8?B?Wi9RQlFySURJQjZXQk5rTjIxMkc5NTZZa0RQcm53Qm8vNVVIUkZaWEpwdjhR?=
	=?utf-8?B?c29wY2lsVzkwZm9lWGVudXo3QkFTYm1qYmxvOFZLVHBKb2thc1VUbUNyN2FK?=
	=?utf-8?B?eGR5UnpZOGltdVFSQWVnTXZqdnQ0TENXUVNpcUtGL0U2QXM0eit2NXFESkRa?=
	=?utf-8?B?R25lU3pIY0pvYmdMVEs5aiszU3NXOTRCSDlNY1FqMFFUb1g2NTV6a2lzOFNo?=
	=?utf-8?B?czdOeE81NHFjS2x1cHl4NXAzQzB5ekNERlhjTk9CVGRmTklnRnFKSkt4RUph?=
	=?utf-8?B?V29KMTdHdk81dzh6QWF0V3ZjNitrTllqWWt2c3BPR0M1ZHRhbWxYNHpNVXpM?=
	=?utf-8?B?VXdmbFhYVDdaTU9nQWd6OEpZazdzazB2ZzJSaU1qbWhkaVZPSWx0eGFqbW9W?=
	=?utf-8?B?ZmZTYSt2bUR0MmJUVXdqMWRYODdrQWpOSjB3UFg5U1ZBN2JiWnExS1NCYklx?=
	=?utf-8?B?aVVncWk2bTgyTnNvREFwa0dnS0J1djZwZ0dVWnRyNWZPRmhiK0dkRXZpR2Vo?=
	=?utf-8?B?dVlTUStKL3VxMGJSeHpzY2ZxZ0xPTlhrTUxxa3pTU25MUHpIK1c0YUM2YXZY?=
	=?utf-8?B?Z0NiSldyU0NSdWRvMTVUck9IaEdqNklDbi9ZbXpSc0IyWDF1ekxSNnlHWmVF?=
	=?utf-8?B?UXJBWG9uRlBJQzVxcnp4cUgwd2x0MUM2ejh1MlJKV0FXcnpWNTlReXFmckk5?=
	=?utf-8?B?cXRXZGpBbVFTVkxkSEh3S0VMRVZBRDM4Q2d3U2szbDFQQVBqNGcxY1lVT1BJ?=
	=?utf-8?B?RkFPeVBwSzRWazNFTEhqZUx2aVkvMitDdXVPcHF3WjFFSGl6NUk1TjdoWnlW?=
	=?utf-8?Q?RULcJOtoF/eihBoPNc8wOgLMebRsv/oQSawwwQmAPHBk?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502ed39e-6de0-4210-c699-08d99a72129c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 00:21:37.7110 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5MPXmI5jXqIHa7Uas6n2pZ8ojSNlOBVzghTthPI/+kHE/eF44J4a8sZ2zWOOOXbNWAHf5ga4CBns2nGQtDUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1328
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19T0Lk4f008859
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 29 Oct 2021 07:06:18 -0400
Cc: Vincent Fu <vincent.fu@samsung.com>, Bart,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>, Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>, Kanchan,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DA9967A942905B42A22F8E68BAE1FFF8@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTAvNy8yMSAxMTo0OSBQTSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPiBFeHRlcm5hbCBl
bWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cwo+IAo+IAo+IE9u
IDA2LjEwLjIwMjEgMTA6MzMsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPj4gT24gMTAvNi8yMSAz
OjA1IEFNLCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+Pj4gSSBhZ3JlZSB0aGF0IHRoZSB0b3Bp
YyBpcyBjb21wbGV4LiBIb3dldmVyLCB3ZSBoYXZlIG5vdCBiZWVuIGFibGUgdG8KPj4+IGZpbmQg
YSBjbGVhciBwYXRoIGZvcndhcmQgaW4gdGhlIG1haWxpbmcgbGlzdC4KPj4KPj4gSG1tIC4uLiBy
ZWFsbHk/IEF0IGxlYXN0IE1hcnRpbiBQZXRlcnNlbiBhbmQgSSBjb25zaWRlciBkZXZpY2UgbWFw
cGVyCj4+IHN1cHBvcnQgZXNzZW50aWFsLiBIb3cgYWJvdXQgc3RhcnRpbmcgZnJvbSBNaWt1bGFz
JyBwYXRjaCBzZXJpZXMgdGhhdAo+PiBzdXBwb3J0cyB0aGUgZGV2aWNlIG1hcHBlcj8gU2VlIGFs
c28gCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9hbHBpbmUuTFJILjIuMDIuMjEwODE3
MTYzMDEyMC4zMDM2M0BmaWxlMDEuaW50cmFuZXQucHJvZC5pbnQucmR1Mi5yZWRoYXQuY29tLyAK
Pj4KCldoZW4gd2UgYWRkIGEgbmV3IFJFUV9PUF9YWFggd2UgbmVlZCB0byBtYWtlIHN1cmUgaXQg
d2lsbCB3b3JrIHdpdGggCmRldmljZSBtYXBwZXIsIHNvIEkgYWdyZWUgd2l0aCBCYXJ0IGFuZCBN
YXJ0aW4uCgpTdGFydGluZyB3aXRoIE1pa3VsYXMgcGF0Y2hlcyBpcyBhIHJpZ2h0IGRpcmVjdGlv
biBhcyBvZiBub3cuLgoKPiAKPiBUaGFua3MgZm9yIHRoZSBwb2ludGVycy4gV2UgYXJlIGxvb2tp
bmcgaW50byBNaWt1bGFzJyBwYXRjaCAtIEkgYWdyZWUKPiB0aGF0IGl0IGlzIGEgZ29vZCBzdGFy
dC4KPiAKPj4+IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IGpvaW5pbmcgdGhlIGNhbGwgdG8gdGFs
ayB2ZXJ5IHNwZWNpZmljIG5leHQKPj4+IHN0ZXBzIHRvIGdldCBhIHBhdGNoc2V0IHRoYXQgd2Ug
Y2FuIHN0YXJ0IHJldmlld2luZyBpbiBkZXRhaWwuCj4+Cj4+IEkgY2FuIGRvIHRoYXQuCj4gCj4g
VGhhbmtzLiBJIHdpbGwgd2FpdCB1bnRpbCBDaGFpdGFueWEncyByZXBseSBvbiBoaXMgcXVlc3Rp
b25zLiBXZSB3aWxsCj4gc3RhcnQgc3VnZ2VzdGluZyBzb21lIGRhdGVzIHRoZW4uCj4gCgpJIHRo
aW5rIGF0IHRoaXMgcG9pbnQgd2UgbmVlZCB0byBhdCBsZWFzdCBkZWNpZGUgb24gaGF2aW5nIGEg
Zmlyc3QgY2FsbApmb2N1c2VkIG9uIGhvdyB0byBwcm9jZWVkIGZvcndhcmQgd2l0aCBNaWt1bGFz
IGFwcHJvYWNoICAuLi4KCkphdmllciwgY2FuIHlvdSBwbGVhc2Ugb3JnYW5pemUgYSBjYWxsIHdp
dGggcGVvcGxlIHlvdSBsaXN0ZWQgaW4gdGhpcyAKdGhyZWFkIGVhcmxpZXIgPwoKPiBUaGFua3Ms
Cj4gSmF2aWVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

