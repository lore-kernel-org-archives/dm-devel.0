From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 13:43:09 +0200
Message-ID: <20050411114309.GJ12752@marowsky-bree.de>
References: <20050410192934.GP12752@marowsky-bree.de>
	<1113164717.8372.2.camel@zezette> <4259B895.4070600@us.ibm.com>
	<20050411011444.GA3748@osdl.org>
	<20050411084611.GA12752@marowsky-bree.de>
	<425A42EF.50808@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <425A42EF.50808@us.ibm.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2005-04-11T02:27:11, Mike Christie <mikenc@us.ibm.com> wrote:

> what is wrong with what you have now where you utilize the queue/path's=
=20
> mempool by doing a blk_get_request with GFP_WAIT?=20

... what if it's trying to free memory by going to swap on multipath,
and can't, because we're blocked on getting the request with
GFP_WAIT...?

Your patch helps, because it means we need less memory.

But, ultimately, we ought to preallocate the requests already when the
hw-handler is initialized for a map (because presumably at that time
we'll have enough memory, or can just fail the table setup). From that
point on, our memory useage should not grow.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
