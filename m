From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Mon, 14 Sep 2015 11:16:26 +0200
Message-ID: <55F6906A.6080404@redhat.com>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
	<55F66C8B.7070603@redhat.com>
	<20150914185943.6d963e0c@korath.teln.shikadi.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150914185943.6d963e0c@korath.teln.shikadi.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 14.9.2015 v 10:59 Adam Nielsen napsal(a):
> Thanks for your response!
>
>> You need to show your 'broken' table first.
>
> $ dmsetup table
> backup: 0 11720531968 crypt aes-xts-plain64
>    0000000000000000000000000000000000000000000000000000000000000000 0
>    9:10 4096

It's not really useful to show just 1 device.

Whole dm  table with all deps needs to be known.

'dmsetup table'
'dmsetup status'
'dmsetup ls --tree'
'dmsetup into -f'

>> However for the 'standard' linear device - you could always replace
>> opened device with error target with '--force'.
>
> I'm not sure how to do this, could you please elaborate?  I thought
> "dmsetup remove --force" would do this but as that doesn't work, I tried
> this also:
>
> $ dmsetup reload backup --table "0 11720531968 error"
> $ dmsetup info backup
> Name:              backup
> State:             ACTIVE
> Read Ahead:        4096
> Tables present:    LIVE & INACTIVE
> Open count:        1
> Event number:      0
> Major, minor:      253, 0
> Number of targets: 1
> UUID: CRYPT-LUKS1-d0b3d38e421545908537dc50f59fb217-backup
> $ dmsetup resume backup
> <no response, dmsetup frozen, kill -9 doesn't work>

really state of whole table needs to be known.

>> Also note - dmsetup remove  supports --deferred removal (see man
>> page).
>
> Oh I didn't notice that.  It doesn't seem to have much of an effect
> though:

Sure it will not fix your problem - it's like lazy umount...

>
> The underlying device is still in use by dm-crypt.  I could not unmount
> the filesystem stored on the dm device as the kernel said it was still
> in use (presumably by the pending writes), so I did a lazy unmount of
> the filesystem.  I think this is what's holding the dm device open and
> causing dmsetup to stop responding all the time.
>
> Any suggestions how to proceed?

What is not clear to me is - what is your expectation here ?
Obviously your system is far more broken - so placing 'error' target
for your backup device will not fix it.

You should likely attach also portion of 'dmesg' - there surely will be 
written what is going wrong with your system.

i.e. you cannot expect 'remove --force' will work when your machine start to 
show kernel errors.

Zdenek
