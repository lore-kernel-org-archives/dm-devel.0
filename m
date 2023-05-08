Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E755C77B75
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590642;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vzzMsmiC5Tl0Ccuw6zzbRp/O/TVD2xDULA9Z/6glP8M=;
	b=fbuEYLYERF+7caUrHiLSzyQvp7xBWtaYrTbhX5Jv/PxPil00ZevkV0gMDiC4chr1i3qPRg
	E8xPmPDphHYVSSXGXH1bNAqvgPGhI1tWFy1OE2Ff95xJwaXecoQiOdvqCMk5lm10VRFtCA
	WRNBSNEzwEICq8ogIG/Hkzn2BXRwGsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-23gKH4iKMLK4xayhqj4mSA-1; Mon, 08 May 2023 20:03:30 -0400
X-MC-Unique: 23gKH4iKMLK4xayhqj4mSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB207857DE4;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68EEA492C13;
	Tue,  9 May 2023 00:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15E0819451D2;
	Tue,  9 May 2023 00:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 23B011946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 19:20:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 127D92026D25; Mon,  8 May 2023 19:20:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A1E52026D16
 for <dm-devel@redhat.com>; Mon,  8 May 2023 19:20:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF5F888CC43
 for <dm-devel@redhat.com>; Mon,  8 May 2023 19:20:42 +0000 (UTC)
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-xf2MsuAINqqqJOF0tf-2uw-1; Mon, 08 May 2023 15:19:38 -0400
X-MC-Unique: xf2MsuAINqqqJOF0tf-2uw-1
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 348HjiRQ016070; Mon, 8 May 2023 19:19:07 GMT
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
 by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3qf5s10njy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 08 May 2023 19:19:06 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 2CF3F12E97;
 Mon,  8 May 2023 19:19:03 +0000 (UTC)
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 07:19:02 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 8 May 2023 07:19:02 -1200
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 19:19:02 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1781.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4c::6) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Mon, 8 May 2023 19:18:50 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::71d7:118b:6b9:c794]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::71d7:118b:6b9:c794%7]) with mapi id 15.20.6363.031; Mon, 8 May 2023
 19:18:50 +0000
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH v6 07/12] x86/cpu/keylocker: Load an internal wrapping
 key at boot-time
