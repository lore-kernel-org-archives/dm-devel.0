From: Andreas Huck <dm-devel@huck.it>
Subject: Re: multipath with dual Compaq SA462 connected to MSA500
Date: Wed, 11 Oct 2006 00:12:29 +0200
Message-ID: <200610110012.29891.dm-devel@huck.it>
References: <37429.195.37.166.71.1160475673.squirrel@io3.huck.it>
Reply-To: dm-devel list <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37429.195.37.166.71.1160475673.squirrel@io3.huck.it>
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
List-Id: dm-devel.ids

Hi,

On Tuesday, 10. October 2006 12:21, Andreas Huck wrote:
> 
> I'd like to enable some sort of multipath to a RAID device which
> is connected by two Smart Array 462 to a MSA500. The host is a DL380 G4.
> In contrast to MSA1000 the MSA500 is just directly attached, no HBA
> involved.
> The RAID appears as /dev/cciss/c1d0 and /dev/cciss/c2d0 and currently
> I am forced to disable one path by lvm filter.
> 
  
well, HP recommends the rather deprecated dm-multipath (on SLES9-SP3).
http://h20000.www2.hp.com/bc/docs/support/SupportManual/c00182786/c00182786.pdf
I recall the old raidtab configuration...

Regards,
Andreas
