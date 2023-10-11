Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A9ECD6E7B
	for <dm-devel@archiver.kernel.org>; Wed, 11 Oct 2023 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697034953;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZEvTgeCDFdMGw6A50WhOWqTriE0SWmBO1lf8rorHcy8=;
	b=ZdPaDqQGg6ZUOD27/0gLagDM+TGZuBsmPRBbCbPSxhoVA1x2d7gGW2fYtqDGC9ebS9rQUL
	G38EZ5YA28MC3DK+hxl+pHy9/Ppc79qhqP4Tqj+gdwuuZUyu4fLF83m7EOHfUDqtYCApJd
	Tb9CwNJA77Fxqft1xMJpD90EUJyBU84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-GDqlW05dPDOMKPGkkI7Y4w-1; Wed, 11 Oct 2023 10:35:51 -0400
X-MC-Unique: GDqlW05dPDOMKPGkkI7Y4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 573FB803499;
	Wed, 11 Oct 2023 14:35:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F664111CD23;
	Wed, 11 Oct 2023 14:35:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 072AD1946594;
	Wed, 11 Oct 2023 14:35:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4FBD91946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 14:35:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 28FE01C060B0; Wed, 11 Oct 2023 14:35:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21D9A1C060AE
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 14:35:49 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE713858F1C
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 14:35:48 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-Yo56ojyXMLeITwoTrMxvEQ-1; Wed, 11 Oct 2023 10:35:47 -0400
X-MC-Unique: Yo56ojyXMLeITwoTrMxvEQ-1
Received: by mail-qk1-f199.google.com with SMTP id
 af79cd13be357-774105f6fb1so783766985a.3
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 07:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1697034946; x=1697639746;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=suZXtWbw9LqCFo9bsOvlZKKzvc10pN0XIH30lhxmVtc=;
 b=azuoiaW6Y3JWXTsCJHvmDiKZFdlVAd0LEW2lNMDWdMxXAQQKQm69tDp5rkfdCMKo4y
 okcNUrchVWppGkk8LxcPdmVmE3IWePOuzR8g0eyPBLzgTqtmpqNv94haRwZwiGtflQ0Y
 UrVRrVe/ExiStfno8ObWqTEKyqPxBlq45UmaIgErR6MlF8WSWvyejCmvydyvMi8CP2gW
 3n2rWrHRSRRYD49W3ml80mqpVeJk96D8bC+n/sM8tFDniT/1L5GOiwVNtr2fI+gJdfr5
 H8qBGCm6jbNk/Qydvar8xbYuWN6y80cF8eUMdi2DNUZ2+sxSLSOeIvTb8qgnDcBfpmJj
 pVzQ==
X-Gm-Message-State: AOJu0YxFDpdpzqr+4K7hSnlm4fcNUq5MDT4E1IxRwcbRYUMu4Rwyv1Or
 /i55FhjUV66uo3G0hYd9ndYfMRpKn0jMMOOCey/kFZsEPgBZ4RxC6nESSHQ32UPRa8V/525ZbNf
 QPCPhHo6ul2pAvCrySNitNI1Oa6CvTZtw4QfrzUmecSZoFAkIE1IEcMM5xqJYUzRTNGWqPsdbgQ
 ==
X-Received: by 2002:a05:620a:2add:b0:775:c0e4:aea4 with SMTP id
 bn29-20020a05620a2add00b00775c0e4aea4mr21787706qkb.66.1697034946279; 
 Wed, 11 Oct 2023 07:35:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQOYIkU+KVuceQArkUCfrQ5BDZ/ee7/VEJy6prTPNi66WB2kjTbeApii+SCFwFEGVDig+8GQ==
X-Received: by 2002:a05:620a:2add:b0:775:c0e4:aea4 with SMTP id
 bn29-20020a05620a2add00b00775c0e4aea4mr21787682qkb.66.1697034945773; 
 Wed, 11 Oct 2023 07:35:45 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 m19-20020ae9e013000000b00767dcf6f4adsm5229797qkk.51.2023.10.11.07.35.45
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Oct 2023 07:35:45 -0700 (PDT)
Date: Wed, 11 Oct 2023 10:35:44 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Subject: Re: dm-devel has migrated to lists.linux.dev
Message-ID: <ZSaywDd8r9VacOB4@redhat.com>
References: <ZSCYSO8wlg4keAmY@redhat.com>
 <ZSCbqvX0f9LOXByf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZSCbqvX0f9LOXByf@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 06 2023 at  7:43P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Oct 06 2023 at  7:29P -0400,
> Mike Snitzer <snitzer@kernel.org> wrote:
> 
> > Hi,
> > 
> > As a dm-devel@redhat.com subscriber, you have been silently subscribed
> > to the new mailing list: dm-devel@lists.linux.dev.
> > 
> > Effective immediately, all dm-devel email should be addressed to:
> > dm-devel@lists.linux.dev
> > 
> > (I say this but my "git pull" request that I just sent to Linus, to
> > update the MAINTAINERS file accordingly, cc'd dm-devel@redhat.com --
> > dm-devel@redhat.com will still function as it has, but nobody should
> > use it moving forward).
> > 
> > If you do send email to dm-devel@redhat.com you will get this
> > auto-response: 
> > 
> >   As of 2023.10.06: dm-devel@redhat.com has migrated to
> >   dm-devel@lists.linux.dev
> > 
> >   If you were a dm-devel@redhat.com subscriber you have been silently
> >   subscribed to dm-devel@lists.linux.dev
> > 
> >   NOTE: If you were a dm-devel@redhat.com subscriber but you disabled
> >   mail delivery: then you must subscribe to dm-devel@lists.linux.dev.
> >   To do so please send email to: dm-devel+subscribe@lists.linux.dev
> > 
> >   To unsubscribe from dm-devel@lists.linux.dev please send email to:
> >   dm-devel+unsubscribe@lists.linux.dev
> 
> 
> Additional useful info:
> 
> Please be sure to update any dm-devel mail filter you may have to look
> for this in mail headers:
> List-Id: <dm-devel.lists.linux.dev>
> 
> Also, we will be backfilling "[dm-devel]" prefix for all list messages.

We cannot backfill the "[dm-devel]" prefix because that practice
breaks DKIM/DMARC.

Also, FYI: mail delivery has been disabled for all subscribers to
dm-devel@redhat.com, but the new list is subscribed and will relay any
mail sent to dm-devel@redhat.com to dm-devel@lists.linux.dev
(I've purposely sent this mail to dm-devel@redhat.com to test this
relay)

If/when you send mail to dm-devel@redhat.com you will still get an
autoresponse directing you to send future mail to
dm-devel@lists.linux.dev

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

