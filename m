Return-Path: <SRS0=M5Wt=PN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52CFC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:43:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D8D4604E9
	for <dm-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0D8D4604E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=dell.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-y4cc4tZ6O-e8tH4wQXTM-A-1; Mon, 25 Oct 2021 03:43:03 -0400
X-MC-Unique: y4cc4tZ6O-e8tH4wQXTM-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26A625128;
	Mon, 25 Oct 2021 07:42:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00B471ACBB;
	Mon, 25 Oct 2021 07:42:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9A8E4E58F;
	Mon, 25 Oct 2021 07:42:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19MLdBms026411 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 17:39:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B1C6040C1257; Fri, 22 Oct 2021 21:39:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABA89400F3F3
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 21:39:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EC821066559
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 21:39:11 +0000 (UTC)
Received: from havoc.proulx.com (havoc.proulx.com [96.88.95.61]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-600-u44pNE08ON6Ro1H-4n5Jzw-1;
	Fri, 22 Oct 2021 17:39:09 -0400
X-MC-Unique: u44pNE08ON6Ro1H-4n5Jzw-1
Received: by havoc.proulx.com (Postfix, from userid 1027)
	id 164A87F5; Fri, 22 Oct 2021 15:30:43 -0600 (MDT)
Resent-From: Mailing List Manager <mlmgr@proulx.com>
Resent-Date: Fri, 22 Oct 2021 15:30:42 -0600
Resent-Message-ID: <20211022213042.GA25236@havoc.proulx.com>
Resent-To: dm-devel@redhat.com
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19ML03kA023472 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 17:00:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B62CC4010FEC; Fri, 22 Oct 2021 21:00:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF44A400DAFD
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 21:00:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FC0C800882
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 21:00:03 +0000 (UTC)
Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com
	[148.163.133.20]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-517-qWuAmyW-PWeF6oVP6BrStA-1; Fri, 22 Oct 2021 17:00:01 -0400
X-MC-Unique: qWuAmyW-PWeF6oVP6BrStA-1
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19MG3lR6001501; Fri, 22 Oct 2021 16:59:59 -0400
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com
	[67.231.149.39])
	by mx0a-00154904.pphosted.com with ESMTP id 3bv0g28uck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 22 Oct 2021 16:59:59 -0400
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	19MKsiD5121789; Fri, 22 Oct 2021 16:59:59 -0400
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by mx0a-00154901.pphosted.com with ESMTP id 3buc7shvsq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 16:59:58 -0400
Received: from BY3PR19MB4852.namprd19.prod.outlook.com (2603:10b6:a03:36a::19)
	by BYAPR19MB2501.namprd19.prod.outlook.com (2603:10b6:a03:134::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18;
	Fri, 22 Oct 2021 20:59:57 +0000
Received: from BY3PR19MB4852.namprd19.prod.outlook.com
	([fe80::bd8e:a7da:e2ea:449]) by BY3PR19MB4852.namprd19.prod.outlook.com
	([fe80::bd8e:a7da:e2ea:449%9]) with mapi id 15.20.4628.018;
	Fri, 22 Oct 2021 20:59:57 +0000
From: "berthiaume, wayne" <Wayne.Berthiaume@dell.com>
To: Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config work
	with alua and multibus
Thread-Index: AQHXxeKQ/vIQRjVXIUaEfL6whxMKkavfgrBw
Date: Fri, 22 Oct 2021 20:59:56 +0000
Message-ID: <BY3PR19MB48523808E0479C19BA225CB8E2809@BY3PR19MB4852.namprd19.prod.outlook.com>
References: <20210928173121.18081-1-xose.vazquez@gmail.com>
	<BY3PR19MB48522AA6EFF15AC8608253ECE2AA9@BY3PR19MB4852.namprd19.prod.outlook.com>
	<d300f40640858a6c38d37285da2ffc381ce689c3.camel@suse.com>
In-Reply-To: <d300f40640858a6c38d37285da2ffc381ce689c3.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2021-10-22T20:59:55Z;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No Protection
	(Label Only) - Internal Use;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=3e594b8b-c9cb-4d7b-b261-1fb7a38613c9;
	MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baafbf36-42a4-4cf3-2f40-08d9959ee784
x-ms-traffictypediagnostic: BYAPR19MB2501:
x-microsoft-antispam-prvs: <BYAPR19MB2501F273E90305631FD84D1FE2809@BYAPR19MB2501.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jlzBuoAx0kEgAiWVBCklumVqs2sPSodkZkoUuvAng4eXk0aIt3EutrFslVe64TqXSOLTW9HQISM72etvbf1rTDYJtad8eT8MrIdxIdc6mIrWMGG+t0XPN8rszPnKPMyAnbTaytnCzACNaBT0e0tlkhXlSNTLO8iP670qf0ZKEoYvDcHUHfBztxPzNp/kZv93D+PXxIROKt+ea2dSp4dFU5USBVVWpzmrlQmRS9H2mQcA1AJbXSKhdblQHEzQTJyaCoHLHm2NYJFm7owTXBj86k8qJzzEnn4JlOP/koQKpWjoloLi0fplGLaxvL4C/CNSOeEaWe+5/0l6J+qxTy4kl78aB4a3D66fgdQbG17qwtEiS4n/X9vdLmkHxeqveUZymGrnkgO2akLshqxNBrWwtGC6TNRmysIMj9hH2/ZqmF2dY4adIDXRt6V1Ca9mAhZNYMd7SVs7AvR8yOA0EL/6wSBpz8xcjPtgWgWlyVUXMer3rSZavJTe049NMEjdmF30gaq/Q9DG76D/xqfTDsUekXDutfEk421nBn1/t0FrX85Yso94WxFPpN5LOpHt02+wTL8vVoOWYhoL6+0qeVpL8DAXt8mlz9QxTv+ZDQ6Ptk5HduBNY5uSrLYApYxNx6J+7kOdLChdp26PIRLrpN2LOBcUM7lxtJFf1e8IsA09iX+iIZYKNqF96OLe84ByUK+KHYfkzCJDNPkS8OJkacprSSFVIYEsFrRpS4PinwLwPyh6HxYrJ8fmdsS978nKWq85rSJ74BVAZdRQqYySYfOyMN8BzWzLAUj71WCY8Ls2iFg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; 
	IPV:NLI; SFV:NSPM;
	H:BY3PR19MB4852.namprd19.prod.outlook.com; 
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(66556008)(122000001)(38100700002)(508600001)(26005)(55016002)(33656002)(66446008)(5660300002)(110136005)(52536014)(2906002)(7696005)(64756008)(8936002)(76116006)(4326008)(186003)(786003)(83380400001)(66476007)(8676002)(40140700001)(53546011)(82960400001)(66946007)(6506007)(9686003)(86362001)(966005)(316002)(38070700005)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?QmkrsUXwNj18DlXIr+rVZbrr1z8oHvc7RBG3sNmzk+2tSgNjVqVPBpBp5w?=
	=?iso-8859-1?Q?JXqyaUNVOn/SzCDa8/9rkyRA4FGBMpyrjrF7Q/f7XSwdvMIvFqf+9sm5/f?=
	=?iso-8859-1?Q?FrYscKfv/nX4yL3N4ta0PRf3JQplSfMsMAOWV20bUd2E+FHfSH5fJEIpHO?=
	=?iso-8859-1?Q?PAE1WTfHjTwxEvmae0N3UPYZb+xXfE5gWFs4Xae050usRn1u6svEhOq8zk?=
	=?iso-8859-1?Q?648f6G9zGX5dCK0g9x/uEMs8D5HILLWIGhU/UwBB/3wAmR9T1gtMvuLJ4F?=
	=?iso-8859-1?Q?5f4Kh8/ohkm7HO/+G9Hp34FXXC2A4rYHpAJn3O3u8gkruUq4ORmWoMlQmM?=
	=?iso-8859-1?Q?pzCvg4Yiq/IBhHucOQagHpL0fGCYAKY7s+5pkkdKBYF18qJjYxMWYG+sNZ?=
	=?iso-8859-1?Q?5+JvQaq1SVEKeY14Os6wJquoydrR9WGL7BCu3CpFeyQ3+gVhxdzGWFqjoD?=
	=?iso-8859-1?Q?E0jszWleyh0VtpoE/6LA9OvrL6rUZGoOW0FA0ljJI7vqnrimg9b/ZnQP2F?=
	=?iso-8859-1?Q?3jWBf+YFFs1wRsoh4hVm5jDnLZxlBGtcFxeVMNblX7yr7UpJjPHsvyNM+n?=
	=?iso-8859-1?Q?u6jEHoPz40D4HYpINLI5GOdj502MQy5/2/S3PoztcNjVMKFhJ33yu8/uq1?=
	=?iso-8859-1?Q?qIxSvx3fCCSbf+DYWmvge9z7WdZm57R+Yzj3ACtkRwxVb1J3hjsj9PSE6l?=
	=?iso-8859-1?Q?IK7b6XRp9V1nshma/bZyhKbrji55eHDphCKpwvUS/JBTJtHj+/lSF8RoO4?=
	=?iso-8859-1?Q?La3A0RtDOT7L1ypBlQcln73id/2dvUpyiumMOS4mZgBDhAKH3vrhEHhMB0?=
	=?iso-8859-1?Q?UWGM95qldrUGtkPUh8LHJ+XrwTKfoXmV3mSiK8BHMkxKgosunmKFpB13gn?=
	=?iso-8859-1?Q?FYf474OHeAwQ0ifJm1CnnJU6Uo+EorGd6yKdvbD0AKnzg4TXC9YPDrQYyZ?=
	=?iso-8859-1?Q?Ed9HxFudBiFmIWe37MyHhlN7IRMlcA35waqc6ynLwLo3mv4JazXQUI2eCt?=
	=?iso-8859-1?Q?iR/jgFk6va8ff4iA3uAATPIJt426N0TV3UrXwugKSUKrQuoYuIHlNwT8nK?=
	=?iso-8859-1?Q?czLmJ6mthkNRTuj1ImZLnO2mJuHvCKafQAZlBojHiSAfdmKxag0hEElwP9?=
	=?iso-8859-1?Q?/tf7uN+8RH3DChSh4g/mxagqFSUGIXuckFj03hadXr8DRoEqdI0Q7gqVTQ?=
	=?iso-8859-1?Q?z7z/J2ql4WuDzdp1txNgjlMsUictuauaneAXKmCtmbqq3sW3toyXGyPWz7?=
	=?iso-8859-1?Q?Tpxob8YvgBFto9+5nRqn0Dg242itRHCl9gKac3wLtyT7jPmIFkqyz8nx9X?=
	=?iso-8859-1?Q?yfcBaSVKvoqIC16533lS09tpNl+7CLTaphUAPPkEdpRwGnYo3p83r8cfxP?=
	=?iso-8859-1?Q?EjJrmcknkWcGdRYnxEjP7IbCH4Ne8ewOVbJZ+0zfk6RNwWLMQHEdtxx9zx?=
	=?iso-8859-1?Q?Rtj/S9XzbT+JtD0kNB75HIwgWJJiLE5XBxNJCOkZ7wnOf7DcM7td6XQMW1?=
	=?iso-8859-1?Q?wkmWmGtA2YS/R6wxvuRAbu?=
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR19MB4852.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baafbf36-42a4-4cf3-2f40-08d9959ee784
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 20:59:56.9862 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wayne.berthiaume@emc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR19MB2501
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.790
	definitions=2021-10-22_05:2021-10-22,
	2021-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	priorityscore=1501
	lowpriorityscore=0 bulkscore=0 clxscore=1011 impostorscore=0
	adultscore=0
	phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220117
X-Proofpoint-GUID: 37ixkcM3qq0PJFzoPIkcmMvxDAsEDaHO
X-Proofpoint-ORIG-GUID: 37ixkcM3qq0PJFzoPIkcmMvxDAsEDaHO
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	malwarescore=0
	phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110220118
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19ML03kA023472
X-loop: dm-devel@redhat.com
X-Listhelper-Id: 20211022150101-12104
X-Bogosity: Spam, tests=bogofilter, spamicity=1.000000, version=1.2.4
X-CRM114-Status: SPAM  ( -74.20  )
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19MLdBms026411
X-Mailman-Approved-At: Mon, 25 Oct 2021 03:40:10 -0400
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config
	work	with alua and multibus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks Martin.

=09I'm still researching this vast company for the product teams responsibl=
e Compellent and PowerVault to be sure they are okay with the changes. We s=
hould hold off on those as well until I can get confirmation.

Regards,
Wayne.

Wayne Berthiaume
Manager, E-Lab Engineering Platform Qualification Team=20
Dell EMC | Server & Infrastructure Systems | Platform and System Engineerin=
g | Infrastructure Engineering & Operations | e2e Validation Lab (E-LAB)=20
176 South Street
Hopkinton, MA 01748
+1 (512) 647-6157 (office)
wayne.berthiaume@dell.com=20
"FOLLOW" E-Lab Engineering at https://inside.dell.com/community/active/po/p=
latform-system-engineering/elab=20
Confidentiality Notice: This email message, including any attachments, is f=
or the sole use of the intended recipient(s) and may contain confidential o=
r proprietary information. Any unauthorized review, use, disclosure or dist=
ribution is prohibited. If you are not the intended recipient, immediately =
contact the sender by reply e-mail and destroy all copies of the original m=
essage.


Internal Use - Confidential

-----Original Message-----
From: Martin Wilck <mwilck@suse.com>=20
Sent: Wednesday, October 20, 2021 2:45 PM
To: berthiaume, wayne; Xose Vazquez Perez
Cc: DM-DEVEL ML
Subject: Re: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config wo=
rk with alua and multibus


[EXTERNAL EMAIL]=20

Wayne,

On Thu, 2021-09-30 at 14:32 +0000, berthiaume, wayne wrote:
> Hi Xose.
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0OPM is no longer supported in the Dell VPLEX prod=
uct. If we at=20
> Dell had wished to change the default device stanzas for any of our=20
> products they would have been done when the product and/or feature is=20
> released. Please remove this patch as well. It is not needed.

thanks for the feedback, and thanks for paying attention. The patch will be=
 removed. The one for SYMMETRIX, likewise.


Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

