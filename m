From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: blockdev --flushbufs required [was: parted
	issue/question
Date: Wed, 18 Jan 2012 15:05:14 +0100
Message-ID: <4F16D19A.9030405@redhat.com>
References: <4F13ADB3.5070806@redhat.com> <87lip6t157.fsf@rho.meyering.net>
	<20120118003802.GA11769@agk-dp.fab.redhat.com>
	<87haztruph.fsf_-_@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87haztruph.fsf_-_@rho.meyering.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 18.1.2012 14:44, Jim Meyering napsal(a):
> [Following up on this thread:
>   http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/14999]
>
> Alasdair G Kergon wrote:
>> Try
>>    blkdev --flushbufs
>> after any cmd that writes to a dev to see if that makes any difference.
>
> Thanks for the work-around.
> Using "blockdev --flushbufs $dev" does indeed make parted
> behave the same with dm-backed storage as with other devices.
>
> Adjusting my small example,
>
>    cd /tmp; truncate -s 10m g&&  loop=$(losetup --show -f g)
>    echo 0 100 linear $loop 0 | dmsetup create zub
>    dev=/dev/mapper/zub
>    parted -s $dev \
>      mklabel gpt \
>      mkpart efi 34s 34s \
>      mkpart root 35s 35s \
>      mkpart roo2 36s 36s \
>      u s p
>    blockdev --flushbufs $dev # FIXME: required with device-mapper-1.02.65-5
>
>    # write random bits to p1
>    dd of=${dev}p1 if=/dev/urandom count=1
>    dd if=${dev}p1 of=p1-copy.pre count=1
>    parted -s $dev mkpart p4 37s 37s
>    blockdev --flushbufs $dev # FIXME: required with device-mapper-1.02.65-5
>
>    dd if=${dev}p1 of=p1-copy.post count=1
>    cmp -l p1-copy.pre p1-copy.post
>
> With that, the "cmp" show no differences.
>
> Does this sound like a problem in device-mapper land,
> or in how parted interacts with DM?


Just my wild guess it could be related to wrong assumption that close of 
descriptor means automatic flush - this is only true in the case, there is 
only one user for descriptor so it would be the last user - but if e.g. the 
device is opened more then once, then close doesn't mean flush - so I'd have 
assume some application is missing fsync(fd) before doing close(fd).

Zdenek
