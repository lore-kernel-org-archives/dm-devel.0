Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EADC7EE2A
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945049;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=R+ipn4TpI4rGcXEpvoNHe1lO2KVyldcfmy2STyEtfdI=;
	b=hl9sKXzjc89Gt5DxNeZVBdc9uuD+P49vNNTMQsGkzMJ5DIk4PFPJcDWBzRVv/zxPUkFWEg
	tnEHFW9y/mqfhEGkLoVVqOtOF4Vg8Ujf3cQeRT0pvp0A82QWI+hynGezuSKdmK43EtmfU+
	z4jesz8ghmfsDl9WYhQoXvkzsOZtiaY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-or5JmgggNDip-EST8WPj3g-1; Mon, 05 Jun 2023 02:04:08 -0400
X-MC-Unique: or5JmgggNDip-EST8WPj3g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7B8A1C07845;
	Mon,  5 Jun 2023 06:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5410349BB98;
	Mon,  5 Jun 2023 06:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A2C719465B7;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C35E01946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 02:35:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42E351121315; Mon,  5 Jun 2023 02:35:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BDFD1121314
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 02:35:49 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FF78101A53A
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 02:35:49 +0000 (UTC)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-ZRIAMm7AOEajoLnFrFi0aQ-1; Sun, 04 Jun 2023 22:35:48 -0400
X-MC-Unique: ZRIAMm7AOEajoLnFrFi0aQ-1
Received: by mail-pl1-f200.google.com with SMTP id
 d9443c01a7336-1b024ab0c28so39717645ad.2
 for <dm-devel@redhat.com>; Sun, 04 Jun 2023 19:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685932547; x=1688524547;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=wbOf9YixGxYUT6+A1F/Xkspb+6fjMJ6LMndsBADdRu0=;
 b=AOfjbTuTEwScq4Frtm+jxB8bK4JxCdEiH/a0o6Ar/HaxBmgMePGwmfOm+cDK/dnT8r
 uvf5jdimyldZFjkECoOinx0Bd//LWPrkAN7fj1oDWfY08139W+/0YsapDWN6LXVLgaUX
 Hza9mTqXispcioKlSf/CGOlF9OGzl1FPVZwe0GYoCYx1DCvrx2phz6fExToP6hF5FHHn
 gnPLS9UyMqK6kuCKwWqPNOCLvcQTTHe6B954FUb3qi03reEJFcGudkmhoTCW85R999GR
 qL/fEnOcJkz0FngQ0e23UEa0/FXHBDEdlnV147hif/OGCNVpq70Axj/zU7UqNw4LaUSv
 sT6A==
X-Gm-Message-State: AC+VfDzIAGNghi1EeKd8rGlo9zwWqtpIQt+MRC0CJmM6fD5O0Jy7w2b7
 0UXENqULKd9anDgRvDrnUkkMJbLOIWipKOvG4TLhmpiKy/j3mGhsQM0rxoa/BVkpx9R6WwRO1LO
 B5wImB1K2MtBbEMY=
X-Received: by 2002:a17:902:c20d:b0:1a9:b0a3:f03a with SMTP id
 13-20020a170902c20d00b001a9b0a3f03amr5828585pll.9.1685932546967; 
 Sun, 04 Jun 2023 19:35:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7RPcaCQNdS4CeYjKEEsiTHolnzKdcAYpiF586LtFjStL6H4T9gcjFxgb0r6IqczKNCCCAZmw==
X-Received: by 2002:a17:902:c20d:b0:1a9:b0a3:f03a with SMTP id
 13-20020a170902c20d00b001a9b0a3f03amr5828575pll.9.1685932546645; 
 Sun, 04 Jun 2023 19:35:46 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 h9-20020a170902748900b001b05e97ee09sm5218208pll.283.2023.06.04.19.35.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 19:35:46 -0700 (PDT)
Date: Mon, 5 Jun 2023 10:31:49 +0800
From: Coiby Xu <coxu@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>, Milan Broz <gmazyland@gmail.com>
Message-ID: <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
 <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH 0/5] Support kdump with LUKS encryption by
 reusing LUKS volume key
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
Cc: Baoquan He <bhe@redhat.com>, Kairui Song <ryncsn@gmail.com>, x86@kernel.org,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 Pingfan Liu <kernelfans@gmail.com>, Dave Hansen <dave.hansen@intel.com>,
 dm-devel@redhat.com, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Eric and Milan,

On Sat, Jun 03, 2023 at 11:22:52AM +0200, Milan Broz wrote:
>On 6/2/23 23:34, Eric Biggers wrote:
>>On Thu, Jun 01, 2023 at 03:24:39PM +0800, Coiby Xu wrote:
>>>[PATCH 0/5] Support kdump with LUKS encryption by reusing LUKS volume key
>>
>>The kernel has no concept of LUKS at all.  It provides dm-crypt, which LUKS
>>happens to use.  But LUKS is a userspace concept.
>>
>>This is a kernel patchset, so why does it make sense for it to be talking about
>>LUKS at all?  Perhaps you mean dm-crypt?
>
>Exactly.

Thanks for raising the above concern! The use cases like CoreOS and
Confidential VMs explicitly want kdump to work for LUKS. And correct me
if I'm wrong, I think the two problems addressed by this patch set only
apply to LUKS so the kdump part of the kernel only cares about the LUKS
case. If there are use cases where similar approach is needed, I'll be
happy to make the solution more generic.

>
>I had the same comment almost a year ago... and it still applies:
>https://lore.kernel.org/all/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
>
> Anyway, please fix the naming before this patchset can be read or reviewed!
>
> LUKS is user-space key management only (on-disk metadata); the kernel has
> no idea how the key is derived or what LUKS is - dm-crypt only knows the key
> (either through keyring or directly in the mapping table).
>
> Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
> is used in many other mappings (plain, bitlocker, veracrypt, ...)
> Just use the dm-crypt key, do not reference LUKS at all.

Thanks for the reminding! That comment was on the first RFC version. But
starting with "RFC v2", there is no longer any interaction with dm-crypt
(to save a copy of the LUKS volume key for the kdump kernel) and now I
make cryptsetup talks to the kdump part of the kernel via the sysfs to
reuse the volume key. So only the kdump part of the kernel needs to know
LUKS which is what it cares. Thus I don't think there is any kernel
namespace pollution now.

>
>Milan
>

-- 
Best regards,
Coiby

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

