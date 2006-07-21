From: Hannes Reinecke <hare@suse.de>
Subject: RE: [PATCH RFC] move scsi parts of dm hw handlers to scsi layer
Date: Fri, 21 Jul 2006 21:30:43 +0200 (CEST)
Message-ID: <7687263.1153510243667.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
References: <6CCEAEDF4D06984A83F427424F47D6E41491BC@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E41491BC@CORPUSMX40A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Edward Goggin <egoggin@emc.com>
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

Am Fr 21.07.2006 21:10 schrieb Edward Goggin <egoggin@emc.com>:

> > IIRC this is
> > 
> > 'DGC' 'DISK'
> > 'DGC' 'RAID 10'
> > 'DGC' 'RAID 5'
> 
> And 'DGC' 'LUNZ'
> 
Yeah. But I left that one out as there is no device attached to it
so we're unlikely to require a hw handler, or?

> What about supporting a wildcard model string?
> 
Well, we're having that.
So 'DGC' 'DISK' and
'DGC' 'RAID*' should be okay.

Cheers,

Hannes

