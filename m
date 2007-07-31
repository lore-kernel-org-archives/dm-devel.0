From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [patch 1/3] Extremely basic hp hardware handler (no
	retries, no error handling, etc).
Date: Tue, 31 Jul 2007 10:35:32 -0700
Message-ID: <1185903332.17399.92.camel@linuxchandra>
References: <20070726044447.846195205@redhat.com>
	<20070726044720.403731599@redhat.com>
	<1185476962.17399.52.camel@linuxchandra> <46AE5353.2050002@cs.wisc.edu>
	<1185838035.17399.80.camel@linuxchandra> <46AEAE06.8080809@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46AEAE06.8080809@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2007-07-30 at 22:35 -0500, Mike Christie wrote:
> Chandra Seetharaman wrote:
> > On Mon, 2007-07-30 at 16:08 -0500, Mike Christie wrote:
> >> Chandra Seetharaman wrote:
> >>> Hi Dave,
> >>>
> >>> some coding style related comments (below).
> >>>
> >>
> >>>> +	if (!error) {
> >>>> +		err_flags = 0;
> >>>> +		DMDEBUG("%s path activation command - success",
> >>>> +		       	path->dev->name);
> >>> Mixed use of space and tab for indentation (many other places too).
> >>>
> >> Where is that rule for this type of plcae?
> > 
> > Documentation/CodingStyle:
> > "Outside of comments, documentation and except in Kconfig, spaces are
> > never used for indentation, and the above example is deliberately
> > broken."
> 
> Ah I see. I still think it is ok for this type of case though. Well, the 

I see what you mean and agree with you.

> above chunk of code should actually be tabbed because it lines up 
> perfectly (I think there are 8 spaces in the above snippet), but some of 
> the other places are not. checkpatch.pl did not care about the others 
> and it looks like reviewers like Andrew Morton did not care about some 
> of the wierder spacing used in dm-mpath-rdac which did not fit the 
> coding style doc or the existing code :)

I will check it out

> 
> If we are getting all picky about that coding style I guess Dave should 

No, I am not getting all picky :). Was trying to help to avoid some
churn when sent to mainline.

> run scripts/checkpatch.pl over his patches, because I think there are 
> some other issues.
> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
