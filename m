From: Andy <genanr@emsphone.com>
Subject: BIO_RW_FAILFAST
Date: Tue, 17 May 2005 15:59:15 -0500
Message-ID: <20050517205915.GA27652@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

I have been having problems with systems getting I/O errors and dropping
mounted filesystems, when it is processing a RCSN caused by some other event
on the fabric within its' zone.  If I unset BIO_RW_FAILFAST in dm-mpath.c I
no longer get the I/O errors and of course no filesystem drops.  Are there
any plans to change this, or make it a settable option?  Are there any
negatives to not setting it?

Andy 
