From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath: Determine which device to use
 for	grubdevice.map file
Date: Mon, 22 Feb 2010 07:41:12 +0100
Message-ID: <4B822708.3010803@suse.de>
References: <4B7DE60A.9020805@storix.com>	<8F08A56613D77044BD153E2AC5DA0F8403B0E9F0@CORPUSMX40A.corp.emc.com>
	<4B7F1194.2040201@storix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B7F1194.2040201@storix.com>
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
List-Id: dm-devel.ids

David Huffman wrote:
> Thanks for the response Wayne, but this does me no good. You cannot use
> the /dev/disk/by-id/* entries for device.map. You have to use the block
> device and not a link or dm-* device name.
> =

Hm. Works here in my setup ...

# cat /boot/grub/device.map
(hd0)   /dev/disk/by-id/scsi-35000c5000042f3f3
(hd1)   /dev/disk/by-id/scsi-SATA_WDC_WD800JD-23L_WD-WMAM9K563627

What are the errors you see?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
