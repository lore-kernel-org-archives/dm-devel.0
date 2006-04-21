From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: multipath and StorageWorks HSG80
Date: Fri, 21 Apr 2006 10:09:42 -0400
Message-ID: <20060421140942.GP14609@vienna.egenera.com>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
	<4447EA16.9070708@free.fr>
	<20060420204449.GA32417@ingress.sbb.uvm.edu>
	<1145567444.3118.60.camel@gator.sc.steeleye.com>
	<20060421134055.GA16090@ingress.sbb.uvm.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060421134055.GA16090@ingress.sbb.uvm.edu>
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

Rumor has it that on Fri, Apr 21, 2006 at 09:40:55AM -0400 Steve Feehan said:
> 
> I tracked this down and fixed the problem. But still, even with
> dm-hp-sw loading before the SCSI devices are probed, I get a ton
> of SCSI errors trying to access the "ghost" devices.

Those should be expected. The SCSI layers are trying to configure the
devices (read capacity, partition tables etc). The dm-hp-sw module
is not in that path so it can't do anything about that. They should be
harmless. 
 
This is an architectural artifact of doing the multipathing above the
SCSI layer.


Cheers,

Phil

> 
> -- 
> Steve Feehan
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
