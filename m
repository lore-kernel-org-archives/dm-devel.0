From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libmultipath: don't lock block device but
 use lock files
Date: Wed, 03 Jun 2015 13:22:12 +0200
Message-ID: <556EE364.5060400@suse.de>
References: <5560EA5C.6040001@iwakd.de>
	<556178AC.2010501@suse.de>	<5561863B.5020001@iwakd.de>
	<4aa67d7fdb957d8dd2ef5ab3c84c6376@iwakd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4aa67d7fdb957d8dd2ef5ab3c84c6376@iwakd.de>
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

On 06/02/2015 02:09 PM, Christian Seiler wrote:
> Am 2015-05-24 10:05, schrieb Christian Seiler:
>> That said, I've noticed that my patch might cause multipathd to have
>> the lock file fds open unnecessarily, so I've updated it to close them
>> on regular unlocking (but not on failure, because that means there will
>> be a retry). Version 2 is attached.
> =

> Ping?
> =

Probably I'm showing my ignorance here, but do we _really_ need this?
Is this really an issue? Personally I've never had any issue with
locking multipathd against multipath; plus I'm not aware of any scenario
which uses 'multipath' on a regular basis.
All scripts I know of rely on multipathd to maintain the path states,
and 'multipath' is only ever used to query the state of the devices.
Using 'multipath' to maintain the paths themselves are typically used
only manually, so any failure can easily be overcome.

Do you have an example where this patch is required?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
