Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80794C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  9 Feb 2023 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675936193;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lDZ22ZRG+KIbGbOpWHmt/VEf0pG7qR+4kHlo0zdERek=;
	b=fasZKfsvo2OSTyb+ORXAS2xakvT8CU1FT/eFhM+rz0A6h3ktna+AsLR/7OMY2tYMCNb6fl
	yYaXjdWel69mp9WiWKuO5rIcfw9XioAWJwSQ+TBJE3KDHByr587EjqH/ic4e2yQkMu2TMg
	yB0DonO9EClDzDrMnNwBoeP7upI3Oog=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-yUv677bxMEudMeCThOIa-A-1; Thu, 09 Feb 2023 04:49:52 -0500
X-MC-Unique: yUv677bxMEudMeCThOIa-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A86191C426A4;
	Thu,  9 Feb 2023 09:49:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A50E040398A0;
	Thu,  9 Feb 2023 09:49:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E320194658D;
	Thu,  9 Feb 2023 09:49:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 37EAF1946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Feb 2023 09:49:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19E191121314; Thu,  9 Feb 2023 09:49:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C9F1121315
 for <dm-devel@redhat.com>; Thu,  9 Feb 2023 09:49:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7A4B811E9C
 for <dm-devel@redhat.com>; Thu,  9 Feb 2023 09:49:46 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-re4HSvFONcuWDBkpxDM8OA-1; Thu, 09 Feb 2023 04:49:45 -0500
X-MC-Unique: re4HSvFONcuWDBkpxDM8OA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8150.eurprd04.prod.outlook.com (2603:10a6:20b:3f0::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.18; Thu, 9 Feb
 2023 09:49:42 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%4]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 09:49:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipath.rules: fix "smart" bug with failed valid path
 check
