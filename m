From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] Questions about the function, queue_empty in
 dm-cache-policy-mq.c
Date: Mon, 5 Jan 2015 09:17:08 +0000
Message-ID: <20150105091707.GA11818@debian>
References: <54AA03E0.9020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AA03E0.9020900@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Sun, Jan 04, 2015 at 10:24:16PM -0500, nick wrote:
> Greetings All,
> I have a few questions about the function I stated in the message for this email.
> 1. What is the issues with the CPU usage for this function?

At the moment it can perform up to NR_QUEUE_LEVELS (16) list_empty()
calls.  Which I consider too much work for a function that is called
frequently.

> 2. What hardware is this on ?

Irrelevant.

> 3. How scalable is this function in terms of NR_QUEUE_LEVELS and how many does it need to handle?

Linear.  NR_QUEUE_LEVELS is a compile time constant currently set to
16, and unlikely to change.

- Joe
