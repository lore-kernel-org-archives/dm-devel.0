From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use 'mpatha' for user_friendly_names option
Date: Wed, 07 May 2008 08:19:24 +0200
Message-ID: <482149EC.4080808@suse.de>
References: <20080430090329.CAC0718C6FF@pentland.suse.de>
	<20080506193539.GA7332@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080506193539.GA7332@bogon.ms20.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi Guido,

Guido G=FCnther wrote:
> On Wed, Apr 30, 2008 at 11:03:29AM +0200, Hannes Reinecke wrote:
>> We really should use 'mpatha' instead of 'mpath0' for the
>> generated names with the user_friendly_names option.
>> Otherwise we can't distinguish them from EVMS names.
>=20
> Is this really such a good idea? We shipped at least two upstream
> versions with this user friendly names default. Changing this causes
> problems and at least debian installer uses this during the installatio=
n
> phase.
> Wouldn't it be nicer to make the user_friendly_names_prefix configurabl=
e
> so people can choose mpath, npath, mp or whatever they want leaving
> mpath as the default? I can cook up a patch in that case.
> Cheers,
>  -- Guido
>=20
(I knew someone would choke about this one ...)
Yeah, you're right. It would be nice to have that configurable.
Preferred would be to select a prefix and a naming scheme,
ie either numerical or characters.
Was just to lazy for this ...

Normally I don't use this option much; in fact, I discourage
everyone on using it :-)
I really loath to have external configuration files to get
your filesystem up.

But that's just me. Feel free to do so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
