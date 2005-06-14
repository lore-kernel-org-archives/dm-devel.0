From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Tue, 14 Jun 2005 15:57:53 +0200
Message-ID: <20050614135753.GN25295@marowsky-bree.de>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<20050610061033.GA9474@us.ibm.com>
	<20050610104711.GC20162@marowsky-bree.de>
	<20050614103450.GH25295@marowsky-bree.de>
	<20050614114434.GA12019@averon.dyndns.org>
	<20050614120027.GK25295@marowsky-bree.de>
	<20050614124818.GA12154@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050614124818.GA12154@averon.dyndns.org>
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

On 2005-06-14T14:48:18, Christophe Varoqui <christophe.varoqui@free.fr> w=
rote:

> For now only the following events :
>=20
> - block dev add
> - block dev remove
>=20
> When transport uevents get implemented we may want to use them too, but=
 it is not the case in HEAD.

The only thing which seems to generate uevents in 2.6.12-rc6-mm1 seems
to be mount/umount though?

Am I spectacularly missing something? ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
