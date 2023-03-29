Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9A0DC6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680111884;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iIVq+h09dx2VZiimMvkPM4TbNRF1aLUXR6sz3FqM0qU=;
	b=Ra5fPRCY6AbF2Lu6VPrs/sF6umQRXraRVzQoB01yLpNabwHkdU5DewaHb+ay6Ia4lkPzT1
	+dhV4e9D7eKL+fzGbZhb/WSJJ+aE1PKd1Txk9+lFwIXT1066HQSI95rGpFKl1HmbDRsZ6r
	hrmm6ZzBk9Cmbshr0fBJycKRchjnesI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-PQx5ZafdPFG-VKinaAE7dQ-1; Wed, 29 Mar 2023 13:44:41 -0400
X-MC-Unique: PQx5ZafdPFG-VKinaAE7dQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7F34802D32;
	Wed, 29 Mar 2023 17:44:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 570AA40BC798;
	Wed, 29 Mar 2023 17:44:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1877C1946588;
	Wed, 29 Mar 2023 17:44:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 515901946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 17:42:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 190E514171BE; Wed, 29 Mar 2023 17:42:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1147814171BB
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:42:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E908A185A7A2
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:42:31 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-uTyzan3PNHWbe-3JLlHrgA-1; Wed, 29 Mar 2023 13:42:30 -0400
X-MC-Unique: uTyzan3PNHWbe-3JLlHrgA-1
Received: by mail-wm1-f52.google.com with SMTP id
 q7-20020a05600c46c700b003ef6e809574so6948536wmo.4
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 10:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680111748;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=5uvenYggsdgWLPmG+QeJ50DimdtmxwZ2Ee6m2Qn7gyA=;
 b=l/bcnnPM10mH88SMGpmdLoMPo4AE1liiJWTSlNfQbwjXI061kt2gcQXPe0QvTeVk0z
 gKTC8HBZyQLjkUF4AtjDGCtDs/yAQz5nN6kkErekMnScyp6T6lmWz2/9h7GtG3I9yA7k
 MDsAUyGHBfpfiH0h2Pw+LRPPT2TrnqXw3Je3EnrGSrSopzdJ2i2/8V5fkGCRlCCI808f
 i4OZ/1RuNT5Wn71D+zelbUfjTBpjvF0frHsfCK8rMtrUuZ3wr+akF/oKQ58iiQyCyjZA
 QKpuyguXxCmIKDw3VHzd3WVBbUHQu1MuVWg/Gj27v+QPNg8BZ7HkLdvSP0AEzt50RJjX
 9EnA==
X-Gm-Message-State: AO0yUKW1hWe1t0r86t+z8oi9VDgNu3dzfaGbbYSwvpoWlKrJYl9xvZe7
 UmNVEd+11dJGYgrHYUD2a5PZ7w==
X-Google-Smtp-Source: AK7set8U2m8jxGBYC+koRV0xgkued9spplMAETyRbpw1f3ElGcD9WPU0LFbzg8AUk2q8cW1CSjeHMA==
X-Received: by 2002:a7b:cc95:0:b0:3ee:775:c573 with SMTP id
 p21-20020a7bcc95000000b003ee0775c573mr14193573wma.20.1680111748719; 
 Wed, 29 Mar 2023 10:42:28 -0700 (PDT)
Received: from [172.16.10.51] (188.4.154.192.dsl.dyn.forthnet.gr.
 [188.4.154.192]) by smtp.gmail.com with ESMTPSA id
 z20-20020a7bc7d4000000b003eeb1d6a470sm2972720wmk.13.2023.03.29.10.42.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Mar 2023 10:42:28 -0700 (PDT)
Message-ID: <09c87d98-7111-a968-7c61-c898b4d9dc5b@arrikto.com>
Date: Wed, 29 Mar 2023 20:42:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Mike Snitzer <snitzer@kernel.org>, Gwendal Grignou <gwendal@chromium.org>
References: <CAMHSBOXxdtGxQ8MTv4Tz+fcngaOJS5r62Br6VEDJESg2g5jP4w@mail.gmail.com>
 <ZCMTwjEIt6QO1u3o@redhat.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <ZCMTwjEIt6QO1u3o@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] dm-clone: Request option to send discard to source
 device during hydration
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
Cc: Sarthak Kukreti <sarthakkukreti@google.com>, dm-devel@redhat.com,
 ntsironis@gmail.com, Daniil Lunev <dlunev@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: arrikto.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/28/23 19:20, Mike Snitzer wrote:
> On Mon, Mar 27 2023 at  4:24P -0400,
> Gwendal Grignou <gwendal@chromium.org> wrote:
> 
>> On ChromeOS, we are working on migrating file backed loopback devices
>> to thinpool logical volumes using dm-clone on the Chromebook local
>> SSD.
>> Dm-clone hydration workflow is a great fit but the design of dm-clone
>> assumes a read-only source device. Data present in the backing file
>> will be copied to the new logical volume but can be safely deleted
>> only when the hydration process is complete. During migration, some
>> data will be duplicated and usage on the Chromebook SSD will
>> unnecessarily increase.
>> Would it be reasonable to add a discard option when enabling the
>> hydration process to discard data as we go on the source device?
>> 2 implementations are possible:
>> a- add a state to the hydration state machine to ensure a region is
>> discarded before considering another region.
>> b- a simpler implementation where the discard is sent asynchronously
>> at the end of a region copy. It may not complete successfully (in case
>> the device crashes during the hydration for instance), but will vastly
>> reduce the amount of data left  in the source device at the end of the
>> hydration.
>>
>> I prefer b) as it is easier to implement, but a) is cleaner from a
>> usage point of view.
> 
> In general, discards may not complete for any number of reasons. So
> while a) gives you finer-grained potential for space being
> deallocated, b) would likely suffice given that a device crash is
> pretty unlikely (at least I would think).  And in the case of file
> backed loopback devices, independent of dm-clone, you can just issue
> discard(s) to all free space after a crash?
> 
> However you elect to do it, you'd do well to make it an optional
> "discard_rw_src" (or some better name) feature that is configured when
> you load the dm-clone target.
> 

I agree with Mike, but I also want to note the following.

dm-clone commits its on-disk metadata periodically every second, and
every time a FLUSH or FUA bio is written. This is done to improve
performance.

This means the dm-clone device behaves like a physical disk that has a
volatile write cache. If power is lost you may lose some recent writes,
_and_ dm-clone might need to rehydrate some regions.

So, you can't discard a region on the source device after the copy
operation has finished, because then the following scenario will result
in data corruption:

1. dm-clone hydrates a region
2. dm-clone discards the region on the source device, either
    synchronously (a) or asynchronously (b)
3. The system crashes before the metadata is committed
4. The system comes up, and dm-clone rehydrates the region, because it
    thinks it has not been hydrated yet
5. The source device might contain garbage for this region, since we
    discarded it previously
6. You have data corruption

So, you can only discard hydrated regions for which the metadata have
been committed on disk.

I think you could discard hydrated regions on the source device
periodically, right after committing the metadata.

dm-clone keeps track of the regions hydrated during each metadata
transaction, so after committing the metadata for the current
transaction, you could also sent an asynchronous discard for these
regions.

Nikos.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

