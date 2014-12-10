From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Date: Wed, 10 Dec 2014 12:33:50 +0000
Message-ID: <20141210123349.GC21108@debian>
References: <5484498E.4000202@gmail.com>
 <20141207200834.GA2322@kroah.com>
 <5484C0E9.3060707@gmail.com>
 <20141209151253.GA17660@debian>
 <20141210100033.GA21108@debian>
 <548827BD.3050803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <548827BD.3050803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: ejt@redhat.com, dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Dec 10, 2014 at 08:00:13PM +0900, Akira Hayakawa wrote:
> Hi, Joe
> 
> Thanks for continuous evaluation.

Some more details:

dd, with block size 512b
------------------------

raw spindle      : 143
writeboost Type 0: 137
writeboost Type 1: 130

dd, with block size 4k
----------------------

raw spindle      : 31
writeboost Type 0: 29
writeboost Type 1: 81


dd, with block size 64m
-----------------------

raw spindle      : 8.9
writeboost Type 0: 32
writeboost Type 1: 72



So maybe it's just volume of IO that's causing the problem?  What's
the difference between Type 0 and Type 1?  In the code I notice you
have 'rambuf' structures, are you caching IO in memory?
