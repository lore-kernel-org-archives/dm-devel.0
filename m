From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH 0/3] Changes to Userspace multipath code to
	support lsi-rdac
Date: Thu, 22 Mar 2007 00:06:55 +0100
Message-ID: <1174518416.6218.35.camel@localhost.localdomain>
References: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: andmike@us.ibm.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com
List-Id: dm-devel.ids

Le mercredi 21 mars 2007 =C3=A0 11:38 -0800, Chandra Seetharaman a =C3=A9=
crit :
> Hi All,
>=20
> While working on lsi-rdac hardware handler, I found that the checkers "=
tur"
> and "readsector0" are not serving the lsi-rdac properly. Also, the stor=
age
> device has a active/passive state which need to be handled properly.
>=20
> So, I wrote a new path checker for lsi-rdac, to use the C4 inquiry page=
 to get
> the current owner of the lun and set the state as UP(active) or GHOST(p=
assive).
> Changes are in patch 1/3.
>=20
> After applying the above patch, I realized the priorities are not set p=
roperly.
> Made some changes to use the GHOST state while setting priorities. Chan=
ges are
> in patch 2/3.
>=20
> Debugging the above patches found that the wait time (5 seconds) in mul=
tipathd
> was not sufficient for the devices to appear in /dev/ It was taking abo=
ut 20
> seconds. Changed the wait time to be 60 seconds. Change in patch 3/3.
>=20
> Please provide me with your feedback/comment on these changes regarding
> correctness, completeness etc.,
>=20
Looks very good. I merged the 3 patches.

In 1/3, I changed the DEF_TIMEOUT name to avoid surcharging the one in
checker.h

I'm having a hard time push to kernel.org, so don't expect to see the
git tree updated soon.

Thanks,
cvaroqui
