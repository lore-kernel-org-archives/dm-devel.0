From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm mpath: Skip calling activate_path if the
	path is already failed
Date: Mon, 17 Aug 2009 08:20:09 +0200
Message-ID: <4A88F699.3040109@suse.de>
References: <E463DF2B2E584B4A82673F53D62C2EF46F2BA886@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF474B7A064@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474B7A064@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Moger, Babu wrote:
> Alasdair, Can you please pick up this patch in your next update..
>=20
> Hannes, Any comments from you? I know you have already reviewed this in=
 another thread.
>=20
> Thanks
> Babu Moger=20
>=20
>> -----Original Message-----
>> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]=
 On
>> Behalf Of Moger, Babu
>> Sent: Wednesday, July 29, 2009 10:47 AM
>> To: dm-devel@redhat.com
>> Subject: [dm-devel] [PATCH] dm mpath: Skip calling activate_path if th=
e
>> path is already failed
>>
>> This patch adds a check to skip failed paths while calling activate_pa=
th.
>> If the path is already failed then activate_path will fail for sure. W=
e
>> don't have to call in that case.
>>
>> Signed-off-by: Babu Moger <babu.moger@lsi.com>
>> ---
>>
>>
>> --- linux-2.6.31-rc3/drivers/md/dm-mpath.c.orig	2009-07-27
>> 10:30:39.000000000 -0500
>> +++ linux-2.6.31-rc3/drivers/md/dm-mpath.c	2009-07-27
>> 10:35:50.000000000 -0500
>> @@ -454,6 +454,10 @@ static void process_queued_ios(struct wo
>>  		m->pg_init_count++;
>>  		m->pg_init_required =3D 0;
>>  		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
>> +			/* Skip failed paths */
>> +			if (!tmp->is_active)
>> +				continue;
>> +
>>  			if (queue_work(kmpath_handlerd, &tmp->activate_path))
>>  				m->pg_init_in_progress++;
>>  		}
>>
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
Patch is fine. And, indeed, we really should be adding it.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
