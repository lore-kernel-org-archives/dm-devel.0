Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D611EC7EE2F
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=075n3jEykVXUJb3yYb9jMzxKi34fMy/ck23iaBfVvG0=;
	b=bNAYPx0/sLCS87LYxY4+M900TpDa+PIQXI89UNaXaYwbm6YM6noMnlPxYgZlxrVmYSDqo9
	lz2QjrXlXkvpjvaabpO9lyiLfjw5BIyeS6GWpsVMSQX4pN/f9+DVRU+osoTbjM/twM8T32
	tPbFr8Z6kORMHSroXpwHXPCpfuVmfjc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-VK84uC2BOEuiQCqWufeNyQ-1; Mon, 08 May 2023 20:03:30 -0400
X-MC-Unique: VK84uC2BOEuiQCqWufeNyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB3731825065;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F54A1121315;
	Tue,  9 May 2023 00:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F3BE19451E3;
	Tue,  9 May 2023 00:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 246611946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 19:21:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 121D1C16024; Mon,  8 May 2023 19:21:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 084C8C15BA0
 for <dm-devel@redhat.com>; Mon,  8 May 2023 19:21:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDBFD85A588
 for <dm-devel@redhat.com>; Mon,  8 May 2023 19:21:38 +0000 (UTC)
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-4x6PMwYxN7KTmM3WrZHoNQ-1; Mon, 08 May 2023 15:21:35 -0400
X-MC-Unique: 4x6PMwYxN7KTmM3WrZHoNQ-1
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 348DVAfX000412; Mon, 8 May 2023 19:21:20 GMT
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
 by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3qf21f2rat-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 08 May 2023 19:21:20 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by p1lg14880.it.hpe.com (Postfix) with ESMTPS id A6211800220;
 Mon,  8 May 2023 19:21:18 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 07:21:18 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 8 May 2023 07:21:18 -1200
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 8 May 2023 07:21:17 -1200
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1781.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4c::6) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Mon, 8 May 2023 19:21:15 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::71d7:118b:6b9:c794]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::71d7:118b:6b9:c794%7]) with mapi id 15.20.6363.031; Mon, 8 May 2023
 19:21:14 +0000
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH v6 11/12] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
Thread-Index: AQHZbAH88VGTsMp+/EmLUGEOvPYmc69Q69qQ
Date: Mon, 8 May 2023 19:21:14 +0000
Message-ID: <MW5PR84MB1842D5D264A5B067934F30CEAB719@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
In-Reply-To: <20230410225936.8940-12-chang.seok.bae@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|DM4PR84MB1781:EE_
x-ms-office365-filtering-correlation-id: 922310dc-f784-4b5c-7143-08db4ff96421
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: or6qTqk8ZUUs0UiBovMcLlKJj4xgfHEs6//Wo1C7Gvtyev9pSo2bf2jMqSCOHc+RFl59IRhrJtvfYPy/y9g7sSaLHLSQOKbgU1Ei5STWKI0CQZ3oY/o9Nm3t0osgCxF4iVXBIR6v0PNNNddJjG4PIkmdA6sePagWg6wLX0olqSR4c9GTzLtQXowov0jsbAtXBwiS6mVTrJTWz0mlY7O04ge5Ko3Dm3JGLaflnC4UtkVOvhdK5YEan3ybcmfFdwwqD0+EuiVSnDEwbKYFDHeEu5Uphc8uLcx+gPs6yVWvHXnRY0rY9Mi0+ka0BEAjx1RtdXeyLX5X0/1fKT14I2CyXulqw9yDWA6hWzCM9XR1rlv6Smyukc57EfGIjQDlSdd6vyC0gqiyfN3EAgpNQQ6K0JSFBcaa+97os3qXcnYNj10+py78Co7tco8vlYGzz4WoP0W2SSSGOgUS9i6rtkS1z/nkAZCWwOW5Z72Xv1ozIrT+f30qUk7Dp2+t7A3ANwbh038hjd1UxX/15EACGgBGzG4bo1hOblhgzXNmbuNDcdYnZAbdp9Mxb3xmcbOb6u4IJ4m6TXtvBVQp+yvPO0RZo4y9OKs6JcjT2dVnU91vgXg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(110136005)(76116006)(7416002)(5660300002)(64756008)(66446008)(4326008)(66946007)(8676002)(478600001)(66556008)(66476007)(54906003)(8936002)(4744005)(2906002)(316002)(52536014)(41300700001)(71200400001)(7696005)(26005)(9686003)(6506007)(186003)(82960400001)(55016003)(83380400001)(38070700005)(38100700002)(33656002)(86362001)(122000001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u8v1Dat1Ol7526Vkqj4ZpV89gO/V8sQkHX+/UcxwVBjYY1AQuTYqwEMwB1rh?=
 =?us-ascii?Q?qUE4XAtQ1zOlFE9qQGwtzJoe1Rp0v8UAng8POKwnvOwdLa2BwbsZgMtzzTnG?=
 =?us-ascii?Q?nvHY1WScKZF2x27yY/DQ9uhnDwOBeol8H48mMiuAjFbrnL7Qp96uNo0PCryA?=
 =?us-ascii?Q?zUXNk0PxBRqKEcgzaxIWIYRAxYjqzzUegZQhLlDHaZpc8FwzUipF8S549ii2?=
 =?us-ascii?Q?B52HOTtxRr6W9y5blKyH9WsP7wNG7D6foKY19TLiiL5Moq1WCAaSGJyxjv5o?=
 =?us-ascii?Q?HVKYgKKSr9/bd1zCfGocIrClz9EbBj1apSG+99CdodUTnWHMgOdTFpEDZ88C?=
 =?us-ascii?Q?XQOgwwNRsLqo3qFjBXIN2pGVFsQhlMB75iHdeUWDZ5mBE4pbuR+qSr/ycaog?=
 =?us-ascii?Q?g4Za6z/qTWWHFzqIf7BWcdl6TuG8VBr0UiwyBekcMrWCaHNuhfWdemJFUUGj?=
 =?us-ascii?Q?mNAJAqBvZ1cOQbGfyYJDWbnR8gpr0NUP2aqzoRy+pC+6O5T+azxMQaL04Ltq?=
 =?us-ascii?Q?4Ob3X2laV6ac43SYOBtcaqa2pmG/v9oA5SRXf0/yq/CvaTtORXREJwWw8/o/?=
 =?us-ascii?Q?XkTAjA/f+4Jb9Z8E1HDnLU35CabeysUdFf0WIp0WVeoV/SvZLrQt5E2KQYRb?=
 =?us-ascii?Q?QspGB64rcy3lpxiyCJVuOQw6iV9+ccGwxKzY3aoh+mESvGMs/kMuvw72W4jV?=
 =?us-ascii?Q?eD6Nh76ZltuDbbE3qvXRQVJLWgILJs1UlaXjMHtrffEQW56353SEVBu6+SIS?=
 =?us-ascii?Q?31/GIetCIfaCp8L5EflPwZ9ZrH2bToRf5wuo3fB16GZiFA0N1D1koFQBX77F?=
 =?us-ascii?Q?VaeFvCPixdaMK99WdQH8fq3BPjjwcBmks5LF/TdWD1LrNnlx9lIjPTVqLEX/?=
 =?us-ascii?Q?ymCTw6A06KkvO7hpytdSn8ksoyKQ7owyCa6TzzNOvjeXCpEARwiCdopOwMJv?=
 =?us-ascii?Q?IwupQv9NoNSAb+BWMpcTSOPk2k1sd+gy2gOlflRyoNPgrdOQeJ3+WCnM50uM?=
 =?us-ascii?Q?+dxEMb2+dUdla7i7w/H9SMeVQ3NulsMWY6QeptoVyVs/PDH4HxtK4fuUNdkY?=
 =?us-ascii?Q?GfyDmTZoN4Uc5aNNGUIpMAuPg/F7w0OJf6tsZJFKtGeyibu6hUqR2+kTBWGV?=
 =?us-ascii?Q?OBYcjgKkXPTzXCZuk0DAkrzlzXzw7Wgin9qJrix77TI1Ipn/bTsuKUUQtDfG?=
 =?us-ascii?Q?+F6pzIWspx8RsYxGCionQS3Zdp1/r8+yWPz+QKYHU0OBmq6OrbK3AXuXtiP5?=
 =?us-ascii?Q?tdg9+6qPe/jycAPdYThwPxDx62RzrAPthAanzICjIsEttGl1d4sl0AFARsBb?=
 =?us-ascii?Q?qv1LH5KfbsWsQZW2ZnL3ODN8OzGs5uyxFxWZVuMEslY7vMfazKLWT93QwaDm?=
 =?us-ascii?Q?Ggk64lzORQAqsVO6BwVmtgt0OzszxYtmsvePyHLN2qB26TtVzpUzXneuykqc?=
 =?us-ascii?Q?L2Vf5WZK9/XtXLt4NSAKWGKgyt/iR5TrMJONVhEbc38tuQ4mCiEVg2rloX8I?=
 =?us-ascii?Q?mBjajKxOTxMcP28OWxahwZGssZC2TdoC6KRUgWqz4OZXWeq6Rr5D2EwUCxyH?=
 =?us-ascii?Q?5G2pfC10Aw+mDtDH9VI=3D?=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 922310dc-f784-4b5c-7143-08db4ff96421
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 19:21:14.8373 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBDsr4MMBqkG9+KIIiwm5LBb10pk9t9IKtGQcQ3/gYqptQZTtsbJQzQS/oJ/LXM+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1781
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: ETdyDvO-uGUyVQv-UpRUAvLDClbu0Srp
X-Proofpoint-GUID: ETdyDvO-uGUyVQv-UpRUAvLDClbu0Srp
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_13,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=953
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1011
 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080128
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hpe.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> diff --git a/crypto/Kconfig b/crypto/Kconfig
...
> +config AS_HAS_KEYLOCKER
> +	def_bool $(as-instr,encodekey256 %eax$(comma)%eax)
> +	help
> +	  Supported by binutils >= 2.36 and LLVM integrated assembler >= V12
> +
> +config CRYPTO_AES_KL
> +	tristate "AES cipher algorithms (AES-KL)"
> +	depends on AS_HAS_KEYLOCKER
> +	depends on CRYPTO_AES_NI_INTEL
> +	select X86_KEYLOCKER

This material belongs in arch/x86/Kconfig now (which didn't exist when
this patch series began).


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

