From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Getting close to RHEL4 U3 freeze
Date: Mon, 7 Nov 2005 13:17:17 -0600
Message-ID: <20051107191717.GB26529@phlogiston.msp.redhat.com>
References: <20051024170054.GC19176@phlogiston.msp.redhat.com>
	<436A9CDB.1060606@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <436A9CDB.1060606@netapp.com>
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

On Thu, Nov 03, 2005 at 06:27:23PM -0500, David Wysochanski wrote:
> When's the freeze?
> 
> I have a path priority patch (for netapp targets) I'm trying to get
> tested so I can submit it.  It's purely new code in userspace (patch
> against multipath-tools), so hopefully non-controversial.
> 
> Not sure if I should kill myself or not, hence the question about
> whether I've missed U3 freeze yet.

If it's just a totally new path priority binary,  I can pretty easily take
it if you get it upstream before the 15th. If you mess with the rest of the
multipath-tools code, it depends.  I'm mostly only taking bug fixes from
upstream now, but I'll pull in enhancements as long as they are minor changes
and obviously correct. For these, sooner is definitely better, and they
must be upstream before the 15th to even have a chance.

-Ben
 
> Thanks.
> 
> Benjamin Marzinski wrote:
> >Just to let everybody know that freeze date for Redhat Enterprise Linux 4
> >Update 3 is getting close.  The blocker bug that is currently being used to
> >track bugfixes and enhancements that are getting into U3 is
> >
> >https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=171044
> >
> >If anyone feels strongly that there is a bugzilla that should be on the 
> >list,
> >but is not, please put a comment in the 171044 bugzilla entry.  If it's an
> >enhancement, please make sure that the enhancement description is as 
> >specific
> >as possible.
> >
> >Thanks
> >
> >-Ben
> >
> >-- 
> >dm-devel mailing list
> >dm-devel@redhat.com
> >https://www.redhat.com/mailman/listinfo/dm-devel
> >
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
