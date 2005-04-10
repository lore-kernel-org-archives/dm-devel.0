From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: reducing path test delays
Date: Sun, 10 Apr 2005 21:25:25 +0200
Message-ID: <20050410192525.GO12752@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A8AB@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A8AB@SRMANNING.eng.emc.com>
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
Cc: 'Christophe Varoqui' <christophe.varoqui@free.fr>, 'Alasdair G Kergon' <agk@redhat.com>, axboe@suse.de
List-Id: dm-devel.ids

On 2005-04-04T15:48:36, "goggin, edward" <egoggin@emc.com> wrote:

> In the interest of reducing delay time when testing either good or
> failed paths, could we (1) prevent SCSI mid-layer initiated i/o
> retry of these requests and (2) insert the test path i/os at the
> head of the path's block i/o queue?  Doing either of these will
> require some kernel enhancement since there is no way to
> either request fail fast capability or insertion at queue head for
> a SCSI CDB issued from user space.
>=20
> Currently the scsi_cmd_ioctl->sg_io->blk_execute_rq code
> path for a multipath test i/o does not set the REQ_FAILFAST
> bit in the flags field of the request structure and unconditionally
> inserts the request at the tail of the request queue for the scsi
> device representing the scsi path being tested.
>=20
> Possibly the desire for each of these two attributes could be
> passed as a flag bit setting in the flag field of the sg_io_hdr
> structure passed into the kernel as part of the test path ioctl(2).

Jens: Indeed, being able to inflict the equivalent of BIO_RW_FAILFAST on
a raw request from user-space would be desireable.

Do you have any objections or suggestions how this could be done best?



Mit freundlichen Gr=FC=DFen,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
