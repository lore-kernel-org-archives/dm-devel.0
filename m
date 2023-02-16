Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104F9C61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676550065;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jJsIX8EYoUsx0KTfrF6hF69expCBwuysNM7xrOXHdhc=;
	b=DJvlily3tB75jzUqTJd4pfoAfLI0Mtn23E8j8RdyjppPa0Umy+lFUhTGpi7ZwR4d+JqlRE
	4Corp+gBK/HZYBT0mOA7a+n9UKomBUHTrfjAOv8mytOtmNrm+pKHvM0fR6/3iQB9eeJ3es
	/Muev3WYP1rZrMPZm5yNGnzn4V3fso4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-bRT0j3wtNI20j0SKrg473w-1; Thu, 16 Feb 2023 07:21:02 -0500
X-MC-Unique: bRT0j3wtNI20j0SKrg473w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2A04101A55E;
	Thu, 16 Feb 2023 12:20:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41E432026D4B;
	Thu, 16 Feb 2023 12:20:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 216711946589;
	Thu, 16 Feb 2023 12:20:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 440951946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 12:20:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E41FA51FF; Thu, 16 Feb 2023 12:20:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBE96175AD
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 12:20:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B88293C10231
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 12:20:52 +0000 (UTC)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com
 [209.85.217.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-96-L_Uqk_XgOAKg0JjhIgUw9A-1; Thu, 16 Feb 2023 07:20:51 -0500
X-MC-Unique: L_Uqk_XgOAKg0JjhIgUw9A-1
Received: by mail-vs1-f49.google.com with SMTP id g8so1715592vso.3
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 04:20:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1676550050;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=KDbrMr3+ZX/SJg0E/kWhfc4oXH3QbJWlpO1YUkiNvMc=;
 b=GMEakrJ+22JfognWOrlHqETMyyuiec1lqjVsObU6Xzlv+jlAZ1KLL4AnaZI95dfswZ
 n1f/51IaTGLb1lNBco05Icc+qhkBmye8ZTEhBkYR3H3NGp3cnN3zTea3Vu2op7TlQJy6
 IxP5b21MDHHh85hBbFwwz7Xw93cYtPoIh+xVehpd3P90wMefgGvIFCl2ef1xQ6UMZLnE
 wQDXfn6QjhuSPHvK6R7Dl4Qzvqv9diMx8nDb88TMEnSQZf38hh0WenqAITqMphnFk2SY
 yq8ZyiGuts15jlifIAUhtUIZtFO4pPHuXXUC+a0/NeVnACn5MRgZoagdki682IRs17L7
 Eewg==
X-Gm-Message-State: AO0yUKUfBeG7YZC8peJO88bBKQT/iYtQd1lBKUUbpdr/4Y33SccLjg0J
 P4+hhbzjGsxUZ+b5D5iE7L5wOlfjLjK8pLmn9ec=
X-Google-Smtp-Source: AK7set+I1LwYU1A7tNe7sEmt8GqOEohDvA6OJZtgotvUOBbB+FwVOouUKAxLkWBdhdTXA3CYXsXb7lSsfyUDZSATgmI=
X-Received: by 2002:a67:e0cf:0:b0:3fc:3a9e:3203 with SMTP id
 m15-20020a67e0cf000000b003fc3a9e3203mr1019995vsl.84.1676550050445; Thu, 16
 Feb 2023 04:20:50 -0800 (PST)
MIME-Version: 1.0
References: <IA1PR20MB5743F5A364EB9E02890364F7DAA29@IA1PR20MB5743.namprd20.prod.outlook.com>
 <CAAMCDefEs9UorPKZ_M_PtvRNxbtaSE1U9-qr-hE=GnBV1dQbag@mail.gmail.com>
 <IA1PR20MB5743D9D4F74B307EE16353F0DAA09@IA1PR20MB5743.namprd20.prod.outlook.com>
In-Reply-To: <IA1PR20MB5743D9D4F74B307EE16353F0DAA09@IA1PR20MB5743.namprd20.prod.outlook.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 16 Feb 2023 06:20:38 -0600
Message-ID: <CAAMCDefLDvk29ZWCeA1DWRjOmBwRwb5aoH02=hVS-UAzUExXRw@mail.gmail.com>
To: Ganapathi Kamath <hgkamath@hotmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Besides caching at the dm layer, there is caching at the filesystem
layer (files, directories and other stuff).  The caching at the DM
layer is not the issue.

If rootfs mounts the dm-device someplace as a
(ntfs)filesystem(readonly), and then later you also mount that same
(ntfs)filesystem (read-write) someplace then you have mounted the
filesystem twice (not a shared bind mount that appears to be 2 mounts
but in reality is only a single mount), and the filesystem code is not
safe when there are 2 unique separate mount instances, the fs caching
is not shared.

ie if the filesystem is already mounted as a filesystem someplace
(mapping a dm device is not mounting) and you mount it a 2nd time then
you are at risk of corruption.

For the mount command to get a busy indicates that something has
already mounted it someplace and has locked the device(to prevent a
2nd corrupting mount from happening), and the entire purpose of the
module appears to be to disable the safety provided by this locking
and allow one to mount the fs again.

And note that with double mounts (usually I have seen/debugged the
crash/ouage from them with shared SAN storage)  they can "APPEAR" to
kind of work if you do not use them too much, but eventually the 2
instances of filesystem code step on each other and it ends badly
(kernel crash, data corruption, loss of the filesystem).

If you need this module so that you can use another (non-bind) mount
command someplace on the same device then you are double mounting.
The point of the busy device is that it is mounted someplace, and the
entire point of the module is to bypass the protection.

It is the filesystem code and filesystem caching that is not safe.
Both filesystems assume they have total control of filesystem data
structures, and at the very least the mount writing will change those
structures, and if the read-only mount may read blocks that were part
of one file but now aren't part of that file returning the wrong data.

On Wed, Feb 15, 2023 at 11:23 PM Ganapathi Kamath <hgkamath@hotmail.com> wrote:
>
>
> Firstly, thankyou for your reply. I'm not a kernel expert, so I value what you say.
> but as I raised the issue I felt I had to defend the usefulness, userbase and the need.
>
> > Typically double mounts are done via bind mounts (not really double
> > mounted just the device showing someplace else).   Or one would do a
> > mount -o remount,rw <originaldir> and remount it rw so you could write
> > to it.
>
> > A real double mount where the kernel fs modules manages both mounts as
> > if it was a separate device won't work reliably, as the filesystem
> > module/caching assumes it has total control.   So writing to a
> > read-write device that has a separate read-only mount with some data
> > in the read cache will not return the true data in all cases.    2
> > read-write (done any way--except with a clustering fs modules) are
> > going to cause corruption of the underlying filesystem.
>
> I want to clarify, even though ventoy uses the word 'remount' to describe the
> feature, the host file system isn't mounted twice.  There is no loopback-fs
> to bind mount. and dmsetup status shows linear sequences of blocks allocated
> to the devmapper device.
>
> For this feature to work, the Linux being booted up, creates the devmapper
> device by after having first somehow determined the sectors occupied by
> the file in the filesystem. Then mounts the partitions inside devmapper device
> and then pivots to the discovered rootfs and continues booting.
>
> So what I think you are saying is that a mount of /dev/sdc1 and
> /dev/mapper/ventoy are claiming to use the hard-disk sectors, and asking the
> kernel to consider them as part of its disk-sector caching mechanism.
>
> Booting virtual-disks this way is also called nativeboot.
> The way this nativeboot so far works, has a little danger.
> Three safe guards are to be followed by self contract:
> 1) The virtual-disk-file must be a fixed size, it cannot be allowed to grow or shrink.
> 2) The virtual-disk-file must not be manipulated/touched/read from the host-partition.
> 3) The filesystem driver shouldn't defrag, scrub or relocate the virtual-disk-file.
> This is so that the the file entry in the outside fs remains untouched.
> Usually, as this is done by root and such administrative user knows what he is
> doing, so it is not so much of a problem.
> If one adheres to the above self-contract, the filesystem code for partitions inside
> the dm-device does not interfere with the filesystem code for the outside partition.
>
> An idea just came to me. There maybe a way around the disk sector caching.
> Will this work or be more safer?
> What if, in addition to /dev/mapper/ventoy, a second dm device
> /dev/mapper/antiventoy of the same size of the host partition /dev/sdc1 is created
> by stitching together the other remaining sectors of the host partition /dev/sdc1,
> with the vdisk sectors swapped for with null sectors. Then the two dm created disks:
> /dev/mapper/ventoy and /dev/mapper/antiventoy can be mounted independently,
> without overlap of disk sectors, separating their caching.
> The self-contract will still be needed, to not alter the location/size of fs-entry.
> I'll suggest the above to ventoy. Your thoughts will be helpful.
>
> > Given that the use case for the module is dangerous and the use case
> > is of questionable usefulness I would think that is no point of the
> > module.  The module's intent seems to be to get around the exclusive
> > locks that the filesystem (for good reason) is putting on the device.
>
> I believe that the danger can be mitigated with a good idea and proper coding.
> But the door shouldn't be shut.
>
> Its usefulness and base of users is really there. The use case is really important
> 1) to those users who dualboot windows/linux, multi boot other OS-es
> and juggle between them for want of SSD space,
> 2) to multiboot alternate OS. but have limited on-machine disk-space
> 2) to mounting different live isos often, which are often re-downloaded due to updates.
> 3) to those keeping a host of recovery isos-s at hand for emergency like
> WINRE, WIN-installer, linux-installer, HBCD-PE, gparted, clonezilla,
> rescuezilla, seabios, samsung-wizard at hand,
>
> Why not a VM?:
> VM-s are nice but a bit slower than nativeboot. Many things cannot be done
> inside a VM such as get full native experience of a live iso, GPU support and all.
> Some system level recovery and repair tools must be booted as native.
>
> In the old days Harddisks, USB drives, iso files were small.
> vdisks were inexistent.
> One had to burn live-isos to cd/dvd. Disks have grown larger.
> Burning DVDs is such a waste now.
>
> At one point I considered having a small number of 8GB microsd cards to function
> just like tiny dvds/floppies. But managing them is also a hassle, as they are stored
> external.
>
> Disadvantages of flashing USB drive
> * flashing a USB drive, which say is 32gb, with a tiny <3gb ISO file. can result in it wasting
> space as it creates a small partition, limiting the drive's usefulness.
> * One doesn't want too many usb drives lying around to boot different iso-s
> * In my experience, flashing seems to have a higher frequency of bricking the USB key.
>
> With multiboot solutions, Its much easier to copy in and out liveisos between
> large filesytems ExFAT, NTFS, ext4 . Linux (as of 6.1) has mature fs driver for
> ExFAT(5.4) and NTFS (5.15)
>
> I've have tried creating my own grub2 configurations to loop mount isos.
> but then its too much work to maintain. One has to update grub2 config files
> everytime one downloads and deletes ISOs. Its preferable, that this is
> auto-detected or dynamically done.
>
> Then I considered other multiboot solutions like
> YUMI, Unetbootin, MultiBootUSB, supergrub2
>
> Ventoy seems to best them, by
> - automatic detection of isos with grub2 menu
> - also being able to nativeboot vdisks.
> Ventoy seems to be fork of grub2 with some additional code to handle vdisks.
>
> One problem with partitioning systems for multi-OS machines is that the
> limited disk space of a 512gb SSD drive gets broken and underutilized between partitions.
> This leaves less usable space in a home partition.
> Filesystems like btrfs allow having one big volume, installing an OS to
> subvolumes and allow booting from subvolumes. Thereby sharing unused
> space. One can then backup-up, offload and restoring subvolumes on need.
> but this isn't cross platform. and requires more mental cognitive involvement.
>
> Consider having windows and linux dual boot. and a data partition.
> One might give 64 gb to each OS. that means when booted into one OS, the
> space occupied by the other OS is a waste. before you know it, there is very
> little space on the SSD  due to all the OS partitions.
>
> Ventoy allows one to just keep a few 40gb vdisk files in the 512 gb partition.
> User can easily move all unused images an external backup, until later use.
>
> Now onto ventoy dm_patch itself.
> I tried reading the patch code dm_patch.c .
> It is strange to me. seems to be finding specifc addresses in memory;
> blanking them, inserting opcodes like 0x80, etc.
> The method taken (kernel/initramfs patching) is spooky.
> It also inserts code/scripts/files into the initramfs for liveisos, which it can do, because it
> is the bootloader, and its MOK (machine owner key) has been added to the UEFI.
> Even though ventoy seems to be honest trustable opensource GPL developer, you never
> know if the mechanism of side-patching initramfs and kernel allows for future exploits by
> malicious entities/governments.
> One wants to be tension free on that front and kernel developers have a responsibility
> to keep linux-users from straying over to risky solutions.
> This is apart from how duplicated work it seems to maintain it that I mentioned in the bug.
> A legit desirable feature shouldn't have to rely on these techniques.
> Its better, for the feature to exist with the blessing of kernel code review and signing
>
> Here, I'm not giving a 'because windows does, linux should do so too',
> justification. But, windows does do nativeboot of vhdx now since Win10-1903.
> Only, to mention, that nativebooting vdisks is a useful enough thing, that Microsoft
> also allows for it. As is the case for ventoy, the vhdx should be fixed-size and not be
> touched in the hosting drive. They note their common scenarios and benefits.
> https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/deploy-windows-on-a-vhd--native-boot?view=windows-11
> I configured a BCDBOOT/BCDEDIT entry to boot a HBCD-PE vhdx this way.
>
> If one completely abandoned windows, without the need for cross-platform usability,
> foregoing VM-attachable/host-mountable mountable vdisks. there could be other
> solutions such as btrfs subvolumes. But most home users laptops, come with windows,
> have limited space and getting rid of windows and windows compatible technology
> completely may not be an option.
>
> Are there dm-devel kernel developers, who have tried ventoy or explored ventoy like solutions.
> I do want to be assured that some dm-devel developer is put their great mind to this
> if at least on the backburner.
>
> Sorry if too verbose. I value your time.
> Thanks
> -Gana
>
> On Wed, Feb 15, 2023 at 3:33 AM Ganapathi Kamath <hgkamath@hotmail.com> wrote:
> >>
> >> I am just an ordinary user of Linux and ventoy .
> >> Q)
> >> https://github.com/ventoy/Ventoy/issues/2234
> >> Is what I have suggested here, meaningful?
> >> Is there contra-indications to not do it or an alternative suggestions?
> >> thoughts?
> >>
> >> Ventoy, a GPL software, uses a small kernel patch to achieve a small remountability feature.
> >> It seemed to me, that patching the kernel per distribution is sub-optimal.
> >> I couldn't find a previous relevant discussion on this on dm-devel, but it seems like a requirement would've been well known and this would have already been discussed. What does the actually patch do?
> >>
> >> Thx
> >> -Gana
> >>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> v https://listman.redhat.com/mailman/listinfo/dm-devel
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

