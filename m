Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E06BC4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 17:38:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-Bd1FFi4qPrCagJjsXXBBRw-1; Thu, 03 Mar 2022 12:38:47 -0500
X-MC-Unique: Bd1FFi4qPrCagJjsXXBBRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1DA151DC;
	Thu,  3 Mar 2022 17:38:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7E3F1017E36;
	Thu,  3 Mar 2022 17:38:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9C071809CB2;
	Thu,  3 Mar 2022 17:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 223HcVc3027367 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Mar 2022 12:38:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9CA7E40D2829; Thu,  3 Mar 2022 17:38:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9741540D2828
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 17:38:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A2BF3C11C7C
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 17:38:31 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-563-KkYrI1gfMb6clNGOhMAE8w-1; Thu, 03 Mar 2022 12:38:27 -0500
X-MC-Unique: KkYrI1gfMb6clNGOhMAE8w-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	223HHZ5K009253; Thu, 3 Mar 2022 17:38:27 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk9g6h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 17:38:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 223HVjDk133800;
	Thu, 3 Mar 2022 17:38:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
	by userp3020.oracle.com with ESMTP id 3efdnt5ew9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Mar 2022 17:38:25 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16)
	by DM6PR10MB3867.namprd10.prod.outlook.com (2603:10b6:5:1fe::29) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14;
	Thu, 3 Mar 2022 17:38:22 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::d811:eb8a:a16e:c46d]) by
	SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::d811:eb8a:a16e:c46d%6]) with mapi id 15.20.5038.014;
	Thu, 3 Mar 2022 17:38:22 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: Martin Wilck <martin.wilck@suse.com>, "bmarzins@redhat.com"
	<bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
Thread-Index: AQHYLu2ESPewu2jO/UqGwdkSd29s1aytZv0A
Date: Thu, 3 Mar 2022 17:38:22 +0000
Message-ID: <AEBD217A-9920-4DBF-A843-7B3866114B51@oracle.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
	<20220222193143.GW24684@octiron.msp.redhat.com>
	<441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
	<20220228224435.GY24684@octiron.msp.redhat.com>
	<1C4A63A7-0ABB-4A26-9C4A-4BD4EA192B1A@oracle.com>
	<20220302183854.GA24684@octiron.msp.redhat.com>
	<455157a88c1087de6cc5c1350e64e1a49eb371b1.camel@suse.com>
