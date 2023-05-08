Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FEDBC77B7F
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590616;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KmqC+kjRH54OW+y6jN+JLgmX3P8om04GrvF/tI4k0Uw=;
	b=G5pmGr4p1dgM2Bs5k6bB2lJQlxPrZjzZgqwLorUKSymgsOUmQMLr97jCmVh0DPI2Pcz8p2
	HW3vgLgPdXQqWBRb4xQ8X0grVMHe3d6Hj8RRnNBDfDDaaCs/PNUcael1NuJdKVfXc5nfTg
	jjYra6PpEUdMwpaa3KapLMm8X1FjdNI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-DoJGmhF3NdKyqI4AcUIx9Q-1; Mon, 08 May 2023 20:03:30 -0400
X-MC-Unique: DoJGmhF3NdKyqI4AcUIx9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE48A86BF49;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22FB040C2063;
	Tue,  9 May 2023 00:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F57019451E4;
	Tue,  9 May 2023 00:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 549D11946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 19:26:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E0666492C3F; Mon,  8 May 2023 19:26:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7967492C13
 for <dm-devel@redhat.com>; Mon,  8 May 2023 19:26:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B809987DC07
 for <dm-devel@redhat.com>; Mon,  8 May 2023 19:26:10 +0000 (UTC)
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-myJFp9BtPQm_-cQgsSjhHQ-1; Mon, 08 May 2023 15:26:07 -0400
X-MC-Unique: myJFp9BtPQm_-cQgsSjhHQ-1
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 348JPcVF027122; Mon, 8 May 2023 19:25:52 GMT
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
 by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3qexgamhku-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 08 May 2023 19:25:52 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 319D712E9B;
 Mon,  8 May 2023 19:25:50 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 07:24:37 -1200
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 07:24:37 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 8 May 2023 07:24:37 -1200
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 07:24:36 -1200
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1448.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:24:35 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::71d7:118b:6b9:c794]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::71d7:118b:6b9:c794%7]) with mapi id 15.20.6363.031; Mon, 8 May 2023
 19:24:35 +0000
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, "Chang S. Bae"
 <chang.seok.bae@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH v6 11/12] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
Thread-Index: AQHZbAH88VGTsMp+/EmLUGEOvPYmc69Q69qQgAABXfA=
Date: Mon, 8 May 2023 19:24:34 +0000
Message-ID: <MW5PR84MB18427DC1BA5C09778A0A057DAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
 <MW5PR84MB1842D5D264A5B067934F30CEAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW5PR84MB1842D5D264A5B067934F30CEAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|DM4PR84MB1448:EE_
