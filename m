From: Hannes Reinecke <hare@suse.de>
Subject: Re: Re: 1st of 2 patches for dm_emc.c and dm-multipath
	hardware handler interface
Date: Mon, 11 Sep 2006 12:43:22 +0200
Message-ID: <45053DCA.7080207@suse.de>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1397@CORPUSMX40A.corp.emc.com>	<4501A68F.8050708@cs.wisc.edu>
	<4501AF96.9030502@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4501AF96.9030502@cs.wisc.edu>
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
Cc: agk@redhat.com, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

Mike Christie wrote:
[ .. ]
> We really need to change how dm-multipath development works IMHO.
> Alasdair is just too overworked. It is not fair to him to have so much
> work piled on top of him and not fair to the community to have problems
> like this sit around for so long.
>=20
[ .. ]
> With Alasdair having to maintain every driver that dm handles and those
> drivers increasing in complexity the work load is too large for one
> person and this makes coordination with other subsystems impossible.
> This is a large problem, when for something like dm-multipath it needs
> help from the block layer, and low levels like scsi.
>=20
> We really need a system like in the scsi layer where there are driver
> maintainers and then one core maintainer of the subsystem. The core
> maintainer has final (well ok community has final say I guess) say but
> trusts the low level driver maintainers to some extent. The low level
> driver maintainers still have to post patches for review to the
> community and maintainer but the core maintainer does not have to do a
> line by line review of the dm target module and learn all the lower
> level details of the sub-subsytem/lld/dm target module/transport/spec
> unless it affects dm core or it is a suspicious patch.
>=20
Totally agree.

Of course, Alasdairs vote's the one that counts ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
