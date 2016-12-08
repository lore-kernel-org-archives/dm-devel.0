From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-cache: please check/repair metadata
Date: Thu, 8 Dec 2016 11:23:26 +0100
Message-ID: <2d776d72-744a-7aa7-a5ae-35192fe145d8@redhat.com>
References: <o2adej$eaa$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <o2adej$eaa$1@blaine.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ian Pilcher <arequipeno@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 8.12.2016 v 02:36 Ian Pilcher napsal(a):
> I have a dm-cache device that throws the following error when I try to
> create it:
>
>  device-mapper: cache: 253:20: unable to switch cache to write mode until
> repaired.
>  device-mapper: cache: 253:20: switching cache to read-only mode
>  device-mapper: table: 253:20: cache: Unable to get write access to metadata,
> please check/repair metadata.
>  device-mapper: ioctl: error adding target to table
>
> How can I go about checking/repairing the metadata?
>


Hi

I'm sorry but you've attached so little information there is no way to
give you some useful hint.

We need to know kernel version, OS (distribution),  lvm2 version,
version of cache_check tools and likely some more (dmesg/messages log)

Also you need to attach  'dmsetup table'  & 'dmsetup status'
'lsblk'

You may get better results opening  bugzilla at:
https://bugzilla.redhat.com/enter_bug.cgi?product=LVM%20and%20device-mapper


Regards

Zdenek
