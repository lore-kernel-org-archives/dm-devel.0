From: Hannes Reinecke <hare@suse.de>
Subject: Re: Device removal handling
Date: Tue, 12 Jul 2011 08:24:44 +0200
Message-ID: <4E1BE8AC.3090503@suse.de>
References: <4E1A079A.9060901@cfl.rr.com>	<20110710220330.GA7857@agk-dp.fab.redhat.com>
	<4E1B11D5.8050603@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E1B11D5.8050603@cfl.rr.com>
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

On 07/11/2011 05:08 PM, Phillip Susi wrote:
> On 7/10/2011 6:03 PM, Alasdair G Kergon wrote:
>> (But devices should be removed from the top down, obviously, and if
>> it's your main filesystem, you could e.g. set up a ramdisk do do
>> this from.)
>
> I disagree. Right now dmraid relies on doing this, but this is not
> possible if it is not aware of the higher level mappings because
> they were created by kpartx. LVM and multipath will have the same
> problem if kpartx recognizes partitions contained within an LV.
>
> Hardware removal also necessitates bottom up removal, since the
> initial event comes from unplugging the hardware at the bottom of
> the stack. The system needs to propagate notification of that up the
> stack so that the higher layers can react appropriately and release
> the removed lower layer device.
>
Yes.

I've been facing this problem for a long time now;
eg if you're having a dm-mirror with one leg local and another one =

on iSCSI. Try shutting down iSCSI here with LVM going bonkers ...

I wouldn't mind replacing a failed device with an error target.
What I would mind is to having to code that logic into each and =

every subsystem which might find itself running underneath =

LVM/device-mapper.

What I would like to see is this logic being pushed into
eg dmsetup, so that one call to dmsetup would be sufficient to =

achieve this. And without heavy parsing of arguments etc.
Something like 'dmraid replace error' would be cool.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
