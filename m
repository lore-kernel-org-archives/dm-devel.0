From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH 6/9] blk: Add request atomic flag for abort
Date: Tue, 04 May 2010 12:43:38 +0200
Message-ID: <4BDFFA5A.3000106@suse.de>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-7-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1272944228-30511-7-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Jens Axobe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Mike Anderson wrote:
> Add atomic flag for a request to indicate that it has marked as abort=
ed.
> Provide functions to mark and test the aborted flag.
>=20
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> Cc: Jens Axobe <jens.axboe@oracle.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
