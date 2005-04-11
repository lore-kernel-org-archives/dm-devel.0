From: "goggin, edward" <egoggin@emc.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 13:36:58 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A8EF@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 11 Apr 2005 04:53:07 -0700
Mike Christie <mikenc@us.ibm.com>
> 
> Lars Marowsky-Bree wrote:
> > On 2005-04-11T02:27:11, Mike Christie <mikenc@us.ibm.com> wrote:
> > 
> > 
> >>what is wrong with what you have now where you utilize the 
> queue/path's 
> >>mempool by doing a blk_get_request with GFP_WAIT? 
> > 
> > 
> > ... what if it's trying to free memory by going to swap on 
> multipath,
> > and can't, because we're blocked on getting the request with
> > GFP_WAIT...?
> 
> GFP_WAIT does not casue IOs though. That is the difference between 
> waiing on GFP_KERNEL and GFP_WAIT I thought. GFP_KERNEL can 
> cause a page 
> write out which you wait on and then there is a problem since 
> it could 
> be to the same disk you are trying to recover. But if you are just 
> waiting for something to be returned to the mempool like with 
> GFP_WAIT + 
> blk_get_request you should be ok as long as the code below you 
> eventually give up their resources and frees the requests you are 
> waiting on?
>
 
A deterministic, fool-proof solution for this case must deal with
the possibility that in order to make progress, one cannot depend
that any memory resource which has previously been used will free
up -- because the freeing of that memory may be dependent on
making progress at this point.  Even using GFP_WAIT, it is possible
that all previously allocated bio (not sure about requests) mempool
resources needed are queued waiting for a multipath path to become
usable again.

I don't see a way around needing to use pre-allocated bio memory
which is reserved strictly for this purpose -- albeit it is possible
that a single bio could be reserved for making progress in serial
fashion across all multipaths which are in this state.

> > 
> > Your patch helps, because it means we need less memory.
> > 
> > But, ultimately, we ought to preallocate the requests 
> already when the
> > hw-handler is initialized for a map (because presumably at that time
> > we'll have enough memory, or can just fail the table 
> setup). From that
> > point on, our memory useage should not grow.
> >
