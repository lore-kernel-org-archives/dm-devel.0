From: Edward Goggin <egoggin@emc.com>
Subject: RE: I/O error during path failover
Date: Tue, 28 Nov 2006 13:50:07 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1592@CORPUSMX40A.corp.emc.com>
References: <31167844.735111164706862589.JavaMail.petteri.j.heinonen@kolumbus.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <31167844.735111164706862589.JavaMail.petteri.j.heinonen@kolumbus.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: petteri.j.heinonen@kolumbus.fi
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tuesday, November 28, 2006 4:41 AM, Petteri Heinonen wrote:
> To: goggin, edward
> Cc: dm-devel@redhat.com
> Subject: RE: [dm-devel] I/O error during path failover
>=20
> But couple of additional questions. I have tried to specify=20
> that additional feature "queue_if_no_path" in several places=20
> in multipath.conf, but no matter where I specify it, it does=20
> not appear in "multipath -ll" nor "dmsetup table" outputs. Is=20
> there some known bug in RHEL4u4 for this?

Try adding the two directives below to the CLARiiON device or
multipath config entries in /etc/multipath.conf.  The combination
of these 2 directives will queue I/O for up to 5 minutes (that
is, 30 times the 10 second polling interval you have configured)
whenever all paths to the block device are failed.

	features		"1 queue_if_no_path"
	no_path_retry	30

>=20
> I have also tried to specify parameter no_path_retry with=20
> several  different values, but it doesn't change the output=20
> of "dmsetup table" in any way. Is this ok?

No.

> I guess that there=20
> should be some visible changes in "dmsetup table",

Yes, IFF the queue_if_no_path attribute is enabled, "dmsetup table"
should return the string "1 queue_if_no_path".

> as dm_*=20
> kernel modules do not read multipath.conf directly, do they?

No they don't ... only multipathd threads in user space read
/etc/multipath.conf.
