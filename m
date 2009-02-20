From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Fri, 20 Feb 2009 10:08:57 -0500
Message-ID: <20090220150857.GA27224@mars.virtualiron.com>
References: <200902171917.38252.knikanth@suse.de>
	<200902191240.22577.knikanth@suse.de>
	<1235090729.9614.8.camel@chandra-ubuntu>
	<200902201033.48806.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200902201033.48806.knikanth@suse.de>
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
Cc: sekharan@linux.vnet.ibm.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> off-topic:
> I think struct multipath can be shrunk even further by making various flags
> like pg_init_required, pg_init_in_progress, queue_io, queue_if_no_path,
> saved_queue_if_no_path in to a single variable. Thoughts?

Do the benefits (cut down on the size of the structure which is allocated once
for a map) vs readability worth it?
