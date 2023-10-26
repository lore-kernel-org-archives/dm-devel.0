Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CEDC132
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 05:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1ybmVNYU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5oYeTObL"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B46D21AF7;
	Thu, 26 Oct 2023 05:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1698298387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PeMtymVsOhoPc4IVdhUDQxUCVZZ3tjxt09GVnvchwvg=;
	b=1ybmVNYU34El0Of93Z2zImOCn4IfVy5n9bAkraFdCJW0B7EzxKkNvvTjEsMMbju3bZRkka
	5FXItpasW9QubS4VHhWKN09OHie1pHb87dyGha05JOWKDHmXFpEkmE6fHN6SDhCzEnBNiM
	+a1NidSXtY7hFog+JhUZ+ANed4pmxcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1698298387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PeMtymVsOhoPc4IVdhUDQxUCVZZ3tjxt09GVnvchwvg=;
	b=5oYeTObL8GfYU2NBEsfJfP85OWZ1cLLDflgU+7C0RtUOeeruXYPEeDDxs0iUqPcsajktvu
	cP/4IC1iT9BX5yDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC7F813927;
	Thu, 26 Oct 2023 05:33:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 8EiQNhL6OWUHRAAAMHmgww
	(envelope-from <hare@suse.de>); Thu, 26 Oct 2023 05:33:06 +0000
Message-ID: <ae0bad75-8d3b-40d7-be4c-91fb4f4cd46f@suse.de>
Date: Thu, 26 Oct 2023 07:33:06 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] libmultipath: directio: don't reset ct->running after
 io_cancel()
Content-Language: en-US
To: Benjamin Marzinski <bmarzins@redhat.com>, mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
 Li Xiao Keng <lixiaokeng@huawei.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-3-mwilck@suse.com>
 <ZTmhT0FSHv8rLzBv@bmarzins-01.fast.rdu2.eng.redhat.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ZTmhT0FSHv8rLzBv@bmarzins-01.fast.rdu2.eng.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -7.04
X-Spamd-Result: default: False [-7.04 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.95)[99.79%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[6];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On 10/26/23 01:14, Benjamin Marzinski wrote:
> On Tue, Oct 24, 2023 at 06:49:33PM +0200, mwilck@suse.com wrote:
>> From: Martin Wilck <mwilck@suse.com>
>>
>> io_cancel() never succeeds, and even if it did, io_getevents() must
>> still be called to reclaim the IO resources from the kernel.
>> Don't pretend the opposite by resetting ct->running, or freeing the
>> memory, before io_getevents() has indicated that the request is finished.
>>
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> ---
>>   libmultipath/checkers/directio.c | 13 ++-----------
>>   tests/directio.c                 | 10 +---------
>>   2 files changed, 3 insertions(+), 20 deletions(-)
>>
>> diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
>> index 25b2383..71ce4cb 100644
>> --- a/libmultipath/checkers/directio.c
>> +++ b/libmultipath/checkers/directio.c
>> @@ -216,7 +216,6 @@ out:
>>   void libcheck_free (struct checker * c)
>>   {
>>   	struct directio_context * ct = (struct directio_context *)c->context;
>> -	struct io_event event;
>>   	long flags;
>>   
>>   	if (!ct)
>> @@ -232,9 +231,7 @@ void libcheck_free (struct checker * c)
>>   		}
>>   	}
>>   
>> -	if (ct->running &&
>> -	    (ct->req->state != PATH_PENDING ||
>> -	     io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event) == 0))
> 
> Does io_cancel() do nothing? If does make the IO likely to end sooner,
> even if it always returns failure, then we should probably still run it
> when we have an outstanding request that we are going to orphan. We
> should just move the io_cancel() to the else block, where we add the
> request to the orphans list.
> 
Well, it doesn't to _nothing_, but what matters is that it doesn't 
actually affect the running I/O. It just cancels the element in the 
libaio infrastructure, not the I/O itself.

So Martin is perfectly right here.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

