From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Synchronizing writes between kernel space and user
	space.
Date: Wed, 12 Apr 2006 19:50:15 -0500
Message-ID: <200604121950.15246.kevcorry@us.ibm.com>
References: <Pine.GSO.4.60.0604121711320.22940@cascade.cs.ubc.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.GSO.4.60.0604121711320.22940@cascade.cs.ubc.ca>
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
To: dm-devel@redhat.com
Cc: Abhishek Gupta <agupta@cs.ubc.ca>
List-Id: dm-devel.ids

On Wed April 12 2006 7:16 pm, Abhishek Gupta wrote:
> Can anyone tell me the synchronization calls to be used if writes
> to a device are being done from both user space and kernel space. I
> noticed that lock_page()/unlock_page() is one set of functions that
> can be used. Obviously, this is too coarse grained, if buffers are smaller
> than the page size. The functions lock_buffer()/unlock_buffer() do not
> seem to do the trick.

What do you mean by doing writes from both user space and kernel space? Is 
there something in particular you're trying to synchronize?

This question doesn't seem specific to device-mapper. I'd suggest posting this 
on lkml to get a wider range of responses.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
