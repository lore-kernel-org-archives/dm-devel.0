Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C9BC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658514835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/ZvFAZwIjw4DxmEyLxdzEJUP0pojhfvOeQGPpkwwIVQ=;
	b=e/apb4m56dAH0YXEFyGABgJJEu9I/Chc4yvVGV7werFXATJi34YCjPoE08vH614Dj72OLx
	YQTV0/ZKmRZuctBxXk2uT64MSGIxo3ihFrNonl0rYfliN6OnOXu4+4s85K5oEpoP8hdKg/
	0U/Ntwg5hvZEp/ITnzMF0N2fQ0jtvdg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-vbn6cEdoOSecls3xKn59XQ-1; Fri, 22 Jul 2022 14:33:51 -0400
X-MC-Unique: vbn6cEdoOSecls3xKn59XQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E2242812C3C;
	Fri, 22 Jul 2022 18:33:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B5BD492C3B;
	Fri, 22 Jul 2022 18:33:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F4093194704D;
	Fri, 22 Jul 2022 18:33:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E40BD1947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 18:33:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2E7418EBB; Fri, 22 Jul 2022 18:33:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF56418ECB
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 18:33:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 928022812C22
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 18:33:47 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-Fn-e8cLaPdajjpFpUZAAvA-1; Fri, 22 Jul 2022 14:33:46 -0400
X-MC-Unique: Fn-e8cLaPdajjpFpUZAAvA-1
Received: by mail-qk1-f197.google.com with SMTP id
 v13-20020a05620a0f0d00b006b5f0ec742eso4289066qkl.2
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 11:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cuAxCjPb5JwgxHvfPH5uVtncIHsSNNJ86IoETDkzjWI=;
 b=5WclXATQC2GKzjjoGQySQXvKjn54XuIS9snibfZ/YrdxT9+EQdLRH7xtUhjO+BSQ11
 J40FSmzwoxbE8zDrse+eHNXoELsYpoF/ijQQu1qJ4TImt88Pjk9VYzf81VbbzDW0IPzF
 M6furljSuNnfQu4AipJ7dkNO/Z/1bo9qUIKp7s4GXtNELX0oi5jgLQJUhw6/GVLZcmNB
 ET2E/6SWBPUiH6Mr3R18iX1gjQnzXysJKkhAJiXRhlK8YnmqbbT8hSnlPrV3H7rsTwma
 av6fpA8QC/co2PJ5PF3x+3dn47kHiPRtplSHYOgNqc3h3s92jWMaEfJWkW+jWN84gl6n
 SIiw==
X-Gm-Message-State: AJIora9W/2GO33FUbHwLWi/ynhN86XpWUfiDf0+wy19JY8NfINIo6Gl/
 92mwrycXgkS71xMWPkFJ1pFrJSq/qn+cfAlxPDNnP57/6y7vSpm87+PpFobyCrTbMAuy6ZqJFWL
 faBV9/NTSGj7pCA==
X-Received: by 2002:a05:6214:d66:b0:473:7906:ac4f with SMTP id
 6-20020a0562140d6600b004737906ac4fmr1312623qvs.126.1658514825961; 
 Fri, 22 Jul 2022 11:33:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uwdMklIfR1RPb6muiHD6u2FhgP1jhA5kPEp8IEKapJ297TmS1h5GutOZjOQ2Ki8tYs42IJtg==
X-Received: by 2002:a05:6214:d66:b0:473:7906:ac4f with SMTP id
 6-20020a0562140d6600b004737906ac4fmr1312606qvs.126.1658514825674; 
 Fri, 22 Jul 2022 11:33:45 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 v17-20020a05620a0f1100b006b55036fd3fsm3882891qkl.70.2022.07.22.11.33.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Jul 2022 11:33:45 -0700 (PDT)
Date: Fri, 22 Jul 2022 14:33:44 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <YtrtiP2p8xnRdC3S@redhat.com>
References: <20220722093823.4158756-1-nhuck@google.com>
 <YtrTI/CJMoLihA/1@infradead.org>
 <cabd732a-9942-3ece-8141-c0bc6378faca@acm.org>
MIME-Version: 1.0
In-Reply-To: <cabd732a-9942-3ece-8141-c0bc6378faca@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 0/3] dm-verity: optionally use tasklets in
 dm-verity
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
Cc: Eric Biggers <ebiggers@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Nathan Huckleberry <nhuck@google.com>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 22 2022 at  2:12P -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 7/22/22 09:41, Christoph Hellwig wrote:
> > We've been tying to kill off task lets for about 15 years.  I don't
> > think adding new users will make you a whole lot of friends..
> 
> +1 for not using tasklets. At least in Android the real-time thread
> scheduling latency is important. Tasklets are not visible to the scheduler
> and hence cause latency spikes for real-time threads. These latency spikes
> can be observed by users, e.g. if the real-time thread is involved in audio
> playback.

OK, then android wouldn't set the _optional_ "try_verify_in_tasklet"

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

