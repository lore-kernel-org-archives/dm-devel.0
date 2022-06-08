Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22BBC43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654695135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DAQD8W+BiaUGEYnJB2jPnDb+j8/IA+S1pU70bg8aFSs=;
	b=WcV/ygz9tuuV+5PbmP329IaPZhCfDmsoG01u7Tdh09HuoGAwsxFsVgsBypCnAvQKAJTQt1
	H/kQg+HgvdWnDaiw6j+yHbGF4jPp+tu9t2ephzDsaABd6RF0Y63gkDisoy83yuns65HWv0
	06mdfS3vZeeTGByU3CbmXcjq6F/ke5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-_kxdDCDVP_iyYfO3OR44xQ-1; Wed, 08 Jun 2022 09:32:11 -0400
X-MC-Unique: _kxdDCDVP_iyYfO3OR44xQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4832B8026B9;
	Wed,  8 Jun 2022 13:32:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87FD5404E4BD;
	Wed,  8 Jun 2022 13:32:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE5A21947041;
	Wed,  8 Jun 2022 13:32:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F2451947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 13:25:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 123F21121315; Wed,  8 Jun 2022 13:25:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E5131121314
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 13:25:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7BE580013E
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 13:25:27 +0000 (UTC)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-LXDnTEk7MjibhuDjvAxrHw-1; Wed, 08 Jun 2022 09:25:26 -0400
X-MC-Unique: LXDnTEk7MjibhuDjvAxrHw-1
Received: by mail-wm1-f71.google.com with SMTP id
 bg40-20020a05600c3ca800b00394779649b1so14402401wmb.3
 for <dm-devel@redhat.com>; Wed, 08 Jun 2022 06:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gKuUIyEEkDbHb7f0xBwFHmqeYFxwTh2tf0cpPwHyW50=;
 b=51mOE/7TdDvRCUEZ7qyoaKP+kaiUIBDZyb9StMic92K3TuXSzoqpt/o4xnM+Zr5w9z
 mCk7YX83XCzeN6fTdn1tlNZXg7HIlVSDVW+QXWQpndvh7gKCsCMk/PgR7TSTOni+tlro
 MsVOurdvxvf4OiEXMEnO6vrcDYJ6M2DmOIjB7uPZf7mZGwwglawZXoJsf1n1/ffYEKaO
 tk2YQjjKFtPk9osRexDIoT03+P+M1T3wYZ/osxQXybku/Jk/V6fuXd6TC8rIeYtR9jrt
 uh9AzjA1Q50nFdym2qG9bv5gROb/lY0Ef4XCobJyQsgXIv9/TX31n9DHfWeKlFYutV7I
 QhjA==
X-Gm-Message-State: AOAM531g9sWdn199P3Csu4PimEOUOOtObYTY+IVGQ19hjwrvU7obNWuj
 k1vl9QNCTzPxhMk6qTnCh55+NaSVkOFWwhcAxyg8SKEmdKNuPlk8c+BlXNlVk4nITFHiZiNNAbO
 o4JFJgVq4fXBVVxY=
X-Received: by 2002:a5d:504d:0:b0:210:24fd:add1 with SMTP id
 h13-20020a5d504d000000b0021024fdadd1mr32899433wrt.630.1654694725276; 
 Wed, 08 Jun 2022 06:25:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVv2I9Qkz6FG0ll1PjpliZcDH8yvDR1kDYVr7PtVn0SgsuAB6ofmzpllOXyGYNX7wmQMbprw==
X-Received: by 2002:a5d:504d:0:b0:210:24fd:add1 with SMTP id
 h13-20020a5d504d000000b0021024fdadd1mr32899412wrt.630.1654694725007; 
 Wed, 08 Jun 2022 06:25:25 -0700 (PDT)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
 by smtp.gmail.com with ESMTPSA id
 ay1-20020a5d6f01000000b0020fee88d0f2sm27913800wrb.0.2022.06.08.06.25.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Jun 2022 06:25:21 -0700 (PDT)
