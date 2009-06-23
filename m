From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: A simple, generic DM-API,
	for codecs/transcoders to use?
Date: Tue, 23 Jun 2009 01:30:05 -0400
Message-ID: <yq1skhrtt42.fsf@sermon.lab.mkp.net>
References: <49C0B79A.9010601@googlemail.com>
	<20090622150849.GA23765@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090622150849.GA23765@mars.virtualiron.com> (Konrad Rzeszutek's
	message of "Mon, 22 Jun 2009 11:08:49 -0400")
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

>>>>> "Konrad" == Konrad Rzeszutek <konrad@virtualiron.com> writes:

Konrad> I thought that the more recent patches by Oracle to support
Konrad> DIF/DIX (Data Integrity Extensions):

Konrad> Are addressing this by adding a checksum for each block sector
Konrad> that is checked by each device.

The DIX/DIF checksum is a CRC, not an ECC.  It is mostly aimed at
detecting in-flight corruption, not latent sector corruption.  Latent
sector corruption is btrfs territory as far as I'm concerned.

The problem as I see it with the proposed ECC scheme is that once a
drive gives up on a sector you lose all of it.  It's not like only a
portion of the sector becomes unreadable to the OS.  So the ECC scheme
will have to be quite potent because at the very minimum it must be able
to withstand losing 512 bytes of data.  Drives with 4KB sectors are
right around the corner making things even more fun.

Once you start working around sector atomicity issues I think it's only
a matter of time before you end up reinventing RAID and its various
reliability vs. space efficiency trade-offs...


Konrad> So the firmware on the hard-drive, along with the SAS controller
Konrad> would carry out the checksumming?

We'll generate the checksum and the other protection information in the
application if it supports it or otherwise once the I/O gets inside the
kernel.  The HBA, the array firmware, and the drive firmware are all
able to verify that the protection information matches the data.

-- 
Martin K. Petersen	Oracle Linux Engineering
