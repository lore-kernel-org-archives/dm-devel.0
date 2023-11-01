Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DF9A28
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0zK4vCD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698840297;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tDojNTGdff1a26ZlTMsOFH9r5d/69ydk4cOc8RQ6e3o=;
	b=A0zK4vCDQBRgWbt1C2AI7abNlCDiFy0tAdbwmhXG8wKxqI4IljXo4KAUryfVOQ1WU5NjZ1
	BD9e0xD907Dqw1qSeH6Bap2mc1z9kE+NoQuqClSVxw4ZpWE2oUEOocCwRQEsASMEEfQoP6
	i6YoU/E6b1xy4Zsf7yNsTS0ennz3L0I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-2S_kGoySM5y95WpRdmh3Vw-1; Wed,
 01 Nov 2023 08:04:56 -0400
X-MC-Unique: 2S_kGoySM5y95WpRdmh3Vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 232F03821562
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:04:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AF661121308
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:04:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B635819465A0
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:04:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4360194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Nov 2023 12:04:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6DFA2166B27; Wed,  1 Nov 2023 12:04:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF92D2166B26
 for <dm-devel@redhat.com>; Wed,  1 Nov 2023 12:04:54 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEF5E81B160
 for <dm-devel@redhat.com>; Wed,  1 Nov 2023 12:04:54 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de
 [80.237.130.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-g_D8opSGMraboon0VOzihg-1; Wed, 01 Nov 2023 08:04:50 -0400
X-MC-Unique: g_D8opSGMraboon0VOzihg-1
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
 by wp530.webpack.hosteurope.de running ExIM with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
 id 1qy9xo-0001cN-9r; Wed, 01 Nov 2023 13:04:48 +0100
Message-ID: <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
Date: Wed, 1 Nov 2023 13:04:45 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
To: Yureka <yuka@yuka.dev>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
 <20230929224327.GA11839@google.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <20230929224327.GA11839@google.com>
X-bounce-key: webpack.hosteurope.de; regressions@leemhuis.info; 1698840290;
 662a1ab6
X-HE-SMSGID: 1qy9xo-0001cN-9r
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
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
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: regressions@lists.linux.dev, Boris Brezillon <bbrezillon@kernel.org>,
 Arnaud Ebalard <arno@natisbad.org>, Srujana Challa <schalla@marvell.com>,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: leemhuis.info
Content-Language: en-US, de-DE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

n 30.09.23 00:43, Eric Biggers wrote:
> On Fri, Sep 29, 2023 at 11:08:55PM +0200, Yureka wrote:
>>
>> I am running the NixOS distribution cross-compiled from x86_64 to a Marvell
>> Armada 388 armv7 SoC.
>>
>> I am not getting expected speeds when reading/writing on my encrypted hard
>> drive with 6.5.5, while it is fast on 5.4.257. Volume is formatted like this:
>> `cryptsetup luksFormat -c aes-cbc-essiv:sha256 /dev/sda`.
>>
>> Specifically, I tracked this down to the changes to crypto/essiv.c from
>> 7bcb2c99f8ed mentioned above. Reverting those changes on top of a 6.5.5 kernel
>> provides working (see applicable diff further below).
>>
>> I'm *guessing* that this is related to the mv-aes-cbc crypto driver (from the
>> marvell-cesa module) being registered as async (according to /proc/crypto),
>> and I *suspect* that async drivers are not being used anymore by essiv or
>> dm_crypt. Going by the commit description, which sounds more like a refactor,
>> this does not seem intentional.
> 
> This is actually from commit b8aa7dc5c753 ("crypto: drivers - set the flag
> CRYPTO_ALG_ALLOCATES_MEMORY"), which set CRYPTO_ALG_ALLOCATES_MEMORY in
> marvell-cesa.  7bcb2c99f8ed is just one of the prerequisite commits.
> 
> I understand that the dm-crypt developers did this as an intentional bug fix in
> order to prevent dm-crypt from using crypto drivers that are known to cause
> deadlocks due to allocating memory during requests.
> 
> If you are interested in still being able to use marvell-cesa with dm-crypt, I
> believe it would need to be fixed to meet the requirements for not needing
> CRYPTO_ALG_ALLOCATES_MEMORY.  I've Cc'ed the maintainers of that driver.
> 
> #regzbot introduced: b8aa7dc5c753

BTW: Eric, thx for this.

Boris, Arnaud, Srujana, and Mikulas, could you maybe comment on this? I
understand that this is not some everyday regression due to deadlock
risk, but it nevertheless would be good to get this resolved somehow to
stay in line with our "no regressions" rule.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke

