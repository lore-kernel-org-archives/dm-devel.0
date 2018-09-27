From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm thin: data block's ref count is not zero but not
 belong to any device.
Date: Thu, 27 Sep 2018 15:25:26 +0100
Message-ID: <20180927142526.GB29590@reti>
References: <20180926031317.GA20632@yyp.>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180926031317.GA20632@yyp.>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: monty <monty_pavel@sina.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 25, 2018 at 11:13:17PM -0400, monty wrote:
> 
> Hi! I met a problem of dm-thin: a thin-pool has no volumes but its
> nr_free_blocks_data is not zero. I guess the scene of this problem like:
> a. create a thin volume thin01, size is 10GB;
> b. write 10GB to thin01;
> c. create a snapshot thin01-snap, orig is thin01;
> d. write 10GB to thin01-snap;
> e. for a data block of thin01-snap, which will be written by user, will
> experience following steps:
> 	1. alloc a data block m firstly;
> 	2. wirte data to data block m;
> 	3. bio callback and assign data block m to thin01-snap.
> If power loss happens between step 2 and step 3, data block will not
> belong to any device but its ref count is not zero.
> Is it a problem? How to solve this problem?

Yes, there are a couple of ways this can happen, a dump and restore of
the metadata will repair it.

- Joe



> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
