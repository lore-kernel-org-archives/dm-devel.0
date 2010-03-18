From: Phillip Susi <psusi@cfl.rr.com>
Subject: device queue scheduler
Date: Thu, 18 Mar 2010 12:49:17 -0400
Message-ID: <4BA2598D.8040503@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'm wondering why the dm block devices have a request queue at all, and
more importantly why they use the default cfq scheduler.  It seems to me
that the physical disk should take care of the scheduling, and not have
that work duplicated at each layer of dm stacked on top.  It wonder
though, where should the scheduler policy be set?  In libdevmapper, or
by a system udev rule?