x-ms-office365-filtering-correlation-id: 849af347-1953-4743-36c5-08db4ff9db69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ea1vIKOuyPlawM+fk+AGtxrE1DGZ2qDC66BdZSR0A8c2+DDFfL/NeF5tV37+D5jqzSQ1FdQQDiSd3V2S9J+8Etk+tfiGXra8iX1rMsy6Cg4COELGoy8XY8UdNmnYq1cJje4hfJ124MO1uhKAKL2L9HUsq7zQJGxc8gctQ6vFkIGEWNgtvPnPUAuf2RC7xyVgFFPP34Wa8LZecA1bq/O/Z1+45NXTw4t/DSHNj8QC//iyyuwNDvzf66LFvlqO2sb/nQE/f5wZXrL3c9wbAGZ+PUavzf+h4i26S24ZGPD3st2BsFuYJdJ1QpaF3pKh72Rw/ac037NtCbc0AOQycBbe6Mm59g47gv30BoC4YB/kC4Obnmgs5ML9lXnDsOv1P1x8Rvpb2QEJ/9YWpE7R55VrkDbHC/u2Ypk7Lr7ibznpH13XKTugHaUPdFXqh1N5182vEUJiGQcorFVcERi1XbKD4jE8T6uZAvkcGvsiBHXiVkNcd5S8syZ6B79MVwdTdEPrG3vuMRQyE0leNf0sTINBBZIML52yEg2gEjUzbTtpL7sqQaSE7H/U8rDD+rX+MK2Rk4vFwJ+4wXfBTu3mRLEEvfM0xbXzANVZyoC8we5VN9KI/gA06wLeVbFN9Bkk49lj
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(7416002)(52536014)(5660300002)(54906003)(110136005)(7696005)(8936002)(41300700001)(71200400001)(316002)(8676002)(26005)(64756008)(66476007)(66556008)(478600001)(66946007)(4326008)(76116006)(9686003)(6506007)(66446008)(2906002)(83380400001)(2940100002)(186003)(122000001)(82960400001)(55016003)(86362001)(33656002)(558084003)(38070700005)(38100700002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qAnID33gEjBsRDqeVPQbh1QUSykcY7udp+wWl5VIIrsmBogovWPPNYpnE6ku?=
 =?us-ascii?Q?GPQu6Y95OhQlCvtNKdqJ5JJt3jb1DK7QFQtZbDEw6w4hIlraoZ54gDc1bYtF?=
 =?us-ascii?Q?hmdwpnmyK+1bOBoYufn65FwOS93H6WigzTlDQABl5IaZZFdoAMKHOPpIqUwv?=
 =?us-ascii?Q?PGnAA8D1GhYpbg5ebJYvsdJB1zlUbf3CxEBmNw3uUkTF29t8FG9Y2kvQj94u?=
 =?us-ascii?Q?C8Y2CJ5Ryf9+KWjmjNiqlVXZ3JcHl1x6JbEJOimVpcaKabX3PaW3L71Xmkwv?=
 =?us-ascii?Q?kOQhUHArzlSixtdWVMHhpM/LB1fGKgvQ0tC+TpR4bMxJsKh1ECxJjC/wUGDH?=
 =?us-ascii?Q?j52mhSUJ/5qo2EJhluO5L/Ynw8Tf4hOwfiZ0w7F6rLMbB/aQDA+18m69PXOl?=
 =?us-ascii?Q?2QSdp8kjIhaHQmFkSR3pYuKO1k2dXBfp63wdknQTZIZG4u7Dj1BNqIQMMam7?=
 =?us-ascii?Q?hhiyLp4ZOMTBp+cOiZfiTeGgslZSVVv0Zpb7gGpmQ9vnJv1eXC6NF/WOCMZc?=
 =?us-ascii?Q?m1oGmr6kYFPw0a70ZpayAgIGDqflhop474Jqd8nZ8yeAEN+OYMpaKnMTqIXk?=
 =?us-ascii?Q?q1HgmBtZjjlVpo1IVhC4hybKf0zSWkA870FhIcenDnRhMydd8UW05+xvGMaN?=
 =?us-ascii?Q?hSPA9AuWyJlGV5B6SgRRY2T7WzI0gqqGc3RJGMBAxh2Z24HZG8zAqJKovthM?=
 =?us-ascii?Q?mrXpWzrb+PqpZPdi/qvUvsLCHhLVe6RCuR12Kall1nVsspZBauZOVmySI3G5?=
 =?us-ascii?Q?zIoCz9wHF0x6h5Uvn7ZjWR+pin0q7iT0WGPNrGLKNlfFFOxKPExZP90bXGrW?=
 =?us-ascii?Q?02fN4MAGdoPkpd+qwywfmYbqFwjbflVwGpjJfEHoojK1Rqu7ivLmn8w2DTnM?=
 =?us-ascii?Q?oZdrJX4X9+ed8ffrTTrqdHhl4klhAhadC03zL8iaAFWNZ8yt4TbOkBA90Jny?=
 =?us-ascii?Q?jmpQtnXKtbbCaAFX/lgiAxWt3dgBcOTZZtQ5Pq1M04OBI8pomV5QPcZULxid?=
 =?us-ascii?Q?LUuXIXj4jq2cRJd4dlBox4wLkOWY16s6kI7dRK1e3Ahi5dMif8SjWAtS3lZI?=
 =?us-ascii?Q?n0xmTImqOTN7xhHof77OH+jmcFZzWUwD6tu+Nn/6zWmH5JqdKycvLzdegzWR?=
 =?us-ascii?Q?aJJBioRN+DzUUW+3b9ol153h0WOQUQ4XJ7IospnbtJx+eCytGuCYdlR/n+O2?=
 =?us-ascii?Q?PfoWd/sdQ4Nj9RYTgD2oQl8baR/gxRe9rdPMXHg9DsT880GhQoCgcOoLyX3z?=
 =?us-ascii?Q?T+6SPguh/iENOTl/cKTMuuiML4NyPRLrh1G+PQ1FS/DVuWZWqW2N9tDKmcfL?=
 =?us-ascii?Q?rAozUXGHGetoZcSZ0zf5M6XXv/WUVFOZCpbDG8ekfvaDHnMBqDo7kunNKx5M?=
 =?us-ascii?Q?3CJFMhfE/uDn4ObuWUc7Z1xV1+kPcImdrqDMiA2ipezlis7fTH2H4j2445hZ?=
 =?us-ascii?Q?trHr3LvFH8pfLfAbrnGeYjaRxFCjAhnlXYuRuLsoQ8tYuTc/EOJcxA1OQKud?=
 =?us-ascii?Q?El45ZLjwmdCRMt1cauuTrLb7N+vlNEJRc1ELjXyxtoXRhD2LD+f6hkkzfpnV?=
 =?us-ascii?Q?AC0nYyDWAa0TtMu8ehM=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 849af347-1953-4743-36c5-08db4ff9db69
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 19:24:34.9372 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pkHre53fqRC3lUrcCNKBPxooI+TdN+PCya3wmxw4Kex9J/Ad5f9JiS7JmdskZUON
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1448
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: YqRFc4gbD39ECMeIizH_rmrl7mHwSGIZ
X-Proofpoint-GUID: YqRFc4gbD39ECMeIizH_rmrl7mHwSGIZ
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_13,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=748 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080128
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 09 May 2023 00:03:21 +0000
Subject: Re: [dm-devel] [PATCH v6 11/12] crypto: x86/aes-kl - Support AES
 algorithm using Key Locker instructions
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
Cc: Nathan Chancellor <nathan@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "ardb@kernel.org" <ardb@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "mingo@kernel.org" <mingo@kernel.org>,
 "ebiggers@kernel.org" <ebiggers@kernel.org>,
 "lalithambika.krishnakumar@intel.com" <lalithambika.krishnakumar@intel.com>,
 Tom Rix <trix@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "luto@kernel.org" <luto@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "bernie.keany@intel.com" <bernie.keany@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>,
 "gmazyland@gmail.com" <gmazyland@gmail.com>,
 "charishma1.gairuboyina@intel.com" <charishma1.gairuboyina@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hpe.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> -----Original Message-----
> From: Elliott, Robert (Servers) <elliott@hpe.com>
...
> This material belongs in arch/x86/Kconfig now (which didn't exist when
> this patch series began).


Sorry, omitted one level:
	arch/x86/crypto/Kconfig


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

