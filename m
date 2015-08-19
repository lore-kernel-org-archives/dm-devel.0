From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Any device mapper target that stores data in files?
Date: Wed, 19 Aug 2015 09:57:05 +0200
Message-ID: <55D436D1.10001@redhat.com>
References: <CAAq2XdoSv34qGewtGKRxUo064dG8mFudxZtw4A_nEUace3KQXQ@mail.gmail.com>
	<CAFx4rwSnVRNvRnwk7CKfxcgHG36HA1HRR07AREd9QhycR89dNQ@mail.gmail.com>
	<CAAq2XdpJapPakQJ9zyfso6+OfRMCTUSsLmeainXoDQ72TsLeRA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAq2XdpJapPakQJ9zyfso6+OfRMCTUSsLmeainXoDQ72TsLeRA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, doug@easyco.com
List-Id: dm-devel.ids

Dne 18.8.2015 v 08:45 Thiago Padilha napsal(a):
>
>         I need a device mapper target that stores data in files of fixed
>         sizes, probably defined when the virtual device is first created. For
>         the sake of explanation, lets call this target as "dirdm" and assume
>         there's an userspace tool of the same name that can be used to manage
>         such virtual devices. Now let's say I have an empty directory "/dirdm"
>         and want to create a virtual device with 4k "block size" on top of it:
>
>              dirdm create --size 10G --block-size 4k /dirdm
>
>         After this command is executed, there's a new file with 4k size at
>         /dirdm/0. This file will be used to store the first block of the
>         device. Here are the filenames that represent some blocks of this
>         virtual device:

Hi


I don't quite follow what you try to invent here - it looks like you play with 
the idea of doing 'btrfs' without btrfs.

DM is about devices - as soon as you start to mix 'filesystem-layer' with 
'block-layer' you get into troubles you cannot resolve - simply because of the 
interacting locking inside kernel is not supported for this use-case.

i.e.  for initial playing you could use  any file  via  'loop' device.
(There is even  dm-loop support which however is not upstream since there
is already 'loop' target.)

At the end however you will get into cases you cannot resolve once your 
filesystem on DM device will get blocked by underlying filesystem used to hold 
backend file for loop device.

For DM - you should stay with pure block devices. Loop over filesystem is good 
for 'testing' but it should be avoided as advised way for using any DM device.

For b-tree layered storage please check thin-pool.

Regards

Zdenek
