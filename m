Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB13C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 16:56:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-eFv9TCFNOKOTVlP7nUPZHw-1; Thu, 09 Jun 2022 12:56:11 -0400
X-MC-Unique: eFv9TCFNOKOTVlP7nUPZHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECB38811E76;
	Thu,  9 Jun 2022 16:56:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0A2E2026D64;
	Thu,  9 Jun 2022 16:56:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 619FF1947062;
	Thu,  9 Jun 2022 16:56:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B44391947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 16:56:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85FA640CFD0B; Thu,  9 Jun 2022 16:56:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 81F5940CFD0A
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 16:56:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 678B985A580
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 16:56:07 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-JZUwgYp5NY-aFOHXB4uyCA-1; Thu, 09 Jun 2022 12:56:03 -0400
X-MC-Unique: JZUwgYp5NY-aFOHXB4uyCA-1
Received: by mail-wr1-f52.google.com with SMTP id x17so33233772wrg.6;
 Thu, 09 Jun 2022 09:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=aWkZjs/Pi5ubB1ck2CIMbrPgWgoNEJHTSygS/OSxN1g=;
 b=wRj0ChpI4Cnb77lUpFg3ED7L2J2XqE87LwsoESiuWg8H26r9crwIbts+xk5WRDeCgP
 g8PebYHD1ZmAJbY+6WfYeqCbEk5El309nMcfrqqAgMYoealj4E15iRzhzU/2vKrKbTCr
 9fNDjYJenhteTe8LpH7sS69+8VRAjOJ/ey8MNrFMlzvoxMOuOOCgv38fprPUj8mG2+HG
 bMu0hmsvuBvK1BrUBrX/5wsk1FzBbJvjNRD+JuZt3CeD2l8SzLHYwQueJAxhKMl7yNIJ
 2XPSvzJ4PLXaTL6rfAMxOYHKARU3R2JEIsYJN022rQ1ZlOg0LPQ9g2tSULrUdtvuVI7g
 opxQ==
X-Gm-Message-State: AOAM532OFJVa8UvZXp2hcnIoKW5X7th+0nFvSJMRLItZPt0g6bRmeJRt
 vueyfc24jQn/Yz4AWP8GLA==
X-Google-Smtp-Source: ABdhPJyJY/TE4w4w8CEFOqjHTKwrKgE525S5onZhV6M1NBcVZ6aZYP2PDGO3zFsVKwWAqR22bvk4aw==
X-Received: by 2002:adf:f803:0:b0:217:d2cb:d6c7 with SMTP id
 s3-20020adff803000000b00217d2cbd6c7mr24154845wrp.215.1654793761933; 
 Thu, 09 Jun 2022 09:56:01 -0700 (PDT)
Received: from localhost (51.red-81-44-146.dynamicip.rima-tde.net.
 [81.44.146.51]) by smtp.gmail.com with ESMTPSA id
 k26-20020a05600c1c9a00b0039740903c39sm27253015wms.7.2022.06.09.09.56.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Jun 2022 09:56:01 -0700 (PDT)
Message-ID: <7510d16e-b821-3030-16cf-ef39854109f5@gmail.com>
Date: Thu, 9 Jun 2022 18:56:00 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>,
 "Schremmer, Steven" <Steve.Schremmer@netapp.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
 <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
 <f29d01dd-676d-0d1e-77b0-df951fb7f99a@gmail.com>
 <8ab798a93edf33a550f0c78f113d8943d76916b6.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <8ab798a93edf33a550f0c78f113d8943d76916b6.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George, Martin" <Martin.George@netapp.com>,
 Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/9/22 18:49, Martin Wilck wrote:

> IIUC NetApp's concern is not the generic entry, but the entries
> mentioning E-Series or it's OEM products in NVMe configuration
> explicitly. I also have some trouble understanding the concern, but
> NetApp is in charge of these entries, so I believe we should respect
> what they're saying.
> 
> With the late patches I submitted, the generic NVMe defaults would work
> for the NetApp devices without those being explicitly mentioned. I hope
> this is ok for everyone. Only the no_path_retry setting would get lost,
> which is acceptable IMO because this is rather an admin setting than
> product-specific.

And now (IMO) it is worse, because NetApp NVMe arrays are under a generic config.

What do they hate?  just ".product = "NetApp E-Series"" ???

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

