Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DE7C19F2D
	for <dm-devel@archiver.kernel.org>; Sat,  6 Aug 2022 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659809852;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MIt6nRBds8PuSOgIstg0fL/xFfhVOmJWk0aMpSPOQWo=;
	b=WvnkCg7C8qSgWDanyR+elAtVn6EiCc9eZet1Pg8UKwpNnu6S7V8GMnabozGS7ucRlJQcwl
	/Fr2TJhLfRPayId8a8DGMkTxHFc9p1da8nYLze8pI3BxOlj+/FnKXzsdo7VE6CawUQrAVg
	cTW6BTWT84zt6ZoStd2KbF+4mJ2rZ60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-mKEYY083PECCV4kEUwx9ng-1; Sat, 06 Aug 2022 14:17:29 -0400
X-MC-Unique: mKEYY083PECCV4kEUwx9ng-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 131A285A581;
	Sat,  6 Aug 2022 18:17:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E6DB5492C3B;
	Sat,  6 Aug 2022 18:17:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF1A01946A4B;
	Sat,  6 Aug 2022 18:17:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE3C71946A4F
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 Aug 2022 18:17:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF55D4010E37; Sat,  6 Aug 2022 18:17:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAFFE404E4D3
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:17:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B4E72805E02
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:17:21 +0000 (UTC)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
 [209.85.208.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-GgPPWqTkOS-9pKDphkEoBQ-1; Sat, 06 Aug 2022 14:17:11 -0400
X-MC-Unique: GgPPWqTkOS-9pKDphkEoBQ-1
Received: by mail-ed1-f49.google.com with SMTP id e13so6878170edj.12
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=beih6qymZGmHssTmn8x7/qNw7kafqzxWG12k8T6XYyQ=;
 b=ISEfxiaPVFdFFWyTXtci0Qf7KwGvCpq22exUAmoiOMa0wDkL6O8Sop/d4v6kfqw75s
 8VBvzjYjxE0PZg3zgKXlT9JRXuruI4AXlVfSSTY307mBD+omPrJ7i3jwK0mlRxJdt9ZD
 FcCIybeq8NBaESHlDgGGGUUstP6ABdfdZxTXGf7IOcLNjocALyisMkxvc53wlh92rIFr
 7cpcu949DRuXVyrY/IWSNMdGBdHHa9Pc1DmRgx/knhxnsZ8FZ9ydRT2hjhaNwBr4PxRL
 VmTaoS9F+JVr8iwTHTAvzsJExP+39KohCiLJw1Y6kkPmlDKZco6xybCOCMMPwgXlNlvT
 Mkng==
X-Gm-Message-State: ACgBeo0SRN9Ewu2lSJojWIdf68nShqgf2mOMxLpo/5RdukrPkYRn4Tzg
 YqC48Pe7Hgjjzps5pVW+sU1CmoZ/NN55ozAN
X-Google-Smtp-Source: AA6agR58FrD/ZtNUkBY7tHIhXWbVn6NzVDHnDFMj7CJkP7wxZ8fmM5ZlHz/BMCthnJdfCLbNyzyZSQ==
X-Received: by 2002:a05:6402:48d:b0:43a:cccd:89d9 with SMTP id
 k13-20020a056402048d00b0043acccd89d9mr11725937edv.257.1659809829896; 
 Sat, 06 Aug 2022 11:17:09 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com.
 [209.85.221.45]) by smtp.gmail.com with ESMTPSA id
 e23-20020a170906315700b0072a881b21d8sm2904944eje.119.2022.08.06.11.17.08
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 06 Aug 2022 11:17:09 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id z16so6461946wrh.12
 for <dm-devel@redhat.com>; Sat, 06 Aug 2022 11:17:08 -0700 (PDT)
X-Received: by 2002:a05:6000:178d:b0:222:c7ad:2d9a with SMTP id
 e13-20020a056000178d00b00222c7ad2d9amr122329wrg.274.1659809828435; Sat, 06
 Aug 2022 11:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
 <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
In-Reply-To: <CAHk-=wj5w+Nga81wGmO6aYtcLrn6c_R_-gQrtnKwjzOZczko=A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Aug 2022 11:16:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjoweVdRqvaVESkJGbj4Xmsw4NMQQRPpy5Om2X4QRwQ8A@mail.gmail.com>
Message-ID: <CAHk-=wjoweVdRqvaVESkJGbj4Xmsw4NMQQRPpy5Om2X4QRwQ8A@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [git pull] Additional device mapper changes for 6.0
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
Cc: Eric Biggers <ebiggers@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Aug 6, 2022 at 11:09 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Feature bitmasks work. Version numbers don't. Version numbers
> fundamentally break when something is backported or any other
> non-linearity happens.

Side note: even feature bitmaps should be discouraged as an interface,
unless there's some fundamental need for actually negotiating some
kind of initial state.

For 99% of all kernel cases, the better option is to simply just rely
on unsupported features erroring out (ie making sure unsupported
argument flags are checked and cause errors, rather than silently
ignored).

So while version numbers are actively broken as an interface
description, often feature bitmask are just pointless and wrong too.

And yes, lots of things get this wrong, and have "I implement feature
Xyz", and then you have pain and gnashing of teeth when versions
change and you have to support them all. It's just a horrible design
pattern.

                  Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

