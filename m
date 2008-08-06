From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: Status of resizing/growing dm-multipath devices on
	the	fly
Date: Wed, 6 Aug 2008 15:48:12 +0200
Message-ID: <BF003E91ABCA429FA851667CB3486F7F@pitagora.it>
References: <20080806125355.GM3771@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080806125355.GM3771@edu.joroinen.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

* Pasi K=E4rkk=E4inen wrote:
>=20
> Is it possible to resize (grow) dm-multipath devices on the=20
> fly nowadays?
>=20
> I googled and found some discussions about the subject, but=20
> the conclusion seemed to be it's not possible.. that was a=20
> while ago, so I was wondering if this has been fixed/implemented..
>=20
> Using LVM and adding another new LUN/PV is not an option=20
> always.. it's a lot easier to manage the whole thing if it's=20
> possible to resize/grow existing LUNs on the fly.

Nowadays all disk-arrays make online LUN extension a breeze but
unfortunately it seems that dm-multipath is still not able to see new siz=
e
without downtime:
 http://www.redhat.com/archives/dm-devel/2007-August/msg00205.html
Look also at this recent thread on RHEL5 mailing-list where you can find
also a post from a Red Hat representative:
 http://www.redhat.com/archives/rhelv5-list/2008-July/msg00267.html

Sure, you can just add a new LUN, pvcreate and vgextend but it is not a
viable solution because it causes LUN proliferation.

Sincerely, I'm still subscribed to this mailing-list only to see if someo=
ne
solve this SHAME!
It's a feature that Linux really needs.

Hope someone pick this cry of pain!

--
Domenico Viggiani
