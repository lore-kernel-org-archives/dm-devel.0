From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 11:34:17 -0400 (EDT)
Message-ID: <alpine.LRH.1.00.0803141133310.23740@bogart.boston.redhat.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
	<20080313214352.GA18433@us.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
	<alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>
	<47DA85A1.2040503@suse.de>
	<alpine.LRH.1.00.0803141025260.23740@bogart.boston.redhat.com>
	<47DA91C0.4010106@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47DA91C0.4010106@suse.de>
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
Cc: Doug Gilbert <dougg@torque.net>
List-Id: dm-devel.ids

On Fri, 14 Mar 2008, Hannes Reinecke wrote:

> Ah, I see. So basically combining lsscsi and scsi_id.

Yes, although the output format is more configurable than lsscsi.

> As already mentioned, I'm not especially partial as to _where_
> scsi_id is kept. I'd happily move it over to sg3_utils.

Ideally, we would also factor out all the common code among the three
into a common library.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
