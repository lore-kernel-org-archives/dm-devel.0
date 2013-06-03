From: Will Drewry <redpig@dataspill.org>
Subject: Re: DM-Verity Tool
Date: Mon, 3 Jun 2013 07:39:16 -0500
Message-ID: <CABmXcB8YmL83K_VZCiDLEqmDxC4KZV8O3qe8kEzXNmLtEitF1g@mail.gmail.com>
References: <22416.192.168.200.1.1369149109.squirrel@gesmail.globaledgesoft.com>
	<519CA6F0.3000309@redhat.com> <519CF66C.8010808@gmail.com>
	<20204.192.168.200.1.1369291275.squirrel@gesmail.globaledgesoft.com>
	<519E806C.1050903@gmail.com>
	<7641.192.168.200.1.1369931315.squirrel@gesmail.globaledgesoft.com>
	<Pine.LNX.4.64.1305310828100.9885@file.rdu.redhat.com>
	<59955.192.168.200.1.1370016939.squirrel@gesmail.globaledgesoft.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <59955.192.168.200.1.1370016939.squirrel@gesmail.globaledgesoft.com>
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
Cc: Marian Csontos <mcsontos@redhat.com>, pavankumar.p@globaledgesoft.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Fri, May 31, 2013 at 11:15 AM, <pavankumar.p@globaledgesoft.com> wrote:
>
> Hi Mikulas,
>
> Thanks for the reply.
>
> Pavan>> 5. How to update DM-Veirty device without removing device mapping.
> I tried mounting the dm-verity target but it fails
> Mikulas>
> Mikulas> You can't update it.
> Mikulas>
> Mikulas> If you want to update it, you need to unmount the filesystem,
> unload the dm-verity target, mount the underlying device read-write, make
> changes, unmount it, recreate checksums with veritysetup, load the
> dm-verity target and mount it read only.
>
> If the filesystem is mounted as read-only, how the filesystem can be
> modified or corrupted (without removing mapping)? How we can test the
> dm-verity functionality?
>

I believe Milan already pointed out a test example, but the very
easiest way to it is to dd data over part of the underlying block
device, then dd it out via the dm-verity device.  If the system has
already read it, you'll need to drop_caches first.  Something like:

dd if=/dev/zero of=/dev/sdb3 bs=1 count=1 seek=4097 #write somewhere
that was non-zero
echo 3 > /proc/sys/vm/drop_caches
dd if=/dev/dm-0 of=/dev/null bs=1 count=1 skip=4097 #read, get EIO

hth,
will

> >
> > On Thu, 30 May 2013, pavankumar.p@globaledgesoft.com wrote:
> >
> >> Hi All,
> >>    Thanks for your answers to previous questions. I have some more
> >> doubts
> >> regarding DM-Verity please clarify it.
> >> 1. When dm-verity validation fails, do we lose access to the file?  And
> how
> >> about accessing the rest of the filesystem?
> >
> > You lose access to the affected files, but the rest of the filesystem is
> still accessible.
> >
> >> 2. Is there any recovery mechanism for a validation failure?
> >
> > No.
> >
> >> 3. How do we update a DM-Verity filesystem?  Can it be done on a file
> basis?
> >> I believe that dm-verity works on the blocks & not on the file system, is
> >> that true?
> >
> > You don't update it. You create the filesystems, then calculate
> dm-verity
> > checksums and then mount it read only.
> >
> > Yes, dm-verity works on blocks.
> >
> >> 4. Can we use dm-verity for any filesystem (say UBIFS)? Is there any
> restriction on filesystem?
> >
> > You can use it for any filesystem.
> >
> >> 5. How to update DM-Veirty device without removing device mapping. I tried
> >> mounting the dm-verity target but it fails
> >
> > You can't update it.
> >
> > If you want to update it, you need to unmount the filesystem, unload the
> dm-verity target, mount the underlying device read-write, make changes,
> unmount it, recreate checksums with veritysetup, load the dm-verity
> target
> > and mount it read only.
> >
> >> Thanks in advance,
> >> Pavan Kumar P
> >
> > Mikulas
> >
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
