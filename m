From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Thu, 13 Mar 2008 16:39:24 -0400 (EDT)
Message-ID: <alpine.LRH.1.00.0803131637090.4959@bogart.boston.redhat.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
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

On Thu, 13 Mar 2008, lemons_terry@emc.com wrote:

> Hi
> 
> I want to have multipath manage only the CLARiiON LUN that I boot from (LUN 0).  So I know that I can specify the following in /etc/multipath.conf:
> 
> blacklist {
> 	wwid *
> 	}
> blacklist_exceptions {
> 	wwid nnnnnnnnnn
> 	}
> 
> The wwid value is different for every CLARiiON LUN.  So, if I want to automate the process of adding the 'wwid' value to the blacklist, what utility can I use to specify a LUN number, and find the WWN of the LUN?

I've written one.  Try it!

Easy way:

rpm -ivh http://people.redhat.com/coldwell/coldwell-release-0-1.noarch.rpm
yum install -y scsitool
scsitool --wwid --hbtl --devname

Alternately, you can download source/binaries:

http://people.redhat.com/coldwell/repo/RHEL/5/src/scsitool-0-4.src.rpm
http://people.redhat.com/coldwell/repo/RHEL/5/x86_64/scsitool-0-4.x86_64.rpm

etc.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
