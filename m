From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add
 dm-writeboost]
Date: Tue, 08 Oct 2013 19:57:16 +0900
Message-ID: <5253E50C.1060608@gmail.com>
References: <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com> <20130926034325.GO26872@dastard>
 <20131001082654.GA10326@debian>
 <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
 <20131004020417.GF4446@dastard> <524FC4F4.6050401@gmail.com>
 <20131007234307.GP4446@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20131007234307.GP4446@dastard>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: david@fromorbit.com
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, ruby.wktk@gmail.com, dm-devel@redhat.com, mpatocka@redhat.com, dan.carpenter@oracle.com, joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com, ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net
List-Id: dm-devel.ids

Dave,

> i.e. there's no point justifying a behaviour with "we could do this
> in future so lets ignore the impact on current users"...
Sure, I am happy if we find a solution that
is good for both of us or filesystem and block in other word.

> e.g. what happens if a user has a mixed workload - one where
> performance benefits are only seen by delaying FUA, and another that
> is seriously slowed down by delaying FUA requests?  This is where
> knobs are problematic....
You are right.
But there is no perfect solution to satisfy all.
Dealing with each requirement will only complicate the code.
Stepping away from the user and
focusing on filesystem-block boundary
>> Maybe, writeboost should disable deferring barriers
>> if barrier_deadline_ms parameter is especially 0.
adding the switch for the mounted filesystem to decides on/off
is a simple but effective solution I believe.

Deciding per bio basis instead of per device could be an another solution.
I am happy if I can check the bio if it "may or may not defer the barrier". 

Akira
