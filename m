From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: [RFC,
	PATCH] dm-log.c: Work with devices with hard-sector-size > 512 bytes
Date: Tue, 28 Mar 2006 16:58:36 -0600
Message-ID: <200603281658.36642.kevcorry@us.ibm.com>
References: <200603271546.25508.kevcorry@us.ibm.com>
	<20060328150100.GD2690@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060328150100.GD2690@agk.surrey.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue March 28 2006 9:01 am, Alasdair G Kergon wrote:
> A couple of options:
>
>   Retain the existing on-disk format exactly, but adjust the offsets and
>   sizes used in the reads and writes to avoid the problems (pre-reading
>   other data if necessary to extend a write).

This method seems like it should be easy to implement. We could just extend 
the buffer for the disk-header and always read and write both the header and 
the log at the same time, and just point lc->clean_bits at the appropriate 
offset within that buffer. The log could then remain at offset 1k, and the 
version wouldn't have to change.

>   Add an option to create version 3 metadata storing the offset in the
>   on-disk header but continue to use version 2 by default.

I think this is a better overall solution - less kludgy and more flexible.

>   Update userspace code to request version 3 (via new log parameter) for
>   new mirror logs by default, but still permit version 2 for new logs.

Is there a situation where someone would still need to create a new version 2 
log? I would think it would be far simpler to switch all new logs to use 
version 3, and revert back to version 2 only when the log offset recorded in 
the on-disk header is blank.

Or were you thinking of using this new log parameter to allow user-space to 
specify the offset of the log?

On a related note, shouldn't log_header.nr_regions be a uint64_t instead of a 
sector_t? The header_to_disk() and header_from_disk() routines already treat 
it as 64-bit.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
