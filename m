Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A66C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-SjamClfNMdSx3na4asKd8g-1; Tue, 19 Apr 2022 02:10:37 -0400
X-MC-Unique: SjamClfNMdSx3na4asKd8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7F801014A6B;
	Tue, 19 Apr 2022 06:10:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9480A40FF419;
	Tue, 19 Apr 2022 06:10:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E539A193F506;
	Tue, 19 Apr 2022 06:10:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A449C19451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 03:44:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7CD2940EC01B; Fri, 15 Apr 2022 03:44:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7755A40EC01A
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 03:44:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB93A85A5BC
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 03:44:29 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-k0oF2vWGOMOOw0YCdZIs2Q-1; Thu, 14 Apr 2022 23:44:28 -0400
X-MC-Unique: k0oF2vWGOMOOw0YCdZIs2Q-1
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; d="scan'208";a="302157095"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO
 NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
 by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 11:43:23 +0800
Received: from BN0PR04MB8048.namprd04.prod.outlook.com (2603:10b6:408:15f::17)
 by DM6PR04MB3962.namprd04.prod.outlook.com (2603:10b6:5:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 03:43:21 +0000
Received: from BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::911:bf3e:1ac3:df22]) by BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::911:bf3e:1ac3:df22%9]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 03:43:21 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [dm-devel] [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
Thread-Index: AQHYT9p5h91e/KJ/UkicsYxGr2oaZ6zvmfeAgAAFBgCAAHgpAIAAPwmA
Date: Fri, 15 Apr 2022 03:43:20 +0000
Message-ID: <20220415034319.kttr7bmqqtskf6x7@shindev>
References: <20220414083436.pweunapygdtuzwaf@shindev>
 <YlhL878nAVPkNK1n@redhat.com> <YlhQKj0iLM8mT+WK@redhat.com>
 <335390c8-8ea5-1e77-f5c3-a5d19b274eba@opensource.wdc.com>
In-Reply-To: <335390c8-8ea5-1e77-f5c3-a5d19b274eba@opensource.wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a0dc245-51f7-419c-f7ad-08da1e921629
x-ms-traffictypediagnostic: DM6PR04MB3962:EE_
x-microsoft-antispam-prvs: <DM6PR04MB39625548937BE1E13321CE0FEDEE9@DM6PR04MB3962.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: HNCgBUYFAXqiZbgyYQWYsTqW6SenCcdW40rCGRa629trQUQUWs/2D1U/oi6JUaNRgCUlT1yZjozgtVWVEOBqVUMonMbfRzawsVDFaA/D7jXIFwXp1jxr/NEL+GBmp/g4MXOINVOwQo4y19412IY+4cnrChSHQO8KcQPu2frEH/2z57IN8nfP0rIlljjhjnIU1us2R5NNgWF7NQKaCtqYyT8AsXNeInaBtxk/7AHgJAAAMxudaUXgi5/7swbF5Qgdcm/ixhriC+mvjJ42XFm+m//t1Qg/ml3tyreKPcplRHDGV7Fj7jjizuprWI2zH648FclcM+Prh3b5PfR+cLBMI/zBeINZwwYu343Mwn5fXqAJd1qigZVDRpA4eNmePNqb0wtuwElzMUkot+C7M2IrVnyR+STgwggEFMG12VnTaYQMgumo5j0CI/05CRHsSYbLGnMZ/zhksSd+YT/WVqCPI79oHknIbhFzimo6jN1JFlO6FKzWelQtKBUabO6zuDBl3s9TllYMmHjHIz1TI27kP1fkTO/5B7NkMxyYQm5fO625wj3ObMdnru8W29Hxif0TdSimJrfYaU5/qFK8kSY4YekVFmVSqYuWyfD/C4C01g1UY6+qYCS/bQ0tasyYvDLgjjeE2eHviqLL4I5PJtZTlqm8tBO2rMlEmsN2v+RpHWHftXfQIu1o3l5f1JPGH7MBcKw2xscJFfpfIGiodlC6rOCv0vk46p2FAxwjow/ScKGDEAHVZ9pxkW+0HOciyDxFcdhk4CMLeY4/8fTw5tgFVFzEx1T3ajmBNke7JhsPDKh3fPE+4/gvXQbFc6+VW/jsV6jbKci8O5AADqfiLYixrg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BN0PR04MB8048.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(7916004)(366004)(66446008)(4326008)(122000001)(64756008)(8676002)(6862004)(9686003)(6506007)(82960400001)(54906003)(53546011)(2906002)(26005)(186003)(6486002)(66556008)(1076003)(83380400001)(33716001)(6512007)(91956017)(66946007)(66476007)(76116006)(508600001)(316002)(8936002)(966005)(38100700002)(86362001)(44832011)(5660300002)(38070700005)(71200400001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cBHfE4O3wu7+hRbFu0opSmMsWOT5cl38uNas1fqX+nilOkboha2jj4+FRlko?=
 =?us-ascii?Q?RivB7IPlF+kyE28/fNDWV2jtAl7CjcU89/3Xp8LiMcaKGXlItqLPFmkPsT6D?=
 =?us-ascii?Q?6eYiBF3xqLpVhUG0Dw3FZJd2np/xX3qpyqzgTGYcaDUY1FesS5Uf0n7yRY1G?=
 =?us-ascii?Q?nGB2Egr/iR3lyWtiI51bpoy5+vLZfYAxMrBPLV06e8IhMkG5vNnVUXBoWT2Q?=
 =?us-ascii?Q?8KTzNQwBqoecIir0BCI//ELZm0KL0X3g/wpsSWvxCyJOWVW3xcyXMEHlSdF8?=
 =?us-ascii?Q?u1FrdrkP/ZIDvBeyiWqXesMHFqNRwoANGzxkq4AjbelVK5XGOJtkvPpYwJuz?=
 =?us-ascii?Q?Cf760OWb8YWOLZEyI7YVIoGSeCoV+pAE/nXDmVf3k+IFCvjZrRHSJCtT/yCe?=
 =?us-ascii?Q?kaHaMlv3Zhh2RlP5PIqDTsk0PlKu8rJFkKrQV7K19GBeXJmzASDMiNL+obKq?=
 =?us-ascii?Q?OIzdCwwovcUbJS+OJzyjgtje8+TN92RoDElWXXJgIYYMbLPdfcs8xGeEMZkM?=
 =?us-ascii?Q?uGGkQmKaz9kIMeBou0SxUKEIuvk+N3jxmCT/SHTZ8Ru1ckkYlrAT9joL9RMY?=
 =?us-ascii?Q?POvl5OuDJfMOzE+jkOvxejnqIadGYDs5Hw0Fjqy8pkdShwYZTZJfOyUYuif7?=
 =?us-ascii?Q?S4GepIZbn2YYTMVkCdEQVcTwtgzqBarLIYqXaKkQ3VZiwLdOubKrY0FX+Ipq?=
 =?us-ascii?Q?AW0IWmXhPnxc/HVT3/MKZdJzj0f+WBvHbWOpIBJe7WEDOxsofncbZ0Zpw+v1?=
 =?us-ascii?Q?r9W6snfJPEo319N23b/VvvWQc3iz21GFDk6CXUurvCyRLfezMjykO/51MvXc?=
 =?us-ascii?Q?BhT0x6D7wjnvJasWgNNgOh852+HhCP3cx/MsuwY/40NC77xu8xbao5YN/4o7?=
 =?us-ascii?Q?8uYlYEC6E4s0NO+gJKwUns3tPobdGS3xSQ2aU72U4uajALcckOzfxn1gHkvZ?=
 =?us-ascii?Q?8Lize7kO6vVWAdZ8WmlfFjfB5rJU2XrHFLxD8towfRz+7SE3PLoELUdKunw+?=
 =?us-ascii?Q?ezyv9AUsEsDLXx7SO57UPwUPNLauZxTlJm3hL2GBIFGzoNXa9u6R742I2OcO?=
 =?us-ascii?Q?/DCNu5aLfs6tXX+PMGff7L5ZamwIzFahYQGqojNgsSErZtN8edjcsoduVyQQ?=
 =?us-ascii?Q?M4FTQ/iTT2JpNww3N9db7/eg4EG6nZFdGBrhtkd/IuS2DXQW6a/uoerkRbIL?=
 =?us-ascii?Q?RBHj4h5f4pGy5a1CqAsPMe0ecCBwRoE1m7uVJyS1f2zvp8t5Cloalp+NMMqY?=
 =?us-ascii?Q?bJxzUJjwmHncYqCh4TsCprHil/YoTQ1u6k/wfJqZrVwIvEpUF6dIa20JzIZP?=
 =?us-ascii?Q?d5Foc2MiItyjnAhGdQJxA9fPIX+XmjW6lMEIjzxDIq3JB5wIVoqbDXxIXhYO?=
 =?us-ascii?Q?no1GXp/XKFxRNQ8CWJ3NiPghVz2eJan10LJ+d/qVuwUuZzfdB64QRTmOnBjC?=
 =?us-ascii?Q?jfjQ2fZZy7ukcJgLfuUsSjTHE5xK13EBNJ9Q7XCiBySeYWBQ99SfkiTBYgAB?=
 =?us-ascii?Q?xsXRDNxmow10RjFX09RZF+pdHzzKHWdl84ZfLNMYFrVpIQRHrbsx3v+sQ/qO?=
 =?us-ascii?Q?ZO6fAoozzyS3mWQpajdnpWCdh+opGwyW/K6B99torACDrCm8Vo9E6nf2JUAm?=
 =?us-ascii?Q?sYudHdjTZkkxMmJ03l5sdRulQSMIqKH1EEZWRohwaGLxpCttoKQIcrDRXFdH?=
 =?us-ascii?Q?zw57bJGyLegqXSAoDADDDiZOQUv1M3ldatgE+3lOvPC4540busbe7NhBCtjY?=
 =?us-ascii?Q?YVY23cFj/7bGrKv9YLBxMh15TAWhb4fUmdrLOfiVv0NiXMJE5GAx?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR04MB8048.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0dc245-51f7-419c-f7ad-08da1e921629
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:43:21.0366 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZiAG1M96k3CLR78hR6d1v4puf1oNvdaKptkXMjRBvsJ0O5yY+5v0JxLaqysvZ+HUPqIYzIu7RCYSHXEpqLnFt+r0kYqepvQQZAVHiAatwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3962
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5192ED84026BEB4EAF0F73E5694E67B0@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Apr 15, 2022 / 08:57, Damien Le Moal wrote:
> On 4/15/22 01:47, Mike Snitzer wrote:
> > On Thu, Apr 14 2022 at 12:29P -0400,
> > Mike Snitzer <snitzer@kernel.org> wrote:
> >  
> >> Thanks for the report, I've staged a fix here (btw, your change above
> >> needs to be paired with the 2nd hunk of my fix otherwise you won't get
> >> the bio split you desire):
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=3dfb6f5e95f26215ca08d348ca2ddb5ea6ea2349

Thank you Mike. Yes, I confirmed that the 2nd hunk is required for split.

> >>
> >> I'll be sending this to Linus later today or tomorrow.
> > 
> > FYI, I revised that commit with further cleanup to not pass
> > 'unsigned *len' to alloc_multiple_bios(), this commit is what will be
> > sent upstream soon:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=c2228f993c7592783b0a2bf7d169b17dfa4cbe2a
> 
> Looks good to me.
> 
> Nit: there is a typo in the commit message:
> 
> dm_accept_paertial_bio() -> dm_accept_partial_bio()
> 
> Feel free to add:
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Another nit in the commit message is "abormal". I think you meant "abnormal".

I tested this revised patch and confrimed it fixes the issue. Good. Thanks.

Tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

-- 
Best Regards,
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

