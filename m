Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517F7C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-llVSXwmQOLSQG1nrbWeWRA-1; Fri, 04 Feb 2022 04:42:09 -0500
X-MC-Unique: llVSXwmQOLSQG1nrbWeWRA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 999CA1853034;
	Fri,  4 Feb 2022 09:42:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 799EE7B6E9;
	Fri,  4 Feb 2022 09:42:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 550944A7CD;
	Fri,  4 Feb 2022 09:42:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2147wXMq001931 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 02:58:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D97B92024CBA; Fri,  4 Feb 2022 07:58:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3BBF2024CB8
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 07:58:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B8A685A5B9
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 07:58:30 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-631-QMaxLZa1M2OFMh9pajCNLg-1; Fri, 04 Feb 2022 02:58:29 -0500
X-MC-Unique: QMaxLZa1M2OFMh9pajCNLg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by BN9PR12MB5099.namprd12.prod.outlook.com (2603:10b6:408:118::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Fri, 4 Feb 2022 07:58:26 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.014;
	Fri, 4 Feb 2022 07:58:25 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5pGTuc0vK6aW0WDOYv4vbM4lKx/5pmAgAIScYCAABSnAIAAMdEAgAB7aoCAADa8gIAAGRyA
Date: Fri, 4 Feb 2022 07:58:25 +0000
Message-ID: <9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
	<863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
	<2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
In-Reply-To: <2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 156ed700-672e-4599-964c-08d9e7b41f92
x-ms-traffictypediagnostic: BN9PR12MB5099:EE_
x-microsoft-antispam-prvs: <BN9PR12MB5099780EE5C6D06DF05097A8A3299@BN9PR12MB5099.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3AYFENidXhtW58dNct13CbD725jWDTS7y6EVNOIEqNaallAhIpQneh+5SpImDilWwopPI3kQfIUqqjbMZ6/Cd+DDEeWPYyttvAFIaXxXVy5ckYCWI07Xu596+jZ9pi3qNFDA6QYhjIavkMUIayLazGvbQYC0JNivotgGSYb0tv4+aOO+9c4/3T1aErqIaUX0+UOwlCrz67i3a2pQwBhmYGrD3/orBux5T6TDtgXO7M25qiV0gb8PPy6oK/lksRZAgR8XqyafbwfmtM1T0Mkyv2xOemGEG5l4FoRCLQJbVf0eqFQelyVlMbMChBw3Xxtf7lLWexMS14eIpn33i9y9vEgwBETDhutkDkrXHymBDjSOEBUYiIRH/P7kqMosdsz70MjNej+Hv5gIyR5ugVl7qKprTAarW4vucaWBaGQYs4FBGGI8eHdbBEXvlO4YCUsrtnl+pkNPjN84Fb2Wxolo+JLuyUXW+H28JYH1i28xCRUnMQeFzZmerFhn/BqqHM1oQbh9zH/0FNhB6znWQKmAcNo7M68V4mJNgYTQlxiOdqIFj3B8Y2oeAtqRjGh26YClnX3S+K2Mpm2fwLjOhM8daSvWcnpspOdFEdX4e09UXPnV4djB/WjbdgUgaLsaQC44eyE3FcDpj7T0WTZLqm2w/iCQyZXWyxYt6EX4oltPhH/ztmrpzPIHgHfUEH0yWUaHutpieJqYsj0IVVIaWq2xqsannvUyqQkj4zfBvD3BauPBzCnelza3zqLTlifmSuLcmGAwHmPbuXQEaDeHB4+z8g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(2906002)(6512007)(36756003)(7416002)(86362001)(5660300002)(186003)(31686004)(122000001)(83380400001)(38100700002)(66946007)(38070700005)(91956017)(76116006)(508600001)(8936002)(8676002)(4326008)(54906003)(6916009)(316002)(53546011)(66556008)(66476007)(2616005)(71200400001)(64756008)(31696002)(6486002)(66446008)(6506007)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTdlUnhpaEJ1TjZ0dWZHTExRamhFS0EzODlXZGxDNnR4NktpckNvSlpIVDRr?=
	=?utf-8?B?dTlXN0ZKRFdKc0pFaUFOeDhuamFVUERReWx4U0ZaZVBSd1hjb1RLckNsWFZV?=
	=?utf-8?B?TklhS1JZaFM4T2VuMEFjbVBqenQ1SjN0YTFTVG4zNVRNMjdvZ3pEODFpK1V1?=
	=?utf-8?B?dWRiRHU3SjV3S2hLSFZNQ1ZlaWJGZEV3bHRHQStLamIydjIrZFpweUVGNC9R?=
	=?utf-8?B?YmF1UkpDMm1ZWkJIWVNrUVV2Z2xsbmNMYmdEdCtBL0l0Y2U0TWFFVlk0K09o?=
	=?utf-8?B?aVpqVVdDdTlwNGMrVnlxTkViWUhyY3ZsM0FJVFIwcGtXY0hIalVncjFWSmVi?=
	=?utf-8?B?OCtVUkZzWEdmMG1Kb3NUVnVwUUMyNnJBL2VGVmV2NjJBR2NOUFNQZTUwdldK?=
	=?utf-8?B?MjhpNXNyT2tFQ29VL1hSTlYydk1MRHcvM2N3Rlo5Sjh3VjlUd0dhMjZtY0di?=
	=?utf-8?B?YnpZRFhyRVk0NHo0Y3F6S3RLNXlpQVdORFZZbUJBd3FLWlZUNDJja3UvUSt0?=
	=?utf-8?B?eERMbmxqVXRXL0c4U2JuZnEwOE1VUWw3Slh3WEt6ZmdFTTJ2ZFd3UDlHWGV6?=
	=?utf-8?B?TER3S25Kcmp4UmN6SDZEdTAwQkdBTlRSdXpZaXRQeW9lTXBJZVp4bG55c2pX?=
	=?utf-8?B?Ti9XS0F2SE5sa2FiZ3ROQTZNVGVodlpXM0E3Zk9UeVBTbW4vZW43Qk1Jd2FU?=
	=?utf-8?B?cWpnbDZDc2wrWC9jRUc3Q3k3L2luaVlJUzN4NmRFSENFRDhrUmY3QnJ1Q1VS?=
	=?utf-8?B?S1dRNTM0RU5kQjA4MjcrOUoxYi9wZnF6Ry9KaFpPYVpMRTMzMm96K3lsbTlK?=
	=?utf-8?B?VWY2SU9wY0ZNRzBtRUNENjQ1V2w0d090a3VKOGp3cG1Xb3RHaENPVnRUWVdX?=
	=?utf-8?B?Q2dyazJQMXFYN2x4SnBYSDlsUWxTQTZjaWNXZ1JuTFdUM0szVWQ1eEVCY3ls?=
	=?utf-8?B?Vy93VHFlN1V5dk9sMDBHSUZEZmFFUFB3MkN5NkNZTXJFVkRsenFVNmRaQit3?=
	=?utf-8?B?NUg2bE15TmpNLzZRMVEwZlo4Z0g4N1h1Uko5R1ptbFlubWczYVJ3T1pkNWNI?=
	=?utf-8?B?V3NQUUdjVmxFS2E3ZkM2YUlvRzBSMnYwdU14WDdaQTVleE5OUUUrdjlMWjF2?=
	=?utf-8?B?bEZqbitoMkpnUkdXdW5rZEZDQnF3b1g1blkzVmFSMFROSWJDUCt4RWtMLy8z?=
	=?utf-8?B?bmRmbUNxQmd1bFhTNnBnMlRCZWYrSjBSK0x0V2RZRUUxQnZKZ3FMOGZVdEd2?=
	=?utf-8?B?VVB1NGl6RWNvakkyeXdGWFp6dXVnZEJaWHBUUkl5MkJNNDVCWWxENG9JeCs5?=
	=?utf-8?B?UiszWmhzaHYxSGNYdHdiQTR3MkxydGdUREVXZkI1VXgrVUZDbHFjTkY1TEhx?=
	=?utf-8?B?T1ovRmNlck84T1F4S3V1WFdYOEhIdDNQQU5lbG5qUHAyLzJVaE5WK21nUWRt?=
	=?utf-8?B?cEdBQ3N2Q3ZSbEhmMDlDVzNwZUJockRCdWxTSHVBUng5OTNKZDhmY3Y0ZG1p?=
	=?utf-8?B?bFF5RGtDcWxWTWd1MjlTdENwN3YxN1VGL0h5VytWK0NOb0RjRkJNVklIaUFX?=
	=?utf-8?B?MU9yOEVya3NPdVhSR1YrdjV0eHZlZUxySUxuT2VHenVaT2U3aVZraTBrWXVh?=
	=?utf-8?B?MmhmMkltTUt1RmNPeE8wd1BrbjRNKzFDbUtWaEVRR0xFTndIREpBSkhObVY0?=
	=?utf-8?B?Zk00MkxUWGpONGVXS2dNc2pxVjhwdGpwYTBYekZBcDJZSG5hK1hFUERRN1JO?=
	=?utf-8?B?b1pZL0NPSklZUFU4bVJGSjNtNWl2ZG5BZWpqTmUwNnVhS2hIS3RVdnhFUTdP?=
	=?utf-8?B?WU9iKzl4RHh0SGtnNDdjeDhNWDJma0VmS2V0NXc2bW82OWNYUGFqMzh5aFpw?=
	=?utf-8?B?dXhCTDVQOThGUFlTRUFZNzBpM2RZUXZsenVVRTFjRWhmMVNORVVURTdtTWJW?=
	=?utf-8?B?K2ZCNFFtUEZOTVRuamgyZmpPTGhTZldqa2VyWjR1YnJYUmx1aEVNV2FRekU5?=
	=?utf-8?B?MjY3bC9tZlMyNXExYnRIbTNobWduSlNjQzVxdWtKcllJU1pWRHRJNzBkSDQx?=
	=?utf-8?B?UXIrQ09MQTZpQ0p0cjViNjJZclp3c1JKSWZMdEtCUEZhTWk2NHNoUXhxWG1G?=
	=?utf-8?B?ejVwU2ZCMXR1NWp5NldQMFA3S0dhaCs3eDBkU1IrdXF2N3cwcmIvN053cjR3?=
	=?utf-8?B?KzRGM1VPQ2lYVG1pSVJFdmVpWlVubUZ0V1RYYlRpYS9EdDlDc09uUWhhK3N5?=
	=?utf-8?Q?oeAE0UXsqYAVg5RFu+cEXyxPcbiRfGycKf6nQsp0Yk=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156ed700-672e-4599-964c-08d9e7b41f92
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 07:58:25.8528 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dYSGR4LlEVOSkw9Yx3pCLZad59ZNU8xuP1hEuB2uzq98vVVyDx5DhEnEBGvmVE9aM8eJ2gJBEA4QvnEYNzV1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5099
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2147wXMq001931
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: Bart, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Manzanares <a.manzanares@samsung.com>, "osandov@fb.com" <osandov@fb.com>,
	=?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>,
	Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Adam,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
Content-ID: <A95C95B38A829B428BEAD9BE29762B38@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/22 22:28, Damien Le Moal wrote:
> On 2/4/22 12:12, Chaitanya Kulkarni wrote:
>>
>>>>> One can instantiate scsi devices with qemu by using fake scsi devices,
>>>>> but one can also just use scsi_debug to do the same. I see both efforts
>>>>> as desirable, so long as someone mantains this.
>>>>>
>>
>> Why do you think both efforts are desirable ?
> 
> When testing code using the functionality, it is far easier to get said
> functionality doing a simple "modprobe" rather than having to setup a
> VM. C.f. running blktests or fstests.
> 

agree on simplicity but then why do we have QEMU implementations for
the NVMe features (e.g. ZNS, NVMe Simple Copy) ? we can just build
memoery backed NVMeOF test target for NVMe controller features.

Also, recognizing the simplicity I proposed initially NVMe ZNS
fabrics based emulation over QEMU (I think I still have initial state
machine implementation code for ZNS somewhere), those were "nacked" for
the right reason, since we've decided go with QEMU and use that as a
primary platform for testing, so I failed to understand what has
changed.. since given that QEMU already supports NVMe simple copy ...

> So personally, I also think it would be great to have a kernel-based
> emulation of copy offload. And that should be very easy to implement
> with the fabric code. Then loopback onto a nullblk device and you get a
> quick and easy to setup copy-offload device that can even be of the ZNS
> variant if you want since nullblk supports zones.
> 

One can do that with creating null_blk based NVMeOF target namespace,
no need to emulate simple copy memory backed code in the fabrics
with nvme-loop.. it is as simple as inserting module and configuring
ns with nvmetcli once we have finalized the solution for copy offload.
If you remember, I already have patches for that...

>>
>> NVMe ZNS QEMU implementation proved to be perfect and works just
>> fine for testing, copy offload is not an exception.
>>
>>>>> For instance, blktests uses scsi_debug for simplicity.
>>>>>
>>>>> In the end you decide what you want to use.
>>>>
>>>> Can we use the nvme-loop target instead?
>>>
>>> I am advocating for this approach as well. It presentas a virtual nvme
>>> controller already.
>>>
>>
>> It does that assuming underlying block device such as null_blk or
>> QEMU implementation supports required features not to bloat the the
>> NVMeOF target.
>>
>> -ck
>>

-ck



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

