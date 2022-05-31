Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70617C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 07:10:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-WJ32DfydOAm9tRwypwpibg-1; Wed, 01 Jun 2022 03:10:25 -0400
X-MC-Unique: WJ32DfydOAm9tRwypwpibg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 007041857F02;
	Wed,  1 Jun 2022 07:10:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87B2E1410DDB;
	Wed,  1 Jun 2022 07:10:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5012F194706E;
	Wed,  1 Jun 2022 07:10:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F25B01947065
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 13:57:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE4F9416362; Tue, 31 May 2022 13:57:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9FC4492C3B
 for <dm-devel@redhat.com>; Tue, 31 May 2022 13:57:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 681F8857FAD
 for <dm-devel@redhat.com>; Tue, 31 May 2022 13:57:16 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-x3Fk3FepOYaxx9LbIIymZw-1; Tue, 31 May 2022 09:57:14 -0400
X-MC-Unique: x3Fk3FepOYaxx9LbIIymZw-1
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de
 [141.14.31.7])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: buczek)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0CE5C61EA1928;
 Tue, 31 May 2022 15:48:11 +0200 (CEST)
To: Jan Kara <jack@suse.cz>
References: <4e83fb26-4d4a-d482-640c-8104973b7ebf@molgen.mpg.de>
 <20220531103834.vhscyk3yzsocorco@quack3.lan>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <3bfd0ad9-d378-9631-310f-0a1a80d8e482@molgen.mpg.de>
Date: Tue, 31 May 2022 15:48:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220531103834.vhscyk3yzsocorco@quack3.lan>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 01 Jun 2022 07:10:21 +0000
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/31/22 12:38 PM, Jan Kara wrote:
> Late reply but maybe it is still useful :)

That's very welcome!

> On Thu 14-04-22 17:19:49, Donald Buczek wrote:
>> We have a cluster scheduler which provides each cluster job with a
>> private scratch filesystem (TMPDIR). These are created when a job starts
>> and removed when a job completes. The setup works by fallocate, losetup,
>> mkfs.ext4, mkdir, mount, "losetup -d", rm and the teardown just does a
>> umount and rmdir.
>>
>> This works but there is one nuisance: The systems usually have a lot of
>> memory and some jobs write a lot of data to their scratch filesystems. So
>> when a job finishes, there often is a lot to sync by umount which
>> sometimes takes many minutes and wastes a lot of I/O bandwidth.
>> Additionally, the reserved space can't be returned and reused until the
>> umount is finished and the backing file is deleted.
>>
>> So I was looking for a way to avoid that but didn't find something
>> straightforward. The workaround I've found so far is using a dm-device
>> (linear target) between the filesystem and the loop device and then use
>> this sequence for teardown:
>>
>> - fcntl EXT4_IOC_SHUTDOWN with EXT4_GOING_FLAGS_NOLOGFLUSH
>> - dmestup reload $dmname --table "0 $sectors zero"
>> - dmsetup resume $dmname --noflush
>> - umount $mountpoint
>> - dmsetup remove --deferred $dmname
>> - rmdir $mountpoint
>>
>> This seems to do what I want. The unnecessary flushing of the temporary data is redirected from the backing file into the zero target and it works really fast. There is one remaining problem though, which might be just a cosmetic one: Although ext4 is shut down to prevent it from writing, I sometimes get the error message from the subject in the logs:
>>
>> [2963044.462043] EXT4-fs (dm-1): mounted filesystem without journal. Opts: (null)
>> [2963044.686994] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
>> [2963044.728391] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
>> [2963055.585198] EXT4-fs (dm-2): shut down requested (2)
>> [2963064.821246] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
>> [2963074.838259] EXT4-fs (dm-2): shut down requested (2)
>> [2963095.979089] EXT4-fs (dm-0): shut down requested (2)
>> [2963096.066376] EXT4-fs (dm-0): ext4_writepages: jbd2_start: 5120 pages, ino 11; err -5
>> [2963108.636648] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
>> [2963125.194740] EXT4-fs (dm-0): shut down requested (2)
>> [2963166.708088] EXT4-fs (dm-1): shut down requested (2)
>> [2963169.334437] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
>> [2963227.515974] EXT4-fs (dm-0): shut down requested (2)
>> [2966222.515143] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
>> [2966222.523390] EXT4-fs (dm-1): mounted filesystem without journal. Opts: (null)
>> [2966222.598071] EXT4-fs (dm-2): mounted filesystem without journal. Opts: (null)
> 
>>
>> So I'd like to ask a few questions:
>>
>> - Is this error message expected or is it a bug?
> 
> Well, shutdown is not 100% tuned for clean teardown. It is mostly a testing
> / debugging aid.
> 
>> - Can it be ignored or is there a leak or something on that error path.
> 
> The error recovery path should be cleaning up everything. If not, that
> would be a bug :)
> 
>> - Is there a better way to do what I want? Something I've overlooked?
> 
> Why not just rm -rf $mountpoint/*? That will remove all dirty data from
> memory without writing it back. It will cost you more in terms of disk IOs
> than the above dance with shutdown but unless you have many files, it
> should be fast... And it is much more standard path than shutdown :).

This is in fact what we are doing now, after I've rejected the above solution
because of the fear of a leak on the probably not so well tested error path.

You answer encourages me to maybe just try it. The problem is, that if a few pages
or inodes keep hanging around only occasionally, the systems would probably need month
and month until this manifest as a problem. So I'd never know when to declare the
test as finished and trust the solution.

The "rm -r" does help a bit but not as much as I've hoped. It might take half
the time for some workloads but it is still in the same order of magnitude
for typical loads.

>> - I consider to create a new dm target or add an option to an existing
>> one, because I feel that "zero" underneath a filesystem asks for problems
>> because a filesystem expects to read back the data that it wrote, and the
>> "error" target would trigger lots of errors during the writeback
>> attempts. What I really want is a target which silently discard writes
>> and returns errors on reads. Any opinion about that?
>
>> - But to use devicemapper to eat away the I/O is also just a workaround
>> to the fact that we can't parse some flag to umount to say that we are
>> okay to lose all data and leave the filesystem in a corrupted state if
>> this was the last reference to it. Would this be a useful feature?
> 
> I think something like this might be useful if the "rm -rf" solution is too
> slow. But it is a bit of a niche usecase ;).

I've abandoned the "dm"-path as well, more or less for the same reason:
This would trigger seldom used error paths in the filesystem.

Aside from the already mentioned one, I could think of others usecases:

- You've already unplugged a removable drive. Whatever happened to the data on
the device already happened and you just want to make sure, the system releases
all resources.

- Anything which uses file system images where the final state of the image
doesn't need to be kept (build systems, test systems).

Another idea I've had is to add a ioctl for the block layer which just undirtyes all
pages which go to that backing device. It would help for file data only, not for
the metadata, but I guess that would be enough. I wouldn't need to mess with the
layer under the filesystem. Good idea or bad idea?

But I have the feeling this would be complicated taking all the required locking
and possible in-flight states into account. This could well be over my level. And
it would never be accepted upstream, so I'd need to forward-port that forever.


Thanks!

   Donald

> 								Honza


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

