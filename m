Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15049C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 26 Nov 2021 12:33:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-2Zas-xzePt6LIsvXuMZa3Q-1; Fri, 26 Nov 2021 07:33:30 -0500
X-MC-Unique: 2Zas-xzePt6LIsvXuMZa3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A47CA81CCB6;
	Fri, 26 Nov 2021 12:33:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46C171001F50;
	Fri, 26 Nov 2021 12:33:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDF824BB7C;
	Fri, 26 Nov 2021 12:33:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AQCXDAc008688 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Nov 2021 07:33:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ED19C404727A; Fri, 26 Nov 2021 12:33:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8DBE4047272
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 12:33:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DDE6803DDA
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 12:33:12 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-514-ANIJfrDANaSO33UC9q33BQ-1; Fri, 26 Nov 2021 07:33:10 -0500
X-MC-Unique: ANIJfrDANaSO33UC9q33BQ-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
	[212.227.17.174]) with ESMTPSA (Nemesis) id 1Mplbx-1mGRva14FJ-00qBEQ;
	Fri, 26 Nov 2021 13:33:08 +0100
Message-ID: <c44de3dc-b7a6-5872-2fe5-05488e93db05@gmx.com>
Date: Fri, 26 Nov 2021 20:33:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: Christoph Hellwig <hch@infradead.org>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YZyiuFxAeKE/WMrR@infradead.org>
X-Provags-ID: V03:K1:091WRRDrxH/2yMPKg6Uo+uTz4mJSDtRMoLxqluII1/bR8fmw6ug
	ey6sTGGxndUgaxgmXx45ESq1eN7eMHvyWiPdr4O215tz7ZJjyhOM2tixFoPk90t9tT4/GYD
	MuNyyDqaroLrSjDE2efwqgvc7Ye9N6e/D5h4C9fZ8lVzQ1pX8GoK3FLRg/ODCUML9kgHtOU
	uzDMRwtCdaDVb4dzAOFvg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ytDR6jOTwN8=:hcjBD9ySYG7BNMMLIZgzQ7
	V9aBPZKqgJ9mvYMUce8XKUZjGcU2+Scc2nVPqVw0efAhDgi6y/7tDDnp/aWp4zitcECBKaHyg
	5wGZSq8hD3Ap7pYxFRiJbMHRToWGUP0xwGdQKkkSmm19ZzE2pZV9F/59CEjM4HU70XcyshRlh
	v5ksP9ZRz7kG93x6c1DVqE7TfWULqk6r6moCXbhzW34TYA8GfvjpOWmfGxS07SQc6FAp6mE2I
	q9YS8q0h/M2z/J4GLqU3VR/SD9TtX8BemsqfHNr0ldRsuClHL7pJnrA+tYQu6mdYmISWnb3qM
	hELKRlMj8GEWcP56ku4/055AHvMIpIctogou84v08qE+xaXxhl7SpbjTQV56EzMC8J/o9H0Hv
	XKo+111ElgmINQo3aEdDE7b/w4mP/CmWQK3gDpT7u7/oHH/h1TZcrVh9DC4zzYf2XbzqZPDgd
	k5XDKR+tHSht88KHBBqNrh+jJrkAy4q6Ry9Cz5QzteKms8G901nfQI4S2vewJCLOCNbtxFSqV
	MK+BNZlojbmFVsype/dibNmVL71ND8ErkNY2hcR5EMpv+af+IeNu3at5H7UBgw6XeBwn40lkM
	vZt+cw8f4tpr08GFBqWHlzbsmR/uh6/OQ7/LVXO148ba9dCZw+FN+wHirl9CKOH9KDXPLIfFR
	fSP27aU9JnhtzA956rz1ZtKIZ1hueSSfc/drYU3KVZSvMOhBNP17P4LXJFkT18zpodXY0Y7M9
	Mtvk0re8y7j4xxs71Dzeo/+5OjbocLSjoJmvsyzOB+stffftD/n9Ze+Nos5OmehgxSRhspmjy
	LN9Ig+wL4xeIZPOveu1Op4UZcyk2pfR1R+iQJPYiyhE2l+3NgfTXCjO5tGpDuzOucDAkTb4gU
	tBi95qm4VLy71x0vsV1EvT7Av48ITBtgWAoAExGnVPFoOhX1hBn0YRBnqpEOYl10WumttLbjU
	aVf5Wblms5vXd27mr8QQdHQ4QLkpF3Zt3RpxZ8trD5mr6amHWNQNg7wPtrR0U4+OQVOR833/m
	chem1+6prG0AfbCs6qgZ9bgZYHWXHkZq8F0U/61xlad3oxsrCKC7ySz2cVeLgIwYNRgUvwNxB
	iizgrvKDlYnoWo=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AQCXDAc008688
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/11/23 16:13, Christoph Hellwig wrote:
> On Tue, Nov 23, 2021 at 04:10:35PM +0800, Qu Wenruo wrote:
>> Without bio_chain() sounds pretty good, as we can still utilize
>> bi_end_io and bi_private.
>>
>> But this also means, we're now responsible not to release the source bio
>> since it has the real bi_io_vec.
>
> Just call bio_inc_remaining before submitting the cloned bio, and then
> call bio_endio on the root bio every time a clone completes.
>

Does this also mean, we need to save a bi_iter before bio submission, so
that at endio time, we can iterate only the split part of the bio?

Or we have to go back to bio_chain() method, and rely on the parent bio
to iterate all bvecs...

Thanks,
Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

