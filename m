Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9E9C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 13 Mar 2022 11:03:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-OLntK6rYMWWQVRwFU4Q4YA-1; Sun, 13 Mar 2022 07:03:50 -0400
X-MC-Unique: OLntK6rYMWWQVRwFU4Q4YA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BC8C3804535;
	Sun, 13 Mar 2022 11:03:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0BC5C50941;
	Sun, 13 Mar 2022 11:03:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90FE41940370;
	Sun, 13 Mar 2022 11:03:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C17B91940370
 for <dm-devel@listman.corp.redhat.com>; Sun, 13 Mar 2022 11:03:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4DE1C5094A; Sun, 13 Mar 2022 11:03:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0EC0C50941
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 11:03:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A84C29AA2E6
 for <dm-devel@redhat.com>; Sun, 13 Mar 2022 11:03:46 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-E-sAX7OeMDCpM4-UygHw0A-1; Sun, 13 Mar 2022 07:03:44 -0400
X-MC-Unique: E-sAX7OeMDCpM4-UygHw0A-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MCbIx-1nKrQz1wLj-009fqT; Sun, 13
 Mar 2022 12:03:43 +0100
Message-ID: <d8ea4246-8271-d3c4-2e4d-70d2c1369a05@gmx.com>
Date: Sun, 13 Mar 2022 19:03:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Matthew Wilcox <willy@infradead.org>
References: <88a5d138-68b0-da5f-8b08-5ddf02fff244@gmx.com>
 <Yi3NkBf0EUiG2Ys2@casper.infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <Yi3NkBf0EUiG2Ys2@casper.infradead.org>
X-Provags-ID: V03:K1:7N7Y+GXcGUd3TgJDXOtNCc1oJ2z91BRD6n8d/n6BDmlX17YIewj
 nkZ+hCr5dlz3BDOnkRPWJ3I7Mv8wuP8+8eprXEtbMrVxf4M/4nPj6wGMnQiFPUk655tkUjW
 F/yZg3Ryo+LVlnX4+Rdi++L7ZZdP++R62XP2Z0tL7uGqyY+v+zVpbZ+JSIzzNlkEtyviF/m
 usdNQxoNBDZtATQcXmG5A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:U/xHFkHs1hQ=:5An6tQIa5ut3kHJLOBEAGu
 ObY7J7H6D9lzUsClRdU5TJzIhQRosTMfPBEa7VPpgKDvuoX6QYooNq3te7PWedd20uM+jn62N
 XCpM7v+/tL6kmIkl+T+kqTrbnffhUrEYvWQLZeCMNW8DwZqlRCfuvf09EyDwqxpe8R/B+ikTI
 t+rSDs1pPJIu+4v3X6f2qUG5IpjUdq//qU1O6WZPDvaDJDNLhHmJdO5DFET4xAbOuXrGDmwTy
 dXQrkyJANStVI77npyIwUGnx5tchFxR2YlgF+UfdM8nMA8xqWInz42h3VqjXCIuWjit0YCnin
 MhWfK0f+ZgOljXZVCjePRGsfp7wKDXxzs/bfHvErQNgUxGWl2PABXu2XD6IEfTyI6la8fnXOu
 FcBu3oCR08GkRf3qHY7syemHKy0nDl61k5XwzpDxWg3t/e+qDuO2VtLhLMDXsBJt9Rh3tSzW9
 k0w7V9BiqsuO1nbgWDVa3+dxrO/vX7q0wahMePTKHf7nT2zizSEVRXJpnKxKYQw8S6WnnWWOA
 rL1IW+yAz67vYMQgkUR8N26FSFAUpHC8b6WlqqUNBTZ8RiDfewLVBd49c4iEuZd94kWR92m13
 QX1D0IGOPmFfANBOm3skUOSnMBMhJiOi1M9LLS11WkTChyAwQzQXanrl3sPDGBZRXs81MPuNS
 LapAXLN+E50sqbCn65JeD1PCW1XEnd1gGuZMCGj+HWfmi1aeYrBKQw4VcCsUzTQc8QoaaoAXI
 fD2euA4LPIxuIJFsW4Ikijtn23ws+fi6mZWY/Dx9C2Do2r+LS2bE3q+TNhQI8pYsUyxqJvZB/
 XzjphZwB2/t43Vf3D6R0TN5J91d+uaez3ZnXMtnGeLnhL2Dx9vwhXAAqsRAygqLd7xCTWq4UY
 CVU0DsEwxbbT2qYMMQ27QJGP1/YA8KeeDrj8w097VzPT9UpEYMksPL/2RD+cEqwtqIgF4u8Ei
 COC0bO68X+xDkm4YY8Nx5mL04ddvSN03lFfY4ZfZrw32lvU0dHDUVWL3G4rVIlcBZWK235CqV
 ZEfq/u8XVmakoWR21wPwvzRbCw2+4OLpdA5AhP6WUcnypyUgQrSI5ZygUFyrZCzUmMWF91qeY
 dU5I4hQqihdjy4=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] Better read bio error granularity?
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
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2022/3/13 18:55, Matthew Wilcox wrote:
> On Sun, Mar 13, 2022 at 06:24:32PM +0800, Qu Wenruo wrote:
>> Since if any of the split bio got an error, the whole bio will have
>> bi_status set to some error number.
>>
>> This is completely fine for write bio, but I'm wondering can we get a
>> better granularity by introducing per-bvec bi_status or using page status?
>>
>>
>> One situation is, for fs like btrfs or dm device like dm-verify, if a
>> large bio is submitted, say a 128K one, and one of the page failed to
>> pass checksum/hmac verification.
>>
>> Then the whole 128K will be marked error, while in fact the rest 124K
>> are completely fine.
>>
>>
>> Can this be solved by something like per-vec bi_status, or using page
>> error status to indicate where exactly the error is?
>
> In general, I think we want to keep this simple; the BIO has an error.
> If the user wants more fine granularity on the error, they can resubmit
> a smaller I/O, or hopefully some day we get a better method of reporting
> errors to the admin than "some random program got EIO".

Indeed this looks much simpler.

>
> Specifically for the page cache (which I hope is what you meant by
> "page error status", because we definitely can't use that for DIO),

Although what I exactly mean is PageError flag.

For DIO the pages are not mapping to any inode, but it shouldn't prevent
us from using PageError flag I guess?

> the intent is that ->readahead can just fail and not set any of the
> pages Uptodate.  Then we come along later, notice there's a page in
> the cache and call ->readpage on it and get the error for that one
> page.  The other 31 pages should read successfully.

This comes a small question, what is prevent the fs to submit a large
bio containing the 32 pages again, other than reading them page by page?

Just because of that page is there, but not Uptodate?

>
> (There's an awkward queston to ask about large folios here, and what
> we might be able to do around sub-folio or even sub-page or sub-block
> reads that happen to not touch the bytes which are in an error region,
> but let's keep the conversation about pages for now).
>
Yeah, that can go crazy pretty soon.

Like iomap or btrfs, they all use page::private to store extra bitmaps
for those cases, thus it really impossible to use PageError flag.
Thus I intentionally skip them here.

Thank you very much for the quick and helpful reply,
Qu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

