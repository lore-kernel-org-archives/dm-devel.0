Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78953C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A3EA61250
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A3EA61250
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-pggYXkvXMQa8wuivkUJvNg-1; Mon, 23 Aug 2021 02:40:34 -0400
X-MC-Unique: pggYXkvXMQa8wuivkUJvNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BCA21008073;
	Mon, 23 Aug 2021 06:40:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A96A69321;
	Mon, 23 Aug 2021 06:40:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D3AFD181A1CE;
	Mon, 23 Aug 2021 06:40:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KMvCaK031245 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 18:57:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B799111E1CE; Fri, 20 Aug 2021 22:57:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2340106246
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 22:57:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32648185A79C
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 22:57:09 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
	[209.85.216.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-462-8t5BLCRsORWI1efJO0OYsw-1; Fri, 20 Aug 2021 18:57:07 -0400
X-MC-Unique: 8t5BLCRsORWI1efJO0OYsw-1
Received: by mail-pj1-f52.google.com with SMTP id
	mq2-20020a17090b3802b0290178911d298bso8324628pjb.1
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 15:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=G1Z8mu8s2sgn0mbpfu7ra3LWl3tk+2BaXWQ56zeT5Qo=;
	b=FcDOMXrmPxBnl9zLTmCCkp2pvq83xeDKcW7/yh+sgAleFCE3kAYoTYBmryjkQD28Qf
	3I5o09RO2gK2rq7bFdcz5rT1I6S+i8oNPZEQUCEUtBcjV5Fq2OlN1dU8od2JPYXG5hOB
	2QPNbGYiwggdz/mULS2hvs2Twhbx2OlI0wmdZQEjjO13tujppzg50PvNzaq6XyyGu38/
	UEoc0CAlgMehqBUTbQ9iAbLd98c7MdxJRn1a9jwkMxFlVTS3cTBebT7BdSt70a6Ww6pk
	PTfcCQxplQ6O3zE6iJ9gdYh1yzRAJT1Dh4Ayr32z3VKhOm652vpCp2BEJgk5m8v+qrFL
	2tUQ==
X-Gm-Message-State: AOAM531gQUyjgiTXqoW9IapQLEoOMRKkqzmfwrBFvta0J2/5pI9GAAXr
	gbRIoReA5IVOZInGoP6wGDsBG7fw0MCsFruYDQJteA==
X-Google-Smtp-Source: ABdhPJxmXpLQCDOV4p/qDFeGVDmICU8dPEjZ+Gjrsjl1tuFZXHOKRbvy6d0ZC+yE1xwMVSAlTTyashdIzkFcEanj6Qo=
X-Received: by 2002:a17:90b:18f:: with SMTP id
	t15mr6777302pjs.168.1629500225798; 
	Fri, 20 Aug 2021 15:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
	<ec5dd047-a420-8e17-d803-729e052b2377@oracle.com>
In-Reply-To: <ec5dd047-a420-8e17-d803-729e052b2377@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 15:56:54 -0700
Message-ID: <CAPcyv4hitKKPByHkX-syRmc1rmF8B4sGRsGdUDsBAE5-yoBvXw@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
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
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 6/9] xfs: Implement
	->notify_failure() for XFS
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, Aug 5, 2021 at 5:50 PM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > +     mapping = VFS_I(ip)->i_mapping;
> > +     if (IS_ENABLED(CONFIG_MEMORY_FAILURE)) {
> > +             for (i = 0; i < rec->rm_blockcount; i++) {
> > +                     error = mf_dax_kill_procs(mapping, rec->rm_offset + i,
> > +                                               *flags);
> > +                     if (error)
> > +                             break;
> > +             }
> > +     }
>
> If a poison is injected to a PMD dax page, after consuming the poison,
> how many SIGBUS signals are expected to be sent to the process?

I think it should only get one. I.e. just like the the generic code
does one shootdown per mapped page regardless of whether that page is
4K, 2M, or 1G. Once the application is notified it should be able to
query the filesystem to determine the full extent of the damage to
files.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

