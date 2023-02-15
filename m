Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9A5C636CC
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 12:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676464694;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JYGtZnt9Qp5TOa5wWqdroEJD7WeskxUFml327fzlN5U=;
	b=G625p86EuibkLEfPsBG0A1HtDv7zNVOcUwMwwod2P7HB1NZDrs4GtTL0kOdDjUwCV8HjVO
	17OQCSmijUzkT1JF3Fd2KGvFOokFVRglejEBSuiQ0z7QfrfUKXHeNGSQfjbwOCa1MS4pGX
	zZTaCQpEgBa0wsw7cQHWhQowVc9k1wE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-efPASvRvOo6gxlp4Oxh6BQ-1; Wed, 15 Feb 2023 07:38:10 -0500
X-MC-Unique: efPASvRvOo6gxlp4Oxh6BQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DD2D811E6E;
	Wed, 15 Feb 2023 12:38:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22F6E492C3C;
	Wed, 15 Feb 2023 12:38:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1798F1946589;
	Wed, 15 Feb 2023 12:37:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F4CE1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 12:30:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82C83492B17; Wed, 15 Feb 2023 12:30:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B426492B15
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 12:30:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F3E385A5B1
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 12:30:53 +0000 (UTC)
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-2fq0yxSRM6eTe-JRRXlOVA-1; Wed, 15 Feb 2023 07:30:51 -0500
X-MC-Unique: 2fq0yxSRM6eTe-JRRXlOVA-1
Received: from host86-157-192-115.range86-157.btcentralplus.com
 ([86.157.192.115] helo=[192.168.1.218])
 by smtp.hosts.co.uk with esmtpa (Exim)
 (envelope-from <antlists@youngman.org.uk>) id 1pSEH4-0009mu-Bn;
 Wed, 15 Feb 2023 09:40:26 +0000
Message-ID: <cbce8455-ed12-4bfa-427e-4dd54f19dca9@youngman.org.uk>
Date: Wed, 15 Feb 2023 09:40:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To: Roger Heflin <rogerheflin@gmail.com>, Heinz Mauelshagen <heinzm@redhat.com>
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
 <CAM23Vxr8LkkcVDFfW1=qEYGgo7JG1qx62eWSV4WOw4_MnD+TZA@mail.gmail.com>
 <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
From: Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAAMCDeeHxMBoVkNYAyssjgjo4=FYd2NonS-mqC7OUEL89B9Cig@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] RAID4 with no striping mode request
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
Cc: linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>,
 Kyle Sanderson <kyle.leet@gmail.com>,
 Linux-Kernel <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 14/02/2023 22:28, Roger Heflin wrote:
> On Tue, Feb 14, 2023 at 3:27 PM Heinz Mauelshagen <heinzm@redhat.com> wrote:
>>
> 
>>
>>
>> ...which is RAID1 plus a parity disk which seems superfluous as you achieve (N-1)
>> resilience against single device failures already without the later.
>>
>> What would you need such parity disk for?
>>
>> Heinz
>>
> 
> I thought that at first too, but threw that idea out as it did not
> make much sense.
> 
> What he appears to want is 8 linear non-striped data disks + a parity disk.
> 
> Such that you can lose any one data disk and parity can rebuild that
> disk.  And if you lose several data diskis, then you have intact
> non-striped data for the remaining disks.

But all your lost disks are lost (until you rebuild parity. The lost 
disks are still lost, but you won't lose any more, unless lightning 
strikes twice).
> 
> It would almost seem that you would need to put a separate filesystem
> on each data disk/section (or have a filesystem that is redundant
> enough to survive) otherwise losing an entire data disk would leave
> the filesystem in a mess..
> 
> So N filesystems + a parity disk for the data on the N separate
> filesystems.   And each write needs you to read the data from the disk
> you are writing to, and the parity and recalculate the new parity and
> write out the data and new parity.
> 
> If the parity disk was an SSD it would be fast enough, but if parity
> was an SSD I would expect it to get used up/burned out from all of
> parity being re-written for each write on each disk unless you bought
> an expensive high-write ssd.

I think even cheap SSDs are okay now ...
> 
> The only advantage of the setup is that if you lose too many disks you
> still have some data.
> 
> It is not clear to me that it would be any cheaper if parity needs to
> be a normal ssd's (since ssds are about 4x the price/gb and high-write
> ones are even more) than a classic bunch of mirrors, or even say a 4
> disks raid6 where you can lose any 2 and still have data.

The only (claimed) advantage of the setup is that you can mix and match 
disk sizes. Personally, I'd just raid-0 the smaller disks to get a whole 
bunch of volumes roughly equal to the largest disk, raid-5 or -6 those 
together, and put LVM on the top.

Probably split two disks out to mirror as my / partition away from the 
main /home raid/lvm.

This scheme is just too hare-brained imho.

(Oh, and if one drive fails and the others carry on writing, you run the 
serious risk of screwing up parity and losing your lost disk, anyway. 
It's just not robust in the face of glitches ...)

Cheers,
Wol

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

