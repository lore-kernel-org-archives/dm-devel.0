Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 713BCC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 21:28:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630--DWE7ewyPT6kSTKxSJSXmg-1; Wed, 02 Feb 2022 16:28:09 -0500
X-MC-Unique: -DWE7ewyPT6kSTKxSJSXmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBEBB10144EA;
	Wed,  2 Feb 2022 21:28:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58C949A329;
	Wed,  2 Feb 2022 21:28:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A23351809CB8;
	Wed,  2 Feb 2022 21:28:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212LS0hb019270 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 16:28:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 77A00C080AA; Wed,  2 Feb 2022 21:28:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72259C07F5D
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:28:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 500F528ECA81
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:28:00 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-671-CaGGpOETNSm9dBZsq-P08g-1; Wed, 02 Feb 2022 16:27:58 -0500
X-MC-Unique: CaGGpOETNSm9dBZsq-P08g-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212KwhJQ023474; Wed, 2 Feb 2022 21:27:47 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxnk2q089-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 21:27:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212LABS0152982;
	Wed, 2 Feb 2022 21:27:45 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
	by userp3020.oracle.com with ESMTP id 3dvy1tbdyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 21:27:45 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by CH0PR10MB5068.namprd10.prod.outlook.com (2603:10b6:610:c7::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12;
	Wed, 2 Feb 2022 21:27:43 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 21:27:43 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 2/7] dax: introduce dax device flag DAXDEV_RECOVERY
Thread-Index: AQHYFI6IEi37NS8sIkiGyAObMdfpFKyARuiAgACHZgA=
Date: Wed, 2 Feb 2022 21:27:42 +0000
Message-ID: <45b4a944-1fb1-73e2-b1f8-213e60e27a72@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-3-jane.chu@oracle.com>
	<YfqFuUsvuUUUWKfu@infradead.org>
