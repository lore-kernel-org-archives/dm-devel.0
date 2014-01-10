From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH for-3.14] dm cache: add total cache blocks to
	status output
Date: Thu, 9 Jan 2014 19:16:04 -0600
Message-ID: <34E2225D-17E6-4184-841F-642BC3FC0EB6@redhat.com>
References: <20140109210412.GA5288@redhat.com>
	<684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
	<20140109221323.GA5555@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140109221323.GA5555@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids


On Jan 9, 2014, at 4:13 PM, Mike Snitzer wrote:

> On Thu, Jan 09 2014 at  4:28pm -0500,
> Brassow Jonathan <jbrassow@redhat.com> wrote:
> 
>> Yes, that'd be nice if we could have this.
>> 
>> It would be great if chunk_size (i.e. cache block size) was also
>> included somehow.  If I had that, I could calculate the size of the
>> cache using the status output alone.  I won't complain much if it
>> isn't there though, because I can get that from the mapping table.
>> 
>> The reason I like adding the total number of cache blocks is because I
>> /can't/ get that information from either type of status (_INFO or
>> _TABLE) for the cache target.  Instead, I would have to get the cache
>> device from the mapping table and query that device for its size -
>> possible, but the level of indirection is a pain.  As it sits in the
>> kernel today, it seems strange to provide some information, but not
>> enough to fill in the whole picture.
> 
> So ideally you want both the cache blocksize and the metadata blocksize.
> We can easily add them, wouldn't be the end of the world.  What format
> seems best?
> 
> <#used metadata blocks>/<#total metadata blocks> <metadata block size>
> <#used cache blocks>/<#total cache blocks> <cache block size>
> ...
> 
> or:
> 
> <metadata block size> <#used metadata blocks>/<#total metadata blocks>
> <cache block size> <#used cache blocks>/<#total cache blocks>
> ...

Either is good (you posted the 2nd).

Still, I don't give a crap about how much metadata is used; but if you think it's useful to others, then great.  The check you mentioned to warn/error/prevent the user when providing an insufficiently sized metadata area might be nice.
