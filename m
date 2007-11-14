From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: DM-Multipath path failure questions..
Date: Wed, 14 Nov 2007 11:28:37 -0600
Message-ID: <473B3045.8060406@cs.wisc.edu>
References: <20071114000743.3b2d36a5.vaio@nolatency.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071114000743.3b2d36a5.vaio@nolatency.com>
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

Michael Vallaly wrote:
> Hello,
> 
> I am currently using the dm-multipather (multipath-tools) to allow high-availability / increased capacity to our Equallogic iSCSI SAN. I was wondering if anyone had come across a way to re-instantiate a failed path / paths from a multipath target, when the backend device (iscsi initiator) goes away. 
> 
> All goes well until we have a lengthy network hiccup or non-recoverable iSCSI error in which case the multipather seems to get wedged. The path seems to get stuck in a [active][faulty] state and the backend block device (sdX) actually gets removed from the system. I have tried reconnecting the iSCSI session, after this happens, and get a new (different IE: sdg vs. sdf) backend block level device, but the multipather never picks it up / never resumes IO operations, and I generally have then to power cycle the box.
> 
> We have anywhere from 2 to 4 iSCSI sessions open per multipath target, but even one path failing seems to cause the whole multipath to die. I am hoping there is a way to continue on after a path failure, rather than the power cycle. I have tried multipath-tools 0.4.6/0.4.7/0.4.8, and almost every permutation of the configuration I can think of. Maybe I am missing something quite obvious.  
> 

I was wondering what you are doing on the target to cause the device/sdX 
to be removed or what error you get? Normally that only happens if you 
run the iscsiadm logout command, or if the target is sends the initiator 
a error indicating that is going away for good, or there is some other 
error like the CHAP values changed on the target. And in older versions 
of open-iscsi there is a bug where it kills the session and removes sdXs 
a little early on errors that should be recoverable (We found the bug in 
865-* but this is fixed in the open-iscsi git tree and will be fixed in 
the new release), so I just want to make sure I got all the recoverable 
errors.

What kernel are you using, and what happens when you reconnect the 
session and get a new sdX if you run the multipath command by hand?
