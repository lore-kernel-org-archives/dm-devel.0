From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Path status updation on HP arrays.
Date: Mon, 11 Jul 2005 12:02:13 +0200
Message-ID: <20050711100213.GP19928@marowsky-bree.de>
References: <3456F611E9329441B12FBB24447B3FA0023F84E6@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3456F611E9329441B12FBB24447B3FA0023F84E6@bgeexc01.asiapacific.cpqcorp.net>
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
Cc: "Reilly, Stephen (MRO)" <steve.reilly@hp.com>, "P S,  Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

On 2005-07-08T18:55:43, "Murthy, Narasimha Doraswamy (STSD)" <narasimha.m=
urthy@hp.com> wrote:

> I am seeing path updation issues with multipath tools versions 0.4.4 an=
d
> 0.4.5, when tested with EVA HSV 200, MSA and XP (Active Active arrays)
> on RHEL U1.=20
>=20
> Failover works fine and fails to the other path in the path group, but
> when the failed path comes back online,  the status of this path is
> [ready][failed]. This doesn't change unless "multipath" is executed
> manually from the command prompt. =20

Is multipathd running correctly, and was it started after the multipath
DM tables have been created?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
