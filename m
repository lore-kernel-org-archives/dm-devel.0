From: David Wysochanski <davidw@netapp.com>
Subject: default value for rr_min_io too high?
Date: Wed, 18 Jan 2006 16:41:57 -0500
Message-ID: <43CEB625.9000503@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'm wondering where the value of 1000 came from, and
whether that's really a good default.

Some preliminary tests I've run with iSCSI seem to indicate
something lower (say 100) might be a better default, but
perhaps others have a differing opinion.  I searched the
list but couldn't find any discussion on it.

Thanks.
