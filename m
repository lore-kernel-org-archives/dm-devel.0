From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Wed, 30 Sep 2009 22:18:26 +0100
Message-ID: <20090930211826.GW5351@agk-dp.fab.redhat.com>
References: <20090923030331.GA26449@us.ibm.com>
	<F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
	<20090930163519.GV5351@agk-dp.fab.redhat.com>
	<61B37279-E0E3-4AF6-81AB-82EEE65C1A09@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <61B37279-E0E3-4AF6-81AB-82EEE65C1A09@redhat.com>
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

On Wed, Sep 30, 2009 at 02:48:22PM -0500, Jon Brassow wrote:
> Inserting a new allocation level is a possibility.  I don't think it's  
> necessary to solve (what I see as) the problem.  Do you have a reason  
> for this?  

It doesn't actually fit into the existing hierarchy very well at all - it's
pretty much an independent property (which the existing allocation routines
do not support).  E.g. consider if you require 'cling' with the log on the
same disk as some of the mirror's data.  Falling through to 'Normal' or
'anywhere' and allowing the log to share a disk could give you a wrong
layout.  But you want to give priority to arrangements with the log on a
different disk where possible.  So do you have to try all the policies twice,
first with the existing find_parallel_areas, and then with a new flag which
allows some specified areas to be 'anywhere' (almost doubling the number of
policies), or perhaps break it into two independent allocations at that point,
one for the data and then one for the log?

Alasdair
