From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 23:10:00 +0200
Message-ID: <20050420211000.GW29071@marowsky-bree.de>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
	<1114030896.24817.145.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1114030896.24817.145.camel@zezette>
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

On 2005-04-20T23:01:36, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

> Don't forget the binaries caching in a ramfs.
> If you don't restart the daemon, it may still use a WIP multipath
> version as a callout.
>=20
> I'll try and reproduce this at OSDL.

I've most certainly restarted the daemon. To make sure the kernel didn't
get stuck somewhere (it's sometimes a bit annoying to be debugging
user-space and the kernel at the same time ;-) I also rebooted the node,
which I guess should count as a restart ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
