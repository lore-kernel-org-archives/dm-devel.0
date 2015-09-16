From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: How do you force-close a dm device after a disk
	failure?
Date: Wed, 16 Sep 2015 10:04:33 +0200
Message-ID: <55F92291.9020808@redhat.com>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
	<55F66C8B.7070603@redhat.com>
	<20150914185943.6d963e0c@korath.teln.shikadi.net>
	<55F6906A.6080404@redhat.com>
	<20150914194552.213afd64@korath.teln.shikadi.net>
	<55F69BA9.30908@redhat.com>
	<20150916105857.69e1cb49@korath.teln.shikadi.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150916105857.69e1cb49@korath.teln.shikadi.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Adam Nielsen <a.nielsen@shikadi.net>
List-Id: dm-devel.ids

Dne 16.9.2015 v 02:58 Adam Nielsen napsal(a):
>>> dmsetup reload backup --table "0 11720531968 error"
>
> This one returns without error.
>
>>> dmsetup suspend --noflush backup
>>
>> or even better use   --noflush  --nolockfs
>> (if there was a mounted filesystem)
>
> This one does not return to the command prompt.  Running it through
> strace shows this:
>
> $ strace dmsetup suspend --noflush --nolockfs backup
> ...
> munmap(0x7f9cdea45000, 4096)            = 0
> ioctl(3, DM_VERSION, 0x5644ae2ca0d0)    = 0
> ioctl(3, DM_DEV_SUSPEND
>
> It always seems to freeze at DM_DEV_SUSPEND.  This ioctl never seems to
> return.

As with any other kernel frozen task - try to capture kernel stack trace.
If you properly configured sysrq trigger - easiest is to use:

'echo t >/proc/sysrq-trigger'

(Just make sure you have large enough kernel log buffer so lines are not lost)
Attach compressed trace - this should likely reveal where it blocks.
(I'll try to reproduce myself)


Zdenek
