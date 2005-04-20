From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Last path failure causes oops
Date: Wed, 20 Apr 2005 21:27:13 +0200
Message-ID: <20050420192713.GR29071@marowsky-bree.de>
References: <20050418160043.GY8413@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050418160043.GY8413@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 2005-04-18T18:00:43, Lars Marowsky-Bree <lmb@suse.de> wrote:

> Hi, I'm finally finding time to work and play with dm-mpath again. It w=
orks,
> unless there's a failure ;-)

BTW, this is now
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D155447
or
https://bugzilla.novell.com/show_bug.cgi?id=3D78986

It's somewhere in the bio_endio() path, and I don't quite understand why
and where. If someone has a good guess what's happening, please let me
know. It's pretty easily reproduced: just fail all paths and the machine
will oops.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
