From: Mike Anderson <andmike@us.ibm.com>
Subject: Question on dm-mp sense handling
Date: Wed, 23 Feb 2005 18:07:49 -0800
Message-ID: <20050224020749.GA669@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: axboe@suse.com
List-Id: dm-devel.ids

Is someone still working on the sense buffer handling code for bios
to be used by dm-mp?

The ifdef'd out code in dm-emc.c and dm_scsi_err_handler appears to only
allow the interpretation of sense data if available and does not provide
any detail on non-sense based failures (DRIVER_TIMEOUT vs DID_* status).

An old patch that Mike Christie submitted was a start at mapping errors to
BLK error flags but did not receive much feedback. Is there some reason to
not decode down at the lower levels with a possible interface for vendor
specific mapping?

Old post can be found here.
http://marc.theaimsgroup.com/?l=linux-kernel&m=107961883914541&w=2

The reason I am asking the question is I am looking into issues of a
single device mapper hardware handler supporting block devices exported by
a DASD driver or through the SCSI subsystem.

-andmike
--
Michael Anderson
andmike@us.ibm.com
