From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: clustered snapshots status,
	LVM on shared storage without CLVM?
Date: Mon, 28 Feb 2011 15:49:57 -0600
Message-ID: <0BCB9055-CE24-41FB-B110-A0159A9A28FE@redhat.com>
References: <20110228212844.GB2173@nik-comp.lan>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110228212844.GB2173@nik-comp.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

A true active/active cluster snapshot is not currently planned.  There  
is some discussion from time to time about whether it is appropriate  
or not, but even this is idle chatter until the new (single-machine)  
shared snapshot implementation is completed.

However, you will be able to take snapshots in a cluster in the next  
RHEL releases (or if you use upstream sources) if the volume you are  
snapshotting is activated exclusively.

It is possible to use LVM in a cluster without CLVM.  I don't think it  
would be smart though.  You are essentially trying to do clvmd's job.   
Do you know everything that it does?  Are you sure you won't ever make  
a mistake?

  brassow

On Feb 28, 2011, at 3:28 PM, Nikola Ciprich wrote:

> Hello,
> I'd like to ask, what is the current status of cluster locking  
> patches?
> I'm especially interested in clustered snapshots, is there some
> estimate on when I could be suitable for testing and possibly
> closer to production?
> I'd like to use DMLoop on my clustered storage (as well as snapshots
> in general), but with CLVM it's not really possible.
> If the time is not close yet, my second question is - is it
> dangerous to use LVM on top of shared storage without using CLVM?
> If I'll take care to not run lvm commands from more then one node?
> I'll be gratefull for any reply from more more experienced users
> in this area.
> thanks a lot in advance!
> with best regards
> nik
>
>
> -- 
> -------------------------------------
> Ing. Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28. rijna 168, 709 01 Ostrava
>
> tel.:   +420 596 603 142
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
>
> www.linuxbox.cz
>
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
