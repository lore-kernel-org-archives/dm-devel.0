From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/9] Generate uevents for all DM events
Date: Wed, 5 Oct 2016 18:43:58 +0100
Message-ID: <20161005174358.GD28416@agk-dp.fab.redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com> <20161004072015.GA11216@kroah.com> <fe185eba-f802-6731-8da7-736c117db135@redhat.com> <20161005004004.GC28416@agk-dp.fab.redhat.com> <20161005065101.GB11013@kroah.com> <0afb2645-59e5-f9a6-ca1f-29aaadf59400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0afb2645-59e5-f9a6-ca1f-29aaadf59400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 05, 2016 at 10:06:41AM -0700, Andy Grover wrote:
> My project *would* like this added sooner, so I'll work on a revised  
> patchset that uses netlink instead of uevents, and will also work on a  
> revision to uevents.txt that talks about KOBJ_CHANGE and when it should  
> and should not be used, as described by agk, to help out the next person.

netlink might still be overkill for this at this stage, if it's only
making one thread able to monitor multiple devices efficiently.

Let's find out your requirements and see if there's anything different from
the ones we've debated before.

Alasdair
