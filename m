Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D504C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 16 Jan 2022 10:29:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-cpSDVwXKNWWXeNwQE1DSfg-1; Sun, 16 Jan 2022 05:29:31 -0500
X-MC-Unique: cpSDVwXKNWWXeNwQE1DSfg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BF5B18460E5;
	Sun, 16 Jan 2022 10:29:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE5E21F463;
	Sun, 16 Jan 2022 10:29:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 566651809CB8;
	Sun, 16 Jan 2022 10:29:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20GATNjK008590 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 16 Jan 2022 05:29:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D17BE40D2969; Sun, 16 Jan 2022 10:29:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCA1D40D1B9F
	for <dm-devel@redhat.com>; Sun, 16 Jan 2022 10:29:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 355CF28F2065
	for <dm-devel@redhat.com>; Sun, 16 Jan 2022 10:29:23 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-164-ihXif7CFOrCuBCcE0tD0_g-1; Sun, 16 Jan 2022 05:29:21 -0500
X-MC-Unique: ihXif7CFOrCuBCcE0tD0_g-1
Received: from MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23)
	by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10;
	Sun, 16 Jan 2022 10:29:18 +0000
Received: from MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d]) by
	MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d%8]) with mapi id 15.20.4888.013;
	Sun, 16 Jan 2022 10:29:18 +0000
Message-ID: <59064c38-05bb-4282-5caa-49c1ea4b8d73@nvidia.com>
Date: Sun, 16 Jan 2022 12:29:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	dm-devel <dm-devel@redhat.com>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<1642097341-6521-2-git-send-email-israelr@nvidia.com>
	<b45d3b40-2587-04dc-9601-a9251dacf806@opensource.wdc.com>
