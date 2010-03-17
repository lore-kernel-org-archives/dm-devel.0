From: Hannes Reinecke <hare@suse.de>
Subject: Re: Determine partition prefix used for mpath devices
Date: Wed, 17 Mar 2010 17:08:53 +0100
Message-ID: <4BA0FE95.8010406@suse.de>
References: <4B9FEA00.2040703@storix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B9FEA00.2040703@storix.com>
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
> In a script, I need to somehow determine what prefix is being used for
> partitions as set by UDEV. It seems that the naming convention is in
> flux and could change frequently. When using user_friendly_names the
> prefix is set using kpartx within udev rules. My problem is I need to
> know what the prefix is so my scripts know what device naming convention
> to look for.
> =

> Here are the different iterations of naming schemes:
> =

> mpath0p1
> mpath0-part1
> mpathap1
> mpatha-part1
> =

> Is there a way other than grepping through the udev rules to determine
> what the prefix is? The partitions may not exist so I cannot just look
> to see what they are. I need to know BEFORE I create partitions. I know
> this is a strange request, but I am working with a lot of code that was
> designed before multipath was available and using the sys naming is not
> an option (i.e. /disk/by-id/wwid).
> =

I wouldn't rely on the device-mapper table names, as they could be pretty
much everything.

To handle this situation I've patches up multipath and kpartx to provide
UUID prefixes, which normally can't be influenced from userspace.
Multipath devices carry the prefix 'mpath-', kpartx generated devices
carry the prefix 'part<num>-'.
So by checking the prefix you pretty much know which program generated
this particular device.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
