From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Should multipath detect changed path UIDs?
Date: Wed, 26 Jan 2005 23:13:54 +0100
Message-ID: <20050126221354.GX5511@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A71C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A71C@SRMANNING.eng.emc.com>
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

On 2005-01-26T16:50:50, "goggin, edward" <egoggin@emc.com> wrote:

> Possible solutions could involve (1) detecting fiber channel disconnect
> hotplug events and acting upon them or (2) modifying multipath checker
> functions to verify a path's UID remains consistent in addition to veri=
fying
> path connectivity.

If you look at the emc_clariion checker in multipath-tools, you'll find
it does that.

I've this handy paper called "Developing Multipath Software for EMC
CLARiiON Arrays" in front of me and believe that we implement it
already, as far as possible. ;-)

(There's one missing piece, it's handling the specific sense codes, but
you'll find that they are already coded in dm-emc.c in the kernel, just
disabled until we finally get the patch to get at the SCSI SENSE data in
the bio struct. I need to pester axboe about it again.)

Maybe you could add the Symmetrix specific handling to the emc_clariion
path checker and the dm-emc.c kernel module? I'd be glad to make it more
powerful than "just" the CX/AX arrays, alas, I "only" have a CX-500 for
playing with ;-)



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