From: Israel Rukshin <israelr@nvidia.com>
In-Reply-To: <b45d3b40-2587-04dc-9601-a9251dacf806@opensource.wdc.com>
X-ClientProxiedBy: FR3P281CA0074.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:1f::12) To MW3PR12MB4409.namprd12.prod.outlook.com
	(2603:10b6:303:2d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8899706c-0316-4979-fd6f-08d9d8db0d1a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4326:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB432670C89446E7EBDB10405DDA569@CH2PR12MB4326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: PrXBEOQWan5iMSioAq6XrUWGhdIcX0cscWPTKPV6PsMi+oYufYuLUbaoqyfuH/sJ+JVmPTN0mt4vSwoIKuCPAKCcMKEkEwqLty95uH0JGa2NOXzfR2lHmlXB2v8uJqiJGLy8uSxp3TRMK3jiqqGvKrbFfLHEpPrBNdMO6QxI7Qt99lKuuvKUvYmVIfRv9tTEY1UTycOHZZZT8aIwN/EmiQ2b7Hw98at1uajq/hz+4StO/j4PgKFwFRycyqBiS0uxRCO49iGSg9y2MdOl723gq5SWokvTsZUQXcTi5WsZwYSpjDDXXk6zE3bQcHmpsyUFo7FC70dJU8j2QF9auPHsONv6BdrmRHwa4fgCtpRM7MjWaBytXZQSmIuN9hetXth8koPLCPxPBbssl/mK5HBMRWI8qubJCMGA0zH9KnHJuHgWwjett69V2+5LmBO3phnrdgZ9x3s/Qm/Fkf6tu2uMlHW/lDNL3Jd73UiWljDzOptThkiyf4Zbl2bHleAewGK6X8PItcUO7JpKUr29D9wGekbsPIGoUQH3k/d1wFOwjmrwGZcNlt6aeVhCGjjH4SLDCPJ3KB9001YGyGT1wOgYVTlhMlMXFL+hOLLgrzIrOr6yHIFYfp2Mne6Hwtj7/xBxqq0BRVNzVpRgT4tAHVGDVmKmivMNsTLgHOBTFTPSWcl6+qM2FRkqauT3pyNBh6OOI0RG3/5c4jpAol1WA/N8bhmoH+cXm7nu/lekVUcRs4m3Lyt8/+xsve4+4cox+rCImDa8eDtafQiSzkevRvMIqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW3PR12MB4409.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(38350700002)(55236004)(26005)(30864003)(8936002)(6486002)(31696002)(5660300002)(36756003)(53546011)(6506007)(31686004)(38100700002)(6512007)(316002)(2906002)(186003)(66556008)(4326008)(54906003)(83380400001)(8676002)(508600001)(110136005)(86362001)(66946007)(2616005)(52116002)(66476007)(6666004)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2QzZktzaWlUQlc5Z0Q4L0owN1dlYnQ3aUFIeTNVSHJEUWlxZjQ5Z1NhbDRs?=
	=?utf-8?B?SWYzZDltOUFXR1BoSnAzUmhjdXZoQWpVOE5NeFd5NFR2WnY3NEp5RGlxc28w?=
	=?utf-8?B?eDlVakI3M09Bc21lbi9NWkV4dEE0U0ZEWU9hYlpZMEY5OFFJUG5XSHM5VTA5?=
	=?utf-8?B?T0xJSk10cjhKZlVCMnVBWUNySFFvZXNPMFFRZEJtV24ycnBQc2pQV1NaVzJQ?=
	=?utf-8?B?T2FOMTM4dFVHNXVSamV2T1VFK1NUZFBDTVlxVEhWSzlWdjg4NUxhNWdpRnRD?=
	=?utf-8?B?bEtSek1qWm15TXR1OERwOWY1YmN1MXZCVTZJTnVKOG1NZjU0UVZSRWd6ZzlC?=
	=?utf-8?B?TnBRN013ek5jU3BnZzJuR013bEtWK1JDR3MrN3ZaalJXVFZzMmNsSGtYMmdK?=
	=?utf-8?B?SGhaMVM1b3ZNbUg0S2o0VjY0OGpWUDN2U1JYM0tiREpsYkFQVmFZOWViQUJE?=
	=?utf-8?B?dFJFNkltRFJ0c0JJTEdwMXpFYkxIVUVha0xQUG9PWGVxdk9UTU5MbXNSTWdh?=
	=?utf-8?B?Mmt5V0F2RFEwOUZLK084V1RFaG8xTkRTTlRjTHFITTk3TGdsV3ZoUDd4bUkw?=
	=?utf-8?B?YUgwNEZjaGt5MGh3M1dZWWR2ZHI5WDZBczhIdjhMNFB1ZDZLTExwNnNjNHNq?=
	=?utf-8?B?bGxVOElSdEd6UFZTekd4WWhPaXhUNVd6VDRyeUYyZ2hTaVFoUjdvczRWVUdv?=
	=?utf-8?B?NWMyVWFFVkNKMTBzM0pYc2hnQVhsY2FFczJJdzNrN08yQ3hLa2tyS0tCWXlQ?=
	=?utf-8?B?NU5JSTZ3Sk03ZkkwZUdISlNEaVNVNnVLZitKMEtWVzBid1R6UnFyTXFmeWha?=
	=?utf-8?B?ckNrS0hzdjZOeC9KRnA5NHdoRWlnVUFwKzZqT0tFUXNhTzZVbXFtR0doTm5S?=
	=?utf-8?B?YU5vWU1OMDdZbDVsNExoYTNnWWtxQldyYTlDaWpPR1BsNk9pRWNSMSt3N3hV?=
	=?utf-8?B?cEdMY2UrODRvRnR4WmpqQXN1YzdVR1RCN2E2UWwxYXJCOU1ROENHZFZaaTc0?=
	=?utf-8?B?MVdVM09Zd0Q1T2Q5bmpDZTBwTTdXT0dNWlAzNit0elhVckh3a29xRkVmVDI3?=
	=?utf-8?B?TEhTMm11bDF3YWlFWG1abHRwcUhlNk56YUFFKzE0cFh0RU1WU0ZxNDRRUSs3?=
	=?utf-8?B?U2tuZVNadkdNOVdiZUhSWUpGN2wrSXUxQXNGaVpRbkgyNFQzVXZWa1N6dHJP?=
	=?utf-8?B?cjFhTlhLNUU0ang3YWRaREVjSWMyUElLZkE4UW55MC9VaS9jSVRaQnV4SlF6?=
	=?utf-8?B?WHBNbkIvdW9rQ1VGVmNqbkhZMC9NQnFjR2IyN2lrcGlXOTc4RnRHRXJaSzhW?=
	=?utf-8?B?NlZucEpyeDdIdlVFb0ZUQzNyaUNmNXk4eEYwNXQ2Slo1ZGFlaFBvVms3MVBl?=
	=?utf-8?B?c0k5OUl2ZW5wUGx1WHZKTFJycWJXU1lvK1VTWG1rb0NDZkZWNUtDRnRTSFE5?=
	=?utf-8?B?Z2tMT0k4cVFHanYzV2ZXcVd5UTB5NlE0QVg1NGJvYzlialBwcGF2S3YyTWJT?=
	=?utf-8?B?L09MZzQ0Rk5YZ3BJUHBFYzc5eGZhTElrb0ZYY3UzYTNONW56SktVOWFXMEwy?=
	=?utf-8?B?bVRqdU84UFhMNnovR1FaUDZiNVBJeFpUdHkzYmMrRUZNbFNpbEFSa1hLa2ZQ?=
	=?utf-8?B?SVlKcllxd3I1WndFaldXMDA2aWhISGUyZmViOWtMbDR1eE9HQXNOejYrcE9u?=
	=?utf-8?B?QnhlZ1NxditZVHlkMEhuaEhvU2wvb0ZMNzVvd3FTK0ZWMVNKc2JTL056Y3lo?=
	=?utf-8?B?bVhQVktYYnRMQXI1TTd1MUFzZEVzYU9aajFlWkxGWkkzeUIyL1lyUEtqVWlm?=
	=?utf-8?B?MDkrMGVyVTFwSWJjbWtWdDJzS3VmWG54VzIvNjlRbk45WXp2b01kb09SR3Nq?=
	=?utf-8?B?MFJRUEx5VTd2UktwcWM5SDk1U0JsUjl3Yis0WVhKYzB6MGFMVytXem1idnZE?=
	=?utf-8?B?UHp2bTU0dVBzNkJ2RUxGRHRnM3hjT0ZWY1pIR05XMEFLaXZtQmpFSDREK0F2?=
	=?utf-8?B?aUNXbXh0MVlidGpKYUQyUjliUEJsY2RsY2RKci9wZk1SOXpEanlRU3Zyc3Fh?=
	=?utf-8?B?UGpTcmFWdTFLdFNTMlVlZTFyMzViV2lVaDRNM0V2aWpwbVE2QUZ4Nk11cVE4?=
	=?utf-8?B?NEVCOEJmckN5dUlTeVkwV3JhNDJxMjFMWGJSV2R1L1ZEWGVpZE5qVjFSME9E?=
	=?utf-8?Q?UxK6pnHEe46Nsa9afzLirC8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8899706c-0316-4979-fd6f-08d9d8db0d1a
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4409.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2022 10:29:18.0052 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2Bi3KJGuy+VRWQnUSaf2Kn+Phky0vxO/CbkkKbRmlsSGqkH5WP2/Qe3u7rK/59wUKnnIgxPz24wgbiItFm9GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>,
	Nitzan Carmi <nitzanc@nvidia.com>
Subject: Re: [dm-devel] [PATCH 1/1] dm crypt: Add inline encryption support
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Damien,

On 1/14/2022 10:14 AM, Damien Le Moal wrote:
> On 2022/01/14 4:11, Israel Rukshin wrote:
>> Using inline encryption means that the block layer handles the
>> decryption/encryption as part of the bio, instead of dm-crypt
>> doing the crypto by itself via Linux's crypto API. This model
>> is needed to take advantage of the inline encryption hardware
>> on the market.
>>
>> To use inline encryption, the new dm-crypt optional parameter
>> "inline_crypt" should be set for the configured mapping. Afterwards,
>> dm-crypt will provide the crypto parameters to the block layer by
>> creating a cypto profile and by filling the bios with crypto context.
>> In case the block device or the fallback algorithm doesn't support
>> this feature, the mapping will fail.
>>
>> Signed-off-by: Israel Rukshin <israelr@nvidia.com>
>> ---
>>   block/blk-crypto.c    |   3 +
>>   drivers/md/dm-crypt.c | 202 ++++++++++++++++++++++++++++++++++++------
>>   2 files changed, 180 insertions(+), 25 deletions(-)
>>
>> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
>> index 1c08d3b6e24a..65f13549eb5f 100644
>> --- a/block/blk-crypto.c
>> +++ b/block/blk-crypto.c
>> @@ -102,6 +102,7 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
>>   
>>   	bio->bi_crypt_context = bc;
>>   }
>> +EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
>>   
>>   void __bio_crypt_free_ctx(struct bio *bio)
>>   {
>> @@ -370,6 +371,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
>>   
>>   	return 0;
>>   }
>> +EXPORT_SYMBOL_GPL(blk_crypto_init_key);
>>   
>>   /*
>>    * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
>> @@ -411,6 +413,7 @@ int blk_crypto_start_using_key(const struct blk_crypto_key *key,
>>   	}
>>   	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
>>   }
>> +EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
>>   
>>   /**
>>    * blk_crypto_evict_key() - Evict a key from any inline encryption hardware
> These changes could probably go into a separate prep patch.
>
>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index d4ae31558826..4c0e1904942b 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -39,6 +39,7 @@
>>   #include <keys/user-type.h>
>>   #include <keys/encrypted-type.h>
>>   #include <keys/trusted-type.h>
>> +#include <linux/blk-crypto.h>
>>   
>>   #include <linux/device-mapper.h>
>>   
>> @@ -134,7 +135,7 @@ struct iv_elephant_private {
>>   enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
>>   	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
>>   	     DM_CRYPT_NO_READ_WORKQUEUE, DM_CRYPT_NO_WRITE_WORKQUEUE,
>> -	     DM_CRYPT_WRITE_INLINE };
>> +	     DM_CRYPT_WRITE_INLINE, DM_CRYPT_INLINE_ENCRYPTION };
>>   
>>   enum cipher_flags {
>>   	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
>> @@ -220,6 +221,11 @@ struct crypt_config {
>>   	struct bio_set bs;
>>   	struct mutex bio_alloc_lock;
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	enum blk_crypto_mode_num crypto_mode;
>> +	enum blk_crypto_key_type key_type;
>> +	struct blk_crypto_key *blk_key;
>> +#endif
>>   	u8 *authenc_key; /* space for keys in authenc() format (if used) */
>>   	u8 key[];
>>   };
>> @@ -2383,11 +2389,103 @@ static void crypt_copy_authenckey(char *p, const void *key,
>>   	memcpy(p, key, enckeylen);
>>   }
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +static int crypt_select_inline_crypt_mode(struct dm_target *ti, char *cipher,
>> +					  char *ivmode)
>> +{
>> +	struct crypt_config *cc = ti->private;
>> +
>> +	if (strcmp(cipher, "xts(aes)") == 0) {
>> +		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
>> +		cc->key_type = BLK_CRYPTO_KEY_TYPE_STANDARD;
>> +	} else if (strcmp(cipher, "xts(paes)") == 0) {
>> +		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
>> +		cc->key_type = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
>> +	} else {
>> +		ti->error = "Invalid cipher for inline_crypt";
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (ivmode == NULL || (strcmp(ivmode, "plain64") == 0)) {
>> +		cc->iv_size = 8;
>> +	} else {
>> +		ti->error = "Invalid IV mode for inline_crypt";
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int crypt_prepare_inline_crypt_key(struct crypt_config *cc)
>> +{
>> +	int ret;
>> +
>> +	cc->blk_key = kzalloc(sizeof(*cc->blk_key), GFP_KERNEL);
>> +	if (!cc->blk_key)
>> +		return -ENOMEM;
>> +
>> +	ret = blk_crypto_init_key(cc->blk_key, cc->key, cc->key_size,
>> +				  cc->key_type, cc->crypto_mode, cc->iv_size,
>> +				  cc->sector_size);
>> +	if (ret) {
>> +		DMERR("Failed to init inline encryption key");
>> +		goto bad_key;
>> +	}
>> +
>> +	ret = blk_crypto_start_using_key(cc->blk_key,
>> +					 bdev_get_queue(cc->dev->bdev));
>> +	if (ret) {
>> +		DMERR("Failed to use inline encryption key");
>> +		goto bad_key;
>> +	}
>> +
>> +	return 0;
>> +bad_key:
>> +	kfree_sensitive(cc->blk_key);
>> +	cc->blk_key = NULL;
>> +	return ret;
>> +}
>> +
>> +static void crypt_destroy_inline_crypt_key(struct crypt_config *cc)
>> +{
>> +	if (cc->blk_key) {
>> +		blk_crypto_evict_key(bdev_get_queue(cc->dev->bdev),
>> +				     cc->blk_key);
>> +		kfree_sensitive(cc->blk_key);
>> +		cc->blk_key = NULL;
>> +	}
>> +}
>> +
>> +static void crypt_inline_encrypt_submit(struct dm_target *ti, struct bio *bio)
>> +{
>> +	struct crypt_config *cc = ti->private;
>> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
>> +
>> +	bio_set_dev(bio, cc->dev->bdev);
>> +	if (bio_sectors(bio)) {
>> +		memset(dun, 0, BLK_CRYPTO_MAX_IV_SIZE);
>> +		bio->bi_iter.bi_sector = cc->start +
>> +			dm_target_offset(ti, bio->bi_iter.bi_sector);
>> +		dun[0] = le64_to_cpu(bio->bi_iter.bi_sector + cc->iv_offset);
>> +		bio_crypt_set_ctx(bio, cc->blk_key, dun, GFP_KERNEL);
>> +	}
>> +
>> +	submit_bio_noacct(bio);
>> +}
> #else
>
> define the above functions as empty (see below).
Good idea.
>
>> +#endif
>> +
>>   static int crypt_setkey(struct crypt_config *cc)
>>   {
>>   	unsigned subkey_size;
>>   	int err = 0, i, r;
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
>> +		crypt_destroy_inline_crypt_key(cc);
>> +		return crypt_prepare_inline_crypt_key(cc);
>> +	}
>> +#endif
> You could avoid the ifdef here using IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION)
> directly in the if condition. That will make the code cleaner. That said, since
> DM_CRYPT_INLINE_ENCRYPTION can only be set if CONFIG_BLK_INLINE_ENCRYPTION is
> enabled, I am not sure if the ifdef buys you much in the
> !CONFIG_BLK_INLINE_ENCRYPTION case.
>
>> +
>>   	/* Ignore extra keys (which are used for IV etc) */
>>   	subkey_size = crypt_subkey_size(cc);
>>   
>> @@ -2648,6 +2746,15 @@ static int crypt_wipe_key(struct crypt_config *cc)
>>   
>>   	kfree_sensitive(cc->key_string);
>>   	cc->key_string = NULL;
>> +
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
>> +		crypt_destroy_inline_crypt_key(cc);
>> +		memset(&cc->key, 0, cc->key_size * sizeof(u8));
>> +		return 0;
>> +	}
>> +#endif
> same comment as above and for most of the following ifdef additions.
>
>> +
>>   	r = crypt_setkey(cc);
>>   	memset(&cc->key, 0, cc->key_size * sizeof(u8));
>>   
>> @@ -2713,6 +2820,10 @@ static void crypt_dtr(struct dm_target *ti)
>>   	if (cc->crypt_queue)
>>   		destroy_workqueue(cc->crypt_queue);
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	crypt_destroy_inline_crypt_key(cc);
>> +#endif
> You can avoid the ifdef here if this function is defined as empty in the
> !CONFIG_BLK_INLINE_ENCRYPTION case (see above the comment about #else).
>
>> +
>>   	crypt_free_tfms(cc);
>>   
>>   	bioset_exit(&cc->bs);
>> @@ -2888,6 +2999,11 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
>>   	/* The rest is crypto API spec */
>>   	cipher_api = tmp;
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
>> +		return crypt_select_inline_crypt_mode(ti, cipher_api, *ivmode);
>> +#endif
>> +
>>   	/* Alloc AEAD, can be used only in new format. */
>>   	if (crypt_integrity_aead(cc)) {
>>   		ret = crypt_ctr_auth_cipher(cc, cipher_api);
>> @@ -3001,6 +3117,11 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
>>   		goto bad_mem;
>>   	}
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
>> +		return crypt_select_inline_crypt_mode(ti, cipher_api, *ivmode);
>> +#endif
>> +
>>   	/* Allocate cipher */
>>   	ret = crypt_alloc_tfms(cc, cipher_api);
>>   	if (ret < 0) {
>> @@ -3036,9 +3157,11 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
>>   		return ret;
>>   
>>   	/* Initialize IV */
>> -	ret = crypt_ctr_ivmode(ti, ivmode);
>> -	if (ret < 0)
>> -		return ret;
>> +	if (!test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
>> +		ret = crypt_ctr_ivmode(ti, ivmode);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>>   
>>   	/* Initialize and set key */
>>   	ret = crypt_set_key(cc, key);
>> @@ -3111,6 +3234,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>>   			set_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
>>   		else if (!strcasecmp(opt_string, "no_write_workqueue"))
>>   			set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +		else if (!strcasecmp(opt_string, "inline_crypt"))
>> +			set_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags);
>> +#endif
> May be add a warning here for the !CONFIG_BLK_INLINE_ENCRYPTION case ?

There is a general warring in case of an option doesn't match:

ti->error = "Invalid feature arguments";

>
>>   		else if (sscanf(opt_string, "integrity:%u:", &val) == 1) {
>>   			if (val == 0 || val > MAX_TAG_SIZE) {
>>   				ti->error = "Invalid integrity arguments";
>> @@ -3218,10 +3345,36 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>   			goto bad;
>>   	}
>>   
>> +	ret = -EINVAL;
>> +	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
>> +	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
>> +		ti->error = "Invalid iv_offset sector";
>> +		goto bad;
>> +	}
>> +	cc->iv_offset = tmpll;
>> +
>> +	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
>> +			    &cc->dev);
>> +	if (ret) {
>> +		ti->error = "Device lookup failed";
>> +		goto bad;
>> +	}
>> +
>> +	ret = -EINVAL;
>> +	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
>> +	    tmpll != (sector_t)tmpll) {
>> +		ti->error = "Invalid device sector";
>> +		goto bad;
>> +	}
>> +	cc->start = tmpll;
>> +
>>   	ret = crypt_ctr_cipher(ti, argv[0], argv[1]);
>>   	if (ret < 0)
>>   		goto bad;
>>   
>> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
>> +		return 0;
>> +
>>   	if (crypt_integrity_aead(cc)) {
>>   		cc->dmreq_start = sizeof(struct aead_request);
>>   		cc->dmreq_start += crypto_aead_reqsize(any_tfm_aead(cc));
>> @@ -3277,27 +3430,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>   
>>   	mutex_init(&cc->bio_alloc_lock);
>>   
>> -	ret = -EINVAL;
>> -	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
>> -	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
>> -		ti->error = "Invalid iv_offset sector";
>> -		goto bad;
>> -	}
>> -	cc->iv_offset = tmpll;
>> -
>> -	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev);
>> -	if (ret) {
>> -		ti->error = "Device lookup failed";
>> -		goto bad;
>> -	}
>> -
>> -	ret = -EINVAL;
>> -	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 || tmpll != (sector_t)tmpll) {
>> -		ti->error = "Invalid device sector";
>> -		goto bad;
>> -	}
>> -	cc->start = tmpll;
>> -
>>   	if (bdev_is_zoned(cc->dev->bdev)) {
>>   		/*
>>   		 * For zoned block devices, we need to preserve the issuer write
>> @@ -3419,6 +3551,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>>   	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
>>   		return DM_MAPIO_KILL;
>>   
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
>> +		crypt_inline_encrypt_submit(ti, bio);
>> +		return DM_MAPIO_SUBMITTED;
>> +	}
>> +#endif
>> +
>>   	io = dm_per_bio_data(bio, cc->per_bio_data_size);
>>   	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
>>   
>> @@ -3481,6 +3620,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>>   		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
>>   		num_feature_args += test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
>>   		num_feature_args += test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +		num_feature_args +=
>> +			test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags);
>> +#endif
> You do not think that you need the ifdef here. If CONFIG_BLK_INLINE_ENCRYPTION
> is not enabled, then DM_CRYPT_INLINE_ENCRYPTION is never set.
>
>>   		num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
>>   		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
>>   		if (cc->on_disk_tag_size)
>> @@ -3497,6 +3640,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>>   				DMEMIT(" no_read_workqueue");
>>   			if (test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
>>   				DMEMIT(" no_write_workqueue");
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +			if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
>> +				DMEMIT(" inline_crypt");
>> +#endif
> ditto.
>
>>   			if (cc->on_disk_tag_size)
>>   				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);
>>   			if (cc->sector_size != (1 << SECTOR_SHIFT))
>> @@ -3516,6 +3663,11 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>>   		       'y' : 'n');
>>   		DMEMIT(",no_write_workqueue=%c", test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags) ?
>>   		       'y' : 'n');
>> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
>> +		DMEMIT(",inline_crypt=%c",
>> +		       test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags) ?
>> +		       'y' : 'n');
>> +#endif
> You do not think that you need the ifdef here. If CONFIG_BLK_INLINE_ENCRYPTION
> is not enabled, then inline_crypt=n will always be reported, which is fine I think.
>
>>   		DMEMIT(",iv_large_sectors=%c", test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags) ?
>>   		       'y' : 'n');
>>   

Thanks for the review,

Israel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