Thread-Index: AQHZbAHvJOw7tE8EFUqNRCfBgGyiXq9Qxy3A
Date: Mon, 8 May 2023 19:18:50 +0000
Message-ID: <MW5PR84MB184225DA6EA0FA7A9191C057AB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-8-chang.seok.bae@intel.com>
In-Reply-To: <20230410225936.8940-8-chang.seok.bae@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|DM4PR84MB1781:EE_
x-ms-office365-filtering-correlation-id: 3e56d50d-37f6-411c-91a6-08db4ff90df1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hyMuYX+50PZDRs/jaJK7eS5bDrpKCCGPH9401ymD+G0j7tMAh3D83aBQdfZdEsLrJwtgWy3NkXi6R+erf5exvr/JXpoRuAXBA54OFrrS2Up9Z6ptg5IRbCSaC2GtVUq2dcOiAMwQ85EEMgscH/rFOVRN+baQQ9X/olS73oYVA2TAO0RDHbjX4UPo7LmXdOAI6ElfQiNfVdZf71GfvW5XGJTDtJCHq/eumdG2ngjfMt6jT3Oh1X/h+MnhlAmusz9U4SBE2WPv5dsQ2GUCIdkZyLsqZXnR83KGPBgcZYHifLa9TRSh06uwGH/Qfbr8j1dym2rlTTWFf2YStDhSXuGpN/xVVXDZ/lwtF+pT1UO3nYJc+4zoYFqh0nKNCkLVQHsZqcSJ3mi54pvaj00uFJa54RmlfbWmzaQxLaa65yc7910IsJqXpwEo2qEOtCZgy1eS2k/oOU8GPDyn7s9nFb3JnBu9jMWoy7DwjYHD2XEGYdWfQL5n6pZMSIoY6MVgrPgl/XzR1Zfg5aJ2d/vZ3RPilOK8XJMYD1BSgbQal3Tf02RJRXEgRDqrTpDu31banuzejJtk54LCTSIEZ8oducqhv2K4H7QXFPdWIIVTei9Pinb3gMBPjv+qqIAU7uTjHi/m
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(110136005)(76116006)(7416002)(5660300002)(64756008)(66446008)(4326008)(66946007)(8676002)(478600001)(66556008)(66476007)(54906003)(8936002)(4744005)(2906002)(316002)(52536014)(41300700001)(71200400001)(7696005)(26005)(9686003)(6506007)(186003)(82960400001)(55016003)(83380400001)(38070700005)(38100700002)(33656002)(86362001)(122000001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xfyeahWxSSOyh5EVAEqRm6bWsiCJBOU5IGIcoh1bFSTISdpLlZVlBAAnylK5?=
 =?us-ascii?Q?by+lwKF0YP+0FZQoVEWL0jQ+E5fImzdDN+rd8RrYjN9l+On0dI6/oDGfjXOC?=
 =?us-ascii?Q?plYnBifFsiGbyQvqhq58AE0XYHWyeWNdfazCG1tcwgIW9oyXJuMR/0QVcMHk?=
 =?us-ascii?Q?jxTYs6Ihbrg1bx8BknFefS7FRZAg1uEgcw110pF+3iOhWNE5n9BwweSyrYeT?=
 =?us-ascii?Q?cSOsy0xJVQGLyuB+Y+iLfgKWgwm5LxkiqXl/Ji+Srd13RHv6pluPAI3u/RLH?=
 =?us-ascii?Q?GUg5iW9nAcRVHAOevmN3+7nYJZdlA85Z19iXNiONb6is81GCLlA54ipjAHLH?=
 =?us-ascii?Q?Pd8IwBL0zJ91SUAE3M4P19SELO9/S4ysTceHSpn6P7vxN6/RkRpTj4KR6CPr?=
 =?us-ascii?Q?GPiHspqo294pP0CuYKJo/rhf5oAVb5Qx3HfOUFls3TV3fp2NiEKanZcXktJV?=
 =?us-ascii?Q?rIPedUiGHEv8ShBRwm919T1kh5G9B57dQ6DRoIiGSNbR/Wi8ren++Gu9cox7?=
 =?us-ascii?Q?SOUUC6rkvxX2XY1W+6mdPjx2sY2+/djfFrosV9dmMGCjF0jJA92CHDK1hwmA?=
 =?us-ascii?Q?L0KQhFPd5mW9IW3aEniNr62kHSyIw9Wv2rqc24bj4zaSq1beta1jPp5PZY/0?=
 =?us-ascii?Q?IREj9HntRV7zE/eExuoSlSBVMSB8c3kkPFd87c01sTqFJC0NyjGzXjoF7pu5?=
 =?us-ascii?Q?NrveEF1fY1LzMEyzYZyR8EvfLe9xlfam6bvY5opeq0LAR914gWBBNqpOLHDF?=
 =?us-ascii?Q?mKYOSWqqwJ6Mws42te3q/lY4bTaSACM3rPenV5lqZfUksMTFNL6L32M5MBdN?=
 =?us-ascii?Q?sXvCIpRuq5t3eOGDFxsvMwtHoqScW2O2Oqi9eEi3/C7AHmzlmFBLVUCxs/T5?=
 =?us-ascii?Q?LTk6Yui410l0ERJAA5Y4KyfHhz4viO96NEiu0ILqbyaoPNNNJjI1u2AETwkg?=
 =?us-ascii?Q?aLJ8cLI3U0VzpjkLvDU+0PViNl+6RqsRTCg4jpH5RU+E2Lqk1vpctHbGRvke?=
 =?us-ascii?Q?6YOE4YBeuQ1HnYlP+CEide+Tu+kfGflBo/MuOR9qH1JYuI5Y9cxlI3fvJcYe?=
 =?us-ascii?Q?ZRXYvcqysNp8kueBSX2h8q6t9kAuslh7E1BClyEh3goDkMSpNIkDLk/V2fuq?=
 =?us-ascii?Q?c34B/qmszrynK++Qg+1pHT7cwNgh6/F2WKJhD9/tVsSwJjMpt3ZMYofBBB2E?=
 =?us-ascii?Q?qo6Zzs8k29UeyUkeXiLK/26r0KX5CJqrCgyZXpyvl/j73zTrhD3gcLRRCcJ9?=
 =?us-ascii?Q?tzRMzUYr5mM9S72ZPcDhUczEQDd4tXFFwh4j48nK/Cd6Dewuo7akOG1J7o6v?=
 =?us-ascii?Q?yWbNdmfXpUnaYtTOjdTsOyWrUMnkEc838lCw1fDM86Ckmt7skh3knuJyrJzw?=
 =?us-ascii?Q?aZuPTHzaOUwiXJH8Yvj9pNxe0enrV8gMJfejaPO2YuraVPg6jWSFF6Oh4h3d?=
 =?us-ascii?Q?rCkmyKl6lovQFnb+cba912K8Pg0PAHyr0p9OWpq2wWhbTcCZZy+DvCc7+TnS?=
 =?us-ascii?Q?necTu5orTJCvtMy81P9gXEcOZxiqmv5o8rvV8r6j+mEGNugArAwbwiOvBbKk?=
 =?us-ascii?Q?/E4wgUaJDkG8tI4mukU=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e56d50d-37f6-411c-91a6-08db4ff90df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 19:18:50.1877 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Isr9Ni/qTcxXU8M7JMdCjKcoTuI+hZdfzV6rmIYY/aOzUlNhClwxWCvnrT01Vced
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1781
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: v3wbkFgu3jKvIdIjXX92AWIU-_NGDmG9
X-Proofpoint-GUID: v3wbkFgu3jKvIdIjXX92AWIU-_NGDmG9
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_13,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0
 clxscore=1011 suspectscore=0 priorityscore=1501 mlxlogscore=908
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080128
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 09 May 2023 00:03:21 +0000
Subject: Re: [dm-devel] [PATCH v6 07/12] x86/cpu/keylocker: Load an internal
 wrapping key at boot-time
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
Cc: "x86@kernel.org" <x86@kernel.org>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "ardb@kernel.org" <ardb@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "mingo@kernel.org" <mingo@kernel.org>,
 "ebiggers@kernel.org" <ebiggers@kernel.org>,
 "lalithambika.krishnakumar@intel.com" <lalithambika.krishnakumar@intel.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "luto@kernel.org" <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 "bernie.keany@intel.com" <bernie.keany@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>,
 "gmazyland@gmail.com" <gmazyland@gmail.com>,
 "charishma1.gairuboyina@intel.com" <charishma1.gairuboyina@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hpe.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
...
> +void __init destroy_keylocker_data(void)
> +{
> +	memset(&kl_setup.key, KEY_DESTROY, sizeof(kl_setup.key));
> +}

That's a special value for garbage collected keyring keys assigned
a keytype of ".dead". memzero() or memzero_explicit() might be better 
for this use case.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

