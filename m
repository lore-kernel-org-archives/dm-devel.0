From: Milan Broz <mbroz@redhat.com>
Subject: Re: Differentiating between dm devices
Date: Thu, 24 Mar 2011 09:32:25 +0100
Message-ID: <4D8B0199.20806@redhat.com>
References: <4D8A2E53.10401@cfl.rr.com> <4D8AF181.4050004@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D8AF181.4050004@suse.de>
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
Cc: Phillip Susi <psusi@cfl.rr.com>
List-Id: dm-devel.ids

On 03/24/2011 08:23 AM, Hannes Reinecke wrote:

> That is the approach I've been following for SUSE.
> The UUID is assumed to be of this syntax:
> 
> <type>-<identifier>

There were several discussions, I think even unofficial definition
tries but nobody documented that properly.

So thanks for opening this here, it should be formalized (Alasdair?).

What I remember from discussions:

- all devices should set DM-UUID (not required still though)
(btw available now in sysfs /sys/block/dm-X/dm/uuid in udev db,
no need to use dm-ioctl)

- everything is supposed to set a prefix to identify subsystem (owner)

- DM-UUID can contain multiple namespaces

- first part (prefix) says which the second part belongs to

(e.g. CRYPT-PLAIN-blabla - CRYPT is says it was cryptsetup namespace,
it is up subsystem to handle content, here we can parse crypt device
type from it it for example.)

- you can stack it (like partition/kpartx over other subsystem)
(problem of prefix separator, now we will get
probably something like part1-CRYPT-LUKS-00000000...)

- kpartx uses prefix in format (part%N- where
N is part number - my opinion it is bug but that up to discussion.
My suggestion is to use KPARTX-part%N*)

- some uses lowercase here

- there is limit of 128 characters for DM-UUID
(so stacking should handle this somehow)

To my knowledge, these prefixes are in the wild:

LVM- (lvm2)
DMRAID- (dmraid)
CRYPT- (cryptsetup)
mpath- (multipath)
part%N- (kpartx)

Milan
