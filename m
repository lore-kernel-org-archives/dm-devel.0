From: malahal@us.ibm.com
Subject: Re: Re: Multipath-tools
Date: Thu, 16 Aug 2007 07:30:40 -0700
Message-ID: <20070816143040.GA19179@us.ibm.com>
References: <1186734435.6431.14.camel@sanderbal>
	<1186739220.6431.22.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1186739220.6431.22.camel@sanderbal>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "S. J. van Harmelen" <svanharmelen@xillan.nl>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

S. J. van Harmelen [svanharmelen@xillan.nl] wrote:
> Also I'm seeing "error calling out mpath_prio_rdac" when starting
> multipathd?! Any word on that one?
> 
> Regards,
> 
> Sander

Make sure you have /sbin/mpath_prio_rdac and is executable.
