Return-Path: <SRS0=+Jjt=MN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CD0C12002
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 15:42:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EAEAF61003
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jul 2021 15:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAEAF61003
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626882176;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1nyHGsbmoUnUbqBtRnw4JhLQMgj54/BMv4+3UoqaJag=;
	b=dg1qvGVRqL2g/I9icPnqhRFYB5JMVAo44H75WjkhZqS5rqbkx1a84MF8LnMbdEYGOWSkxE
	c7h39Kpks1+xdRLx6SNpQ3wF/lSQcrA6zAxVofZmeNcMqloQY4hQ20zSW6mn4h+w5fdoGe
	S0twZxUW7lYbRkfJEyyNgq5hKDm4wfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-5XjG2nofO3iAdKVv6Fve5Q-1; Wed, 21 Jul 2021 11:42:54 -0400
X-MC-Unique: 5XjG2nofO3iAdKVv6Fve5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD22C190B2A0;
	Wed, 21 Jul 2021 15:42:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F29CD7A8D7;
	Wed, 21 Jul 2021 15:42:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 089BC4BB7C;
	Wed, 21 Jul 2021 15:42:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16LFgdMl014888 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Jul 2021 11:42:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A20C11112C35; Wed, 21 Jul 2021 15:42:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E14B102FDFC
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 15:42:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43DE589C888
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 15:42:36 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-527-oTINNpUENL220nhmqiuVBA-1; Wed, 21 Jul 2021 11:42:34 -0400
X-MC-Unique: oTINNpUENL220nhmqiuVBA-1
Received: by mail-qt1-f199.google.com with SMTP id
	j16-20020ac855100000b029025bf786be09so1760781qtq.20
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 08:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=mC3YFDA+fRrmMU6CPpALtx86xAvYF4K/VPk02lU+2Pc=;
	b=R2CCNzoSZy/idtUQMvJZRw97Ay5p8yT1kt5csjm0lavkaMNQxVcDwagwbGpvzT5k+s
	PDYi1yAYoITtr9Doq048FCfX8c7nHbIRQj66AaPAF4do1Pm3ThL4AeyPOXAh7ytNVz8q
	deOYFSFQ+YwI06uFtR5XxwWj5YiposbzTyMFinScB0zEmMuXyVMI6Sccc+8Az45dLvN+
	+4sDSb5nIQ54TOqMnhG+QUXX7QvsyBGb6oRzPK1l0XLNSsRLYStUxcYerGoHM9lmDhN7
	gsKEBE18FOJDSyY+q7rCuVrdpHfgQ7AlT1Ae2vlPcPHL12RmrRId+tghQWG8kWhK3kSM
	Wjiw==
X-Gm-Message-State: AOAM533aTbQbDCKajna0g3ql6WGP6ntwG+k/MexB6YzHW5IljCT3E+WM
	FcEzqDBIZvKCPt2YddnWqjY0+w/7pS7baeawszfB1Xj2XSTnemBb5Bczmue9PZTLdyr97+na3EV
	L+dAjwIYVz+j8ow==
X-Received: by 2002:ac8:1249:: with SMTP id g9mr18972680qtj.292.1626882154313; 
	Wed, 21 Jul 2021 08:42:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBCUbNIq4GM1ljypiPbKNvxp5VilwRNSZpBInXM1bHvIYhD/SAhXl5O1HT4obVg4YaJLewZQ==
X-Received: by 2002:ac8:1249:: with SMTP id g9mr18972670qtj.292.1626882154100; 
	Wed, 21 Jul 2021 08:42:34 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d79sm6825042qke.45.2021.07.21.08.42.33
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 21 Jul 2021 08:42:33 -0700 (PDT)
Date: Wed, 21 Jul 2021 11:42:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Message-ID: <YPhAaAyo8fKXzu5c@redhat.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
	<20210713004904.8808-2-tusharsu@linux.microsoft.com>
	<713d22788b678c612c5b18edfb8cf849af61ace5.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <713d22788b678c612c5b18edfb8cf849af61ace5.camel@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Tushar Sugandhi <tusharsu@linux.microsoft.com>, nramas@linux.microsoft.com,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 1/7] dm: measure data on table load
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 20 2021 at 10:12P -0400,
Mimi Zohar <zohar@linux.ibm.com> wrote:

> Hi Tushar, Mike, 
> 
> On Mon, 2021-07-12 at 17:48 -0700, Tushar Sugandhi wrote:
> > +struct dm_ima_device_table_metadata {
> > +       /*
> > +        * Contains data specific to the device which is common across
> > +        * all the targets in the table.e.g. name, uuid, major, minor etc.
> > +        * The values are stored in comma separated list of key1=val1,key2=val2; pairs
> > +        * delimited by a semicolon at the end of the list.
> > +        */
> > +       char *device_metadata;
> > +       unsigned int device_metadata_len;
> > +       unsigned int num_targets;
> > +
> > +       /*
> > +        * Contains the sha256 hashs of the IMA measurements of the
> > +        * target attributes key-value pairs from the active/inactive tables.
> > +        */
> 
> From past experience hard coding the hash algorithm is really not a
> good idea.
> 
> Mimi
> 
> > +       char *hash;
> > +       unsigned int hash_len;
> > +
> > +};

Hi Mimi,

The dm-ima.c code is using SHASH_DESC_ON_STACK and then storing the
more opaque result via 'hash' and 'hash_len'.

So if/when the dm-ima.c hash algorithm were to change this detail
won't change the dm_ima_device_table_metadata structure at all right?
But even if changes were needed this is purely an implementation
detail correct?  Why might users care which algorithm is used by
dm-ima to generate the hashes?

Assuming there is a valid reason for users to care about this, we can
improve this aspect as follow-on work.. so I don't consider this a
blocker for this patchset at this point.  Please clarify if you feel
it should be a blocker.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

