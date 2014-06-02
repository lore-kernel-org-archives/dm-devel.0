From: Hannes Reinecke <hare@suse.de>
Subject: Re: Status of SCSI referrals support in dm-multipath
Date: Mon, 02 Jun 2014 08:34:50 +0200
Message-ID: <538C1B0A.6080808@suse.de>
References: <20140601224650.000043de@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140601224650.000043de@localhost>
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
Cc: Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

On 06/01/2014 10:46 PM, Sebastian Herbszt wrote:
> Hello,
>
> I am trying to find out the status of SCSI referrals support in dm-multip=
ath.
> SCSI referrals support was a topic at LSF [1] but I wasn't able to find a=
ny
> information. Back in 2010 Hannes suggested the use of multiple entries in=
 a
> multipath table [2] but this doesn't seem to work (anymore):
>
> [ 7750.354190] device-mapper: table: Request-based dm doesn't support mul=
tiple targets yet
>
> Is there any SCSI referrals support yet?
>
> [1] http://marc.info/?l=3Dlinux-scsi&m=3D129553880112460&w=3D2
> [2] http://www.redhat.com/archives/dm-devel/2010-June/msg00155.html
>
Not as of now. I've managed to push referrals support into =

target_core, so you now can set up a backend which supports referrals.

And for the multiple entries I've though to use a linear target on =

top of the multipath target.
The linear target would just split up the device in chunks, =

according to the referrals layout.
And then you would have several multipath devices (all referring to =

the same disk), one for each supported referrals ALUA configuration.
The linear target would then map each chunk to the correct multipath =

device.

It'll be a beast for failover, but should be possible.
And maybe it's better to use dm-switch here; the number or referrals =

might overflow dm-linear ...

Cheers,

Hannes

-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
