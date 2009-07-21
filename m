From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Failed path will not be recovered when
	disabling/enabling remote port
Date: Tue, 21 Jul 2009 17:42:46 -0400
Message-ID: <20090721214246.GF22977@mars.virtualiron.com>
References: <4A4C998F.7010602@linux.vnet.ibm.com> <4A4C9D92.1020808@suse.de>
	<20090702130619.GA21821@mars.virtualiron.com>
	<4A4CB349.2050601@suse.de>
	<20090720164654.GA22977@mars.virtualiron.com>
	<4A655E09.8080707@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A655E09.8080707@suse.de>
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

> Ah. Hmm. Seems you are correct.
>=20
> I'll have to apply the patch, then.
>=20
> Fancy opening a bugzilla for it?

Done. BZ #524018.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
