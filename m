Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F41C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-2GpUoAzOMAOVAV04abXAUg-1; Tue, 19 Apr 2022 02:10:36 -0400
X-MC-Unique: 2GpUoAzOMAOVAV04abXAUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE2C4804193;
	Tue, 19 Apr 2022 06:10:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7F2440FF41B;
	Tue, 19 Apr 2022 06:10:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A02951949762;
	Tue, 19 Apr 2022 06:10:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FB6319451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 15:25:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE22B404D2FB; Thu, 14 Apr 2022 15:25:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9601404E4AE
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 15:25:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96A821C0691E
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 15:25:46 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-BUwfvVJEPoOX_xwoGlxLCg-1; Thu, 14 Apr 2022 11:25:43 -0400
X-MC-Unique: BUwfvVJEPoOX_xwoGlxLCg-1
Received: from [192.168.0.175] (ip5f5aed13.dynamic.kabel-deutschland.de
 [95.90.237.19])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: buczek)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id 36EBE61EA1928;
 Thu, 14 Apr 2022 17:19:50 +0200 (CEST)
Message-ID: <4e83fb26-4d4a-d482-640c-8104973b7ebf@molgen.mpg.de>
Date: Thu, 14 Apr 2022 17:19:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com
From: Donald Buczek <buczek@molgen.mpg.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: [dm-devel] ext4_writepages: jbd2_start: 5120 pages, ino 11; err -5
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 it+linux@molgen.mpg.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

We have a cluster scheduler which provides each cluster job with a private scratch filesystem (TMPDIR). These are created when a job starts and removed when a job completes. The setup works by fallocate, losetup, mkfs.ext4, mkdir, mount, "losetup -d", rm and the teardown just does a umount and rmdir.

This works but there is one nuisance: The systems usually have a lot of memory and some jobs write a lot of data to their scratch filesystems. So when a job finishes, there often is a lot to sync by umount which sometimes takes many minutes and wastes a lot of I/O bandwidth. Additionally, the reserved space can't be returned and reused until the umount is finished and the backing file is deleted.

So I was looking for a way to avoid that but didn't find something straightforward. The workaround I've found so far is using a dm-device (linear target) between the filesystem and the loop device and then use this sequence for teardown:

- fcntl EXT4_IOC_SHUTDOWN with EXT4_GOING_FLAGS_NOLOGFLUSH
- dmestup reload $dmname --table "0 $sectors zero"
- dmsetup resume $dmname --noflush
- umount $mountpoint
- dmsetup remove --deferred $dmname
- rmdir $mountpoint

This seems to do what I want. The unnecessary flushing of the temporary data is redirected from the backing file into the zero target and it works really fast. There is one remaining problem though, which might be just a cosmetic one: Although ext4 is shut down to prevent it from writing, I sometimes get the error message from the subject in the logs:

[2963044.462043] EXT4-fs (dm-1): mounted filesystem without journal. Opts: (null)
[2963044.686994] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
[2963044.728391] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
[2963055.585198] EXT4-fs (dm-2): shut down requested (2)
[2963064.821246] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
[2963074.838259] EXT4-fs (dm-2): shut down requested (2)
[2963095.979089] EXT4-fs (dm-0): shut down requested (2)
[2963096.066376] EXT4-fs (dm-0): ext4_writepages: jbd2_start: 5120 pages, ino 11; err -5
[2963108.636648] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
[2963125.194740] EXT4-fs (dm-0): shut down requested (2)
[2963166.708088] EXT4-fs (dm-1): shut down requested (2)
[2963169.334437] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
[2963227.515974] EXT4-fs (dm-0): shut down requested (2)
[2966222.515143] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
[2966222.523390] EXT4-fs (dm-1): mounted filesystem without journal. Opts: (null)
[2966222.598071] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)

So I'd like to ask a few questions:

- Is this error message expected or is it a bug?
- Can it be ignored or is there a leak or something on that error path.
- Is there a better way to do what I want? Something I've overlooked?
- I consider to create a new dm target or add an option to an existing one, because I feel that "zero" underneath a filesystem asks for problems because a filesystem expects to read back the data that it wrote, and the "error" target would trigger lots of errors during the writeback attempts. What I really want is a target which silently discard writes and returns errors on reads. Any opinion about that?
- But to use devicemapper to eat away the I/O is also just a workaround to the fact that we can't parse some flag to umount to say that we are okay to lose all data and leave the filesystem in a corrupted state if this was the last reference to it. Would this be a useful feature?

Best
   Donald
-- 
Donald Buczek
buczek@molgen.mpg.de

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

