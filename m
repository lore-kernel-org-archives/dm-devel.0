From: Denis Semakin <d.semakin@omprussia.ru>
Subject: Re: [PATCH] dm table: add support for secure erase
 forwarding [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Fri, 23 Mar 2018 18:24:42 +0300 (MSK)
Message-ID: <582342829.319960.1521818682384.JavaMail.zimbra@omprussia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi.
Soon or later everybody start to think about security.
One of the most frequently requirement is 100% reliable data deletion from
any device in case of compromising or loss or theft.

For this, drive and memory cards manufacturers provide ERASE and TRIM features
which can notice (inform) controller of the device to erase sectors
(write down only zeros or one or random data). Features can be triggered
by calling ioctl() requests or a mount options (like ext4 does). But this works
only with whole device -- /dev/sdX, /dev/mmcblk0pX...
But what if for some security reasons we need to secure delete a single file.
A file-system layer provide this functionality... one may call __blkdev_issue_discard()
with BLKDEV_DISCARD_SECURE flag.
But...
All this works well if there is no virtual layer (like device-mapper)
between file-system and block-layer, because if device driver supports
this feature it can set up related flag in request_queue flags.

I have ext4 lvm partitions on my test instance and a drive which can
secure erase sectors.
Without lvm it works, with lvm it doesn't.
That's the purpose if this patch - to provide the opportunity to secure erase
given sectors (through device-mapper layer, forward request) that were assigned for regular file.



>But I'm left skeptical that this is enough.  Don't targets need to
>explicitly handle these REQ_OP_SECURE_ERASE requests?  Similar to how
>REQ_OP_DISCARD is handled?

I think yes, REQ_OP_DISCARD will not secure erase the data and it can be possible
to get it from device.

>I'd feel safer about having targets opt-in with setting (a new)
>ti->num_secure_erase_bios.

Well... May it make sense but I didn't see any reasons to add it in patch.

>Which DM target(s) have you been wanting to pass REQ_OP_SECURE_ERASE
>bios?
I think first of all a linear target of course should have this. For others I'm not sure, I need
to investigate.

Hopefully, I answered to all your question.


Denis
