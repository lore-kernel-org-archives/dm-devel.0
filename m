From: Spelic <spelic@shiftmail.org>
Subject: Multisnap / dm-thin
Date: Wed, 18 Jan 2012 11:35:40 +0100
Message-ID: <4F16A07C.7040705@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello all,
I would need the multisnap feature, i.e., the ability to make many 
snapshots without high performance degradation...
I saw it mentioned around, but it does not seem to be in the kernel yet. 
Is it planned to be introduced? Is there an ETA?

Note that I am not very fond of the new dm-thin which is planned to have 
a multisnap-equivalent feature, because of the fragmentation it will 
cause (I suppose a defragmenter is long way to come). Not having 
fragmentation is the reason for using blockdevices instead of loop 
mounted files after all isn't it?

Thanks for your information
Spelic
