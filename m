From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Mon, 21 Sep 2015 13:39:40 +0200
Message-ID: <20150921113940.GJ7519@soda.linbit>
References: <55F66C8B.7070603@redhat.com>
	<20150914185943.6d963e0c@korath.teln.shikadi.net>
	<55F6906A.6080404@redhat.com>
	<20150914194552.213afd64@korath.teln.shikadi.net>
	<55F69BA9.30908@redhat.com>
	<20150916105857.69e1cb49@korath.teln.shikadi.net>
	<55F92291.9020808@redhat.com>
	<20150916223512.40687a03@korath.teln.shikadi.net>
	<55F96893.2010201@redhat.com>
	<20150919194752.753cdc44@korath.teln.shikadi.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150919194752.753cdc44@korath.teln.shikadi.net>
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
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Sat, Sep 19, 2015 at 07:47:52PM +1000, Adam Nielsen wrote:
> > Was this the 'ONLY' dmsetup in your listing (i.e. you reproduced case
> > again)?
> 
> This was the original instance of the problem.  Today I have rebooted
> and reproduced the problem on a fresh kernel.
> 
> > I mean - your existing reported situation was already hopeless and
> > needed reboot - as if  flushing suspend holds some mutexes - no other
> > suspend call can fix it ->  you usually have just  1 chance to fix it
> > in right way, if you go wrong way reboot is unavoidable.
> 
> That sounds like a very unforgiving buggy kernel, if you only have one
> chance to fix the problem ;-)
> 
> Here is my attempt on the fresh kernel.  I received some write errors
> in dmesg, so tried to umount the dm device to confirm I had reproduced
> the problem, and when umount failed to exit I tried this:
> 
>   $ dmsetup reload backup --table "0 11720531968 error"
>   $ dmsetup suspend --noflush --nolockfs backup

You need to *resume* to activate the new table.

> These two worked fine now.  "dmsetup suspend" was locking up before,
> this time it worked.
> 
>   $ umount /mnt/backup
>   umount: /mnt/backup: not mounted
> 
> The dm instance is no longer mounted.
> 
>   $ mdadm --manage --stop /dev/md10
>   mdadm: Cannot get exclusive access to /dev/md10:Perhaps a running
>     process, mounted filesystem or active volume group?

Also, as mentioned before, why don't you
mdadm /dev/md10 --fail /dev/sdd --remove /dev/sdd
mdadm /dev/md10 --fail /dev/sde --remove /dev/sde
(for whatever sdX members it currently has;
or maybe combine in one command line, if that is supposed to work)

Should kick out the disks from the MD,
should make md10 fail all pending (and new) requests,
should even get the stuck dm suspend going again
(the implicit "flush" one, not the --noflush one,
as that did not get stuck anyways).

> I can't restart the underlying RAID array though, as the dm instance is
> still holding onto the devices.
> 
>   $ dmsetup remove --force backup
>   device-mapper: remove ioctl on backup failed: Device or resource busy
>   Command failed

You need to *resume* the new (error) table.
Or the previous table is only suspended, but still holds references.

> I don't appear to be able to shut down the dm device either.  I tried
> to umount the device before any of this, and the umount process has
> frozen (despite it seeming to have unmounted successfully), so this is
> probably what the kernel thinks is using the device.  Although the table
> has been replace by the "error" target, the umount process is not
> returning and appears to be frozen inside the kernel (because killall
> -9 doesn't work.)
> 
> Strangely I can still read and write to the underlying device
> (/dev/md10), it is only processes accessing /dev/mapper/backup that
> freeze.

You *suspended* it. It is supposed to be frozen.

Cheers,
	Lars Ellenberg
