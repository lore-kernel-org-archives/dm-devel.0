From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [Notice] multipath-tools changes upstream
Date: Thu, 17 Apr 2008 13:25:26 -0500
Message-ID: <20080417182526.GH3116@ether.msp.redhat.com>
References: <1208278929.11770.62.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1208278929.11770.62.camel@plop>
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

On Tue, Apr 15, 2008 at 07:02:08PM +0200, Christophe Varoqui wrote:
> Hi,
> 
> please take notice I updated the upstream git tree for the
> multipath-tools project. This tree includes lots of code shuffling :
> 
> 1) prioritizers as dlopen'ed shared libs (/lib/libmultipath/libprio*.so)
> 2) checkers as dlopen'ed shared libs (/lib/libmultipath/libcheck*.so)
> 
> Consequences :
> The multipath tool is about to get shot for good
> The klibc build is gone
> 
> Please review, and comment.

I'm not able to update my copy of the repository, or clone a new one.
Am I the only one?

-Ben
 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