In-Reply-To: <YfqFuUsvuUUUWKfu@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9641346-7d08-409b-be34-08d9e692d911
x-ms-traffictypediagnostic: CH0PR10MB5068:EE_
x-microsoft-antispam-prvs: <CH0PR10MB50686C8CD3F9AF60D62F0B26F3279@CH0PR10MB5068.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:628
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Tq6DRJTqExx90NrBVbONNzh6GGfXHpMKmPS9RXFQtRXby6dTJTfeCRSfgCmAABb1FrmtzJhjqdz/XRYVmpxeIaDgOFKhTSXjqtS4mRBFOzTnYU9Y1dZ0Hk9OfE1RFbjMDojKdbilLVdjbiWk+b51/na7WyIG4yD3Urrt+TsIBwxu/uRqA62/jzbUWCG9ZrCkI1ELj4R61E5VULjbkKukNDzb0IZ/Tkupte3AtfbR2G6Nshm+dLm0y6dWAHgrVxcroZDjr045hLzpMBI/991F8crMOkMoqM9WzgBzgplFf2jKsKKHLrcVkJdDlK89Uz1hwuCck0tp9X5XZZIRS4Sz+wOoUfgHyGSKTNNcnSMYkwkbcVP+FmZCYWGT/uA2u8UDRReFVs0Bpix30VeeR4mopuaV+mCiQpexY8zRy3y0bxS5ArAKoBsc+3Q0zvYLy/uW7aSWBZjlRw3qH1ATbfjrAV9+dnPcqInz+7ZMuJVru2VWVK4w/8Jphr0GkDfuOynD0aGVue2Aj++7lBSJZ41Vwk3RRo02kIuisglw+c54Qkj9sBhbIjEHK4f9iHAJU1mJk5iDfqDWoAdPRMAoSD8c9ZfCbvoadYVwrQuxwHPlulE+HuuYmE9fNS7UAfVV0rmlUi3KSqiWfDYMKZP6WmX2pGyn87Peyxjs5M9lbHajqIQNhsIu5BAdzG9D8WSAwqGXifb9G1vhpXEEh30QTNvwvf5gvsQYVUwABIfAx6xNMy8b+xbjVf7M+yRV4NPh5blbYhJdz1I2Ir34yMpm+aSb4Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(66946007)(66556008)(8676002)(8936002)(66476007)(5660300002)(66446008)(44832011)(91956017)(6916009)(316002)(76116006)(54906003)(4326008)(64756008)(6486002)(2906002)(31686004)(7416002)(4744005)(36756003)(38100700002)(53546011)(86362001)(6506007)(6512007)(122000001)(508600001)(26005)(71200400001)(186003)(31696002)(2616005)(83380400001)(38070700005)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlZMUHAwTkVPUGgvei9NUENiUHUxSnllbk04VDE1SXBBU2pWZXdSSzJuSmVE?=
	=?utf-8?B?UDcyL3hWR3BiMEc1Tndhb3dBZ28wa1VGNHBBSFRrb25jZkg4QlVWU01iUWQw?=
	=?utf-8?B?N2hlc0VWc01lUDAwT3k5NGhwb2tMcHMrbEo3OGFLeTNJbUlJb2FyTVlIck9L?=
	=?utf-8?B?d2RHMXlwZWxVUXpQaHBCeFArekRFcWhVR25xa1hsU1B5VGpJbWVGYWxBZUtj?=
	=?utf-8?B?bEdpdlltdmtlZTE5WWplaDMxajROQ29XU2dWOXJKakxTWC9EOVJSWGl4UU80?=
	=?utf-8?B?bFNlTVBjSDdIY2xDT3N2bHVHZXEwWml1WXpPSEcxenJiYlZiWUh3Y2lzaFpL?=
	=?utf-8?B?U3hXcTZ0VDdJQWFoNmgvOGZOZ3UvNmxka3FHalNRamdsNlBRMkpRSTNJMWti?=
	=?utf-8?B?SFprUUJiNE9XQ0g0ZkhLSisycjA1WmFucFhQMUdRak5BMkljTjc3c3Jxamcv?=
	=?utf-8?B?eWxwYmp6b05OQkM5WVhvQ3BZejJjcjFsVkxtcUFyWUhNSjl6bS9XK3haSHNR?=
	=?utf-8?B?RFdMS2szTDlXYmJyYWFKYTBEcEdJVmpNL0pnV2s0ZWMwY0lyQlBQRWkrREpQ?=
	=?utf-8?B?RnVBeGlwQ0FFdFdvTzBLTU8vcHRWeFN1SzZxdUdDZG5YZ3pmckk5U2hGZm94?=
	=?utf-8?B?KzRpQUhnZzVVOWZCUFJvbEcrdHZxaG5tN2pzQ1M4ZUVFY3VybERoNTFOK2pI?=
	=?utf-8?B?alpNSzFpM1JVWVNROXA2b2Z2ZjM4SmREVTlaOGQ4enFkdEllNE1JSmhCa3dv?=
	=?utf-8?B?YkF6amlMSjM4Rm8wa2xPR3hjNjdCWG12amJ0bWQwUWNGOWJ3MlpMQmwzMXdm?=
	=?utf-8?B?R1ptcTZ4VFo2ZGtpK25ZbEpyMU9FMCthTUZDQzRVeUFnZ1BKQmNsNWJwNE1w?=
	=?utf-8?B?QnNnYUUrWmRIRWJITGRyVm5hckVjT3poUzVIbTBURkVlb20rcWM5RThuK0c1?=
	=?utf-8?B?Sis2WVFlYjZDaVAwckNFd0RLUHEvbXp2Mnh2ck5uUEJLZjhVbzBMNTdVWlFC?=
	=?utf-8?B?QkRLTnNBQmN5Z2YyNjJ3QU1YbWJpc0xpQ1BDemx1NG9BRStvOENhdXJUU1V3?=
	=?utf-8?B?U0VJTVBrc0JMTVVlRWRuZUxEa3lLZXQvalNvd3RYNmw3RGx2NGo3OHVYQWdQ?=
	=?utf-8?B?NG9yRkR1ZFY2TGtiMnc5Vmtla3lWcVZTRkUyRERzdFZSK0RreXhJemdWTEJK?=
	=?utf-8?B?cFRJSUlhYW5vZTRYL1dMdU9rVndDY3h0c1NRektLNWE4UXdySEg2VCtNNlJH?=
	=?utf-8?B?Y29xNTJMbk9WcUo3dnluY1FsTTVldVRydVJINEk5Ykx0ODc4Ry8rQVIrZlV6?=
	=?utf-8?B?QW9xZU11Um1aVEFPN0lnYitTUXRIRThrd25nVWk5RVlCdEsxeG9wVGg4dnh3?=
	=?utf-8?B?aDlLMkhJUE0rMENmT2dnbzlSbW9JckRpS2IrTkNGMHpiNzZHQkIzM3Rkby95?=
	=?utf-8?B?UU4vS0x6ajEyS1U5cE1lek9NRTBGcEF1R3EwYUlVRERIMDY4aFcrLzBlWDB5?=
	=?utf-8?B?ei80V0ViZGY5RWxZYkhLcU5UdmR1ZGZDMzFDc0pPMnJYdFBHMWwyQklrcS8z?=
	=?utf-8?B?R3g2S1lmZXIxeHdqZGdxSS9lNWRyYmFzSkZiNUxYZXlxcFptdTFFSlJPblJw?=
	=?utf-8?B?eXpsVGF4eHpuamhwaG1lYUhhaDBpSURNUG93cUJDTzg5bmo2Tk9RQTYzN09O?=
	=?utf-8?B?NnVmT1QyVlRXTCtIa2M4R3dhZnZ0dkRnOGJ0d0ZnbTFwRjJRUXZyUVZaRFVn?=
	=?utf-8?B?cmFuTmphWENhemJwSFJSRXBnZVpUbTNlSGYxWkdaVHQvQlBEMmFNYVRFTzU4?=
	=?utf-8?B?OUt2N3VPUDY3WkYxU1dnWDIxa3E3WkdNVk9GeVZkMjMxLzBmeVdsMG1ZMVo2?=
	=?utf-8?B?R0ZpU0hyUHQ4ZWM0ODJ4WVlwMUxtVTl1THd6eUZMVjNva2ZlQmZvNDNjNE11?=
	=?utf-8?B?eVV3aHpMRUJ6aGgyNnNWNUlUMW5uaUJCclZtZFVoOE1EL2RNZXJRZFV0cVl6?=
	=?utf-8?B?RUVEekVhV210WTZ0bXhVSC9INmRGNTBsaUx6Q1FDZldmOXVCczVHMnpzRHAy?=
	=?utf-8?B?QUFLRFlLZlFENmFvbmlabEpxQW95dE8vYUhoVDY0b2RjM2ZKTnVlQk96Z0Ft?=
	=?utf-8?B?K1ZGYVdvTWF5U1F4RnBSUjEveTZOdmhaNCthdmJ2YWxEVUpiVTluOTl4WU9E?=
	=?utf-8?B?NlE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9641346-7d08-409b-be34-08d9e692d911
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 21:27:42.9974 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSEPQd4svHGVnWXzj8iaHjGqGsTG1jfBMKDZGiS/cOetr6SNNXOy/m233nmoDL5RZLPiTeQnA4nlGZqmoa/kaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5068
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxscore=0 spamscore=0
	bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020116
