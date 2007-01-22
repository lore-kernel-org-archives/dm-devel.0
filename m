From: "roland" <devzero@web.de>
Subject: Re: bug in dm-loop? - was:Re: Re: device mapper
	integrated loops - and one more year !
Date: Mon, 22 Jan 2007 23:00:58 +0100
Message-ID: <083901c73e70$ccd85f60$eeeea8c0@aldipc>
References: <1574903375@web.de> <45B48B50.8070009@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <breeves@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Bryn,

> I'll also get the version on kernel.org updated - thanks for catching 
> this!

thanks very much for that quick patch - it works as expected and the kernel 
oops went away!

since i want to use dm-loop for having a large number of loop-devices, i did 
some more "hardcore testing". ;)

so, i wrote a little test script which created a lot of dummy-files and 
turning them into a dm-loop target.

this worked very well - must have been around 3000 loop-targets when i got 
this one:

# device-mapper: reload ioctl failed: not enough memory available

and in dmesg:

Jan 22 22:42:06 localhost device-mapper: loop: Finalized extent map of 56 
bytes, 2 entries.
Jan 22 22:42:08 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:08 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:09 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:09 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:10 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:10 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:10 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:10 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:10 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:10 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:12 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:13 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:13 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:13 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:13 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0
Jan 22 22:42:13 localhost dmlosetup: page allocation failure. order:4, 
mode:0xd0
Jan 22 22:42:13 localhost  [<c015e1a2>] __alloc_pages+0x272/0x2f0


this was on a system with 256 MB of ram.

i assume, that i ran out of some kernel-buffer memory.

