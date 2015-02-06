From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dmcache RAID1 bug?
Date: Fri, 6 Feb 2015 11:33:19 -0500
Message-ID: <20150206163319.GA13544@redhat.com>
References: <CAEZ+n-i7kOC3zZzrv5GHbmfuKJ3b1U6COG8DyDW8HjHk9wDf-Q@mail.gmail.com>
	<20141117144659.GA29929@redhat.com>
	<CAEZ+n-jJoCS0WqeeiETYf1jAwPJzy+fyEgr_-Qek+7NzS+uERQ@mail.gmail.com>
	<CAEZ+n-i3yP+qO6bVDs8O0CwkJKBNzVBMW6gOtd=dty9ALj_8eQ@mail.gmail.com>
	<CAEZ+n-ha0tFew+807rumUQsk-tqYVyxPUTrGoz0DvdCqLK50Og@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEZ+n-ha0tFew+807rumUQsk-tqYVyxPUTrGoz0DvdCqLK50Og@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Leonardo Santos <heiligerstein@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 19 2014 at  4:39pm -0500,
Leonardo Santos <heiligerstein@gmail.com> wrote:

> After run regression tests using 'git bisect', I identify that the error
> was created after commit 8c081b52c6833a30a69ea3bdcef316eccc740c87
> 
> To reproduce this error just:
> - create a raid1 HDDs for origin device;
> - create a cache device with SSDs (could or not be raid)
> - create a metadata device with SSDs (could or not be raid)
> - create a cache device using prior devices
> - kernel crashes.
> 
> I attached the bitseclog and diff file!

Hi, Joe recently fixed a couple issues in dm-cache that were only seen
when a DM raid device lost a raid member (while not exact as your
report, could resolve your issues).  Could you please retest with these
3 dm-cache commits applied to your kernel (all commits are in latest
3.19-rc kernel)?

9b1cc9f dm cache: share cache-metadata object across inactive and active DM tables
a59db67 dm cache: fix problematic dual use of a single migration count variable
766a788 dm cache: fix missing ERR_PTR returns and handling
