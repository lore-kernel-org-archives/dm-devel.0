From: malahal@us.ibm.com
Subject: Re: multipath multibus performance
Date: Thu, 31 Jan 2008 10:26:47 -0800
Message-ID: <20080131182647.GA27979@us.ibm.com>
References: <20080131163918.GA10313@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080131163918.GA10313@thumper2>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Andy [genanr@emsphone.com] wrote:
> I would like to increase the performance of the multibus mode of multipath. 
> It would be nice if multibus performance would be very close to accessing
> the device directly.  From what I have been told, under multibus, I/O's are
> broken up into bio's and sent down the multiple paths, with no merging of
> adjacent I/O's.

Not quite correct. It depends on the path selector algorithm you use.
"round_robin" with rr_min_io set to 1 will definitely give you bad
performance for sequential I/O. If you set rr_min_io to a big number,
the adjacent I/Os may be merged together. What values did you use in
your testing?

--Malahal.
