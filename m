From: guy keren <choo@actcom.co.il>
Subject: Re: Losing paths
Date: Wed, 23 Jul 2008 01:10:58 +0300
Message-ID: <48865AF2.8090000@actcom.co.il>
References: <65F9ACC78BD8304BAAEB817634C62D4C060CFB67@AUSMAIL01.americas.ppdi.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <65F9ACC78BD8304BAAEB817634C62D4C060CFB67@AUSMAIL01.americas.ppdi.local>
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


Does the 'tur' checker take into account unit-attention issues (i.e.=20
when the configuration of a SCSI device changes, the next command coming=20
from an afected initiator (not necessarily to the same LU) should be=20
failed with a 'check condition' error and a 'unit attention' sense code.

if the TUR checker sent a TUR right after the change and before another=20
read/write command was sent - it will be failed, and then the question=20
is, whether the lower-level driver retries the TUR command, or returns=20
an error. any idea?

--guy

Daniel Keisling wrote:
> FWIW, I have the same issue under an HP EVA8000.  I'm not really certai=
n=20
> if directio is a solution as I have only seen the tur checker being use=
d=20
> with an EVA.
> =20
> Daniel
> =20
> =20
> -----------------------------------------------------------------------=
----------------------
> Date: Tue, 22 Jul 2008 16:55:27 +0200
> From: Hannes Reinecke <hare@suse.de <mailto:hare@suse.de>>
> Subject: Re: [dm-devel] Losing paths
> To: device-mapper development <dm-devel@redhat.com=20
> <mailto:dm-devel@redhat.com>>
> Message-ID: <4885F4DF.8010000@suse.de <mailto:4885F4DF.8010000@suse.de>=
>
> Content-Type: text/plain; charset=3DISO-8859-1; format=3Dflowed
> =20
> Hi John,
> =20
> Romanowski, John (OFT) wrote:
>>  Hi,
>>  We had similar problem last year using sles9 and SVC 4.2.0.2,  as you=
=20
> describe: adding/deleting a LUN causes
>>  brief path failures for the host's remaining, unaffected LUNs.
>>
>>  We were using tur checker and it turned out that while adding/deletin=
g=20
> a LUN (and some other admin tasks)
>>  the SVC does not respond well to test-unit-ready tur requests; but it=
=20
> responds perfectly well to normal read
>>  commands. I opened IBM PMR 43118 on that if you want to ask the SVC=20
> folks about it.=20
>>
>>  Workaround for us was to use readsector0 instead of  tur as multipath=
=20
> path checker.
>>=20
>>  Recent post here (see July 8, 2008)  said multipath-tools is=20
> deprecating readsector0, and to use directio as
>>  path checker, but directio was said to be much slower than tur,=20
> implying tur was better replacement than
>>  directio for readsector0.
>>
> Only for those cases where no actual read-access is necessary.
> =20
>>  Not sure what deprecating readsector0 means for us SVC users.=20
>>
> It means you should be using directio there.
> =20
> Thanks for the information, I'll see to have it included in SLES10.
> =20
> Cheers,
> =20
> Hannes
> --=20
> Dr. Hannes Reinecke        zSeries & Storage
> hare@suse.de <mailto:hare@suse.de>         +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>=20
>=20
>=20
>=20
> ______________________________________________________________________
> This email transmission and any documents, files or previous email
> messages attached to it may contain information that is confidential or
> legally privileged. If you are not the intended recipient or a person
> responsible for delivering this transmission to the intended recipient,
> you are hereby notified that you must not read this transmission and
> that any disclosure, copying, printing, distribution or use of this
> transmission is strictly prohibited. If you have received this transmis=
sion
> in error, please immediately notify the sender by telephone or return e=
mail
> and delete the original transmission and its attachments without readin=
g
> or saving in any manner.
>=20
>=20
> -----------------------------------------------------------------------=
-
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
