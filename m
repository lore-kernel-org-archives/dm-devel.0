From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: Integrity errors should not cause failover
Date: Tue, 08 Mar 2011 10:24:07 -0500
Message-ID: <yq1fwqxd4a0.fsf@sermon.lab.mkp.net>
References: <yq1aah6drw7.fsf@sermon.lab.mkp.net>
	<20110308151430.GB4669@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20110308151430.GB4669@redhat.com> (Mike Snitzer's message of
	"Tue, 8 Mar 2011 10:14:31 -0500")
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> But James has already staged a few patches associated with IO
Mike> error differentation for 2.6.39.  Your dm-mpath patch will need to
Mike> be rebased on that work;

Oh, I didn't see they finally went in. I'll take a look at scsi-misc.

-- 
Martin K. Petersen	Oracle Linux Engineering
