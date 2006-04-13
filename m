From: Abhishek Gupta <agupta@cs.ubc.ca>
Subject: Synchronizing writes between kernel space and user space.
Date: Wed, 12 Apr 2006 17:16:37 -0700 (PDT)
Message-ID: <Pine.GSO.4.60.0604121711320.22940@cascade.cs.ubc.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Can anyone tell me the synchronization calls to be used if writes 
to a device are being done from both user space and kernel space. I 
noticed that lock_page()/unlock_page() is one set of functions that 
can be used. Obviously, this is too coarse grained, if buffers are smaller 
than the page size. The functions lock_buffer()/unlock_buffer() do not 
seem to do the trick.

Please help.

Thanks

Abhishek
