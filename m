From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/18] libmultipath: Add prioritizer context
 data
Date: Mon, 12 Oct 2015 08:35:22 +0200
Message-ID: <561B54AA.2080404@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-2-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> Currently, running the alua prioritizer on a path causes 5 ioctls on many
> devices.  get_target_port_group_support() returns whether alua is
> supported. get_target_port_group() gets the TPG id. This often takes two
> ioctls because 128 bytes is not a large enough buffer size on many
> devices. Finally, get_asymmetric_access_state() also often takes two
> ioctls because of the buffer size. This can get to be problematic when
> there are thousands of paths.  The goal of this patch to to cut this down
> to one call in the usual case.
> =

> In order to do this, I've added a context pointer to the prio structure,
> similar to what exists for the checker structure, and initprio() and
> freeprio() functions to the prioritizers. The only one that currently uses
> these is the alua prioritizer. It caches the type of alua support, the TPG
> id, and the necessary buffer size.  The only thing I'm worried about with
> this patch is whether the first two values could change.  In order to deal
> with that possibility, whenever a path gets a change event, or becomes
> valid again after a failure, it resets the context structure values, which
> forces all of them to get checked the next time the prioritizer is called.
> =

Hmm. What about reading /sys/block/sdX/device/vpg_pg83 ?
That carries the same information, and you would need to call the
ioctl only once ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
