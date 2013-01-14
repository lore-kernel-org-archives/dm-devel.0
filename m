From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] multipath: change default configuration
 parameters
Date: Mon, 14 Jan 2013 16:50:57 +0100
Message-ID: <50F42961.2030904@suse.de>
References: <20130110200508.GO19059@ether.msp.redhat.com>
	<50EFB886.7050707@suse.de>
	<20130111170142.GE19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130111170142.GE19059@ether.msp.redhat.com>
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

On 01/11/2013 06:01 PM, Benjamin Marzinski wrote:
> On Fri, Jan 11, 2013 at 08:00:22AM +0100, Hannes Reinecke wrote:
>> On 01/10/2013 09:05 PM, Benjamin Marzinski wrote:
>>> This patch makes multipath devices default to setting fast_io_fail,
>>> switches the default selector to service-time and removes the
>>> round-robin setting of the builtin device configurations. The goal is
>>> to give multipath devices better performance "out of the box".
>>>
>> Couldn't you split it off in three patches?
>> (Bad) experience tells me one always run into problems when
>> munching together unrelated pieces ...
>>
>
> I suppose.  However, each config change is easily isolatable by editting
> multipath.conf.
>
>>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>>> ---
>>>    libmultipath/config.c   |    1
>>>    libmultipath/defaults.h |    2 -
>>>    libmultipath/hwtable.c  |   65 -------------------------------------=
-----------
>>>    3 files changed, 2 insertions(+), 66 deletions(-)
>>>
>>> Index: multipath-tools-120821/libmultipath/config.c
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- multipath-tools-120821.orig/libmultipath/config.c
>>> +++ multipath-tools-120821/libmultipath/config.c
>>> @@ -516,6 +516,7 @@ load_config (char * file)
>>>    	conf->reassign_maps =3D DEFAULT_REASSIGN_MAPS;
>>>    	conf->checkint =3D DEFAULT_CHECKINT;
>>>    	conf->max_checkint =3D MAX_CHECKINT(conf->checkint);
>>> +	conf->fast_io_fail =3D 5;
>>>
>>>    	/*
>>>    	 * preload default hwtable
>>
>> Please use #define DEFAULT_FAST_IO_FAIL here.
>
> fine.
>
>>> Index: multipath-tools-120821/libmultipath/hwtable.c
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- multipath-tools-120821.orig/libmultipath/hwtable.c
>>> +++ multipath-tools-120821/libmultipath/hwtable.c
>>> @@ -28,7 +28,6 @@ static struct hwentry default_hw[] =3D {
>>>    		.product       =3D "Compellent Vol",
>>>    		.features      =3D DEFAULT_FEATURES,
>>>    		.hwhandler     =3D DEFAULT_HWHANDLER,
>>> -		.selector      =3D DEFAULT_SELECTOR,
>>>    		.pgpolicy      =3D MULTIBUS,
>>>    		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>>>    		.rr_weight     =3D RR_WEIGHT_NONE,
>>
>> Can't we get rid of _all_ 'DEFAULT_XXX' settings in the
>> hardware table? They _should_ be set to default during
>> init anyway, shouldn't they?
>> And that would shorten the hardware table by quite a lot ...
>
> Not all of them, I think.  For instance, for many devices, we know that
> we don't want a hardware handler. Someone could set the hardware handler
> in their defaults section to deal with all their devices that don't
> already have a device specific config built in.  In this case, we want
> the devices with a built-in config to not use that new hwhandler
> setting. I think a good question would be, "will changing this option
> make the device not work correctly?"  If so, then it should be
> explicitly set in the device config.  If not, then it can inherit it
> from default.
>
> So, DEFAULT_HWHANDLER, DEFAULT_CHECKER, and DEFAULT_PRIO, must be stay
> explicitly set. DEFAULT_FEATURES is kind of questionable but I think it
> should stay as well.  DEFAULT_MINIO and DEFAULT_MINIO_RQ are safe to
> inherit from the defaults section.  Does that sound reasonable?
>
>
>>> Index: multipath-tools-120821/libmultipath/defaults.h
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- multipath-tools-120821.orig/libmultipath/defaults.h
>>> +++ multipath-tools-120821/libmultipath/defaults.h
>>> @@ -1,7 +1,7 @@
>>>    #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
>>>    #define DEFAULT_UDEVDIR		"/dev"
>>>    #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
>>> -#define DEFAULT_SELECTOR	"round-robin 0"
>>> +#define DEFAULT_SELECTOR	"service-time 0"
>>>    #define DEFAULT_ALIAS_PREFIX	"mpath"
>>>    #define DEFAULT_FEATURES	"0"
>>>    #define DEFAULT_HWHANDLER	"0"
>>>
>> Hmm.
>>
>> And you _have_ tested 'service-time' thoroughly, now have you?
>
> I've tested it with the admittedly non-exhaustive supply of hardware I
> have available.  In my experience, service-time or queue-length are
> both pefectly good choices.  But on some loads to some arrays, they
> do outperform round-robin, and I've never seen them noticeably worse.
>
> When people ask for performance tuning tips and we have them try out the
> dynamic load balancing selectors, I've never heard a report that they
> underperform round-robin.  Have you seen different results?  If there's
> a good reason to think it might cause problems, I'm fine with leaving
> round-robin as the default. But I think we should try to get the
> defaults to what we believe will provide the best performance on most
> devices.
>
Actually, I'm not worried about performance, but rather stability.
multipath-tools took _ages_ to stabilize, and we're still somewhat
on the shaky side. So I'm rather loath to make new features the =

default without having tested them thoroughly.

But if you say so ...

Cheers,

Hannes

-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
