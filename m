Return-Path: <SRS0=NHnu=EJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77DEC388F2
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 08:32:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36A0E22264
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 08:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36A0E22264
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-YvvOi7lhOvWt_L0ZeQil5g-1; Tue, 03 Nov 2020 03:32:28 -0500
X-MC-Unique: YvvOi7lhOvWt_L0ZeQil5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3E806D58C;
	Tue,  3 Nov 2020 08:32:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9361455769;
	Tue,  3 Nov 2020 08:32:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07F7444A43;
	Tue,  3 Nov 2020 08:32:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A38WKHG014514 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 03:32:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A42458288B; Tue,  3 Nov 2020 08:32:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E0058362A
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 08:32:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53E49101CC96
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 08:32:18 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by
	relay.mimecast.com with ESMTP id us-mta-449-nh2htb7-OtCLXuz6sG_TCw-1;
	Tue, 03 Nov 2020 03:32:13 -0500
X-MC-Unique: nh2htb7-OtCLXuz6sG_TCw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 33602AD68;
	Tue,  3 Nov 2020 08:32:12 +0000 (UTC)
Message-ID: <5a7e73f60d53d6bfe64421f1920612de79fcce3e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 03 Nov 2020 09:32:11 +0100
In-Reply-To: <20201102195839.GR3384@octiron.msp.redhat.com>
References: <20201027224536.11662-1-mwilck@suse.com>
	<20201027224536.11662-5-mwilck@suse.com>
	<20201102195839.GR3384@octiron.msp.redhat.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Leonardo Arena <rnalrd@alpinelinux.org>
Subject: Re: [dm-devel] [PATCH 4/5] libmultipath tests: fix strerror()
 difference between musl and glibc
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2020-11-02 at 13:58 -0600, Benjamin Marzinski wrote:
> On Tue, Oct 27, 2020 at 11:45:35PM +0100, mwilck@suse.com wrote:
> > 
> >  	check_expected(prio);
> >  	va_start(ap, fmt);
> >  	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
> >  	va_end(ap);
> > -	assert_string_equal(buff, mock_ptr_type(char *));
> > +	expected = mock_ptr_type(char *);
> > +	assert_memory_equal(buff, expected, strlen(expected));
> 
> This looks fine. I'm just wondering the purpose. Is it just to deal
> with
> bad,non-null terminated strings? 

No. In the case at hand, the error strings returned by the C library,
which are at the tail of the log message in this case, were different.
We're looking at an errno==0 case, where glibc returns "Success",
whereas musl returned something else (like "undefined error" or so, I
forgot the exact wording).

The downside of this patch is that if a mismatch occurs,
assert_string_equal() prints the two different strings, whereas
assert_memory_equal() prints differing offsets and values in hex, which
makes it more difficult to assess the cause of the mismatch.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

