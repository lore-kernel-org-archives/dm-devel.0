From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: dd between thin provisioned devices
Date: Mon, 28 Jan 2013 10:06:20 +0100
Message-ID: <51063F8C.3090603@gmail.com>
References: <CABSD0hKsdtxyQCeZPzFhwpiKY7kmapkPxWJLFidK4VujHnTqTg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABSD0hKsdtxyQCeZPzFhwpiKY7kmapkPxWJLFidK4VujHnTqTg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: devicemapper niko <devicemapper.niko@gmail.com>
List-Id: dm-devel.ids

Dne 27.1.2013 11:01, devicemapper niko napsal(a):
> Hi,everyone
> if we dd between thin provisioned devices,
> can we just get allocated blocks copied ?

Nope - devices mapper target operates on block level - not on the filesystem
level - so it has no knowledge about file layout.

What I could eventually imagine is some kind of block compactification (just 
like kernel does for hugepages) - but it's currently not being developed....


> Will the output thin device get fully provisioned?
> I glanced through the dm-thin code,
> it turns out unmapped blocks return zeroed,am i right?

depends on settings - you could have either zeroed block or block
with content left on the disk - i.e. running thin with 1MB block/chunk size
means - before the first use whole 1MB must be zeroed - so it has its price.

> Is there a trick to tell upper applications that all u got are zeroes.
> or should they scan zeroed blocks themselves to trigger WRITE_SAME to reduce
> I/O load?


Documentation/device-mapper/thin-provisioning.txt
see flag: skip_block_zeroing

Eventually for lvm2   lvcreate --zero y|n for thin pool creation.

Zdenek
