Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F3EC636D4
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 20:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675284399;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8WC3lRsnF+NIskgZFZXkOIGisyjQUsKj/5q9JJPHM48=;
	b=QUyX8a0Fw3s0u76rBFSXHwzEO5VmdQ+zxx0qMX916ffhNDoUed5IDik5b9PfKmnO57tyvO
	HNF6l0PbnTjHjQe8lHha5L5JoPOWBqINbwilOMI7OUgzhK3M7UDJqI4xHqyueFJchMR99a
	YOpiXIka2X0ymNtD4PtQTJm1ZL+g+EY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-qWyQH051M36-V1nFfEQfGw-1; Wed, 01 Feb 2023 15:46:38 -0500
X-MC-Unique: qWyQH051M36-V1nFfEQfGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17FF7181E3FA;
	Wed,  1 Feb 2023 20:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DF712026D4B;
	Wed,  1 Feb 2023 20:46:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CB7C19465A3;
	Wed,  1 Feb 2023 20:46:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DAF42194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 08:18:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E4BE1121330; Wed,  1 Feb 2023 08:18:19 +0000 (UTC)
Received: from localhost (ovpn-13-89.pek2.redhat.com [10.72.13.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C501D112132C;
 Wed,  1 Feb 2023 08:18:18 +0000 (UTC)
Date: Wed, 1 Feb 2023 16:18:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Coiby Xu <coxu@redhat.com>
Message-ID: <Y9ogR0/zPRBGI1kq@MiWiFi-R3L-srv>
References: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221104113000.487098-1-coxu@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 01 Feb 2023 20:46:35 +0000
Subject: Re: [dm-devel] [RFC v2 0/5] Support kdump with LUKS encryption by
 reusing LUKS volume key
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
Cc: kexec@lists.infradead.org, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Coiby,

On 11/04/22 at 07:29pm, Coiby Xu wrote:
> RFC v2
>  - libcryptsetup interacts with the kernel via sysfs instead of "hacking"
>    dm-crypt 
>    - to save a kdump copy of the LUKS volume key in 1st kernel
>    - to add a logon key using the copy for libcryptsetup in kdump kernel [Milan]
>    - to avoid the incorrect usage of LUKS master key in dm-crypt [Milan]
>  - save the kdump copy of LUKS volume key randomly [Jan]
>  - mark the kdump copy inaccessible [Pingfan]
>  - Miscellaneous
>    - explain when operations related to the LUKS volume key happen [Jan]
>    - s/master key/volume key/g
>    - use crash_ instead of kexec_ as function prefix
>    - fix commit subject prefixes e.g. "x86, kdump" to x86/crash
> 
> With kdump enabled, when the 1st kernel crashes, the system could boot
> into the kdump/crash kernel and dump the memory image i.e. /proc/vmcore
> to a specified target. Currently, when dumping vmcore to a LUKS
> encrypted device, there are two problems,

I went through this patchset, have some concerns. Do you mind sending a
formal patchset with some adjustment?

1) maybe put the luks key handling related to crash_dump out into
a separate file. e.g kernel/crash_dump_luks.c. This will reduce the code
complexity to other kdump code from luks handling. At least from code
reading side.
2) please rearrange your patches order so that generic luks handling at
the beginning. Then the x86 specific code comes next. Please refer to
below patchset. Like this, other arch can easily add its specific code
accordingly.

[PATCH v18 0/7] crash: Kernel handling of CPU and memory hot un/plug

And I am wondering
1) in what proportion the luks system is used,
2) in which cases the dumped vmcore have to be saved into luks disk,
   no workaround?
3) with the 1 hour aging of luks key, to what extent it's still
   worthwhile to add the support of luks kdumping? E.g for me, I have
   been using Fedora, and often start kexec-tools service when I need to
   do test kdump w/o reboot. With that, the key has aged.

I am not familiar with LUKS and it's key mechanism, my above concerns
could be shallow, anyone please help clarify if it does impact. Please
also show your support if this adding is really helpful.

Thanks
Baoquan

