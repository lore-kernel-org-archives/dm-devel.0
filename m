Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A73C6FA86
	for <dm-devel@archiver.kernel.org>; Thu,  8 Sep 2022 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662653620;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VShYb/fVR4YX1XzQYwBcaAgiAoHuJtG2INm912kUSX0=;
	b=QKrxCsPPQJBGc8pbdx1VbvEBFhAmSBkTVzVT1YCBbuYIQro4iQKE0cnf1yP1EWsg47Kxa1
	TGqkUrGO2mgqZW3iyhNzK9NtJ/GlerB4P0kwqdrhNUR7L1QWJeothYv36cjsZ2a7U/lq+N
	jFrS7HIFoLlsZpN21lVQgfUIdfUEkX8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-9eYEm8_XNuydnE6GedYVvw-1; Thu, 08 Sep 2022 12:13:39 -0400
X-MC-Unique: 9eYEm8_XNuydnE6GedYVvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F6D338149B1;
	Thu,  8 Sep 2022 16:13:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41B982166B29;
	Thu,  8 Sep 2022 16:13:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F54A1946A44;
	Thu,  8 Sep 2022 16:13:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 364861946A41
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Sep 2022 16:13:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1AD5D403162; Thu,  8 Sep 2022 16:13:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16F17492C3B
 for <dm-devel@redhat.com>; Thu,  8 Sep 2022 16:13:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFFEE294EDDC
 for <dm-devel@redhat.com>; Thu,  8 Sep 2022 16:13:35 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-271-AqBPEXivNW-2lGfv6rocNA-1; Thu, 08 Sep 2022 12:13:34 -0400
X-MC-Unique: AqBPEXivNW-2lGfv6rocNA-1
Received: by mail-pj1-f54.google.com with SMTP id pj10so7842302pjb.2
 for <dm-devel@redhat.com>; Thu, 08 Sep 2022 09:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Ynlv/HlbjINH5vzgYf4TA8R4RfVi30O2jA5crDrStO0=;
 b=XjzSUpJB88/Z3Ibyw18kj9LAyGwpKgSKn5Qnu42EvJll9niczVxxvEMnxjRm05Fvhp
 BiKwfl0SN5oBu8oDOITRCjM/Kqt0nPTqwlDWWNPp3YaV6zai56B2noz91B38i+h1mvKf
 NZop2Jszxi+vWCCPrlbA/wURHfYkLLf9fUwC2LmdrRbgAqhrRfUcpLCO2oyRVeqvE1kv
 TnKH+iUjBeLqoUOqe3bUJkv69tPsExhP4P5tNRRyfCOW7BkaRzOyhVSen5AJNWD0psLx
 GfxWEgxu5TK1kmq0+K3b7E58iU/HJohf4fSZ/vjUYoAD8MbBXNHRkdIkWIFHTU6i9ZVE
 BLxA==
X-Gm-Message-State: ACgBeo0G3oru1embS8XE2qmvd2QAP4qrS7CLOfuB4ElwfpiqgYV5JYO4
 /O6Z7Tc+PH9BfoEKJb3ypYitCw==
X-Google-Smtp-Source: AA6agR4b8HBqas+oT3K9pH3ycWp3TxRR1yMAxYD+7X/J4yLb8tb1538WM7cusSa+UKAv+3mrExLCmQ==
X-Received: by 2002:a17:90b:1bc8:b0:200:43c7:5940 with SMTP id
 oa8-20020a17090b1bc800b0020043c75940mr5071911pjb.46.1662653613370; 
 Thu, 08 Sep 2022 09:13:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 b14-20020a1709027e0e00b0016be596c8afsm14773738plm.282.2022.09.08.09.13.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Sep 2022 09:13:32 -0700 (PDT)
Date: Thu, 8 Sep 2022 09:13:31 -0700
From: Kees Cook <keescook@chromium.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <202209080912.00880AD6@keescook>
References: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
 <166259004596.4128104.7200162640366282166.b4-ty@chromium.org>
 <YxoJcG5MN4OdaulL@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YxoJcG5MN4OdaulL@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] dm: verity-loadpin: Only trust verity targets with
 enforcement
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
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, dianders@chromium.org,
 linux-security-module@vger.kernel.org, mka@chromium.org,
 sarthakkukreti@chromium.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 08, 2022 at 11:25:36AM -0400, Mike Snitzer wrote:
> On Wed, Sep 07 2022 at  6:34P -0400,
> Kees Cook <keescook@chromium.org> wrote:
> 
> > On Wed, 7 Sep 2022 13:30:58 -0700, Matthias Kaehlcke wrote:
> > > Verity targets can be configured to ignore corrupted data blocks.
> > > LoadPin must only trust verity targets that are configured to
> > > perform some kind of enforcement when data corruption is detected,
> > > like returning an error, restarting the system or triggering a
> > > panic.
> > > 
> > > 
> > > [...]
> > 
> > Applied to for-next/hardening, thanks!
> > 
> > [1/1] dm: verity-loadpin: Only trust verity targets with enforcement
> >       https://git.kernel.org/kees/c/2e1875c05267
> 
> Does this mean you're intending to send this upstream?  I prefer to
> take all DM changes unless there is an external dependency.

Oh! Yeah, I added it to my tree since you'd asked me to take the
original verity-loadpin series and this was a fix. I'm happy either
way. Shall I drop this change from my tree?

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

