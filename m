From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 1/3] Extremely basic hp hardware handler (no
	retries, no error handling, etc).
Date: Mon, 30 Jul 2007 22:35:34 -0500
Message-ID: <46AEAE06.8080809@cs.wisc.edu>
References: <20070726044447.846195205@redhat.com>	
	<20070726044720.403731599@redhat.com>	
	<1185476962.17399.52.camel@linuxchandra>
	<46AE5353.2050002@cs.wisc.edu>
	<1185838035.17399.80.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1185838035.17399.80.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> On Mon, 2007-07-30 at 16:08 -0500, Mike Christie wrote:
>> Chandra Seetharaman wrote:
>>> Hi Dave,
>>>
>>> some coding style related comments (below).
>>>
>>
>>>> +	if (!error) {
>>>> +		err_flags = 0;
>>>> +		DMDEBUG("%s path activation command - success",
>>>> +		       	path->dev->name);
>>> Mixed use of space and tab for indentation (many other places too).
>>>
>> Where is that rule for this type of plcae?
> 
> Documentation/CodingStyle:
> "Outside of comments, documentation and except in Kconfig, spaces are
> never used for indentation, and the above example is deliberately
> broken."

Ah I see. I still think it is ok for this type of case though. Well, the 
above chunk of code should actually be tabbed because it lines up 
perfectly (I think there are 8 spaces in the above snippet), but some of 
the other places are not. checkpatch.pl did not care about the others 
and it looks like reviewers like Andrew Morton did not care about some 
of the wierder spacing used in dm-mpath-rdac which did not fit the 
coding style doc or the existing code :)

If we are getting all picky about that coding style I guess Dave should 
run scripts/checkpatch.pl over his patches, because I think there are 
some other issues.
