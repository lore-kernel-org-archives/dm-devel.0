From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Tue, 12 Aug 2008 12:00:36 -0700
Message-ID: <200808121200.36628.phillips@phunq.net>
References: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
	<200808120556.57314.phillips@phunq.net>
	<20080812221448N.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080812221448N.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Tuesday 12 August 2008 06:14, FUJITA Tomonori wrote:
> >  You just want to use getblk for alloc_chunk_buffer,
> > not vmalloc.
> 
> I think that it means that we cache all the chunks, both btree chunks
> and the data chunks (which are passed to the upper layer such as file
> systems). I think that we don't want cache the latter in dm.

That is true.  However your code should not be reading data chunks into
memory at all.  The only time the snapshot code has to read a data
chunk is when performing the copy from origin to snapshot store in
make_unique.  Your code does not directly perform this task as far as I
can see.  That would be done in a part of the dm snapshot code your
patch does not touch, which I seem to recall uses the kcopyd mechanism.

Regards,

Daniel
