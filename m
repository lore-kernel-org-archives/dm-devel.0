From: "Zhao Qian" <zhaoqian@aaastor.com>
Subject: Re: bio's bi_size bug also be founded at dm-stripe.c and
	dm-snap.c (resend in correct charset)
Date: Thu, 30 Jun 2005 10:02:03 +0800
Message-ID: <003501c57d17$bd99f2f0$1f000064@polaris>
References: <00a501c57c92$c3041020$1f000064@polaris>
	<200506290630.57441.kevcorry@us.ibm.com>
	<200506290646.00118.kevcorry@us.ibm.com>
	<20050629144253.GR27078@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Zhao Qian <zhaoqian@aaastor.com>
List-Id: dm-devel.ids

Yes,i think so:)

Sincerely,
Zhao Qian zhaoqian@aaastor.com

----- Original Message -----=20
From: "Alasdair G Kergon" <agk@redhat.com>
To: "device-mapper development" <dm-devel@redhat.com>
Cc: "Zhao Qian" <zhaoqian@aaastor.com>
Sent: Wednesday, June 29, 2005 10:42 PM
Subject: Re: [dm-devel] bio's bi_size bug also be founded at dm-stripe.c =
and dm-snap.c (resend in correct charset)


> On Wed, Jun 29, 2005 at 06:46:00AM -0500, Kevin Corry wrote:
>> Alasdair, should that field be set for dm-mirror targets?=20
>=20
> Like you, I assumed it already was:-)
>=20
> Zhao, does Kevin's patch fix things for you?
>=20
> Alasdair
> --=20
> agk@redhat.com
>
