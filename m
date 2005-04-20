From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: release 0.4.4 ?
Date: Thu, 21 Apr 2005 00:40:58 +0200
Message-ID: <20050420224058.GA29071@marowsky-bree.de>
References: <1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
	<1114030896.24817.145.camel@zezette>
	<20050420211000.GW29071@marowsky-bree.de>
	<1114033119.24817.161.camel@zezette>
	<20050420215213.GY29071@marowsky-bree.de>
	<1114034685.24817.165.camel@zezette>
	<1114035053.24817.168.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1114035053.24817.168.camel@zezette>
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

On 2005-04-21T00:10:52, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

> In the mean time, you should check why your prio callout always errors
> when run from multipathd. One obvious reason would be that the callout
> was not copied into the ramfs ...

How can I check that? I don't see any ramfs/shmfs in mount, and
multipathd also doesn't log anything about it.


Mit freundlichen Gr=FC=DFen,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
