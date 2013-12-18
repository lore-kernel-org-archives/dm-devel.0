From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-multipath: Accept failed paths for
 multipath maps
Date: Wed, 18 Dec 2013 08:52:26 +0100
Message-ID: <52B1543A.4000104@suse.de>
References: <1386580532-103264-1-git-send-email-hare@suse.de>
	<FB8A412F33166C4A930D37BD63236C902AD4A2B5@SACEXCMBX02-PRD.hq.netapp.com>
	<52AFF5E5.4040800@suse.de>
	<FB8A412F33166C4A930D37BD63236C902AD4A325@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <FB8A412F33166C4A930D37BD63236C902AD4A325@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/17/2013 04:57 PM, Merla, ShivaKrishna wrote:
> Hi Hannes, Just verified with SUSE code and I see below check in multipat=
h_iterate_devices(), which is missing in patch.
> =

> 	if (!p->path.dev)
>                                 continue;
> 	ret =3D fn(ti, p->path.dev, ti->begin, ti->len, data);
>                         if (ret)
>                                 goto out;
> =

Thanks. I'll be sending an updated patch.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
