Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83339932
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K7eUtLKY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697049736;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2srrLD2I+y6AoYJsJPm73UyPjL85SJALM39HGc0Hzd0=;
	b=K7eUtLKY8FjDLI3EL/lu83rv5FOkil6pfllBGNTIT8GJILwGRR4lZnIODXZMczOGFBDS4B
	N1i7Wf5gBHsOa4kEdY98NV1azL5byiSZi21StH8oQoBJmdnBwVMkWp3PGJWZggL7ov9iuT
	PKsnqLADg/idPUvr9daBibwv26nEiEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-WdFn07PWNC-FXfwS7TPttw-1; Wed, 11 Oct 2023 14:42:14 -0400
X-MC-Unique: WdFn07PWNC-FXfwS7TPttw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97C8085A5BD
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 18:42:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9083E492B00
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 18:42:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40B601946597
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 18:42:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C0581946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 18:42:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE85E158; Wed, 11 Oct 2023 18:42:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7CE9150
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 18:42:12 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B721E1C03DAD
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 18:42:12 +0000 (UTC)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-y68JrbE5PcyGvcfDetxUEg-1; Wed, 11 Oct 2023 14:42:01 -0400
X-MC-Unique: y68JrbE5PcyGvcfDetxUEg-1
Received: by mail-ot1-f70.google.com with SMTP id
 46e09a7af769-6c4b9cab821so243776a34.0
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 11:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1697049720; x=1697654520;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=m0SH0S81HdUdRJYV4PnoYd2/wrnKPyALEKbzbADB/TY=;
 b=KTzTjkvEJ+OudXn7+nfpwENPLASn7AK5tg5sRMzfgqgE2q4KWxXFYjxZGwFQjOIRJl
 WSRKoIKsEbXPH1klea+ENG2sZ7GYKeG78dUWWlK1pEoFbjhe2i5cNtWZz7CpLpp6TmL3
 GXyAfQWn073bQAz29+usfgUsBE2hvsVYXIIIG2lEbJ4zXrtR9jW4Hy34TgA6JZJb7niW
 d+HnqWMXn0ePJlMB46qb9dzapDNYUWPh+Ha0g1tRKwZItD2yhgfJyzBlXYQF9FYhNMDU
 2cq+6j3DO2LFfwjy8Ve2DzHKScupTPNgiPbUFyVQJb+AIPmY81Mc6/uBdWefd30T5P6C
 yRQg==
X-Gm-Message-State: AOJu0YzCRfelm6OCqMlNztdSJG/99j7id3zRGb+wWign/lYwLw1S35k1
 bVM4AgtwILhRLAWlpWAcID7fIAUIuAyuce1ihGMzHVRB8aeugG0hbjmNO/QGDLNnwOVMamqjUhi
 yVbR9JPLkSNIdE7VA2QBtfProHn7j+WnB2aPQkDHj9FyOMh4H/zoWl6MlEJAt62umaBAvOfjRBw
 ==
X-Received: by 2002:a9d:68c6:0:b0:6c4:81d6:171b with SMTP id
 i6-20020a9d68c6000000b006c481d6171bmr24881661oto.21.1697049720110; 
 Wed, 11 Oct 2023 11:42:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7W1xknuSFFajL88Qq2QWhEymDlSZ7cBHRdYfiXhLKhpNvHVFvX1M+apWjMo3lAIyfil3EmA==
X-Received: by 2002:a9d:68c6:0:b0:6c4:81d6:171b with SMTP id
 i6-20020a9d68c6000000b006c481d6171bmr24881648oto.21.1697049719744; 
 Wed, 11 Oct 2023 11:41:59 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 d2-20020ac85442000000b00407906a4c6fsm5531933qtq.71.2023.10.11.11.41.59
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Oct 2023 11:41:59 -0700 (PDT)
Date: Wed, 11 Oct 2023 14:41:58 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Subject: Re: dm-devel has migrated to lists.linux.dev
Message-ID: <ZSbsdlfRAoUj8Jzb@redhat.com>
References: <ZSCYSO8wlg4keAmY@redhat.com>
 <ZSCbqvX0f9LOXByf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZSCbqvX0f9LOXByf@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[this is also test, to see if new list allows old list to email it]

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

