From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath-tools libcheckers/tur.c libmultipath ...
Date: Tue, 21 Apr 2009 12:43:22 -0500
Message-ID: <20090421174322.GV15911@ether.msp.redhat.com>
References: <20090421000525.23250.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090421000525.23250.qmail@sourceware.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Tue, Apr 21, 2009 at 12:05:25AM -0000, bmarzins@sourceware.org wrote:
> CVSROOT:	/cvs/dm
> Module name:	multipath-tools
> Branch: 	RHEL5_FC6
> Changes by:	bmarzins@sourceware.org	2009-04-21 00:05:24
> 
> Modified files:
> 	libcheckers    : tur.c 
> 	libmultipath   : discovery.c discovery.h 
> 	multipathd     : main.c 
> 	path_priority/pp_alua: rtpg.c 
> 
> Log message:
> 	Fix for bz 472451.  This fixes two issues. First, it keeps multipathd from checking
> 	scsi paths in the "blocked" state, since multipathd will just hang until the device
> 	times out. Second, the tur checker retrys on a few more error codes that could happen
> 	during transient path failures.
> 

Is there any interest having this upstream in 0.4.9, given that the
path checking method is going to be changing? I'm not sure how soon all
of those changes will be in place.  Christophe, if you want me to port
this upstream, just let me know.

-Ben
