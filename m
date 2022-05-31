Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD161C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 31 May 2022 10:47:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-RDsz6ns8N7mdAZ4jch_lyg-1; Tue, 31 May 2022 06:47:50 -0400
X-MC-Unique: RDsz6ns8N7mdAZ4jch_lyg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D25203C0ED4F;
	Tue, 31 May 2022 10:47:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F8DC492CA2;
	Tue, 31 May 2022 10:47:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D62C194705E;
	Tue, 31 May 2022 10:47:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE641194705C
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 10:47:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9556A400E88E; Tue, 31 May 2022 10:47:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 917F3404754D
 for <dm-devel@redhat.com>; Tue, 31 May 2022 10:47:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 792F33C0ED48
 for <dm-devel@redhat.com>; Tue, 31 May 2022 10:47:46 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-VEg29e7dOJ2xRcRxiJb6iw-1; Tue, 31 May 2022 06:47:45 -0400
X-MC-Unique: VEg29e7dOJ2xRcRxiJb6iw-1
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
 by smtp-out2.suse.de (Postfix) with ESMTP id BACC11F975;
 Tue, 31 May 2022 10:38:34 +0000 (UTC)
Received: from quack3.suse.cz (unknown [10.163.28.18])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by relay2.suse.de (Postfix) with ESMTPS id A88F82C141;
 Tue, 31 May 2022 10:38:34 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id 3955DA0633; Tue, 31 May 2022 12:38:34 +0200 (CEST)
Date: Tue, 31 May 2022 12:38:34 +0200
From: Jan Kara <jack@suse.cz>
To: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <20220531103834.vhscyk3yzsocorco@quack3.lan>
References: <4e83fb26-4d4a-d482-640c-8104973b7ebf@molgen.mpg.de>
MIME-Version: 1.0
In-Reply-To: <4e83fb26-4d4a-d482-640c-8104973b7ebf@molgen.mpg.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] ext4_writepages: jbd2_start: 5120 pages, ino 11;
 err -5
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
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 linux-ext4@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 it+linux@molgen.mpg.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Late reply but maybe it is still useful :)

On Thu 14-04-22 17:19:49, Donald Buczek wrote:
> We have a cluster scheduler which provides each cluster job with a
> private scratch filesystem (TMPDIR). These are created when a job starts
> and removed when a job completes. The setup works by fallocate, losetup,
> mkfs.ext4, mkdir, mount, "losetup -d", rm and the teardown just does a
> umount and rmdir.
> 
> This works but there is one nuisance: The systems usually have a lot of
> memory and some jobs write a lot of data to their scratch filesystems. So
> when a job finishes, there often is a lot to sync by umount which
> sometimes takes many minutes and wastes a lot of I/O bandwidth.
> Additionally, the reserved space can't be returned and reused until the
> umount is finished and the backing file is deleted.
> 
> So I was looking for a way to avoid that but didn't find something
> straightforward. The workaround I've found so far is using a dm-device
> (linear target) between the filesystem and the loop device and then use
> this sequence for teardown:
> 
> - fcntl EXT4_IOC_SHUTDOWN with EXT4_GOING_FLAGS_NOLOGFLUSH
> - dmestup reload $dmname --table "0 $sectors zero"
> - dmsetup resume $dmname --noflush
> - umount $mountpoint
> - dmsetup remove --deferred $dmname
> - rmdir $mountpoint
> 
> This seems to do what I want. The unnecessary flushing of the temporary data is redirected from the backing file into the zero target and it works really fast. There is one remaining problem though, which might be just a cosmetic one: Although ext4 is shut down to prevent it from writing, I sometimes get the error message from the subject in the logs:
> 
> [2963044.462043] EXT4-fs (dm-1): mounted filesystem without journal. Opts: (null)
> [2963044.686994] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
> [2963044.728391] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
> [2963055.585198] EXT4-fs (dm-2): shut down requested (2)
> [2963064.821246] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
> [2963074.838259] EXT4-fs (dm-2): shut down requested (2)
> [2963095.979089] EXT4-fs (dm-0): shut down requested (2)
> [2963096.066376] EXT4-fs (dm-0): ext4_writepages: jbd2_start: 5120 pages, ino 11; err -5
> [2963108.636648] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
> [2963125.194740] EXT4-fs (dm-0): shut down requested (2)
> [2963166.708088] EXT4-fs (dm-1): shut down requested (2)
> [2963169.334437] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
> [2963227.515974] EXT4-fs (dm-0): shut down requested (2)
> [2966222.515143] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
> [2966222.523390] EXT4-fs (dm-1): mounted filesystem without journal. Opts: (null)
> [2966222.598071] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)

> 
> So I'd like to ask a few questions:
> 
> - Is this error message expected or is it a bug?

Well, shutdown is not 100% tuned for clean teardown. It is mostly a testing
/ debugging aid.

> - Can it be ignored or is there a leak or something on that error path.

The error recovery path should be cleaning up everything. If not, that
would be a bug :)

> - Is there a better way to do what I want? Something I've overlooked?

Why not just rm -rf $mountpoint/*? That will remove all dirty data from
memory without writing it back. It will cost you more in terms of disk IOs
than the above dance with shutdown but unless you have many files, it
should be fast... And it is much more standard path than shutdown :).

> - I consider to create a new dm target or add an option to an existing
> one, because I feel that "zero" underneath a filesystem asks for problems
> because a filesystem expects to read back the data that it wrote, and the
> "error" target would trigger lots of errors during the writeback
> attempts. What I really want is a target which silently discard writes
> and returns errors on reads. Any opinion about that?

> - But to use devicemapper to eat away the I/O is also just a workaround
> to the fact that we can't parse some flag to umount to say that we are
> okay to lose all data and leave the filesystem in a corrupted state if
> this was the last reference to it. Would this be a useful feature?

I think something like this might be useful if the "rm -rf" solution is too
slow. But it is a bit of a niche usecase ;).


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

