From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Thu, 12 Mar 2009 10:08:36 +0100
Message-ID: <49B8D114.6040200@suse.de>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>	<49B60444.2090008@ct.jp.nec.com>
	<49B613FE.3060501@suse.de> <49B8CEBB.7070701@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B8CEBB.7070701@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> Hi Hannes,
>=20
> On 2009/03/10 16:17 +0900, Hannes Reinecke wrote:
[ .. ]
>> Yes, I've found that one later on.
>> The real problem was in clone_setup_bios(), which might end up calling=
 an
>> invalid end_io_data pointer. Patch is attached.
>=20
> Nice catch!  Thank you for the patch.
>=20
Oh, nae bother. Took me only a month to track it down :-(

>> -static void free_bio_clone(struct request *clone)
>> +static void free_bio_clone(struct request *clone, struct mapped_devic=
e *md)
>=20
> I have changed the argument order to match with other free_* functions:
>     free_bio_clone(struct mapped_device *md, struct request *clone)
>=20
Sure. I wasn't sure myself which way round the arguments should be.

Do you have an updated patch of your suspend fixes? We've run into an iss=
ue
here which looks suspiciously close to that one (I/O is completed on a de=
leted
pgpath), so we would be happy to test it these out.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