ok, not a real problem for me since i don`t expect having that much number 
of iso images on my cd-roms server to be loopback mounted, but - anyway - 
could you probably give a comment on this ?

is this some "natural limitation" due to dm-loop or device mapper consuming 
kernel-memory, or could this be another bug ?

regards
roland





----- Original Message ----- 
From: "Bryn M. Reeves" <breeves@redhat.com>
To: <devzero@web.de>
Cc: <agk@redhat.com>; <dm-devel@redhat.com>
Sent: Monday, January 22, 2007 11:00 AM
Subject: Re: bug in dm-loop? - was:Re: Re: device mapper integrated loops - 
and one more year !


> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> devzero@web.de wrote:
>>
>> i was doing some testing of dm-loop with latest dmsetup on a 2.6.20-rc5 
>> system.
>>
>> i did some basic test, which seems to work ok.
>>
>> i can now map a file to become /dev/mapper/loop0
>>
>> dmlosetup loop0 test.img
>>
>> -> device-mapper: loop: Finalized extent map of 1232 bytes, 44 entries.
>>
>> root@localhost ~ # ls -la /dev/mapper/loop0
>> brw------- 1 root root 252, 0 21. Jan 17:25 /dev/mapper/loop0
>
> Great! Am glad this much is working for you!
>
>>
>> while fiddling around a little bit, i accidentally tried to map that file 
>> a second time - anyway, i would expect this is quite ok and should work.
>>
>> dmlosetup loop1 test.img
>>
>> this bails out with the following error, leaving trace in dmesg:
>>
>> device-mapper: loop: file is already in use: 
>> /root/device-mapper/dmsetup/test.dat
>> BUG: unable to handle kernel NULL pointer dereference at virtual address 
>> 00000000
>>  printing eip:
>> d097589c
>> *pde = 00000000
>> Oops: 0000 [#1]
>
> The dm-loop target only allows a file to be mapped once. That said, it
> should just return the error, not oops the kernel!
>
> This is fixed in my CVS copy of this patch - I'm attaching a patch that
> you can apply on top of the one that you already have that includes this
> fix plus a couple of other minor fixes/enhancements.
>
> I'll also get the version on kernel.org updated - thanks for catching 
> this!
>
>> after this, if i do
>> dmlosetup -d loop1
>> dmlosetup -d loop0
>>
>> i cannot "rmmod dm-loop" , now telling me "device is in use", but it 
>> isn`t !
>>
>> so, this looks like a bug to me, leaving dm-loop in an inconsitent state.
>
> Unfortunately, after an oops in a kernel module you're pretty much
> forced to reboot - the kernel terminates the code path that caused the
> fault, leaving a hanging reference count on the module.
>
>> furthermore, one question about naming conventions :
>>
>> dmlosetup testloop1 test.dat
>> dmlosetup: Could not parse loop_device testloop1
>> Usage:
>>
>> losetup [-d|-a] [-e encryption] [-o offset] [-f|loop_device] [file]
>>
>> Couldn't process command line.
>>
>>
>> so, it`s mandatory that loop_device needs to begin with "loop...." !?
>>
>
> It is at the moment :) The current command line parameters try to be as
> faithful as possible to the nomrmal losetup, where devices are normally
> named as (/dev/)loopN. We can't exactly match that without disrupting
> users of the regular loop driver though, so this should probably be 
> relaxed.
>
> Thanks for testing!
>
> Bryn.
>
>
>
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.5 (GNU/Linux)
> Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org
>
> iD8DBQFFtItQ6YSQoMYUY94RAijWAJ47OJL21+0W3yiMqbq51k3EHAw0WACfaefN
> PjSa8djCMZuyZ/gGyUAikp0=
> =3bv3
> -----END PGP SIGNATURE-----
>


--------------------------------------------------------------------------------


> --- drivers/md/dm-loop.c.rel 2007-01-22 09:45:04.000000000 +0000
> +++ drivers/md/dm-loop.c 2007-01-22 09:45:10.000000000 +0000
> @@ -22,7 +22,7 @@
> #include "dm-bio-record.h"
>
> #define DM_MSG_PREFIX "loop"
> -#define LOOP_MAX_EXTENTS 1024
> +#define LOOP_MAX_EXTENTS 2048
>
> #define DMLOOP_READONLY 0x01
> #define DMLOOP_SYNC 0x02
> @@ -69,7 +69,7 @@ struct loop_c {
> };
>
> #ifdef CONFIG_DM_DEBUG
> -static void dump_extent(struct extent *e)
> +static void dump_extent(unsigned i, struct extent *e)
> {
>  const char types[] = { 'f', 'd' };
>
> @@ -81,8 +81,8 @@ static void dump_extent(struct extent *e
>  return;
>  }
>
> - DMDEBUG("start: %8llu len: %4llu %4c.rstart: %8llu",
> - e->start, e->len, types[e->type],
> + DMDEBUG(" [%u] start: %8llu len: %4llu %4c.rstart: %8llu",
> + i, e->start, e->len, types[e->type],
>  (sector_t)e->data );
> }
>
> @@ -97,7 +97,7 @@ static void dump_extent_map(struct exten
>  map->nr_extents, map->cur_extent);
>
>  for (i = 0; i < map->nr_extents; i++)
> - dump_extent(DMLOOP_EXTENT(i));
> + dump_extent(i, DMLOOP_EXTENT(i));
> }
>
> #else /* CONFIG_DM_DEBUG */
> @@ -228,16 +228,25 @@ reprobe:
>  continue;
>  }
>
> + if (nr_extents == LOOP_MAX_EXTENTS && probe_block < last_block){
> + DMERR("Loopfile contains more than LOOP_MAX_EXTENTS (%d) fragments\n",
> + LOOP_MAX_EXTENTS);
> + goto out_free;
> + }
> +
>  map->nr_extents = nr_extents;
>  map->cur_extent = 0;
>
>  DMDEBUG("created initial extent map, finalizing.");
>  map = finalize_map(map);
> + if (!map)
> + return -ENOMEM;
> +
> + //dump_extent_map(map);
>  DMINFO("Finalized extent map of %u bytes, %d entries.",
>  (map->nr_extents * sizeof(struct extent)),
>  map->nr_extents);
>
> - dump_extent_map(map);
>  lc->blkbits = blkbits;
>  lc->map = map;
>
> @@ -408,7 +417,7 @@ static struct file *loop_get_file(char *
> {
>  struct file *filp;
>  struct inode *inode;
> - int r;
> + int r = 0;
>
>  filp = filp_open(loop_path,
>  ((*flags & DMLOOP_READONLY) ? O_RDONLY : O_RDWR) |
> @@ -434,6 +443,7 @@ static struct file *loop_get_file(char *
>
>  if (IS_SWAPFILE(inode)) {
>  DMERR("file is already in use: %s", loop_path);
> + r = -EBUSY;
>  goto out;
>  }
>
> @@ -461,7 +471,7 @@ static int loop_setup_size(struct loop_c
>  lc->size = i_size_read(inode);
>  lc->blkbits = inode->i_blkbits;
>
> - if (lc->offset & (1 << lc->blkbits - 1)) {
> + if (lc->offset & ((1 << lc->blkbits) - 1)) {
>  DMERR("Backing file offset of %lld bytes not a multiple of "
>  "filesystem blocksize (%d)", lc->offset,
>  1 << lc->blkbits);
> @@ -565,8 +575,11 @@ static int loop_ctr(struct dm_target *ti
>  goto out_putf;
>
>  r = setup_loop_extents(lc);
> - if (r) {
> - ti->error = "Could not create extent map";
> + if (r == -EINVAL) {
> + ti->error = "Could not create extent map - invalid argument";
> + goto out_putf;
> + } else if (r == -ENOMEM) {
> + ti->error = "Could not allocate extent map";
>  goto out_putf;
>  }
>
> 
