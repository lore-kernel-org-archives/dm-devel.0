From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: rlookup WWIDs with spaces by	alias
Date: Mon, 14 Nov 2011 12:34:00 -0600
Message-ID: <20111114183359.GG24133@ether.msp.redhat.com>
References: <20111112045426.GD24133@ether.msp.redhat.com>
	<4EC0DCC2.8060804@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4EC0DCC2.8060804@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Mon, Nov 14, 2011 at 10:17:54AM +0100, Hannes Reinecke wrote:
> On 11/12/2011 05:54 AM, Benjamin Marzinski wrote:
>> If a WWID contained spaces, the rlookup code wasn't able to look it up
>> by its user_friendly_name, since the code was only reading the wwid till
>> the first space.  It now reads to the end of the line.
>>
>> Signed-off-by: Benjamin Marzinski<bmarzins@redhat.com>
>> ---
>>   libmultipath/alias.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: multipath-tools-110412/libmultipath/alias.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- multipath-tools-110412.orig/libmultipath/alias.c
>> +++ multipath-tools-110412/libmultipath/alias.c
>> @@ -288,7 +288,7 @@ rlookup_binding(FILE *f, char **map_wwid
>>   		curr_id =3D scan_devname(alias, NULL); /* TBD: Why this call? */
>>   		if (curr_id>=3D id)
>>   			id =3D curr_id + 1;
>> -		wwid =3D strtok(NULL, " \t");
>> +		wwid =3D strtok(NULL, "");
>>   		if (!wwid){
>>   			condlog(3,
>>   				"Ignoring malformed line %u in bindings file",
>>
> Please, don't.
>
> We keep on changing this one back and forth about every year.
> (The original patch was by you, back in 2008. Then I changed it back =

> because it breaks compability with existing configuration files. Now you =
go =

> and change it _again_).
>
> The real problem here is
>
> 'If the WWID contains spaces'
>
> The WWID _never_ should contain spaces. I pretty certain we can't handle =

> WWID with spaces in the bindings file; eg we don't have any quotation =

> mechanism implemented.
> So can't we just settle on 'The WWID must not contain spaces' ?

I suppose that since we're using the "--replace-whitespace" option to
scsi_id by default, I'm fine with not including this patch.

-Ben

>
> Cheers,
>
> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
