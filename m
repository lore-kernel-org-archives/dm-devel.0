From: "David Strand" <dpstrand@gmail.com>
Subject: Re: fdisk on a multipath device fails kernel partition
	re-read
Date: Fri, 28 Sep 2007 15:48:28 -0700
Message-ID: <448b15030709281548q246dc915i933bcf1147cd69d1@mail.gmail.com>
References: <448b15030709281328i104c04f0te6dd1ef333b825a3@mail.gmail.com>
	<5fb0f77b0709281332n56832c2bocfec48077040887a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5fb0f77b0709281332n56832c2bocfec48077040887a@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'd like to have multiple partitions rather than one large disk.

What if one of your paths fails during the mkfs on the single path'd /dev/sdX?

I am adding auto partition/format/mount capability (triggered by udev
add events). A reboot between the sfdisk and mkfs.ext3 will not be
possible. I would really like to operate on multipathed device nodes
the whole way through to handle possible path failure during the
process and because the ultimate mount point will be to the
multipathed partition device node.

Any other suggestions?


On 9/28/07, Kevin Foote <kevin.foote@gmail.com> wrote:
> I alwase use the entire disk .. no partitions, and I usually do mkfs on the
> underlying /dev/sdX device before
> I bother with multipath..
> Then I just use the /dev/mapper entries for  actual mounts .. the
> underlying FS is already there.
> just my .02
>
>  mkfs.ext3 -F /dev/sdX
>
>
> On 9/28/07, David Strand <dpstrand@gmail.com> wrote:
> >
> > When I perform an fdisk or sfdisk on a /dev/mapper/ multipath device I
> > get a warning about it failing to re-read the partition information.
> > With fdisk it warns that I'll need to reboot before using the device,
> > with sfdisk it just complains about the ioctl that failed:
> >
> > Re-reading the partition table ...
> > BLKRRPART: Invalid argument
> >
> > Is it possible I have something configured wrong? Or is this a problem
> > with the way /dev/mapper nodes work? I get the same result when using
> > /dev/dm-* nodes. With the raw device nodes such as /dev/sd* it works
> > ok.
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
>
>
> --
> :wq!
> kevin.foote
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