Date: Wed, 8 Jun 2022 14:25:18 +0100
From: "Bryn M. Reeves" <breeves@redhat.com>
To: Tony Camuso <tcamuso@redhat.com>
Message-ID: <YqCjPnT1P3s6EjHn@redhat.com>
References: <b65d1bbb-7367-3a51-ba21-9de057a435fc@redhat.com>
 <Yp8hB/tJBVNxDXgy@redhat.com>
 <1046d899-7fe9-7bbe-87fd-7e200c73668e@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1046d899-7fe9-7bbe-87fd-7e200c73668e@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] Device Mapper being derailed in tboot launch
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 07, 2022 at 08:15:16AM -0400, Tony Camuso wrote:
> On 6/7/2022 5:57 AM, Bryn M. Reeves wrote:
> > On Mon, Jun 06, 2022 at 11:43:58AM -0400, Tony Camuso wrote:
> > > Successful bootlog snippet:
> > > 
> > > [    3.843911] sd 5:0:0:0: [sda] Attached SCSI disk
> > > [    3.848370] sd 6:0:0:0: [sdb] Attached SCSI disk
> > > [    3.925639] md126: detected capacity change from 0 to 1900382519296
> > > [    3.946307]  md126: p1 p2 p3
> > 
> > Are the MD array partitions being used as the PVs for the rhel_lenovo
> > volume group? It's the major difference in the two snippets other than
> > timing, and would account for why the volume group cannot be discovered
> > in the tboot case.
> 
> It would appear from the respective grub command lines that they are.
> See below.

OK great - that explains why the LVM devices are timing out in the tboot
case. 

> ======================================================================
> Here is the kernel command line in grub for the normal boot (succeeds)
> ----------------------------------------------------------------------
> 
> set gfx_payload=keep
> insmod gzio
> linux ($root)/vmlinuz-4.18.0-348.el8.x86_64 root=/dev/mapper/rhel_lenovo--st25\
> 0v2--02-root ro crashkernel=auto resume=/dev/mapper/rhel_lenovo--st250v2--02-s\
> wap rd.md.uuid=8061c4cf:06de8a59:a9eefb7e:3edb011a rd.md.uuid=549c2ba4:1e03463\
> b:d429e75b:398c67a3 rd.lvm.lv=rhel_lenovo-st250v2-02/root rd.lvm.lv=rhel_lenov\
> o-st250v2-02/swap console=ttyS0,115200N81
> initrd  ($root)/initramfs-4.18.0-348.el8.x86_64.img $tuned_initrd
> 
> =============================================================
> And here is the kernel command line in grub for tboot (fails)
> -------------------------------------------------------------
> 
>         echo        'Loading tboot 1.10.5 ...'
>         multiboot2        /tboot.gz logging=serial,memory,vga
>         echo        'Loading Linux 4.18.0-348.el8.x86_64 ...'
>         module2 /vmlinuz-4.18.0-348.el8.x86_64 root=/dev/mapper/rhel_lenovo--s\
> t250v2--02-root ro crashkernel=auto resume=/dev/mapper/rhel_lenovo--st250v2--0\
> 2-swap rd.md.uuid=8061c4cf:06de8a59:a9eefb7e:3edb011a rd.md.uuid=549c2ba4:1e03\
> 463b:d429e75b:398c67a3 rd.lvm.lv=rhel_lenovo-st250v2-02/root rd.lvm.lv=rhel_le\
> novo-st250v2-02/swap console=ttyS0,115200N81 intel_iommu=on noefi
>         echo        'Loading initial ramdisk ...'
>         module2 /initramfs-4.18.0-348.el8.x86_64.img

There are some minor differences here particularly these two that are
only present in the tboot entry:

  intel_iommu=on
  noefi

The first doesn't seem likely to be involved - if forcing the IOMMU on
did anything to affect this I would expect it to break the SCSI driver
and prevent the disks from being disovered, but we see the sd log
messages in the tboot case so that isn't happening.

The noefi is a bit more interesting - a lot of modern systems ship the
motherboard RAID configuration tools as an EFI application now, and I
wonder if forcing EFI off with noefi is somehow breaking the discovery
of the imsm RAID set? The full dmesg for the two cases might give some
more hints about this.

My other possible guess was to check whether the initramfs image for the
tboot case was missing MD support, however from the above it looks as
though the two entries are using the same image (one has a ($root)
prefix, but that's where grub should look for / anyway).

Regards,
Bryn.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

