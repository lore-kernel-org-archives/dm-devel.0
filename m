From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Mon, 14 Sep 2015 18:59:43 +1000
Message-ID: <20150914185943.6d963e0c@korath.teln.shikadi.net>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
	<55F66C8B.7070603@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55F66C8B.7070603@redhat.com>
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

Thanks for your response!

> You need to show your 'broken' table first.

$ dmsetup table
backup: 0 11720531968 crypt aes-xts-plain64
  0000000000000000000000000000000000000000000000000000000000000000 0
  9:10 4096

> However for the 'standard' linear device - you could always replace
> opened device with error target with '--force'.

I'm not sure how to do this, could you please elaborate?  I thought
"dmsetup remove --force" would do this but as that doesn't work, I tried
this also:

$ dmsetup wipe_table backup
<no response, dmsetup frozen, kill -9 doesn't work>

$ dmsetup reload backup --table "0 11720531968 error"
$ dmsetup info backup
Name:              backup
State:             ACTIVE
Read Ahead:        4096
Tables present:    LIVE & INACTIVE
Open count:        1
Event number:      0
Major, minor:      253, 0
Number of targets: 1
UUID: CRYPT-LUKS1-d0b3d38e421545908537dc50f59fb217-backup
$ dmsetup resume backup
<no response, dmsetup frozen, kill -9 doesn't work>

> What you can't expect is  'device deletion' - as long as device is
> opened, it will be present (even if all read & writes will be
> errored).

That's probably ok, what I'm really trying to do is to get the
underlying device released.

> Also note - dmsetup remove  supports --deferred removal (see man
> page).

Oh I didn't notice that.  It doesn't seem to have much of an effect
though:

$ dmsetup remove --deferred backup
$ dmsetup info
Name:              backup
State:             ACTIVE (DEFERRED REMOVE)
Read Ahead:        4096
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      253, 0
Number of targets: 1
UUID: CRYPT-LUKS1-d0b3d38e421545908537dc50f59fb217-backup

The underlying device is still in use by dm-crypt.  I could not unmount
the filesystem stored on the dm device as the kernel said it was still
in use (presumably by the pending writes), so I did a lazy unmount of
the filesystem.  I think this is what's holding the dm device open and
causing dmsetup to stop responding all the time.

Any suggestions how to proceed?

Thanks again,
Adam.
