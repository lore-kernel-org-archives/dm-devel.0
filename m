From: Andreas Beckmann <beckmann@cs.uni-frankfurt.de>
Subject: Re: discard/trim support in device mapper?
Date: Wed, 09 Jun 2010 14:43:07 +0200
Message-ID: <4C0F8C5B.803@cs.uni-frankfurt.de>
References: <4BA75F52.9090701@cs.uni-frankfurt.de>
	<20100322135720.GA16077@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100322135720.GA16077@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Mike,

Mike Snitzer wrote:
> We are aware of the benefits associated with issuing discards to SSDs.
> Discard support for DM will be a focused priority for me starting
> mid-April.

Did you find some time to look into this?

If there is something to test, I can offer my help, having an array of 4
trim capable SSDs that is used for experiments only.

> Until then I hope to establish a baseline understanding on the scope of
> the project.  In particular I intend to get back with Martin Petersen to
> understand how his work is going on making "write same and discard
> requests first class citizens so they can be split and merged like
> regular write requests".

How is Martin's project progressing?


Andreas
