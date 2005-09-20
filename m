From: Ray Stell <stellr@cns.vt.edu>
Subject: Re: blacklisted paths?
Date: Tue, 20 Sep 2005 11:11:51 -0400
Message-ID: <20050920151151.GA3518@locust.cns.vt.edu>
References: <20050919211649.GA24756@locust.cns.vt.edu>
	<20050920120153.GA25978@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050920120153.GA25978@locust.cns.vt.edu>
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

On Tue, Sep 20, 2005 at 08:01:53AM -0400, Ray Stell wrote:
> devnode_blacklist {
>         devnode "hd*"
>         devnode "fd*"
>         devnode "ram*"
>         devnode "md*"
> }

I removed the * chars from this block it mapped all the paths.  
============================================================
Ray Stell  stellr@vt.edu  (540) 231-4109  Tempus fugit  28^D