Thread-Index: AQHZO1TRbKDOpnqkN0i94lq6egfSTq7GYP+A
Date: Thu, 9 Feb 2023 09:49:42 +0000
Message-ID: <a7d50de37054ac12ffd03604eb5a0439ad937962.camel@suse.com>
References: <1675816336-24371-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675816336-24371-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8150:EE_
x-ms-office365-filtering-correlation-id: 35ed758f-fefe-4552-445d-08db0a82f7c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: E3LukKiYbiiUpaxAdovQSR/byURdda5CfZNkfWAJlwn7bDsx0DaluuzyaU3XiZhPoaua7KstaI7Yns1VxvhXebsISyIHIBCuoUFfHi0jC6ez2HxHyndEvfEFCm7PNa7WpWhySyUncpNh61biTKHZCuuR23JAcOY1kMdkwBjI8XDZoznbSxpH3zRJwr7703tWb2+bN1YyObDPgwZKTSzhpdn0jGfS9x7DpThT85rs7e03TK1hKQp69oQyh0N86XAW6dXG3LPGtuvj+yVmFgJh7YUGIcxwEXS7RJWPWSXRNmAMZOkhNKBi/Xa5hHo50p2o3mS/Ml2FidSLz4iptmbjm6Jm0oJ9R9M93uv7RoWhEwpkxiyvgjzfU4S5oEoRfG+kognnpOw2agqgJ8EYSdZUKfOXmPSpCUoZuY4vCbQVBu3IU9Ypewd2Wtfjb+nSAxHTrjY1oCIYeMGChJPUI7SfnL6TCX6kK2gSPuHUAGOUu6O254txbSz0c5kJhxECbwWmYn+2jg5fQc12jpcqyWOgHxOiBQLNH3RulNFurIpNNs89N00E7Iaz7qFKtpr4R8JGCk/6G6NdQXCjf9hhwKvpodOo1RKHrPIGjA1HAhcinFgIO0WHiyA1PdcnWW+mbFKVNbUJ2e8gmmyLS4jAS4rjORuEVacO1praM/CmYHyxpPXv5S5WiWbnV+unrFWYGxLNY05zgeY04imUH+NH2jF2dw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(71200400001)(8936002)(110136005)(6506007)(26005)(36756003)(5660300002)(6486002)(316002)(478600001)(4326008)(38070700005)(8676002)(2616005)(44832011)(91956017)(41300700001)(186003)(6512007)(2906002)(66476007)(66556008)(66446008)(64756008)(76116006)(66946007)(122000001)(86362001)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?UWXZyFrTIwx5IUKFaCXBaBq5H97tmFLLfYiueM8YGhNXuK2g59sy+n1q+?=
 =?iso-8859-15?Q?lsEjt7XDdbVkuMYWL0TFnIO/j2ZwC8gf/4MiBs/6aPY4v3GsWPE3x1+W7?=
 =?iso-8859-15?Q?LcYNfIiTaaRAuXLf8nn58m9yyX/r6OMD+is8kf0Osuyi08JL8DB6OPvuD?=
 =?iso-8859-15?Q?fsKFx3ZU8yaKJ/o6C3FpaUdYE9lhfVOCLygxJEz/vDJHAvC5LVw7mOwLa?=
 =?iso-8859-15?Q?mxDKHezbk+Di0EN64yRBioxkrpHAwSg7I9S2eMNbq0c6Hakc6YhhQT4h7?=
 =?iso-8859-15?Q?FVicJjs0f61EQI06+B+wkBfHkf4U0bRgyTm5MYwlApMpUNRt9qiV5RJa0?=
 =?iso-8859-15?Q?Bmyzsu1NagUPcrTTMwZ0PMMUHpQRBpBXZUreBcCYZvcmYcamSh6KexiLy?=
 =?iso-8859-15?Q?dzpk0WUxwKKga1m6QPNpn5XDpjCF4B4mTrc70TpIfZadT2WTObZ3rdlCW?=
 =?iso-8859-15?Q?Qc8q4r+IMix+9TEeeJ6gjwuxycsN/KC4ZVGf8xAoP0SkVGY8Se2yGh2Vl?=
 =?iso-8859-15?Q?innWVcurQWv/fdBS/f0xefOpjqhLyEY7MgztlCnePpESjhaQlFZsiDF8L?=
 =?iso-8859-15?Q?XS0/0zgBF88uLKIiLKOp+VADGJ6CWs+q8YSbgx4TxOGsSq841dwnMB3gN?=
 =?iso-8859-15?Q?mkvJhamSUdbyWaguCFY6hlGgGHDEXQpk3UKvZ/c8MpdEjWoqrWJnO6B40?=
 =?iso-8859-15?Q?swurOq7nl/4gjUeZgs68DFVgZ3AboqILB3m+seWNIPyc6h3YUIo77FaVg?=
 =?iso-8859-15?Q?FXHPS+YOdVuMNIEx8JiB3C2IJdsOVLaCkDwu84J7WtL9PNDcCT3Fi4eMo?=
 =?iso-8859-15?Q?VVz/GMYqagdl9r/lIf8qGGNrzOi3n6e//s/JKmSjIISqxesy7Qs0XgQ9a?=
 =?iso-8859-15?Q?Dr55Lj57bQCKYe/RtUKmNOmnCILybOgVMtmH4jLhQK03HD6a6yY/djzNb?=
 =?iso-8859-15?Q?FYHft6+FFEbi+MwaXaqMN1RYSSh2LpGSZBXZ1pdJqXNCn2CWuuVLlodnT?=
 =?iso-8859-15?Q?kJdQbFWXJwQ3XkNzawiaUmk0Q2W0M1BoIO4zi6HljdGsr+3WslQcefQUo?=
 =?iso-8859-15?Q?MVDeQB+PX9tzznnCnM0HeDiEUtQcp7fQ/zxohsHJgFxi0Ju88970XoHJF?=
 =?iso-8859-15?Q?WAgK4e6neWlu7PuSgnDYhk6noUpRbPnJJSyiQLvbQbG/F/1AjkReH820/?=
 =?iso-8859-15?Q?5q/NGWG1BfhbiPSb6LYLxl7/fnhMTeChSkRFesB5fn3QPCJZVDItuVhsN?=
 =?iso-8859-15?Q?Fecv6Z/U1Ce9YQvxDFacl/Bka6hK3ECZ+pxDZM42GZL/uK+gF6zc4j0dn?=
 =?iso-8859-15?Q?7XKbMte3SjhdxNgYJ0RLMFa9jAezXLdWzP70I5199z5+542NoA+tCXybu?=
 =?iso-8859-15?Q?5Qjgc1tiRvFoioTjAzokEjWsR0JhNxDRT9GUR1nA/DfrZRUl7XyedptUy?=
 =?iso-8859-15?Q?8n5vhKDC3IzHYTfuvpfKL+psNKvRTrpJuexXgW4QfIH+e6sVH6+eqVshY?=
 =?iso-8859-15?Q?ncCG7+y7K+PK8H8luAeNQRaWpdPUMvsB7QQClzi3Vuw1RWoeTGZ2agyTu?=
 =?iso-8859-15?Q?b2IsO58maHA+83ODDCQ2KVP3NlYaCF9wcmZFk+JepE05cFETS9EquyaP6?=
 =?iso-8859-15?Q?aO06VirGiD0qGCMeaxawEtD7nDunqDalM7g59vGQhhwsLwJEImC86q92m?=
 =?iso-8859-15?Q?uy0Iu5Kfe/awYXCMP7/1vuu6ag=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ed758f-fefe-4552-445d-08db0a82f7c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 09:49:42.1409 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IlagzRvBjwMCRWVisxAxDUB+O4J8qoshKBAdN0lKLbl+dl3AChsuy3EH6c/CcQnMbMc8WfzvmanaHwx9EFfsEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8150
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath.rules: fix "smart" bug with failed
 valid path check
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DC1CBE5DE47F60498A285EEF4FA37B0D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-02-07 at 18:32 -0600, Benjamin Marzinski wrote:
> If "multipath -u" fails, udev doesn't import any values from the
> program. This means that multipath.rules will continue to use the
> values
> for DM_MULTIPATH_DEVICE_PATH and FIND_MULTIPATHS_WAIT_UNTIL that it
> has
> already imported from the database. This is the correct thing to do
> for
> every case except the MAYBE case for "find_multipaths smart". In that
> case, DM_MULTIPATH_DEVICE_PATH will be set to 1, and the rules will
> assume that the device has been definitively claimed.
> 
> In this case, we know that the device shouldn't have been claimed
> before, but we don't know if it should be claimed now, or if we have
> hit
> the timeout and it should be released, since we didn't get any
> information from multipath. The safest thing to do is assume that
> this
> was the timeout, and the device shouldn't be claimed. The only time
> when
> this could be the wrong answer is when we first see a new multipath
> device, and it could only cause problems if there is metadata on the
> device that will cause it to get autoassembled by something else,
> before
> multipathd can autoassemble it. If we assume that it is a multipath
> device, or we assume that this wasn't actually the timeout uevent, we
> can keep a necessary device from getting released to the reset of the
> system.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

