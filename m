From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] multipath: remove duplicates
	from	multipath configuration
Date: Fri, 11 Jan 2013 11:52:20 -0600
Message-ID: <20130111175220.GF19059@ether.msp.redhat.com>
References: <20130110201022.GR19059@ether.msp.redhat.com>
	<50EFBC17.1070401@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <50EFBC17.1070401@suse.de>
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

On Fri, Jan 11, 2013 at 08:15:35AM +0100, Hannes Reinecke wrote:
> On 01/10/2013 09:10 PM, Benjamin Marzinski wrote:
>> Added code to remove duplcate entries in the devices section, and the
>> blacklist devices section of the builtin configuration table. The only
>> change to setup_default_blist is the addition of _blacklist_device()
>> to check if the device's bl_product entry already exists.
>>
>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>> ---
>>   libmultipath/blacklist.c |   91 ++++++++++++++++++++++++--------------=
---------
>>   libmultipath/config.c    |   16 ++++++--
>>   2 files changed, 60 insertions(+), 47 deletions(-)
>>
>> Index: multipath-tools-120821/libmultipath/blacklist.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- multipath-tools-120821.orig/libmultipath/blacklist.c
>> +++ multipath-tools-120821/libmultipath/blacklist.c
>> @@ -96,50 +96,6 @@ set_ble_device (vector blist, char * ven
>>   }
>>
>>   int
>> -setup_default_blist (struct config * conf)
>> -{
>> -	struct blentry * ble;
>> -	struct hwentry *hwe;
>> -	char * str;
>> -	int i;
>> -
>> -	str =3D STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
>> -	if (!str)
>> -		return 1;
>> -	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>> -		return 1;
>> -
>> -	str =3D STRDUP("^hd[a-z]");
>> -	if (!str)
>> -		return 1;
>> -	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>> -		return 1;
>> -
>> -	str =3D STRDUP("^dcssblk[0-9]*");
>> -	if (!str)
>> -		return 1;
>> -	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>> -		return 1;
>> -
>> -	vector_foreach_slot (conf->hwtable, hwe, i) {
>> -		if (hwe->bl_product) {
>> -			if (alloc_ble_device(conf->blist_device))
>> -				return 1;
>> -			ble =3D VECTOR_SLOT(conf->blist_device,
>> -					  VECTOR_SIZE(conf->blist_device) -1);
>> -			if (set_ble_device(conf->blist_device,
>> -					   STRDUP(hwe->vendor),
>> -					   STRDUP(hwe->bl_product),
>> -					   ORIGIN_DEFAULT)) {
>> -				FREE(ble);
>> -				return 1;
>> -			}
>> -		}
>> -	}
>> -	return 0;
>> -}
>> -
>> -int
>>   _blacklist_exceptions (vector elist, char * str)
>>   {
>>   	int i;
>> @@ -192,6 +148,53 @@ _blacklist_device (vector blist, char *
>>   	}
>>   	return 0;
>>   }
>> +
>> +int
>> +setup_default_blist (struct config * conf)
>> +{
>> +	struct blentry * ble;
>> +	struct hwentry *hwe;
>> +	char * str;
>> +	int i;
>> +
>> +	str =3D STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
>> +	if (!str)
>> +		return 1;
>> +	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>> +		return 1;
>> +
>> +	str =3D STRDUP("^hd[a-z]");
>> +	if (!str)
>> +		return 1;
>> +	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>> +		return 1;
>> +
>> +	str =3D STRDUP("^dcssblk[0-9]*");
>> +	if (!str)
>> +		return 1;
>> +	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>> +		return 1;
>> +
>> +	vector_foreach_slot (conf->hwtable, hwe, i) {
>> +		if (hwe->bl_product) {
>> +			if (_blacklist_device(conf->blist_device, hwe->vendor,
>> +					      hwe->bl_product))
>> +				continue;
>> +			if (alloc_ble_device(conf->blist_device))
>> +				return 1;
>> +			ble =3D VECTOR_SLOT(conf->blist_device,
>> +					  VECTOR_SIZE(conf->blist_device) -1);
>> +			if (set_ble_device(conf->blist_device,
>> +					   STRDUP(hwe->vendor),
>> +					   STRDUP(hwe->bl_product),
>> +					   ORIGIN_DEFAULT)) {
>> +				FREE(ble);
>> +				return 1;
>> +			}
>> +		}
>> +	}
>> +	return 0;
>> +}
>>
>>   #define LOG_BLIST(M) \
>>   	if (vendor && product)						 \
>> Index: multipath-tools-120821/libmultipath/config.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- multipath-tools-120821.orig/libmultipath/config.c
>> +++ multipath-tools-120821/libmultipath/config.c
>> @@ -25,13 +25,16 @@
>>   static int
>>   hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
>>   {
>> -	if (hwe1->vendor && hwe2->vendor && strcmp(hwe1->vendor, hwe2->vendor))
>> +	if ((!!(hwe1->vendor) !=3D !!(hwe2->vendor)) ||
>> +	    (hwe1->vendor && strcmp(hwe1->vendor, hwe2->vendor)))
>>   		return 1;
>>
>> -	if (hwe1->product && hwe2->product && strcmp(hwe1->product, hwe2->prod=
uct))
>> +	if ((!!(hwe1->product) !=3D !!(hwe2->product)) ||
>> +	    (hwe1->product && strcmp(hwe1->product, hwe2->product)))
>>   		return 1;
>>
>> -	if (hwe1->revision && hwe2->revision && strcmp(hwe1->revision, hwe2->r=
evision))
>> +	if ((!!(hwe1->revision) !=3D !!(hwe2->revision)) ||
>> +	    (hwe1->revision && strcmp(hwe1->revision, hwe2->revision)))
>>   		return 1;
>>
>>   	return 0;
> I hate the '!!' constructs.

noted. If I respin this patch, I'll change it to something like

if ((hwe2->revision && !hwe1->revision) ||
    (hwe1->revision && (!hwe2->revision || strcmp(hwe1->revision, hwe2->rev=
ision))))

But there are many other instances of !! in the multipath tools code.

>
>> @@ -416,6 +419,13 @@ factorize_hwtable (vector hw, int n)
>>   				continue;
>>   			/* dup */
>>   			merge_hwe(hwe2, hwe1);
>> +			if (hwe_strmatch(hwe2, hwe1) =3D=3D 0) {
>> +				vector_del_slot(hw, i);
>> +				free_hwe(hwe1);
>> +				n -=3D 1;
>> +				i -=3D 1;
>> +				j -=3D 1;
>> +			}
>>   		}
>>   	}
>>   	return 0;
>>
> Is the 'hwe_strmatch' required here?

It should help clear up some user confusion.  If the user adds a
new config that only regex matches the built-in config, but doesn't
string match it, you obviously need to keep the built-in config to
correctly configure devices that match the built-in config but not
the user config.

However if the user's config string matches the built-in, then the
built-in config will never be used.  Any device what would match the
built-in config will match the user's merged config first.  However, if
the user dumps the config, and goes looking through it to make sure that
everything got merged correctly, the first config they will see is the
built-in config.  Then they call support, who needs to explain to them
that their config is further down in the output, and the last config in
the output is what gets used.

It's easy to avoid all that by simply deleting the built-in config in
the case where it string matches the user's config.

> Also I'm not sure if just decrementing the indices is the correct
> way of doing things; I had a version which just restarted
> the outer loop if we encountered a duplicate.

Oops. You're correct. Looks like I am respinning the patch.

-Ben

> Cheers,
>
> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
