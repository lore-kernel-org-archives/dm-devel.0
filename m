Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DF8C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 15:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647963516;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gcArC/8uiXLsIpUpHNBQyq3T/BiM1bgmvO1IjER/390=;
	b=BW3HfyIQxCxsdP4Y8nusGW+6l/uVoK+Qqxh/NqD0YvRs9wFp4tnQiJFTZuUr9+oidsYPhm
	aKKemgCFSo6Jad1Hve+Pv+ooQEXEImiR3DX/bgBRqATi+1iaGlTG4gFzWDT7b3Rk6CQ+gF
	toXCbpezOq0aGZmX+q7Hw8Nno6B/80Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-t0Ce8naCPC678jDglMjIOw-1; Tue, 22 Mar 2022 11:38:35 -0400
X-MC-Unique: t0Ce8naCPC678jDglMjIOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 166CF1C01506;
	Tue, 22 Mar 2022 15:38:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95EEF1400E6F;
	Tue, 22 Mar 2022 15:38:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41D861949762;
	Tue, 22 Mar 2022 15:38:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AAF951947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 15:38:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99CDDC23DB1; Tue, 22 Mar 2022 15:38:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 96015C080A2
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:38:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A91F2999B2E
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 15:38:27 +0000 (UTC)
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-kb-ix07kNXCodkpCNkWfqQ-1; Tue, 22 Mar 2022 11:38:25 -0400
X-MC-Unique: kb-ix07kNXCodkpCNkWfqQ-1
Received: by mail-lj1-f197.google.com with SMTP id
 j7-20020a2e3c07000000b00247f8eb86a4so7620729lja.3
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CowhKDvPauf9aD5aqgSLLDd8VV4q7CsZuOiKg3E8/gg=;
 b=mf6GQaxbYRsrL4S3rjoTtosYpSnpwFJnQrqnGkxMiJgOh91E7R5nhaASFrwvwamulZ
 Wqdqc1O9IjxEQc04eflv9AvBUkELxw7ZMFK30/+noVC/+GeuSWHqL8+gbUYGl+LFXDLR
 cyqDotaRysYhmNqJ50rO/JT8m8j4IUY/7+SISK0n2LANYMd97A1cu7Yt7SScR0TnkDM2
 UlAc5KerHUpPQu9Wo94GgLYrsg6Styznx0ImUa130LMcWorwQrnwsWmN0hMkBBY31MTB
 xzmC5P8v85ES2O38BPWDpAxtJG0T2F17LMDi4aSU35DmRdWLnM88pr/l0FyAqMmypodv
 RiqQ==
X-Gm-Message-State: AOAM532faBbqlgeYM5PZWB3ceQUCCZSX2VyCovNXUUz5pIIxJ2Rt6Pob
 FyPgdWvd1rJOB34asIwUsGpXxLEt9zbLPNS+fhCeX8fNb6uD6mhQ0BwRtH6x/uowrM48Bkb6F/V
 Ci5Euw2Q5QSWqhawpITzJQBsHLOOyk3s=
X-Received: by 2002:a05:6512:3f0a:b0:44a:e3f:2862 with SMTP id
 y10-20020a0565123f0a00b0044a0e3f2862mr13891375lfa.397.1647963504143; 
 Tue, 22 Mar 2022 08:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2Msndv/qORxepNbVdk1/2zUqKq4Ie+Lmg2sbe9qHtTDXZqEPjBlFoE8Dy2EMhYmzMTFi2P2uay6tSRIIIBCI=
X-Received: by 2002:a05:6512:3f0a:b0:44a:e3f:2862 with SMTP id
 y10-20020a0565123f0a00b0044a0e3f2862mr13891366lfa.397.1647963503956; Tue, 22
 Mar 2022 08:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-12-mwilck@suse.com>
 <CAPt1nt4Ug=Z0mn1TUzmKevYqm3Uqy-sGXBc9rQRdZUgHFi3i9g@mail.gmail.com>
 <e86df86dc511e0092e15da399e2e713561fb13c9.camel@suse.com>
In-Reply-To: <e86df86dc511e0092e15da399e2e713561fb13c9.camel@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 10:38:13 -0500
Message-ID: <CAPt1nt7-Rws3LnQttR_GZFCb04+G=F9Qcxkk50E7=CVKtfDU1A@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 11/11] multipathd: remove unhelpful
 startup / shutdown messages
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22, 2022 at 4:30 AM Martin Wilck <mwilck@suse.com> wrote:
>
> On Mon, 2022-03-21 at 19:43 -0500, Benjamin Marzinski wrote:
> > On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
> > >
> > > From: Martin Wilck <mwilck@suse.com>
> > >
> > > These messages are noisy in the system log without being actually
> > > helpful.
> >
> > I've actually found the "start up" and "shut down" messages useful a
> > number of times, for tracking when multipathd starts up and shuts
> > down.
>
> Makes sense ;-)
>
> Currently we see the following messages for multipathd startup and
> shutdown:
>
> Mar 11 09:30:00 bremer systemd[1]: Starting Device-Mapper Multipath Device Controller.
> Mar 11 09:30:01 bremer multipathd[363]: --------start up--------
> Mar 11 09:30:01 bremer systemd[1]: Started Device-Mapper Multipath Device Controller.
> Mar 11 09:30:01 bremer multipathd[363]: read /etc/multipath.conf
> Mar 11 09:30:01 bremer multipathd[363]: path checkers start up
> ...
> Mar 11 09:30:52 bremer systemd[1]: Stopping Device-Mapper Multipath Device Controller...
> Mar 11 09:30:52 bremer multipathd[363]: exit (signal)
> Mar 11 09:30:52 bremer multipathd[363]: --------shut down-------
> Mar 11 09:30:52 bremer systemd[1]: Stopped Device-Mapper Multipath Device Controller.
>
> To my taste, this is too much. Of course, not everyone is using
> systemd. Without systemd and with the part of my patch you acked, we'd
> be down from 9 to 3 messages. IMO either the "exit" message or the
> "shut down" message could be hidden at -v2. I suppose we could decrease
> the verbosity level of handle_signals() to -v3 instead. Would you agree
> with that?

Sure.

> > Since people generally run multipathd constantly, they rarely
> > appear more than a couple of times per boot. I would prefer if they
> > could stay.  I'm fine with removing the others.
>
> Ok, fine with me. Do you insist on the "--------", too? It's mainly
> that which bothers me. If you look at the typical boot messages of
> contemporary Linux servers, no other daemon uses this strong emphasis
> for an informational message. The informational value would be higher
> if we printed a detailed version number including HEAD commit ID, like
> other daemons do.

I'm fine with changing what the messages look like, I'd just like
something to stay there.

-Ben

> Martin
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

