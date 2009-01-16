From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: multipath.conf and polling_interval option seems
	misleading
Date: Fri, 16 Jan 2009 08:10:55 -0800
Message-ID: <1232122255.29644.23.camel@chandra-ubuntu>
References: <4970AFB8.6090906@redhat.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4970AFB8.6090906@redhat.com>
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


On Fri, 2009-01-16 at 11:03 -0500, shane bradley wrote:
> After reviewing the code and doing some testing I have noticed that 
> polling_interval did not work as expected.
> I had reviewed the description of the option for multipath.conf and it 
> conflicted with the results that I had got
> testing device-mapper-multipath on RHEL4/RHEL5.
> 
> $ cat /usr/share/doc/device-mapper-multipath-0.4.7/multipath.conf.annotated
> #       # name    : polling_interval
> #       # scope   : multipathd
> #       # desc    : interval between two path checks in seconds
> #       # default : 5
> #       #
> #       polling_interval 10
> 
> ---------
> 
> The behaviour that I had expected based on the option's description above:
> check path 1
> wait polling_interval
> check path 2
> wait polling_interval
> check path 1
> wait polling_interval
> check path 2
> wait polling_interval
> 
> However after testing the results that I got was(with multipathd -v4):
> example:
> check path 1
> check path 2
> wait polling_interval
> check path 1
> check path 2
> wait polling_interval
> 
> ---------
> 
> The behaviour I seen in RHEL4 and RHEL5 was working as design after
> reviewing the code and talking to a couple engineers.
> 
> The problem it seems is how I was reading the description of the option.
>  From my results in testing and talking with some engineers the 
> "polling_interval" option actually means:
> 
> "The interval between checking all possible paths for all multipath paths"
> ----------
> 
> 1) Is my assumption correct that "polling_interval" actually means:
> "The interval between checking all possible paths for all multipath paths"
> 
> 2) What is a better way to describe the "polling_interval" option?
> 
> 3) Shouldn't we make it clearer for people who don't that that much 
> experience with multipathing?

IMO, the behavior seen is the proper behavior.

If it does as per your interpretation, the seconds between checking of
the same path will depend on the number of paths to a storage, which may
not be acceptable.

May be the wording in multipath.conf.annotated should be made clear.

> --sbradley
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
