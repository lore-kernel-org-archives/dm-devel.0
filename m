From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath-tools support for SGI TP9700...
Date: Thu, 12 Jun 2008 23:48:48 +0200
Message-ID: <1213307328.25460.34.camel@plop>
References: <OF744EE384.61DE82DD-ON86257466.0019E988-85257466.001AAE7D@mck.us.ray.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF744EE384.61DE82DD-ON86257466.0019E988-85257466.001AAE7D@mck.us.ray.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin M Lange <kevin_m_lange@raytheon.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Le jeudi 12 juin 2008 =C3=A0 00:51 -0400, Kevin M Lange a =C3=A9crit :
>=20
> Salut,=20
>=20
> Our organization is currently prototyping a database host which is
> running RHEL5 with SGI InfiniteStorage TP9700 Storage System.  Red Hat
> support has effectively told us that the device-mapper-multipath
> software does not support our TP9700 storage.  Does the
> multipath-tools v0.4.8 support SGI TP9700?  We are interested in
> contributing our hardware configuration for test of multipath-tools,
> but are unable to contribute programming resources at this time.=20
>=20
TP9700 seems to look like TP9500, which has configuration defaults set.
You should try and report using the TP9500 config for 9700 in
your /etc/multipath.conf:

devices {
        device {
                vendor "SGI"
                product "TP9[457]00"
                path_grouping_policy group_by_prio
                path_checker rdac
                checker rdac
                hardware_handler "1 rdac"
                prio rdac
                failback immediate
                no_path_retry queue
        }
}

Regards,
cvaroqui
