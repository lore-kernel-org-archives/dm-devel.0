From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Multipath-tools not seeing replaced RAID controller
Date: Wed, 13 Feb 2008 23:09:13 +0100
Message-ID: <1202940553.6733.7.camel@localhost>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<46F8A29F.6060803@suse.de>  <200709250852.08464.npf@eurotux.com>
	<1191345214.5831.2.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1191345214.5831.2.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Chandra,

I hope you can answer this question, but of course I'll be very happy if
anyone on this list can answer my question.

I just replaced a faulty RAID controller in an MD3000 enclosure. Now
after enabling it, I can't see it in the multipath driver (mutlipath
-ll). Not even after restarting the multipath-tools (version 0.4.8)...

So what should I restart so that it sees the new controller? I rather
not restart the host if possible...

Thanks!!

Sander
