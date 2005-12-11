From: Josef Whiter <jwhiter@redhat.com>
Subject: Question about kpartx
Date: Sun, 11 Dec 2005 16:48:34 -0500
Message-ID: <20051211214834.GA24943@dogpound.rdu.redhat.com>
Reply-To: dm-devel@redhat.com
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

Hello,

I have a quick question about kpartx.  Whenever I run dmsetup ls --target=multipath it doesn't show the dm devices for the partitions on my multipathed devices that kpartx creates the dm devices for.  I'm assuming this is becuase of instances where you want to run the command dmsetup ls --target=multipath --exec='kpartx -a', you don't want the partition dm devices showing up in that list, but I was wondering if that was the actual reason, or if there was more to it than that.  Thank you,

Josef
