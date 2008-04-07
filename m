From: malahal@us.ibm.com
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 7 Apr 2008 10:22:30 -0700
Message-ID: <20080407172230.GA11600@us.ibm.com>
References: <20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
	<20080403014042.GA3789@us.ibm.com>
	<yq14padoast.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq14padoast.fsf@sermon.lab.mkp.net>
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

Martin K. Petersen [mkp@mkp.net] wrote:
> >>>>> "Malahal" == malahal  <malahal@us.ibm.com> writes:
> 
> [I sent this last week but it never made it to the list]
> 
> Malahal> Very few drivers require it, so how about an interface to
> Malahal> lock the pages of an I/O available to drivers. Only needed
> Malahal> RAID drivers would lock the I/O while it is in progress and
> Malahal> they only pay the performance penalty.  mmap pages are a bit
> Malahal> tricky. They need to go into read-only mode when an I/O is in
> Malahal> progress. I know this would likely be rejected too!!!
> 
> I have exactly the same problem with the data integrity stuff I'm
> working on.
> 
> Essentially a checksum gets generated when a bio is submitted, and
> both the I/O controller and the disk drive verify the checksum.
> 
> With ext2 in particular I often experience that the page (usually
> containing directory metadata) has been modified before the controller
> does the DMA.  And the I/O will then be rejected by the controller or
> drive because the checksum doesn't match the data.

Your problem is very similar to an iSCSI problem sumitted here:
http://now.netapp.com/NOW/cgi-bin/bol?Type=Detail&Display=137902

Fortunately, you can detect the problem and the I/O can be retried if
possible. In the RAID case, it goes undetected until you hit the
eventual corruption!
