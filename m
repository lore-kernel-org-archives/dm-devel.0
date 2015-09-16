From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Wed, 16 Sep 2015 10:58:57 +1000
Message-ID: <20150916105857.69e1cb49@korath.teln.shikadi.net>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
	<55F66C8B.7070603@redhat.com>
	<20150914185943.6d963e0c@korath.teln.shikadi.net>
	<55F6906A.6080404@redhat.com>
	<20150914194552.213afd64@korath.teln.shikadi.net>
	<55F69BA9.30908@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55F69BA9.30908@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> > dmsetup reload backup --table "0 11720531968 error"

This one returns without error.

> > dmsetup suspend --noflush backup
> 
> or even better use   --noflush  --nolockfs
> (if there was a mounted filesystem)

This one does not return to the command prompt.  Running it through
strace shows this:

$ strace dmsetup suspend --noflush --nolockfs backup
...
munmap(0x7f9cdea45000, 4096)            = 0
ioctl(3, DM_VERSION, 0x5644ae2ca0d0)    = 0
ioctl(3, DM_DEV_SUSPEND

It always seems to freeze at DM_DEV_SUSPEND.  This ioctl never seems to
return.

> > dmsetup resume backup

Running this anyway also freezes:

$ strace dmsetup resume backup
...
close(4)                                = 0
semop(720903, {{0, 1, 0}}, 1)           = 0
semctl(720903, 0, GETVAL, 0x7fa5b3c28957) = 2
ioctl(3, DM_DEV_SUSPEND

> > Is this working for you ?

Looks like it's a kernel problem with DM_DEV_SUSPEND getting stuck
waiting for something?  There are no messages in dmesg after running
the above commands, not even any 'hung task' warnings.

Thanks,
Adam.
