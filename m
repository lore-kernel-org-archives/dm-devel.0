Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646F3C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 11 May 2022 08:11:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-coikcxgvOQGCnc56gb9UbA-1; Wed, 11 May 2022 04:11:29 -0400
X-MC-Unique: coikcxgvOQGCnc56gb9UbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C04B3804068;
	Wed, 11 May 2022 08:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80FEF40CF8E8;
	Wed, 11 May 2022 08:11:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D0FEE193F6F4;
	Wed, 11 May 2022 08:11:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5D92194704C
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 May 2022 07:00:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C28C4145BA7B; Tue, 10 May 2022 07:00:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEAB6145BA4B
 for <dm-devel@redhat.com>; Tue, 10 May 2022 07:00:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A71A98015BA
 for <dm-devel@redhat.com>; Tue, 10 May 2022 07:00:02 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-IgdyuoFgNQ6bNk6V-M61zg-1; Tue, 10 May 2022 03:00:00 -0400
X-MC-Unique: IgdyuoFgNQ6bNk6V-M61zg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6B60D1FA14;
 Tue, 10 May 2022 06:59:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 496AB13AA5;
 Tue, 10 May 2022 06:59:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id qU7jD28NemK5aQAAMHmgww
 (envelope-from <mliska@suse.cz>); Tue, 10 May 2022 06:59:59 +0000
Message-ID: <038dee02-deb8-b848-6a82-718b3f484b61@suse.cz>
Date: Tue, 10 May 2022 08:59:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Benjamin Marzinski <bmarzins@redhat.com>, mwilck@suse.com
References: <20220509152127.7257-1-mwilck@suse.com>
 <20220509211552.GA5254@octiron.msp.redhat.com>
From: =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
In-Reply-To: <20220509211552.GA5254@octiron.msp.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 11 May 2022 08:11:20 +0000
Subject: Re: [dm-devel] [PATCH] multipath-tools: Makefile.inc: add test for
 -D_FORTIFY_SOURCE=3
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/9/22 23:15, Benjamin Marzinski wrote:
> On Mon, May 09, 2022 at 05:21:27PM +0200, mwilck@suse.com wrote:
>> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Martin Liska <mliska@suse.cz>

> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
>>
>> 6186645 ("Fix possibility to redefine -D_FORTIFY_SOURCE macro.")
>> does not work as-is, because OPTFLAGS can't be used to override CPPFLAGS.
>> Instead, add a test for support of -D_FORTIFY_SOURCE=3, and use it
>> automatically if supported. The test uses similar logic as e.g.
>> https://sourceware.org/git/?p=elfutils.git;a=commit;h=29859f2e79ef3c650ee9712cae990c6a7f787a7d
>>
>> This test works in environments with glibc 2.33 or newer. On older distributions,
>> -D_FORTIFY_SOURCE=3 does not cause an error, and will thus be used. In this
>> case, it has the same effect as -D_FORTIFY_SOURCE=2. On alpine Linux (musl
>> libc), -D_FORTIFY_SOURCE=3 generates an error.
>>
>> Fixes: 6186645 ("Fix possibility to redefine -D_FORTIFY_SOURCE macro.")
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> ---
>>  Makefile.inc | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile.inc b/Makefile.inc
>> index cef7a06..b915c06 100644
>> --- a/Makefile.inc
>> +++ b/Makefile.inc
>> @@ -117,6 +117,20 @@ TEST_CC_OPTION = $(shell \
>>  		echo "$(2)"; \
>>  	fi)
>>  
>> +# "make" on some distros will fail on explicit '#' or '\#' in the program text below
>> +__HASH__ := \#
>> +# Check if _DFORTIFY_SOURCE=3 is supported.
>> +# On some distros (e.g. Debian Buster) it will be falsely reported as supported
>> +# but it doesn't seem to make a difference wrt the compilation result.
>> +FORTIFY_OPT := $(shell \
>> +	if /bin/echo -e '$(__HASH__)include <string.h>\nint main(void) { return 0; }' | \
>> +		$(CC) -o /dev/null -c -O2 -Werror -D_FORTIFY_SOURCE=3 -xc - 2>/dev/null; \
>> +	then \
>> +		echo "-D_FORTIFY_SOURCE=3"; \
>> +	else \
>> +		echo "-D_FORTIFY_SOURCE=2"; \
>> +	fi)
>> +
>>  STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
>>  ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)
>>  WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)
>> @@ -126,7 +140,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
>>  WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
>>  		  -Werror=implicit-function-declaration -Werror=format-security \
>>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
>> -CPPFLAGS	:= -D_FORTIFY_SOURCE=2
>> +CPPFLAGS	:= $(FORTIFY_OPT)
>>  CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
>>  		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" -DRUN_DIR=\"${RUN}\" \
>>  		   -DCONFIG_DIR=\"$(configdir)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
>> -- 
>> 2.36.0
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