X-Proofpoint-GUID: CRB1nRajlcCN2t77m3bZvgV67J7MzZPB
X-Proofpoint-ORIG-GUID: CRB1nRajlcCN2t77m3bZvgV67J7MzZPB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212LS0hb019270
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 2/7] dax: introduce dax device flag
	DAXDEV_RECOVERY
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3E5C4E45A80E1B4C975D554F9015D57D@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 5:23 AM, Christoph Hellwig wrote:
> On Fri, Jan 28, 2022 at 02:31:45PM -0700, Jane Chu wrote:
>> +int dax_prep_recovery(struct dax_device *dax_dev, void **kaddr)
>> +{
>> +	if (dax_recovery_capable(dax_dev)) {
>> +		set_bit(DAXDEV_RECOVERY, (unsigned long *)kaddr);
>> +		return 0;
>> +	}
>> +	return -EINVAL;
> 
> Setting a random bit on a passed in memory address looks a little
> dangerous to me.

Yeah, I see.  Would you suggest a way to pass the indication from
dax_iomap_iter to dax_direct_access that the caller intends the
callee to ignore poison in the range because the caller intends
to do recovery_write? We tried adding a flag to dax_direct_access, and 
that wasn't liked if I recall.

> 
> Also I'd return early for the EINVAL case to make the flow a little
> more clear.

Agreed, will do.

thanks!
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

