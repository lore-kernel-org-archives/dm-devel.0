From: Christoph Hellwig <hch@infradead.org>
Subject: Re: CONFIG_DM_MQ_DEFAULT makes my kernel unhappy..
Date: Mon, 27 Apr 2015 09:03:53 -0700
Message-ID: <20150427160353.GA16384@infradead.org>
References: <20150425092358.GA15550@infradead.org>
	<20150425152856.GB28453@redhat.com>
	<20150425153732.GA10612@infradead.org>
	<20150426141628.GA7085@infradead.org>
	<20150427155915.GA9976@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150427155915.GA9976@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 27, 2015 at 11:59:15AM -0400, Mike Snitzer wrote:
> So you're still using lio-utils?  Seems "lio-utils are deprecated and
> have been superseded by targetcli".. what am I missing?

That targetcli is a complete fucking mess, and due to it's stateful
nature entirely useless for reproducer scripts or volatile test setups.

> What lio-utils repo should I be using to get the utils that'll work with
> your script?

I'm using the stock Debian wheezy packages. But AFAIK lio-utils never
changed much, so any version should be fine.

You can also try to recreate this situation using targetcli, I'm pretty
sure the result will be the same.
