From: Chaskiel Grundman <cg2v@andrew.cmu.edu>
Subject: rdac.c patch not quite right.
Date: Mon, 29 Nov 2010 19:03:47 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1011291838420.15702@sphinx.andrew.cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

commit 362d2e5f215894818b52a0d03b723b75917390fb
added the following block to rdac.c:

        } else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
                /* LUN not connected*/
                ret = PATH_DOWN;
                goto done;
        }

I don't know what the intended effect actually was, but since
(inq.PQ_PDT & 0x20) will be true if (inq.PQ_PDT & 0x7f), the code is
incorrect as-is. I have some dell RDAC devices, but I cannot delete
targets on any of them to test this.

Update, after reading some scsi docs: If RDAC is using the standard
peripheral qualifier semantics, I think the following is what should be
used instead


        } else if ((inq.PQ_PDT & 0xE0) == 0x20 || inq.PQ_PDT == 0x7f) {

This form checks for the PQ bits being 001 or 011, and if 011, also
that the device type has the standard value for an unsupported
lun.

Alternatively,

        } else if ((inq.PQ_PDT & 0xC0) == 0x20) {

does not validate the device type bits in case the PQ is 011
