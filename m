From: malahal@us.ibm.com
Subject: Re: how do I re-synchronize with the Master mirror device?
Date: Tue, 19 Jun 2007 15:32:49 -0700
Message-ID: <20070619223249.GA11907@us.ibm.com>
References: <20070619001410.GA4442@us.ibm.com>
	<57F02999-B101-42EC-BFE9-3A59CB8FBCAF@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57F02999-B101-42EC-BFE9-3A59CB8FBCAF@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jonathan, I am using 'disk logging' and I setup using dmsetup for now. I
may use LVM2 tools to setup mirror in the future. So answers for both
the setups would be nice. Thank you very much.

--Malahal.

Jonathan Brassow [jbrassow@redhat.com] wrote:
> Are you using disk logging?
> 
> Are you using LVM to setup the mirrors, or are you doing it yourself  
> through dmsetup?
> 
>  brassow
> 
> On Jun 18, 2007, at 7:14 PM, malahal@us.ibm.com wrote:
> 
> >I have a dm-mirror setup where the mirror devices could occasionally
> >timeout due to network congestion or recovery at the device. If a  
> >device
> >times out, it goes out of sync with the Master. How do I sync it back?
> >Only few regions would have gone out of sync with the Master. Is it
> >possible to sync only the regions that have gone out of sync?
> >
> >Thank you for your time.
> >
> >--Malahal.
> >
> >--
> >dm-devel mailing list
> >dm-devel@redhat.com
> >https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