> 
>  - for some machines, a system administrator may not have a chance to
>    enter the password to decrypt the device in kdump initramfs after the
>    1st kernel crashes 
> 
>  - LUKS2 by default use the memory-hard Argon2 key derivation function
>    which is quite memory-consuming compared to the limited memory reserved
>    for kdump. Take Fedora example, by default, only 256M is reserved for
>    systems having memory between 4G-64G. With LUKS enabled, ~1300M needs
>    to be reserved for kdump. Note if the memory reserved for kdump can't
>    be used by 1st kernel i.e. an user sees ~1300M memory missing in the
>    1st kernel. 
>  
> Besides users (at least for Fedora) usually expect kdump to work out of
> the box i.e. no manual password input is needed. And it doesn't make
> sense to derivate the key again in kdump kernel which seems to be
> redundant work.
> 
> Based on Milan's feedback [1] on Kairui's ideas to support kdump with
> LUKS encryption, this patch set addresses the above issues by reusing
> the LUKS volume key in kdump kernel and here is the life cycle of this
> kdump copy of LUKS volume key,
> 
>  1. After the 1st kernel loads the initramfs during boot, systemd
>     asks for a passphrase from the user and uses it to de-crypt the LUKS
>     volume key
> 
>  2. After the 1st kernel saving the volume key as a logon key,
>     libcrytpsetup notifies the kernel to read this logon key and store a
>     temporary copy by writing the key description to
>     /sys/kernel/crash_luks_volume_key
> 
>  3. After switching to the real root fs, kdump.serivce is started and it 
>     loads the kdump kernel using the kexec_file_load syscall
> 
>  4. The kexec_file_load syscall saves the temporary copy of the volume
>     key to kdump reserved memory and wipe the copy.
> 
>  5. When the 1st kernel crashes and kdump kernel is booted,
>     libcryptsetup asks the kdump kernel to add a logon key using
>     the volume key stored in kdump reserved memory by writing the key
>     description to /sys/kernel/crash_luks_volume_key
> 
>  6. The system gets rebooted to the 1st kernel after dumping vmcore to
>     the LUKS encrypted device is finished
> 
> Note the kdump copy of LUKS volume key never leaves the kernel space and
> is saved in the memory area exclusively reserved for kdump where even
> the 1st kernel has no direct access. 
> 
> Milan's major concern [2] on previous version is "storing the encryption
> key to yet another place are creating another attack vector". To further
> secure this copy, two additional protections are added,
>  - save the copy randomly in kdump reserved memory as suggested by Jan
>  - clear the _PAGE_PRESENT flag of the page that stores the copy as
>    suggested by Pingfan
> 
> If there is no further security concern with this approach or any other
> concern, I will drop the following assumptions,
>   - only x86 is supported
>   - there is only one LUKS device for the system
> 
> to extend the support to other architectures including POWER, ARM and
> s390x and address the case of multiple LUKS devices. Any feedback will be 
> appreciated, thanks!
> 
> For a proof of concept, I've patched cryptsetup [3] in a quick-and-dirty
> way to support a new option "--kdump-kernel-master-key"
> and hacked systemd [4]. It works for Fedora 35.
> 
> [1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/
> [2] https://lwn.net/ml/linux-kernel/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
> [3] https://gitlab.com/coxu/cryptsetup/-/commit/750a46d933fac82e0c994b5c41de40a0b8cac647
> [4] https://github.com/coiby/systemd/tree/reuse_kdump_master_key
> 
> Coiby Xu (5):
>   kexec_file: allow to place kexec_buf randomly
>   crash_dump: save the LUKS volume key temporarily
>   x86/crash: pass the LUKS volume key to kdump kernel
>   x86/crash: make the page that stores the LUKS volume key inaccessible
>   crash_dump: retrieve LUKS volume key in kdump kernel
> 
>  arch/x86/include/asm/crash.h       |   1 +
>  arch/x86/kernel/crash.c            |  47 ++++++-
>  arch/x86/kernel/kexec-bzimage64.c  |   7 +
>  arch/x86/kernel/machine_kexec_64.c |  16 +++
>  include/linux/crash_core.h         |   2 +
>  include/linux/crash_dump.h         |   2 +
>  include/linux/kexec.h              |   6 +
>  kernel/crash_dump.c                | 200 +++++++++++++++++++++++++++++
>  kernel/kexec_file.c                |  15 +++
>  kernel/ksysfs.c                    |  19 +++
>  10 files changed, 314 insertions(+), 1 deletion(-)
> 
> -- 
> 2.37.3
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

