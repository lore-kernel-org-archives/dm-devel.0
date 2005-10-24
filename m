From: Brian Long <brilong@cisco.com>
Subject: Re: Getting close to RHEL4 U3 freeze
Date: Mon, 24 Oct 2005 13:07:10 -0400
Message-ID: <1130173630.4201.19.camel@brilong-lnx>
References: <20051024170054.GC19176@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051024170054.GC19176@phlogiston.msp.redhat.com>
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

On Mon, 2005-10-24 at 12:00 -0500, Benjamin Marzinski wrote:
> Just to let everybody know that freeze date for Redhat Enterprise Linux 4
> Update 3 is getting close.  The blocker bug that is currently being used to
> track bugfixes and enhancements that are getting into U3 is
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=171044
> 
> If anyone feels strongly that there is a bugzilla that should be on the list,
> but is not, please put a comment in the 171044 bugzilla entry.  If it's an
> enhancement, please make sure that the enhancement description is as specific
> as possible.
> 
> Thanks
> 
> -Ben

Ben,

We are starting to use dm-multipath in RHEL 4 U2 and documentation is
sorely lacking.  I've opened IT 81946, but my TAM said it came in too
late for U3.  Any doc updates you can provide around the proper usage of
"dm-emc" or "1 emc" hardware_handler as well as expounding on the docs
around path_checker of tur vs. readsector0.  The vendor-specific
path_checkers like "emc_clariion" are not documented inside the dm-
multipath RPM; only by searching the archives on this mailing list is it
found.

Thanks. 

/Brian/

-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
