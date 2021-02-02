Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE30EC433DB
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:50:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 008E064E93
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 008E064E93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-kAlIv2wkOkWjd3dD5QST5A-1; Wed, 03 Feb 2021 04:50:43 -0500
X-MC-Unique: kAlIv2wkOkWjd3dD5QST5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2459D9CC01;
	Wed,  3 Feb 2021 09:50:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F038B60C66;
	Wed,  3 Feb 2021 09:50:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 56BA94EA31;
	Wed,  3 Feb 2021 09:50:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112IJmcI024459 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 13:19:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D19DCAE7D4; Tue,  2 Feb 2021 18:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C663BB2783
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 18:19:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBD3800B3A
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 18:19:44 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-34-_8o1J0R4MOybqOPR-rPyKQ-1; Tue, 02 Feb 2021 13:19:41 -0500
X-MC-Unique: _8o1J0R4MOybqOPR-rPyKQ-1
Received: from gallifrey.ext.pengutronix.de
	([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
	by metis.ext.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1l70H5-000128-Sk; Tue, 02 Feb 2021 19:19:39 +0100
To: Mike Snitzer <snitzer@redhat.com>
References: <20210122084321.24012-1-a.fatoum@pengutronix.de>
	<20210202181035.GA14886@redhat.com>
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <6bf5f23d-ff89-7e03-a226-d23959f34abb@pengutronix.de>
Date: Tue, 2 Feb 2021 19:19:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202181035.GA14886@redhat.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
	SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 03 Feb 2021 04:50:36 -0500
Cc: Arnd Bergmann <arnd@arndb.de>, Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	kernel@pengutronix.de, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] dm crypt: replaced #if defined with
	IS_ENABLED
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Mike,

On 02.02.21 19:10, Mike Snitzer wrote:
> On Fri, Jan 22 2021 at  3:43am -0500,
> Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> 
>> IS_ENABLED(CONFIG_ENCRYPTED_KEYS) is true whether the option is built-in
>> or a module, so use it instead of #if defined checking for each
>> separately.
>>
>> The other #if was to avoid a static function defined, but unused
>> warning. As we now always build the callsite when the function
>> is defined, we can remove that first #if guard.
>>
>> Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> ---
>> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
>> ---
>>  drivers/md/dm-crypt.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index 8c874710f0bc..7eeb9248eda5 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -2436,7 +2436,6 @@ static int set_key_user(struct crypt_config *cc, struct key *key)
>>  	return 0;
>>  }
>>  
>> -#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
>>  static int set_key_encrypted(struct crypt_config *cc, struct key *key)
>>  {
>>  	const struct encrypted_key_payload *ekp;
>> @@ -2452,7 +2451,6 @@ static int set_key_encrypted(struct crypt_config *cc, struct key *key)
>>  
>>  	return 0;
>>  }
>> -#endif /* CONFIG_ENCRYPTED_KEYS */
>>  
>>  static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
>>  {
>> @@ -2482,11 +2480,10 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
>>  	} else if (!strncmp(key_string, "user:", key_desc - key_string + 1)) {
>>  		type = &key_type_user;
>>  		set_key = set_key_user;
>> -#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
>> -	} else if (!strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
>> +	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
>> +		   !strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
>>  		type = &key_type_encrypted;
>>  		set_key = set_key_encrypted;
>> -#endif
>>  	} else {
>>  		return -EINVAL;
>>  	}
>> -- 
>> 2.30.0
>>
> 
> I could be mistaken but the point of the previous way used to enable
> this code was to not compile the code at all.  How you have it, the
> branch just isn't taken but the compiled code is left to bloat dm-crypt.
> 
> Why not leave this as is and follow same pattern in your next patch?

It's safe to assume the compiler will constant-fold the resulting if (0) away.
The kernel coding style documentation got a section on that:
https://www.kernel.org/doc/html/v5.11-rc6/process/coding-style.html#conditional-compilation

Cheers,
Ahmad

> 
> Mike
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