In-Reply-To: <455157a88c1087de6cc5c1350e64e1a49eb371b1.camel@suse.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d87632cd-1086-4a33-3280-08d9fd3c9d2f
x-ms-traffictypediagnostic: DM6PR10MB3867:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3867CB568C4F28140043A9DA8F049@DM6PR10MB3867.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JEdYM7GW0+c/kY4aR0zMCrnBM/fR2+Raf1STMLzsUbSHvXA/UNjZ3jQzjJPbY6+TUt6N4O7cPNaI/rq8diCcLRBt8yVt3x7q3Ucim/9d6t9//LLiB36nvdKgK8PkxlY+ebYHpj74QQLNmWRgnE2omia36e3XKMSeaaJkoV3NgHWhhHgCZO4WDM/5NqIzc87O6wkXM8t8Eyar7x8T73ta3R086fNlvyx+9fLKXt7qQ4pE14hUSINjRAXStXs5TGJaSDTGBT8dGxglUVFHxyrwAbd/D06lrbDrn9cDwn+CLZb8gvfPWPOfgeKxy0nD1jFP8nbhvDEO6QPGB7x0dyzkAPg12n42uXOqCBwqlsNXxL5ghdgTH/3udDaGNs0bxpreCZD96YyCaFiqiC8oO5HHXdGBru0obwZP4+DsQCscgxt56dfARHD1WQxDo+xVVy/ynRyf09en0BZyGSAYgrzCJBIBYuZ5uCHgUcxLdkZRjljtj4XtLgnUMbJSrclRXXgsNglJY5tCC64bcAiaF4bAX9GdRgMU+A0Qe3vE8Yuxjcrg51OJ+LMIlNHfwJGlNsyJiISXSt/1GxgvLgdUmkWTXhvmo2rA/qN4wo5jm1yvixp1ffyi9I4AhrwbY5DK22lBR14zsbKSXU9I4JqjpF7vRWoS09OykNuvEHii09DjCXvfcnHI35ROW4h1sGyWjfRxT6uZSNgEsCqtMuopcozP2Ebvt7K5ymg/N4xmQ3tgr7lkpXeqtrhZwV3GGmUeQmt1
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4654.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(44832011)(110136005)(316002)(86362001)(8936002)(6486002)(36756003)(186003)(33656002)(6506007)(38070700005)(5660300002)(2616005)(122000001)(71200400001)(38100700002)(4326008)(66946007)(76116006)(66446008)(508600001)(64756008)(66476007)(66556008)(8676002)(2906002)(6512007)(53546011)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2NqaDM3UGxLeVJCcTlmVk9tUnZsMFZQd1cxUjFDZE0vWVNzM3NEREhRSlN1?=
	=?utf-8?B?L1l5MUR3Tk9JVlROUVo1bVhzTEZnZzhLa2VIV05DU0R3NWtIdkxpTDFrTFlC?=
	=?utf-8?B?U2lpOVhlc1laZU91V0s1L0pqcnNhL25BUWJhTU90UFUzNUVZa3ZaZVVCQ2Fi?=
	=?utf-8?B?WmJuSmtTZHJmQTc0eWMrSWRlVXpudDZGcVAvN05KdU5iak5lTGppN1lFbURN?=
	=?utf-8?B?bDljWjNuZjlLb2JBMWU5eU1KRzNraUdGaDVMcGpmZlFlVXZxampPNmliYUFL?=
	=?utf-8?B?bE5uZy8rNCtsNkowVWlqZlp6elpneDN0SDlJYXZCais1bzU5K2xCbUlXd0ls?=
	=?utf-8?B?ZGF1a2FYRnFSUFRVb3pnakh6VlRzNHRBcitXY21sejVxdDBLcFczMzMraGho?=
	=?utf-8?B?NGxnS0FzN0RHVTV3c1YxeitCakV1LzloN1N2S1R0MzdzUXBxcFplMzFtV3BB?=
	=?utf-8?B?Wk5lQWZNa1M4d2lNUXh6ZFM1eDBoRTJSMGtEL0FJeUxmbDd3ZFMxTVk3aTJD?=
	=?utf-8?B?dG5XK2o0aHlFZTU5MFpCWVBIMWJxM3lnd3hTY29Wczg3STkzaE5Nd1lMcjg5?=
	=?utf-8?B?SENkT1gzbnJicGpSTmJYSjlERmpsM2x0eFRNMXhTMnpVRWZ0dXVXR0owc0pQ?=
	=?utf-8?B?eVhBcjc2c2lEWjgrMXc2K2Fva2g4dERrNE0zWnRJTW4vZ2ZuSnFFQWZjSXp1?=
	=?utf-8?B?aHVaYUpyUzdxYUN4YXg0MUs1bXRCcWFaNUFwQ1JYZnVSaWFVa0tNemJud20r?=
	=?utf-8?B?NzluYk9aVThKUCtVWjIzb2RSdUlOSTM5VmZvMnRCQllyckxZL2U4V2R1UlRW?=
	=?utf-8?B?b0MvekM5OXhPS1ROdlpCT1Y5MytGQlRKYWEwZ3huTEFvNFpQWVFDdm9aaTZI?=
	=?utf-8?B?T3BYZTRONG1LSjF5YmQrZmNJUURsV2pXQmlyazAzYXZYNTBmMzRPK0ZnKzcy?=
	=?utf-8?B?OVlvK2JnVkNRSXFUWUdmTCs2UDAyYU1BdWZJZW5yeHpBSGlHbUFOWkltVEpu?=
	=?utf-8?B?UFRKeUVOV210MFZ3bDNOY3Yzb3FxMng0OHc1c1RYaEVwc094LzdwdUllbjZz?=
	=?utf-8?B?TmpCZ1l1eUJ3V1JlRG1YbWlKL29mWFFGSnYwK3QwcGNXdnFNVUFud2pXOTZW?=
	=?utf-8?B?TEtXTDcvazU1S25TZkZpQWxyZGk2NHhVdkxuMTd0OWJ6NVdrVXJRWHV0OWtC?=
	=?utf-8?B?TEFRMUZyeTNJTnNpVk5xZzUzZkFIZ0xqLzdRWGFLUVhBaTg0WHZNVGVZUS84?=
	=?utf-8?B?MUZxUktTWjE0dkdLdEExTktmdW5ya0tzeTBqQXFnUTlTLzEvQ1E5UTkvaXBj?=
	=?utf-8?B?dVQ2N29QUEhBR0RNMUMrQnNwYldPQ3dpWnIxeUJrVjBrSG9jRGw5cjR0elIz?=
	=?utf-8?B?SzBWajlSNEVzcENpd1VCZXA5elA2bVQzUERYcDNQK0F0RTFwTWw5UmRONmtG?=
	=?utf-8?B?ODVuWDFyYnFSZWZidEZnckplK0lPL0ZVRWk2UEpGaWQwaHNSR0V4T2F5SW9v?=
	=?utf-8?B?Qjl0VytORFlGaWw5bkdGTmJPQVR5dnlSMnJ4S3ZZM2R3b3BMdmZhQjdYd3Jk?=
	=?utf-8?B?Y0RYbnlWTkM1bklwYzhhcVVqOStrRlpMeGhzSFo4WStPU0dJZUhoR2s3OWRR?=
	=?utf-8?B?Sjh5L3ZvT2xqMWVtdmdCOEs4MFZXYmVCMjQ0N3ZsamVYcytHTFJvSnBndjZl?=
	=?utf-8?B?Szlkc001UFpqbDdmREVCZmEyUVhXbjBibjZGRWhTYitrbW1lL1hJVFlWY0tT?=
	=?utf-8?B?UlJ4YnhibGpWK052bTVvditORENpTXlmTGp5aEppR1hXeXAxejZVUVMvMHFX?=
	=?utf-8?B?VFFzQWFFNU96bk9zYjVzUHVSMGlLbEI0aVZET2NvUVJLOVo3bGZaeThTUy93?=
	=?utf-8?B?KzB6alZGRWVnUWFvWU10aUV5cUhkRWJtRWcycDl1d282SHFMdXJTdnVFSTVK?=
	=?utf-8?B?R3R3OElleFlMa216bVlia285bGJRMUg3RmM5c2owOXRIbUszczNhdkwycVYv?=
	=?utf-8?B?V3JTdXZycmh2aHFhODFvOElJSkh6MmdjeWVncENvSnlJU2hkV0FnZXJJRFRB?=
	=?utf-8?B?ZXFKM2F5WTVvODQ2RER3NzBOdk0vVFpaQ0tiMHNXMUpIdlRkYitBUHFkTFJ4?=
	=?utf-8?B?N01zYllpMm05aTRDUmNzMnBGZ2dFOEJ3b0JaQk12QWhxblRyYmg4R3V3ZW1W?=
	=?utf-8?B?YTdXeVpkWHJTV3RURmxFTHNHRkdTM1BaRVBoM1NJaDVncFdtakFEL2dpOU9I?=
	=?utf-8?B?UWtBUGFKRDRhRGNkOHg4OEtpZDMwSTRPMUhqQVk0SWZQWjRrbUEya0lKaTJU?=
	=?utf-8?Q?jD2CO5eAbPjI8jXBN8?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4654.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87632cd-1086-4a33-3280-08d9fd3c9d2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 17:38:22.5835 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vW3N0Rdp350EDIfABLz0LdIdT8hVj0MJGbg9duZ6kSuBMBbPYOJTb0r5ItWbSmprJBAON9NF9XXzTNyO6xA3Fo+Dt15zOnE/URDssQ5UHRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3867
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275
	signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	bulkscore=0
	adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2203030082
X-Proofpoint-GUID: NJHzL6_VNYdWp9fd4N4lYntAgwBSlfru
X-Proofpoint-ORIG-GUID: NJHzL6_VNYdWp9fd4N4lYntAgwBSlfru
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 223HcVc3027367
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2DC148E0659C0C4E9302CCBD4E1D19EF@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/3/22, 2:57 AM, "Martin Wilck" wrote:

    > I agree. kpartx is a tool for creating linear dm mappings that behave
    > roughly like partitions. And it should stay that way. We (made the
    > mistake to) add convenience functionality to setup loop devices when
    > kpartx is called with a regular file argument. That doesn't mean that
    > kpartx is a generic tool for handling loop devices or partition
    > devices. We should stick to the "do one thing, do it right" philosophy
    > here.

    > TBH, he usage "kpartx -av /some/file" just to create the loop device,
    > if the file has no partition table, looks like an abuse to me. I
    > wouldn't recommend to rely on that behavior. It might change in the
    > future.

Thank you for clarifying this.
I was under the impression that since kpartx supports loop device creation,  
it may as well support partition scanning functionality - just like losetup does.

Will keep this in mind and be wary about using kpartx -a to create loop device.
Thank you, Ben and Martin, for your review.

Thanks,
Ritika


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

