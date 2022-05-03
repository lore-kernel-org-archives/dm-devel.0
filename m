Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40302C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 07:13:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-Iu0IJmURM8ie4WMbVx5Yqw-1; Tue, 03 May 2022 03:13:43 -0400
X-MC-Unique: Iu0IJmURM8ie4WMbVx5Yqw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CC521014A61;
	Tue,  3 May 2022 07:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A891463E06;
	Tue,  3 May 2022 07:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 26B3E1947042;
	Tue,  3 May 2022 07:13:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98BC71947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 07:13:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79052C28102; Tue,  3 May 2022 07:13:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7488AC28100
 for <dm-devel@redhat.com>; Tue,  3 May 2022 07:13:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A7373C0FEA5
 for <dm-devel@redhat.com>; Tue,  3 May 2022 07:13:40 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-IiHAtuIGPRK0Hy3vpR1hsQ-1; Tue, 03 May 2022 03:13:39 -0400
X-MC-Unique: IiHAtuIGPRK0Hy3vpR1hsQ-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2059.outbound.protection.outlook.com [104.47.5.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-35--a6iY9NBNTW7Khpz5qldTw-1; Tue, 03 May 2022 09:13:35 +0200
X-MC-Unique: -a6iY9NBNTW7Khpz5qldTw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB8PR04MB6923.eurprd04.prod.outlook.com (2603:10a6:10:114::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 07:13:34 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::21aa:a826:f438:827f]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::21aa:a826:f438:827f%7]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 07:13:34 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] update HPE MSA builtin config
Thread-Index: AQHYXBXF8ZWLcvy5HUadA+386xOhQK0Mwm4A
Date: Tue, 3 May 2022 07:13:34 +0000
Message-ID: <fcfea2e0a4aabf0c35f15a6aab831a71d5c23bf4.camel@suse.com>
References: <1651270144-29953-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1651270144-29953-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75a71239-50e5-4fc7-aabd-08da2cd46fde
x-ms-traffictypediagnostic: DB8PR04MB6923:EE_
x-microsoft-antispam-prvs: <DB8PR04MB69236ACB97C6DF1C7A71ED2CFCC09@DB8PR04MB6923.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1k3POFEmWwZbCBu27Vy9G3B6hpKZ0jmEyeTwFndKTzltTBZ15ZIWynoIMD572XpcDxE8jFV048vIjCS245B0PS9NIuUbu3oBvpGrjg4zK0iW3uA1kyF7ZWJAdItF4G4WjV6CILS+J5cS5PNb6UqYZJMoNk9oWRDQV5oNa9Ma/9Xf+UJYZqRoojexVgJddnu5JTCmrcQdsLA78nHBTGydLIJDYgOfCPTskzUIpOGmyslcaHnWo9rIbkVw4NOTiBPUioWkpxTYgoMSwYO8Y/SSJ7mGxkdvVqGUncT+7tV4rKcnWMh77XLbvyeAhtD2AzYeYjh4TXHrwE3Kbgq6xpzFFOxFCXjuHMYc4DEeC5gVEtvCrAmR+07P37vRD2lHxogbZA8rzsjgScx75AOb59mMSCEGAqXNflfXi0+WaPR9oBAoaMH/zSVxWFarChedXtEX+bWclyGSKzlmrkXEGNF7XQNTZcz7IEqQ6qgZQ3zrpTvRzkyr970pwHXka4efKDXF23MBWvlOphUhcPyzCc3hyAn0fez+wQgjNWsHyXpzTf2pmmnYLVCOoGZsQqh7OZLoGzOLyb5uCkL0jjCdsREa/RH+hNaoMD0OGbsmAWSkOR51vKiVj9QboNL0GGjsr/V47OHK3KVrcO2wPZVT8GCHBhitixp2SzKK7XNRupYoSbCYtmF0xRBAE9KlsKIxopBbTxhigztkAzyncJ8WJSddeg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(4326008)(86362001)(66556008)(76116006)(8676002)(66446008)(64756008)(66946007)(66476007)(186003)(2616005)(71200400001)(2906002)(5660300002)(6486002)(508600001)(558084003)(6506007)(316002)(8936002)(38100700002)(110136005)(54906003)(122000001)(38070700005)(6512007)(26005)(36756003)(91956017)(44832011);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?zoMI2C+ouFGR20Ztz+YZHJFbjDflvNraBdhF3otQDWwZ34ySSYSOTPGDO?=
 =?iso-8859-15?Q?U/+1KyJS/5lSl6Vv2lMonuN3/IH0hZfJwyQ/QpopOGazjBBrtGZp1kZEW?=
 =?iso-8859-15?Q?j5hX1hM2iaeAGQbNZEpjmuRxMX+d79Jj0tn+DxxPpvzQNbPenisdD2o5r?=
 =?iso-8859-15?Q?4ukbkY1OIDvKiRNkmg0wpYQmiRkB+fIZCke9VEEDlQvKqBF+O7k+4gql9?=
 =?iso-8859-15?Q?5XH05kIdxyr0BpkuAg4/ee2ZOMc64uH9t6W8GylGRpSKLB+YczLQm2J84?=
 =?iso-8859-15?Q?OBxrjDaj4iNkro4g0YQYmifE6bvxU6FzXx4hT/6wZNtejeDk2D3cpNGwh?=
 =?iso-8859-15?Q?yp81/Om/UP1iInmqJ1i3E4UDv7MO3ez4fg/Ly2rZNpcscLLNa2oCLBb37?=
 =?iso-8859-15?Q?uzmWXPCpIIPvCOPBOYyf9R9y/VJCxI4vx4zMNecaRyOjXCQAYUcIkGCBc?=
 =?iso-8859-15?Q?XKqb+B07TuZt9TPkj7Vx/z2onLezVL7GDVrAzUWMGlPFGLMY8pEXFdWvB?=
 =?iso-8859-15?Q?Ud2IeJl9iqyDSMgqN1+YRdjLqbxfgZscPwxOD3X5045QsH1PRM1miMZZF?=
 =?iso-8859-15?Q?o56daHNkz1FnoMNFW0Rm0FnITjwBEnb+n+RwPTI8P/eFaKtutoQuM9PU/?=
 =?iso-8859-15?Q?V9oy5fefJUOiDoui6Dnil9yu54LQ6xlQysyC8AkQwXbFPiP4gwKLjnoaL?=
 =?iso-8859-15?Q?fVl2kqQBE5WFmzK9RKl4eZzYFCQD3QQRld4zKjHDs7dDKsABx+I8vCSi9?=
 =?iso-8859-15?Q?p87s3RfLQq43edhSx338ds5rmMos0CQNdy90I38qLJ2byRJIuoi17Yjvi?=
 =?iso-8859-15?Q?sGh9deQ15v/54UG+pkxaTNQ8Mwpw1iXqy8kjO70zuL8bc6BKkSNLM9ViJ?=
 =?iso-8859-15?Q?ysLdp8wCADxVNBj6ekCsmAe/Gly/g1QhI2wD/JK2qiyV481asj6H3LE+x?=
 =?iso-8859-15?Q?K0EEZezTKFIgStQolm5/FQ9gZKGvJmh2eMUBDKClmGWAdEY9DJm9dKJar?=
 =?iso-8859-15?Q?TMZx4Uf3HTi8Mth5KsGgqHRulCncoLFqWkr5LGDk+1i45SIMta/zhbalv?=
 =?iso-8859-15?Q?SbiN80Yk55V52s/hP99McTfNSBhJ/5JNYNR5ult29EZpGlA1ExXSp0X5E?=
 =?iso-8859-15?Q?2GwGGJIh8z8O2BCX1UQTeNaUsm9I9eyeBGW5U/URnedcTbSWhINiDWv9M?=
 =?iso-8859-15?Q?evABkUUW7kRBvM98xgSANUSTh/7v4Ms9/bpvlxmvqBpZozepGNRxLywlY?=
 =?iso-8859-15?Q?8IOhUneqIOCCT/ZbZIJ+mdarKeeaJQv4FSJUdf+OhJg97x6myGzHoux2S?=
 =?iso-8859-15?Q?OrPsPT62hg5GI8a6aEyL+ZCXMCR+saaW3Dv+ogmsuh/D7AwE97j5LeSNw?=
 =?iso-8859-15?Q?/Ddc9dvVZnRAAGQeto6kWTLEx2dlNzifXZN1E06zr575dUM2ufqKAp0j6?=
 =?iso-8859-15?Q?wegoRlRkJzPfB3emIk/d/d7UoaZnKkLpb2rHaSX5Dwy0FZCzSrt9uQ9uB?=
 =?iso-8859-15?Q?z/iKdol7yKwH5QjmO7PKgZ496eNAR6/dukQvsVPD15EMjIFZtiQKk7GKZ?=
 =?iso-8859-15?Q?u0bXvQjCLC8jKuRq1ePUw+eyf6JFeCE/s88fxHN+3h6ogMOiC0zd9wqh0?=
 =?iso-8859-15?Q?UJzKlfaElJpvf1Gpgr+4DLlJIftA9fWOCQD/UY6oomVG2L8axjkxOkj1P?=
 =?iso-8859-15?Q?c9w5x8znwimjIJHKyBaMXsVJ2q0jj/dBXPIMeGkn5PdL+2VXQyuHA0ADo?=
 =?iso-8859-15?Q?urq3+hCKZ4oen9q/rA2AZ1bYKH6jHlrQ9QchNafHTFXV1W2elOhA4u+n6?=
 =?iso-8859-15?Q?SnkAtj7+wNtEZe11ks3L6sNc8EM+3ZfRRzojx7hEecbczEk4CtpHlveRY?=
 =?iso-8859-15?Q?FCK4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a71239-50e5-4fc7-aabd-08da2cd46fde
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 07:13:34.7274 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6tad2JYc19yuedE+pgMsNiYnFKlfEqLZ0MAQRai89FKl9jBiqo33x6rbMw07b2RojkKwi8LD+2CqqylNC05hIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6923
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] update HPE MSA builtin config
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
 "Jon.Paul@hpe.com" <Jon.Paul@hpe.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E37C5B7F7F4D3A439350A841793B92C7@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2022-04-29 at 17:09 -0500, Benjamin Marzinski wrote:
> Make the config better align to MSA 4th, 5th and 6th Generation
> systems.
> 
> Suggested-by: Jon Paul <Jon.Paul@hpe.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

