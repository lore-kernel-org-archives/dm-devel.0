From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] multipath: add detect_prio option to
 autodetect prioitizer
Date: Mon, 14 Jan 2013 08:02:10 +0100
Message-ID: <50F3AD72.5070109@suse.de>
References: <20130110201358.GS19059@ether.msp.redhat.com>
	<50EFBC71.5080109@suse.de>
	<1357993580.4263.5.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357993580.4263.5.camel@lapoo.opensvc.com>
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

On 01/12/2013 01:26 PM, Christophe Varoqui wrote:
> On ven., 2013-01-11 at 08:17 +0100, Hannes Reinecke wrote:
>> On 01/10/2013 09:13 PM, Benjamin Marzinski wrote:
>>> This patch adds a new multipath.conf option, detect_prio.  If set to ye=
s,
>>> multipathd will try to determine the correct prioritizer for the device=
. If
>>> it finds one, that will be used instead of its configured prioritizer. =
 If
>>> none is found, the configured prioritizer will be used.  It can current=
ly
>>> only detect ALUA devices.
>>>
>>> Also fixed and issue with select_prio where in the devices section, it =
was
>>> passing in the prio name string instead of the prio args string to prio=
_get()
>>>
>>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>>
>> Good idea.
>>
> Don"t you think it would be fair to fallback to autodetection if no
> prioritizer is set, instead ? Admins would expect the values they care
> to set in the config file are honored.
>
It would, if we had autodetection for more (or, better, all) =

hardware handlers.
Shouldn't be too hard.

I'll give it a go at it once this patchset is merged.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
