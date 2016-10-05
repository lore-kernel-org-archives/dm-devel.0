From: Andy Grover <agrover@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/9] Generate uevents for all DM events
Date: Wed, 5 Oct 2016 10:06:41 -0700
Message-ID: <0afb2645-59e5-f9a6-ca1f-29aaadf59400@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
 <20161004072015.GA11216@kroah.com>
 <fe185eba-f802-6731-8da7-736c117db135@redhat.com>
 <20161005004004.GC28416@agk-dp.fab.redhat.com>
 <20161005065101.GB11013@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161005065101.GB11013@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On 10/04/2016 11:51 PM, Greg KH wrote:
> On Wed, Oct 05, 2016 at 01:40:05AM +0100, Alasdair G Kergon wrote:

>> We see these as two different categories of notifications, and prefer
>> the greater flexibility a mechanism independent of uevents would
>> provide.  The team has discussed several alternatives over the years but
>> didn't make a decision as we've not yet reached a point where we're
>> straining the existing mechanism too far.
>
> So, no changes need to be made?  I'm confused here, who is wanting this
> changed?

Hehe, Alasdair and I are both RH but working on different projects. 
We're not the Borg :)

My project *would* like this added sooner, so I'll work on a revised 
patchset that uses netlink instead of uevents, and will also work on a 
revision to uevents.txt that talks about KOBJ_CHANGE and when it should 
and should not be used, as described by agk, to help out the next person.

Thanks -- Regards -- Andy
