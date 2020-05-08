From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: track io errors per mapped device
Date: Fri, 8 May 2020 01:18:25 +0100
Message-ID: <20200508001825.GC22266@agk-dp.fab.redhat.com>
References: <20200507230532.5733-1-kj@orbekk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200507230532.5733-1-kj@orbekk.com>
Sender: linux-block-owner@vger.kernel.org
To: Kjetil Orbekk <kj@orbekk.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, harshads@google.com, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

On Thu, May 07, 2020 at 07:05:33PM -0400, Kjetil Orbekk wrote:
> This will track ioerr_cnt on all dm targets and expose it as
> <device>/dm/ioerr_cnt.

How do you propose to use this?
What are you trying to measure and why?
- How exact must the number be to meet your requirements?

Or to put it another way, do you need to know the exact number you are
exposing, or do you derive something else from this which could also be
derived from an alternative number?

In particular, given the way we split and clone and stack devices (so
there may be an element of multiplication), and reload tables (so
existing values might become irrelevant), did you consider alternative
semantics before selecting this approach?
(Or to put it another way, is there a need to reset it or track
the value since the last resume?)

(Documentation is also needed - which ought to explain the semantics
and how the observed values interact with the use of device-mapper
features.)

Alasdair
